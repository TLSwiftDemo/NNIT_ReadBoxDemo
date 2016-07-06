//
//  NNBoxModel.h
//  NNIT_ReadBoxDemo
//
//  Created by Andrew on 16/7/6.
//  Copyright © 2016年 Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NNBoxModel : NSObject
@property (nonatomic, assign)float bloodVoice;//音频血糖数据
@property (nonatomic, copy)NSString *boxSN;//盒子的序列号
@property (nonatomic, copy)NSString* xueTangYiSN;//血糖仪的序列号
@property (nonatomic, assign)float bloodGlucose;//血糖值
@property (nonatomic, assign)NSInteger sync;//数据状态0新增数据／1旧数据
@property (nonatomic, copy)NSString *recordTime;//记录时间
@end
