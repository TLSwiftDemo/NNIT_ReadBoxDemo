
#import <Foundation/Foundation.h>
#import "KOALCommandBundle.h"
#import "AQPlayer.h"
#import "AQRecorder.h"
 
@interface KOALAudioAdapter : NSObject


+(KOALAudioAdapter*)assertWithDelegate:(id)delegate;
-(void)setPlayerTransferLength:(int)len;
-(Boolean)isRecorderRunning;
-(void)startRecord;
-(void)stopRecord;
-(void)startQueue:(BOOL)inResume;
-(void)createQueueForFileForPlayer;
-(void)sendCommandData:(KOAL_COMMAND*)command;
-(UInt8*)getReceivedDataBuffer;
-(UInt8)getRecieveDataBufferLength;
-(void)clearReceivedData;
-(void)resetUpdateState;
 
@end
