//
//  QSCExpressionGroupModel.h
//  qingsongchou
//
//  Created by yf on 2018/11/12.
//  Copyright © 2018年 Chai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QSCExpressionModel.h"

@interface QSCExpressionGroupModel : NSObject

//分组logo（暂时只有一个默认分组）
@property (nonatomic,copy) NSString * group_pic;

@property (nonatomic,strong) NSMutableArray * emoticons;

@end
