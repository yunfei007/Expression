//
//  QSCCommentEditView.m
//  qingsongchou
//
//  Created by yf on 2018/11/8.
//  Copyright © 2018年 Chai. All rights reserved.
//

#import "QSCCommentEditView.h"
#import "UITextView+Placeholder.h"

@interface QSCCommentEditView()<UITextViewDelegate>

@property (nonatomic,strong) UIButton * expressionSwitchBtn;
@property (nonatomic,strong) UIButton * sendBtn;
@property (nonatomic,strong) UIView * bottomView;
//@property (nonatomic,strong) UIButton * keyboardBtn;
//@property (nonatomic,strong) UIButton * expressionBtn;
//@property (nonatomic,strong) UIButton * completeBtn;

@end

@implementation QSCCommentEditView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithGivenHexColorString:@"#F5F6F7"];
        [self stepSubView];
    }
    return self;
}

-(void)stepSubView
{

    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = [UIColor colorWithGivenHexColorString:@"#E9E8E8"];
    [self addSubview:_bottomView];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(0);
    }];
    
    _commentTextView = [[UITextView alloc] init];
    _commentTextView.delegate = self;
    _commentTextView.font = [UIFont systemFontOfSize:15];
    _commentTextView.textColor = [UIColor colorWithGivenHexColorString:@"#666666"];
    _commentTextView.placeholder = @"写评论";
    _commentTextView.placeholderColor = [UIColor colorWithGivenHexColorString:@"#999999"];
    _commentTextView.clipsToBounds = YES;
    _commentTextView.layer.cornerRadius = 4;
    [self addSubview:_commentTextView];
    
    [_commentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(15);
        make.left.equalTo(self.mas_left).offset(20);
        make.bottom.equalTo(_bottomView.mas_top).offset(-15);
        make.width.mas_equalTo(self.width-20-65);
    }];
    
    _expressionSwitchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_expressionSwitchBtn setImage:[UIImage imageNamed:@"expression"] forState:UIControlStateNormal];
    [_expressionSwitchBtn addTarget:self action:@selector(expressionSwitchBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_expressionSwitchBtn];
    
    [_expressionSwitchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(15);
        make.left.equalTo(_commentTextView.mas_right).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(40);
    }];
    
    _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [_sendBtn setTitleColor:[UIColor colorWithGivenHexColorString:@"#43ac43"] forState:UIControlStateNormal];
    _sendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_sendBtn addTarget:self action:@selector(sendBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sendBtn];
    
    [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_expressionSwitchBtn.mas_bottom).offset(10);
        make.left.equalTo(_commentTextView.mas_right).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.bottom.equalTo(_commentTextView.mas_bottom).offset(0);
    }];


    
//    _keyboardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _keyboardBtn.tag = 100;
//    [_keyboardBtn setImage:[UIImage imageNamed:@"jianpan"] forState:UIControlStateNormal];
//    [_keyboardBtn addTarget:self action:@selector(bottomAction:) forControlEvents:UIControlEventTouchUpInside];
//    [_bottomView addSubview:_keyboardBtn];
//
//    [_keyboardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.bottom.mas_equalTo(_bottomView);
//        make.width.mas_equalTo(self.width/3);
//    }];
//
//    _expressionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _expressionBtn.tag = 101;
//    [_expressionBtn setImage:[UIImage imageNamed:@"biaoqing"] forState:UIControlStateNormal];
//    [_expressionBtn addTarget:self action:@selector(bottomAction:) forControlEvents:UIControlEventTouchUpInside];
//    [_bottomView addSubview:_expressionBtn];
//
//    [_expressionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.mas_equalTo(_bottomView);
//        make.left.equalTo(_keyboardBtn.mas_right).offset(0);
//        make.width.mas_equalTo(self.width/3);
//    }];
//
//    _completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _completeBtn.tag = 102;
//    [_completeBtn setImage:[UIImage imageNamed:@"jinggao"] forState:UIControlStateNormal];
//    [_completeBtn addTarget:self action:@selector(bottomAction:) forControlEvents:UIControlEventTouchUpInside];
//    [_bottomView addSubview:_completeBtn];
//
//    [_completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.mas_equalTo(_bottomView);
//        make.left.equalTo(_expressionBtn.mas_right).offset(0);
//        make.width.mas_equalTo(self.width/3);
//    }];

}


-(void)textViewDidChange:(UITextView *)textView
{
    NSRange wholeRange = NSMakeRange(0, self.commentTextView.textStorage.length);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    [self.commentTextView.textStorage addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithGivenHexColorString:@"#666666"],NSParagraphStyleAttributeName:paragraphStyle} range:wholeRange];
}

-(void)expressionSwitchBtn:(UIButton *)btn
{
    if (_keyboardType == KkeyboardType) {
        NSLog(@"表情");
        _keyboardType = KExpressionType;
    }else{
        NSLog(@"键盘");
        _keyboardType = KkeyboardType;
        [self.commentTextView becomeFirstResponder];
    }
    self.editViewActionBlock();
}

-(void)sendBtnAction:(UIButton *)btn
{
    NSLog(@"发送");
    if (_commentTextView.text.length == 0) {
        [ProgressHUD showSuccess:@"评论不能为空"];
    }else if (_commentTextView.text.length>2000) {
        [ProgressHUD showSuccess:@"评论最多2000个字符"];
    }else{
        self.sendActionBlock();
    }
}

-(void)getFirstResponder
{
    [_commentTextView becomeFirstResponder];
}

@end
