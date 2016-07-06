//
//  NNIT_Utils.m
//  NNIT_ReadBoxDemo
//
//  Created by Andrew on 16/7/5.
//  Copyright © 2016年 Andrew. All rights reserved.
//

#import "NNIT_Utils.h"

@implementation NNIT_Utils
#pragma mark 十六进制转换为普通字符串的。
- (NSString *)stringFromHexStringLK:(NSString *)hexString {  //
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr] ;
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    NSLog(@"------字符串=======%@",unicodeString);
    return unicodeString;
}

#pragma mark 根据血糖仪型号协议换算血糖值
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
                GLYXMuArr:(NSMutableArray*)GLYXMuArr

{
    //时间截取
    //年：
    NSString *year=[dataStr substringWithRange:NSMakeRange(8, 2)];
    //月：
    NSString *moom=[dataStr substringWithRange:NSMakeRange(4, 2)];
    //日
    NSString *day=[dataStr substringWithRange:NSMakeRange(6, 2)];
    //时
    NSString *hour=[dataStr substringWithRange:NSMakeRange(0, 2)];
    //分
    NSString *minute=[dataStr substringWithRange:NSMakeRange(2, 2)];
    
    NSString *DateStr=[NSString stringWithFormat:@"20%@/%@/%@ %@:%@",year,moom,day,hour,minute];
    NSInteger moomI=[moom integerValue];//1_12
    NSInteger dayI=[day integerValue];//1_31
    NSInteger hourI=[hour integerValue];//0-24
    NSInteger minuteI=[minute integerValue];//0-60
    if ((moomI>=1&&moomI<=12)&&(dayI>=1&&dayI<=31)&&(hourI>=0&&hourI<=24)&&(minuteI>=0)&&(minuteI<=60)) {//在这区间才把血糖值存储到本地
        
        //    }
        //
        //    if ([day floatValue]!=0&&[hour floatValue]!=0&&[minute floatValue]!=0) {
        NSLog(@"非0：year==%@,moon===%@,day ===%@,hour===%@,mimnute===%@,血糖值：%@",year,moom,day,hour,minute,GlyxStr);
        
        //血糖协议：
        NSString *  typeStr=GlucoseType;//selectType;
        if ([typeStr isEqualToString:@"011"] || [typeStr isEqualToString:@"012"] || [typeStr isEqualToString:@"013"])
        {//直接读取
            
            NSString *str=[NSString stringWithFormat:@"%.1f",[GlyxStr floatValue]];
            
            [DateMuArr addObject:DateStr];
            [GLYXMuArr addObject:str];
            return;
            
        }else if ([typeStr isEqualToString:@"006"] || [typeStr isEqualToString:@"009"] || [typeStr isEqualToString:@"010"] )
        {//整合乘以0.1
            
            float GValue= [GlyxStr intValue]*0.1;
            NSString *str=[NSString stringWithFormat:@"%.1f",GValue];
            [DateMuArr addObject:DateStr];
            [GLYXMuArr addObject:str];
            return;
            
        }else if ([typeStr isEqualToString:@"003"] )
        {//*0.05551/2 七舍八入
            
            float GValue=([GlyxStr intValue]*0.05551)/2;
            float changeV;
            int b;
            b =(int)((GValue+0.02)*10);
            changeV=(float)(b/10.0);
            
            NSString *str=[NSString stringWithFormat:@"%.1f",changeV];
            [DateMuArr addObject:DateStr];
            [GLYXMuArr addObject:str];
            return;
            
        }else if ([typeStr isEqualToString:@"004"] || [typeStr isEqualToString:@"005"] )
        {//四舍六入，五看后
            
            float GValue;
            float changeV;
            GValue=([GlyxStr floatValue]*0.05551);
            changeV=GValue*100;
            int a=(int)(changeV)%10;//小数点后第二位数
            int b=((int)(GValue*1000)%10);//小数点后第三位
            
            if (a<5||a>5) {
                NSString *str=[NSString stringWithFormat:@"%.1f",GValue];
                [DateMuArr addObject:DateStr];
                [GLYXMuArr addObject:str];
                return;
                
            }else if(a==5)
            {
                if (b>=5) {
                    float c=GValue+0.05;
                    NSString *str=[NSString stringWithFormat:@"%.1f",c];
                    [DateMuArr addObject:DateStr];
                    [GLYXMuArr addObject:str];
                    return;
                    
                }else if(b<5)
                {
                    int d;
                    float e;
                    d =(int)(GValue*10);
                    e=(float)(d/10.0);
                    NSString *str=[NSString stringWithFormat:@"%.1f",e];
                    [DateMuArr addObject:DateStr];
                    [GLYXMuArr addObject:str];
                    return;
                }
                
            }
            
            
        }else //007、008,001，002
            //        if([typeStr isEqualToString:@"002"] )//其他
        {
            
            float GValue= [GlyxStr intValue]*0.05551+0.0055;
            
            NSString *str=[NSString stringWithFormat:@"%@",[self decimalwithFormat:@"0.0" floatV:GValue]];
            
            [DateMuArr addObject:DateStr];
            [GLYXMuArr addObject:str];
            return;
            
        }
    }else
    {
        NSLog(@"为0：：year==%@,moon===%@,day ===%@,hour===%@,mimnute===%@,血糖值：%@",year,moom,day,hour,minute,GlyxStr);
        
    }
}
//格式话小数 四舍五入类型
- (NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setPositiveFormat:format];
    
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
}




#pragma mark  音频数据上传服务器将时间转换成时间戳
-(NSString *)timeWithStr:(NSString *)str2
{
    //字符串转换date
    NSString *str = str2;
    NSLog(@"str=%@",str);
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY/MM/dd HH:mm"];
    NSDate *date = [formatter dateFromString:str];
    NSLog(@"date=%@",date);
    
    //   NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSLog(@"localeDate=%@", localeDate);
    
    //  3.根据当前date转换时间戳
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    NSLog(@"timeSp:%@",timeSp); //时间戳的值
    
    
    return timeSp;
}
@end
