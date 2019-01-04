//
//  QSCExpressionCell.m
//  qingsongchou
//
//  Created by yf on 2018/11/12.
//  Copyright © 2018年 Chai. All rights reserved.
//

#import "QSCExpressionCell.h"
#import "UIImage+BundleImg.h"

@interface QSCExpressionCell()

@property (nonatomic,strong) UIImageView * imgView;

@end

@implementation QSCExpressionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self stepSubView];
    }
    return self;
}

-(void)stepSubView
{
    _imgView = [[UIImageView alloc] init];
    _imgView.image = [UIImage imageNamed:@""];
    [self.contentView addSubview:_imgView];
    
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(0);
        make.left.equalTo(self.mas_left).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
    }];
}

-(void)setExpressionModel:(QSCExpressionModel *)expressionModel
{
    _expressionModel = expressionModel;
    if (expressionModel) {
        _imgView.hidden = NO;
        _imgView.image = [UIImage imagesNamedFromCustomBundle:[NSString stringWithFormat:@"%@@3x",expressionModel.image]];
    }else{
        _imgView.hidden = YES;
    }
}

@end
