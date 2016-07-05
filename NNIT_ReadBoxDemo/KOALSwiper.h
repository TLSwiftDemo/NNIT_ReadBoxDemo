
#import <Foundation/Foundation.h>
#import "KOALSwiperDelegate.h"
#import <MediaPlayer/MediaPlayer.h>


@protocol AQRecorderDelegate;
@protocol AQPlayerDelegate;

@interface KOALSwiper : NSObject <AQRecorderDelegate,AQPlayerDelegate>
@property (nonatomic,assign) id<KOALSwiperDelegate> delegate;


+(KOALSwiper*)sharedSwiper;
-(void)StartReCord;
-(void)StopReCord;


@end
