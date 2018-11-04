//
//  SMRLogSys.h
//  SMRLogSystemDemo
//
//  Created by 丁治文 on 2018/8/15.
//  Copyright © 2018年 tinswin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SMRFunctionName          (SMRToString(@"%s", __PRETTY_FUNCTION__))
#define SMRToString(a...)        ([NSString stringWithFormat:a])

#define SMRLog0(desc) \
            ([SMRLogSys outputSMRLogToFile:SMRToString(desc) fcName:SMRFunctionName])
#define SMRLog1(desc, arg1) \
            ([SMRLogSys outputSMRLogToFile:SMRToString(desc, arg1) fcName:SMRFunctionName])
#define SMRLog2(desc, arg1, arg2) \
            ([SMRLogSys outputSMRLogToFile:SMRToString(desc, arg1, arg2) fcName:SMRFunctionName])
#define SMRLog3(desc, arg1, arg2, arg3) \
            ([SMRLogSys outputSMRLogToFile:SMRToString(desc, arg1, arg2, arg3) fcName:SMRFunctionName])
#define SMRLog4(desc, arg1, arg2, arg3, arg4) \
            ([SMRLogSys outputSMRLogToFile:SMRToString(desc, arg1, arg2, arg3, arg4) fcName:SMRFunctionName])
#define SMRLog5(desc, arg1, arg2, arg3, arg4, arg5) \
            ([SMRLogSys outputSMRLogToFile:SMRToString(desc, arg1, arg2, arg3, arg4, arg5) fcName:SMRFunctionName])

@interface SMRLogSys : NSObject

/// 日志同时会显示在控制台上
+ (void)outputSMRLogToFile:(NSString *)log fcName:(NSString *)fcName;
/// 将NSLog的日志备份到文件,设置了这个选项后,控制台将不会显示log了
+ (void)outputNSlogToFile;

/// 设置完此时间后,log可显示相对时间
+ (void)setBeginTime;
/// 清除
+ (BOOL)clear;
/// 打印日志输出的地址
+ (void)printFilePath;

@end
