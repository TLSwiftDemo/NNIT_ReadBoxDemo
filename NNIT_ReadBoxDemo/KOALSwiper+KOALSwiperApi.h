
#import "KOALSwiper.h"

@interface KOALSwiper (KOALSwiperApi)

-(void)emitWriteDataSend:(UInt8)len/*长度1Byte*/
                    Data:(NSData*)data;/*数据指针*/
@end
