//
//  QSCCommentEditView.h
//  qingsongchou
//
//  Created by yf on 2018/11/8.
//  Copyright © 2018年 Chai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    KkeyboardType,
    KExpressionType,
} KeyBoardType;

@interface QSCCommentEditView : UIView

@property (nonatomic,strong) UITextView * commentTextView;

@property(nonatomic, assign) KeyBoardType keyboardType;

@property (nonatomic,copy) void (^editViewActionBlock)();

@property (nonatomic,copy) void (^sendActionBlock)();


-(void)getFirstResponder;


@end
