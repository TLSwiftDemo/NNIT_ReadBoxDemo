//
//  NNIT_Utils.m
//  NNIT_ReadBoxDemo
//
//  Created by Andrew on 16/7/5.
//  Copyright © 2016年 Andrew. All rights reserved.
//

#import "NNIT_Utils.h"

@implementation NNIT_Utils
#pragma mark 十六进制转换为普通字符串的。
- (NSString *)stringFromHexStringLK:(NSString *)hexString {  //
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr] ;
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    NSLog(@"------字符串=======%@",unicodeString);
    return unicodeString;
}
@end
