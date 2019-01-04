//
//  QSCExpressionModel.h
//  qingsongchou
//
//  Created by yf on 2018/11/12.
//  Copyright © 2018年 Chai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QSCExpressionModel : NSObject

//表情图片
@property (nonatomic,copy) NSString * image;
//表情名
@property (nonatomic,copy) NSString * desc;

@property (nonatomic,copy) NSString * emojiTag;

@end
