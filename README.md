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



#在需要用到的地方实现代理
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
