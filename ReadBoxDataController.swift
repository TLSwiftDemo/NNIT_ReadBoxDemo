//
//  ReadBoxDataController.swift
//  NNIT_ReadBoxDemo
//
//  Created by Andrew on 16/7/5.
//  Copyright © 2016年 Andrew. All rights reserved.
//

import UIKit

class ReadBoxDataController: UIViewController,KOALSwiperDelegate {

   
    
    var swiper:KOALSwiper!
    var numInput:Int = 50//输入的条数
    var bloodType:String = "" //血糖类型
    /// 接收硬件发回来的数据
    var NoticeReturnValue:String?
    
    
    //MARK: - 音频数据
    var noticeReturnValueLK:String?;//接收硬件发回来的数据
    var reture0X40Value:String?;//0x40返回来的值
    var reture0X41Value:String?;//0x41
    var retureECK:String?;
    var reture0X42Value:String?;//0x42
    var reture0X43Value:String?;//0x43
    
    /// 解析后数据（去（）截字符再转型最终得到的数据
    var analyzingRecorderStrLK:String?
    
    
    //发送0x40的解析数据
    var designatorWith0x40LK:String?;//发送命令符
    var GlucoseType:String?;//血糖仪类型
    
    //MARK: - 发送0x41的解析数据
    var designatorWithSendLK:String?;//发送命令符
    var version:String?;//固定版本
    var electric:String?;//电量
    var SerialNumber:String?;//序列号
    
    //MARK: - 读血糖0x42的解析数据
    var designatorWithGLYXStrLK:String?;//命令符
    var statuOfGlucoseMeterLK:String?;//血糖仪状态
    var recognitionSizeLK:String?;//识别血糖仪类型
    var versionNumberOneLK:String?;//血糖仪固定版本号1
    var versionNumberTwoLK:String?;//血糖仪固定版本号2
    var currentTimeLK:String?;//血糖仪当前日期和时间
    var NumberByteOfDataLK:String?;//血糖仪中总共数据条数
    var serialOfGlucoseMeterLK:String?;//血糖仪序列号
    
    //MARK: - 读数据0x43的解析数据
    var designatorWithDataStrLK:String?;//命令符
    var bagthStrLK:String?;//第几包
    var dataNumStrLK:String?;//数据条数
    var dateMuStrLK:String?;//年月日
    var GLYXMuArr:NSMutableArray = NSMutableArray()//血糖值数组
    var DateMuArr:NSMutableArray = NSMutableArray();//时间数组
    var specialStrArr = NSMutableArray();//血糖和时间后面的一位特殊字节
    
    var nTimer:NSTimer?;
    var conut:Int = 0;
    
    var totalMutableArray:NSMutableArray = NSMutableArray()
    
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationItem.title = "读取数据"
        initView()
        initData()
    }
    
    
    func initData() -> Void {
        
        swiper = KOALSwiper.sharedSwiper()
        swiper.delegate = self;
        //执行读取的命令
        swiper.StartReCord()
    }
    
    
    func initView() -> Void {
        
    }
    
    
    //MARK: -  延时重发0x40
    
    func delay0x40Method() -> Void {
        
        self.sendData("40")
    }
    
    
    
    
    /**
     收/发机制
     
     - parameter data: 数据
     */
    func sendData(sendStr:String) -> Void {
        let test = sendStr;
        
        let testStr = test
        
        let testData:NSData =  KOALSampleUtil.nsdataOfHexString(testStr);
        
        print("HEX发送：\(testStr)")
        swiper.emitWriteDataSend(UInt8(testData.length), data: testData)
    }
    //MARK: -   ----发----0x44 结束指令
    func sendEnd(data:String) -> Void {
        self.sendData("44")
    }
    

}


extension ReadBoxDataController{
    //MARK: - KOALSwiperDelegate
    
    func headjackDidUnPlug() {
        print("耳机设备拔出")
    }
    //耳机设备拔出
    func headjackDidPlug() {
        print("耳机设备插入")
    }
    
    //操作失败
    func swiperDidReturnErrorCode(errorCode: UInt8, command commandCode: UInt8, errorMessage message: String!) {
        print("操作失败:\(message)")
    }
    
    //写数据成功
    func writeCustomDataSuccessful() {
        print("写数据成功了")
    }
    
    //成功读取自定义数据
    func swiperDidObtianCustomData(result: String!) {
        print("成功读取自定义数据:\(result)")
    }
    
    func sdkThrowException(e: NSException!, errorMessage errorMsg: String!) {
        print("输入参数错误")
    }
}
