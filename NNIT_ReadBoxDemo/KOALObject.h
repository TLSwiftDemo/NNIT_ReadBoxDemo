
struct KOAL_RW_DATA{
    UInt8 dataBuffer[256];//数据缓冲区
    UInt8 dataBufferLength;//缓冲区长度
};


typedef struct KOAL_RW_DATA KOAL_COMMAND;
typedef struct KOAL_RW_DATA KOAL_DATA;

#define CUSTOM_DATA_MAX_LEN 250

typedef enum
{
    STATE_SWIPER_INITIALIZED    =   -1,                 //已初始化 初次获得对象的默认状态
	STATE_DEVICE_UNPLUGEED      =    0,                 //刷卡器已拔出
	STATE_DEVICE_PLUGEED        =    1,                 //刷卡器已插入
}KOALSwiperState;




//音频设备错误
#define   ERROR_INIT_AUDIO_SESSION_FAILED                   0xa //ERROR INITIALIZING AUDIO SESSION
#define   ERROR_COULDNOT_SET_AUDIO_CATEGORY                 0xb //COULDNOT SET AUDIO CATEGORY
#define   ERROR_ADDING_AUDIO_SESSION_PROP_LISTENER          0xc //ERROR ADDING AUDIO SESSION PROP LISTENER!
#define   ERROR_GETTING_INPUT_AVAILABILITY                  0xd //音频输入不可用
#define   ERROR_SET_AUSIOSESSION_ACTIVE_FAILED              0xe //激活音频会话失败


#define   CODE_ERROR_INIT_AUDIO_SESSION_FAILED              @"ERROR INITIALIZING AUDIO SESSION"
#define   CODE_ERROR_COULDNOT_SET_AUDIO_CATEGORY            @"COULDNOT SET AUDIO CATEGORY"
#define   CODE_ERROR_ADDING_AUDIO_SESSION_PROP_LISTENER     @"ERROR ADDING AUDIO SESSION PROP LISTENER"
#define   CODE_ERROR_GETTING_INPUT_AVAILABILITY             @"音频输入不可用"
#define   CODE_ERROR_SET_AUSIOSESSION_ACTIVE_FAILED         @"激活音频会话失败"

