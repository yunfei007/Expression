//
//  QSCEmojiTextAttachment.h
//  qingsongchou
//
//  Created by yf on 2018/11/13.
//  Copyright © 2018年 Chai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSCEmojiTextAttachment : NSTextAttachment

@property(strong, nonatomic) NSString *emojiTag;
@property(assign, nonatomic) CGRect emojiRect;

@end
