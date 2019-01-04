# Expression
自定义表情


#表情view
-(QSCExpressionView *)expressionView
{
    if (!_expressionView) {
        _expressionView = [[QSCExpressionView alloc] initWithFrame:CGRectMake(0, KDeviceHeight, self.view.width, 260)];
        _expressionView.delegate = self;
    }
    return _expressionView;
}



#在需要用到的地方实现代理,点击表情后给相应的textview赋值；
#pragma mark ------------QSCExpressionViewDelegate--------------
-(void)expressionViewItemClickWith:(NSString *)imgStr andEmojiTag:(NSString *)emojiTag
{
    if (![NSString isBlankString:imgStr]) {
        QSCEmojiTextAttachment *emojiTextAttachment = [QSCEmojiTextAttachment new];
        emojiTextAttachment.emojiTag = emojiTag;
        emojiTextAttachment.image = [UIImage imagesNamedFromCustomBundle:[NSString stringWithFormat:@"%@@3x",imgStr]];
        UIFont * font = [UIFont systemFontOfSize:15];
        emojiTextAttachment.emojiRect = CGRectMake(0,font.descender,font.lineHeight, font.lineHeight);
        NSAttributedString *str = [NSAttributedString attributedStringWithAttachment:emojiTextAttachment];
        
        NSRange selectedRange = self.editView.commentTextView.selectedRange;
        if (selectedRange.length > 0) {
            [self.editView.commentTextView.textStorage deleteCharactersInRange:selectedRange];
        }
        [self.editView.commentTextView.textStorage insertAttributedString:str atIndex:self.editView.commentTextView.selectedRange.location];
        self.editView.commentTextView.selectedRange = NSMakeRange(self.editView.commentTextView.selectedRange.location+1, 0);
        
        
        NSRange wholeRange = NSMakeRange(0, self.editView.commentTextView.textStorage.length);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5;
        [self.editView.commentTextView.textStorage addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithGivenHexColorString:@"#666666"],NSParagraphStyleAttributeName:paragraphStyle} range:wholeRange];
        
        [self.editView.commentTextView.placeholderLabel removeFromSuperview];
    }else{
        //删除
        NSRange selectedRange = self.editView.commentTextView.selectedRange;
        NSMutableAttributedString * attStr = [NSMutableAttributedString new];
        [attStr setAttributedString:self.editView.commentTextView.attributedText];
        NSInteger len = [QSCGlobalMethod stringContainsEmoji:self.editView.commentTextView.text];
        [attStr replaceCharactersInRange:NSMakeRange(selectedRange.location-len, len) withString:@""];
        self.editView.commentTextView.attributedText = attStr;
    }
}



#把表情图片转成相应的字符串，用于给后台传
NSString * str = [weakSelf.editView.commentTextView.textStorage getPlainString];


#把从后台获取的表情字符串，转成相应的富文本显示出来
//匹配表情字符串
+ (NSMutableAttributedString *)getExpressionAttributeStrWith:(NSString *)expressionStr
{
    NSMutableAttributedString * mAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",expressionStr]];
    
    if (![NSString isBlankString:expressionStr]) {
        //加载plist文件中的数据
        NSBundle *bundle = [NSBundle mainBundle];
        //寻找资源的路径
        NSString *path = [bundle pathForResource:@"expression" ofType:@"plist"];
        //获取plist中的数据
        NSArray *groupArr = [[NSArray alloc] initWithContentsOfFile:path];
        NSDictionary * groupDict = groupArr[0];
        NSArray * face = groupDict[@"emoticons"];

        //正则匹配要替换的文字的范围
        //正则表达式
        NSString * pattern = @"\\[\\w+\\]";
        NSError *error = nil;
        NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        
        if (!re) {
            NSLog(@"%@", [error localizedDescription]);
        }
        
        //通过正则表达式来匹配字符串
        NSArray *resultArray = [re matchesInString:expressionStr options:0 range:NSMakeRange(0, expressionStr.length)];
        
        //用来存放字典，字典中存储的是图片和图片对应的位置
        NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
        
        //根据匹配范围来用图片进行相应的替换
        for(NSTextCheckingResult *match in resultArray) {
            //获取数组元素中得到range
            NSRange range = [match range];
            
            //获取原字符串中对应的值
            NSString *subStr = [expressionStr substringWithRange:range];
            
            for (int i = 0; i < face.count; i ++)
            {
                if ([face[i][@"emojiTag"] isEqualToString:subStr])
                {
                    
                    //face[i][@"gif"]就是我们要加载的图片
                    //新建文字附件来存放我们的图片
                    QSCEmojiTextAttachment *emojiTextAttachment = [QSCEmojiTextAttachment new];
                    emojiTextAttachment.emojiTag = face[i][@"emojiTag"];
                    emojiTextAttachment.image = [UIImage imagesNamedFromCustomBundle:[NSString stringWithFormat:@"%@@3x",face[i][@"image"]]];
                    UIFont * font = [UIFont systemFontOfSize:15];
                    emojiTextAttachment.emojiRect = CGRectMake(0,font.descender,font.lineHeight, font.lineHeight);
                    
                    
                    //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
                    NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:emojiTextAttachment];
                    
                    //把图片和图片对应的位置存入字典中
                    NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
                    [imageDic setObject:imageStr forKey:@"image"];
                    [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
                    
                    //把字典存入数组中
                    [imageArray addObject:imageDic];
                    
                }
            }
        }
        
        //从后往前替换
        for (int i = imageArray.count -1; i >= 0; i--)
        {
            NSRange range;
            [imageArray[i][@"range"] getValue:&range];
            //进行替换
            [mAttributedString replaceCharactersInRange:range withAttributedString:imageArray[i][@"image"]];
            
        }
    }
    return mAttributedString;
}



