//
//  NNIT_Utils.h
//  NNIT_ReadBoxDemo
//
//  Created by Andrew on 16/7/5.
//  Copyright © 2016年 Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NNIT_Utils : NSObject
/**
 *  十六进制转换为普通字符串的。
 *
 *  @param hexString <#hexString description#>
 *
 *  @return <#return value description#>
 */
- (NSString *)stringFromHexStringLK:(NSString *)hexString;


/**
 *  根据血糖仪型号协议换算血糖值
 *
 *  @param GlyxStr     <#GlyxStr description#>
 *  @param dataStr     <#dataStr description#>
 *  @param GlucoseType 血糖仪类型
 *  @param DateMuArr   时间数组
 *  @param GLYXMuArr   血糖值数组
 */
-(void)ConversionOfGLYXLK:(NSString *)GlyxStr
                     time:(NSString *)dataStr

            xueTangYiType:(NSString*)GlucoseType
                DateMuArr:(NSMutableArray*)DateMuArr
                GLYXMuArr:(NSMutableArray*)GLYXMuArr;


//格式话小数 四舍五入类型
- (NSString *) decimalwithFormat:(NSString *)format
                          floatV:(float)floatV;

/**
 *  音频数据上传服务器将时间转换成时间戳
 *
 *  @param NSString <#NSString description#>
 *
 *  @return <#return value description#>
 */
-(NSString *)timeWithStr:(NSString *)str2;
@end
