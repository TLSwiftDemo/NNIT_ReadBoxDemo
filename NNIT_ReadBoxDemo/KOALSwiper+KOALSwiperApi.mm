
#import "KOALSwiper+KOALSwiperApi.h"
#import "KOALAudioAdapter.h"
#import "KOALSwiperUtil.h"


@implementation KOALSwiper (KOALSwiperApi)
///写入待发送数据
-(void)emitWriteDataSend:(UInt8)len/*长度1Byte*/
                    Data:(NSData*)data/*数据指针*/
{
    @try {
        KOAL_COMMAND* cmd = [[KOALCommandBundle sharedBundle]getWriteCustomDataCommandWithIndex:len andData:data];
        
        [[KOALAudioAdapter assertWithDelegate:self] sendCommandData:cmd];
        
    }
    @catch (NSException *exception) {
        NSLog(@"写入自定义数据时，程序出现异常,请检查您输入的参数");
        [self.delegate sdkThrowException:exception errorMessage:[NSString stringWithFormat:@"写入自定义数据时，出现程序异常，请检查您输入的参数格式。 异常原因如下：\n%@", exception.reason]];
    }
    @finally {
        [[KOALCommandBundle sharedBundle] clearCommand];
    }
}
@end
