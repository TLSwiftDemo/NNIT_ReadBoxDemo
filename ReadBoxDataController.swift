//
//  ReadBoxDataController.swift
//  NNIT_ReadBoxDemo
//
//  Created by Andrew on 16/7/5.
//  Copyright © 2016年 Andrew. All rights reserved.
//

import UIKit


let NN_SerialNumber = "SerialNumber"
let NN_xuetangyiType = "xuetangyiType"
let NN_xuetangyiSN = "xuetangyiSN"


class ReadBoxDataController: UIViewController,KOALSwiperDelegate {

   
    
    var swiper:KOALSwiper!
    var numInput:Int = 50//输入的条数
    var bloodType:String = "" //血糖类型
    /// 接收硬件发回来的数据
    var NoticeReturnValue:String?
    /// 第一次发送收到值为1，未收到为0
    var isRecive:Bool = false
    
    /// 血糖仪类型
    var xueTangYiType:String = ""
    
    
    //MARK: - 音频数据
    /// 接收硬件发回来的数据
    var noticeReturnValueLK:NSString?;
    /// 0x40返回来的值
    var reture0X40Value:NSString?;
    /// 0x41返回来的值
    var reture0X41Value:NSString?;
    var retureECK:NSString?;
    /// 0x42返回来的值
    var reture0X42Value:NSString?;
    /// 0x43返回来的值
    var reture0X43Value:NSString?;
    
    /// 解析后数据（去（）截字符再转型最终得到的数据
    var analyzingRecorderStrLK:NSMutableString =  NSMutableString()
    
    
    //发送0x40的解析数据
    /// 0x40发送命令符
    var designatorWith0x40LK:NSString?;
    /// 血糖仪类型
    var GlucoseType:NSString?;
    
    //MARK: - 发送0x41的解析数据
    /// 0x41发送命令符
    var designatorWithSendLK:NSString?;
    /// 0x41固定版本
    var version:NSString?;//
    /// 0x41电量
    var electric:NSString?;//
    /// 0x41序列号
    var SerialNumber:NSString?;
    
    //MARK: - 读血糖0x42的解析数据
    /// 0x42命令符
    var designatorWithGLYXStrLK:NSString?;
    /// 0x42血糖仪状态
    var statuOfGlucoseMeterLK:NSString?;
    /// 0x42识别血糖仪类型
    var recognitionSizeLK:NSString?;
    /// 0x42血糖仪固定版本号1
    var versionNumberOneLK:NSString?;
    /// 0x42血糖仪固定版本号2
    var versionNumberTwoLK:NSString?;
    /// 0x42血糖仪当前日期和时间
    var currentTimeLK:NSString?;
    /// 0x42血糖仪中总共数据条数
    var NumberByteOfDataLK:NSString?;
    /// 0x42血糖仪序列号
    var serialOfGlucoseMeterLK:NSString?;
    
    //MARK: - 读数据0x43的解析数据
    /// 0x43命令符
    var designatorWithDataStrLK:NSString?;
    /// 第几包
    var bagthStrLK:NSString?;
    /// 数据条数
    var dataNumStrLK:NSString?;
    var dateMuStrLK:NSString?;//年月日
    /// 血糖值数组
    var GLYXMuArr:NSMutableArray = NSMutableArray()
    /// 时间数组
    var DateMuArr:NSMutableArray = NSMutableArray();
    /// 血糖和时间后面的一位特殊字节
    var specialStrArr = NSMutableArray();
    
    var nTimer:NSTimer?;
    var conut:Int = 0;
    
    var totalMutableArray:NSMutableArray = NSMutableArray()
    
    /// 0为自动识别到血糖仪类型，1为未识别跳转选择页面
    var isIdentification:Int = 0;
    /// 成功同步的条数
    var successNum:Int!;
    /// 1(true)为读到类型，0为未读到类型
    var isRead:Bool = false
    
    /// 显示的提示信息，比如盒子开机，读取数据等
    var showTipMsg:NSMutableString = NSMutableString()
    
    
    var isECK:Bool = false
    var isEnd:Bool = false
    var isBag:Bool = false
    
    /// 进度条
    var progressView:LDProgressView!;
    
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
        
        let screen_width = UIScreen.mainScreen().bounds.width
        let screen_height = UIScreen.mainScreen().bounds.height
        
        var rect = CGRectMake(10, 64+15, 100, 20)
        let tipLb = UILabel(frame: rect)
        tipLb.text = "读取数据中..."
        self.view.addSubview(tipLb)
        
        rect = CGRectMake(10, CGRectGetMaxY(tipLb.frame)+10, screen_width-20, 30)
        progressView = LDProgressView(frame: rect)
        progressView.color = UIColor.redColor()
        progressView.flat = true
        progressView.showText = true
        progressView.animate = true
        progressView.progress = 0.00;//传值用
        self.view.addSubview(progressView)
        progressView.type=LDProgressSolid
    }
    
    
    //MARK: -  延时重发0x40
    
    func delay0x40Method() -> Void {
        
        self.conut += 1
        
        self.sendData("40")
        
        if(self.conut>3){
          sendEnd()
            showAlert("抱歉", msg: "血糖仪连接失败，请稍后重试...")
            nTimer?.invalidate()
            nTimer = nil
            return
        }
    }
    func delay0x41Method() -> Void {
        
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
    func sendEnd() -> Void {
        self.conut += 1;
        
        self.sendData("44")
        
        if (self.conut>=2) {
            nTimer?.invalidate()
            nTimer = nil
            return;
        }
    }
    //MARK: - 第二套音频源码交互
    /**
     第二套音频源码交互
     */
    func vioceDataInteraction() -> Void {
        
        nTimer = NSTimer(timeInterval: 1.5, target: self, selector: #selector(delay0x40Method), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(nTimer!, forMode: NSDefaultRunLoopMode)
        
        nTimer?.fire()
    }
    

}

extension ReadBoxDataController{
  //MARK: - Help methods
    /**
     将整串字符串分割成每两个字符一个字节
     
     - parameter strUrl:
     */
    func CutTwoStrLK(strUrl:NSString) -> Void {
        
        var str:NSString?
        var changeStr:NSString?
        
        let utils = NNIT_Utils()
        
        for item in 0..<(strUrl.length)/2 {
            
            str = strUrl.substringWithRange(NSMakeRange(item*2, 2))
            //16进制转字符串
            changeStr = utils.stringFromHexStringLK(str! as String)
            analyzingRecorderStrLK.appendString(changeStr! as String)
        }
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
    
    //MARK: - 写数据成功
    func writeCustomDataSuccessful() {
        print("写数据成功了")
        
        
    }
    
    //MARK: - 成功读取自定义数据
    func swiperDidObtianCustomData(result: String!) {
        print("成功读取自定义数据:\(result)")
       sendData("40")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            dispatch_sync(dispatch_get_main_queue(), {
                if(result == "284429"){
                    //取消执行
                   self.nTimer?.invalidate()
                    self.nTimer = nil
                }
                
                if(self.isRecive == true){
                  return
                }
                
                //接收硬件发回来的数据
                self.noticeReturnValueLK = result
                let range = NSMakeRange(2, self.noticeReturnValueLK!.length - 4);
                
                let strUrl = self.noticeReturnValueLK?.substringWithRange(range)
                //将整串字符串分割成每两个字符一个字节
                self.CutTwoStrLK(strUrl!)
                
                /// 解析完的字节码
                let designator = self.analyzingRecorderStrLK.substringWithRange(NSMakeRange(0, 1));
                
                //如果是自动识别到血糖仪
                if(self.isIdentification == 0){
                    if(designator == "Q"){
                        self.isECK = false
                        self.isEnd = false
                        self.xueTangYiType = ""
                        
                        //取消执行
                        self.nTimer?.invalidate()
                        self.nTimer = nil
                        
                        self.GlucoseType = ""
                        self.reture0X40Value = self.analyzingRecorderStrLK as String
                        //第一次收到值为true
                        self.isRecive = true
                        //分析0x40的数据
                        self.analyzing0x40Data()
                        
                        if(self.GlucoseType != "000"){
                            //1为读到类型，0为未读到类型
                            self.isRead = true
                            self.isRecive = false
                            self.isIdentification = 0
                            self.showTipMsg.appendString("已检测到血糖仪...\n")
                            
                            self.progressView.progress = 0.1
                            //发请求
                            self.vioceDataInteraction()
                        }else{
                          self.isRecive = false
                            self.showTipMsg.appendString("未识别血糖仪，请手动选择...\n")
                            self.isIdentification = 1
                            self.isECK=false;
                            self.isEnd=false;
                            
                            //跳转到选择血糖仪的页面
                        }
                        
                    }
                    
                    if(designator == "P"){
                        self.isRecive = false
                        //取消执行
                        self.nTimer?.invalidate()
                        self.showTipMsg.appendString("手机和盒子正在通讯..\n")
                        self.progressView.progress = 0.20
                        
                        self.conut = 0
                        //发请求
                        self.nTimer = NSTimer(timeInterval: 1.5, target: self, selector: #selector(self.delay0x41Method), userInfo: nil, repeats: true)
                        NSRunLoop.mainRunLoop().addTimer(self.nTimer!, forMode: NSDefaultRunLoopMode)
                        
                        self.nTimer?.fire()
                    }
                    
                }
                
            })
        }
    }
    
    func sdkThrowException(e: NSException!, errorMessage errorMsg: String!) {
        print("输入参数错误")
    }
}



extension ReadBoxDataController{
  //MARK: - 分析收到的数据，进行解析
    
    //MARK: - 0x40
    func analyzing0x40Data() -> Void {//第一开始接收到的值，在40之前
        //发送命令符
        self.designatorWith0x40LK=reture0X40Value?.substringWithRange(NSMakeRange(0, 1))
        
        //血糖仪类型
        let range = NSMakeRange(1, 3)
        GlucoseType=reture0X40Value?.substringWithRange(range)
    }
    //MARK: - 0x41
    func analyzing0x41Data() -> Void {
        if (self.reture0X41Value!.length)<19{
            showAlert("抱歉", msg: "盒子的序列号位数不对")
            return
        }
        // 0 1234 567 89 10 11
        designatorWithSendLK = reture0X41Value?.substringWithRange(NSMakeRange(0, 1))
        //0x41固定版本
        version = analyzingRecorderStrLK.substringWithRange(NSMakeRange(1, 4))
        //0x41电量
        electric = analyzingRecorderStrLK.substringWithRange(NSMakeRange(5,3))
        //0x41序列号
        SerialNumber = reture0X41Value?.substringWithRange(NSMakeRange(8, 11))
        /**
         *  存储，后面盒子SN需要
         */
        NSUserDefaults.standardUserDefaults().setObject(SerialNumber, forKey: NN_SerialNumber)
    }
    //收到盒子信息
    func analyzingECK() -> Void {
        
    }
    //MARK: - 0x42
    func analyzing0x42Data() -> Void {
        if(self.reture0X42Value!.length<47){
           showAlert("抱歉", msg: "血糖仪的序列号位数不对")
            return
        }
        //命令符 一个字节
        designatorWithGLYXStrLK = reture0X42Value?.substringWithRange(NSMakeRange(0, 1))
        // 血糖仪状态  一个字节
        statuOfGlucoseMeterLK=reture0X42Value?.substringWithRange(NSMakeRange(1, 1))
        //识别血糖仪类型 三个字节
        recognitionSizeLK = reture0X42Value?.substringWithRange(NSMakeRange(2, 3))
        //血糖仪固定版本号1  6个字节
        versionNumberOneLK = reture0X42Value?.substringWithRange(NSMakeRange(5, 6))
        //血糖仪固定版本号2   6个字节
        versionNumberTwoLK = reture0X42Value?.substringWithRange(NSMakeRange(11, 6))
        
        //血糖仪当前日期和时间   12个字节
        currentTimeLK = reture0X42Value?.substringWithRange(NSMakeRange(17, 12))
        //血糖仪中总共数据条数     3个字节
        NumberByteOfDataLK = reture0X42Value?.substringWithRange(NSMakeRange(29, 3))
        //血糖仪序列号       15个字节
        serialOfGlucoseMeterLK = reture0X42Value?.substringWithRange(NSMakeRange(32, 15))
        //selectType 血糖仪类型
        NSUserDefaults.standardUserDefaults().setObject(GlucoseType, forKey: NN_xuetangyiType)
        //存储血糖仪SN
        NSUserDefaults.standardUserDefaults().setObject(serialOfGlucoseMeterLK, forKey: NN_xuetangyiSN)
        
        reture0X42Value = ""
        noticeReturnValueLK = ""
    }
    
    //MARK: - 0x43
    func analyzing0x43Data() -> Void {
        //0x43命令符 一字节C或者#
        designatorWithDataStrLK = reture0X43Value?.substringWithRange(NSMakeRange(0, 1))
        //第几包
        let str1 = reture0X43Value?.substringWithRange(NSMakeRange(1, 1))
        let str2 = reture0X42Value?.substringWithRange(NSMakeRange(2, 1))
        
        bagthStrLK = "\(str1!)\(str2!)"
        //数据条数 两字节
        dataNumStrLK = reture0X43Value?.substringWithRange(NSMakeRange(3, 2))
        
        let num = Int(dataNumStrLK as! String)
        var GLYXAndDateStr:NSString?;
        var dateString:NSString?;
        var glyxStr:NSString?;
        var specialStr:NSString?
        //解析出多包血糖值和时间
        for index in 0..<num! {
            GLYXAndDateStr = reture0X43Value?.substringWithRange(NSMakeRange(5+15*index, 4+10+1))
            //血糖值
            glyxStr = GLYXAndDateStr?.substringWithRange(NSMakeRange(0, 4))
            
            for i in 0..<4 {
                //(0,1)(1,1)(2,1)(3,1)
                let str = glyxStr?.substringWithRange(NSMakeRange(i, 1))
                if str! == "H"{
                    glyxStr="450";//把最高33.3（600）改成25
                }else if(str! == "L"){
                    glyxStr="9";
                }
            }
            
            let glyxValue = glyxStr?.integerValue
            if (glyxValue>600) {
                glyxStr="333";
            }
            //年月日
            dateString = GLYXAndDateStr?.substringWithRange(NSMakeRange(4, 10))
            //特殊符 1个字节
            specialStr = GLYXAndDateStr?.substringWithRange(NSMakeRange(14, 1))
            
            specialStrArr.addObject(specialStr!)
            let utils = NNIT_Utils()
            utils.ConversionOfGLYXLK(glyxStr! as String, time: dateString as! String, xueTangYiType: GlucoseType as! String, dateMuArr: DateMuArr, GLYXMuArr: GLYXMuArr)
            
            if(designatorWithDataStrLK != nil){
                if(GLYXMuArr.count == DateMuArr.count){
                  //清空音频数据库中的内容
                     self.NoticeReturnValue = ""
                     reture0X43Value = ""
                }
            }
            
            self.NoticeReturnValue = ""
            reture0X43Value = ""
            
        }
    }
    
    
    func showAlert(title:String,msg:String) -> Void {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}

