//
//  QSCEmojiTextAttachment.m
//  qingsongchou
//
//  Created by yf on 2018/11/13.
//  Copyright © 2018年 Chai. All rights reserved.
//

#import "QSCEmojiTextAttachment.h"

@implementation QSCEmojiTextAttachment

- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex
{
    return CGRectMake(_emojiRect.origin.x, _emojiRect.origin.y, _emojiRect.size.width, _emojiRect.size.height);
}


@end
