//
//  DBManager.h
//  Temporarily
//
//  Created by xiaomifeng on 15/6/22.
//  Copyright (c) 2015年 xiaomifeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NNBoxModel.h"

@interface DBManager : NSObject

+ (DBManager *)sharedInstance;
- (id)init;

/**
 *  查询音频盒子数据
 *
 *  @return <#return value description#>
 */
- (NSArray *)boxVoiceAllUser;


/**
 *  按状态查询音频盒子
 *
 *  @param sync <#sync description#>
 *
 *  @return <#return value description#>
 */
- (NSArray *)bloodVoiceAllUser:(NSInteger)sync;

/**
 *  增音频盒子数据
 *
 *  @param boxModel
 */
- (void)insertWithBloodVoiceModel:(NNBoxModel *)boxModel;
/**
 *  删除音频里的血糖数据
 */
-(void)deleteWhithBloodVoiceModel;
/**
 *  改血糖 音频盒子
 *
 *  @param boxModel
 */
- (void)updateWithBoxVoiceUserModel:(NNBoxModel *)boxModel;


@end
