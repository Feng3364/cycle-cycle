//
//  FXLogger.h
//  FXTrack
//
//  Created by Felix on 2023/1/13.
//

#if DEBUG
#define FXLog(s, ...) NSLog(@"\n******************** 💛 START 💛 ********************\n文件名：%@\n行号：%d行\n方法名：%s\n信息：%@\n******************** 💛 END 💛 ********************", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __func__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define FXLog(s, ...)
#endif
