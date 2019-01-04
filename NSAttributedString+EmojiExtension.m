//
//  NSAttributedString+EmojiExtension.m
//  qingsongchou
//
//  Created by yf on 2018/11/13.
//  Copyright © 2018年 Chai. All rights reserved.
//

#import "NSAttributedString+EmojiExtension.h"
#import "QSCEmojiTextAttachment.h"

@implementation NSAttributedString (EmojiExtension)

- (NSString *)getPlainString
{
    NSMutableString *plainString = [NSMutableString stringWithString:self.string];
    __block NSUInteger base = 0;
    
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length)
                     options:0
                  usingBlock:^(id value, NSRange range, BOOL *stop) {
                      if (value && [value isKindOfClass:[QSCEmojiTextAttachment class]]) {
                          [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length)
                                                     withString:((QSCEmojiTextAttachment *) value).emojiTag];
                          base += ((QSCEmojiTextAttachment *) value).emojiTag.length - 1;
                      }
                  }];
    
    return plainString;
}

@end
