//
//  QSCExpressionView.h
//  qingsongchou
//
//  Created by yf on 2018/11/12.
//  Copyright © 2018年 Chai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QSCExpressionViewDelegate <NSObject>

@optional

//desc为空标识删除
-(void)expressionViewItemClickWith:(NSString *)imgStr andEmojiTag:(NSString *)emojiTag;

@end

@interface QSCExpressionView : UIView

@property (nonatomic, weak) id<QSCExpressionViewDelegate> delegate;


@end
