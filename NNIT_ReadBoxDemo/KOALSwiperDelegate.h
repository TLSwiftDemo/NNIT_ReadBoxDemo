
#import <Foundation/Foundation.h>

@protocol KOALSwiperDelegate <NSObject>

//耳机设备插入
-(void)headjackDidPlug;
//耳机设备拔出
-(void)headjackDidUnPlug;
//操作失败
-(void)swiperDidReturnErrorCode:(UInt8)errorCode command:(UInt8)commandCode errorMessage:(NSString*)message;
//写数据成功
-(void)writeCustomDataSuccessful;
//成功读取自定义数据
-(void)swiperDidObtianCustomData:(NSString*)result;

//输入参数错误
-(void)sdkThrowException:(NSException*) e errorMessage:(NSString*) errorMsg;
@end
