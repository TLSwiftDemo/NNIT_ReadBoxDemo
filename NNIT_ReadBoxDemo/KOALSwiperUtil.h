
#import <Foundation/Foundation.h>
@class KOALSwiper;
#import "KOALObject.h"
//#import "KOALCommandBundle.h"



@interface KOALSwiperUtil : NSObject 

+(void)logKoalData:(KOAL_DATA*)data;
////将16进制字符串的金额转换成bytes
//+(NSData*)wrapAmount:(NSString*)stringAmount;
//bytes转16进制字符串，用户抓去返回信息
+(NSString*) hexStringOfBytes:(Byte*) bytes length:(int)len;

//hexString to NSData
+(NSData*)nsdataOfHexString:(NSString*)hexStr;

+(UInt8*) bytesOfString:(NSString*) str;
//发送数据检测
+(UInt8)theLRCCheckOfBytes: (Byte *)buffer andLength:(UInt8 )len;
+(NSString*)stringOfBytes:(Byte *)bytes andLength:(int)length;

+(void)parseMerchantAndTerminalData:(Byte*)data
                         dataLength:(int)len 
                     delegateHolder:(KOALSwiper*) holder;

//解析读取的自定义数据信息
+(void)parseReadCustomData:(Byte*)data
                     dataLength:(int)len
                 delegateHolder:(KOALSwiper*) holder;
@end
