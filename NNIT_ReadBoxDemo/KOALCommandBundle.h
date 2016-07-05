
#import <Foundation/Foundation.h>
#import "KOALSwiperUtil.h"




@interface KOALCommandBundle : NSObject
+(KOALCommandBundle*)sharedBundle;
-(void)clearCommand;
-(KOAL_COMMAND*)getWriteCustomDataCommandWithIndex:(UInt8)index andData:(NSData*)data;//6
@end
