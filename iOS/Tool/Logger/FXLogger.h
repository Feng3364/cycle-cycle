//
//  FXLogger.h
//  FXTrack
//
//  Created by Felix on 2023/1/13.
//

#if DEBUG
#define FXLog(s, ...) NSLog(@"\n******************** ð START ð ********************\næä»¶åï¼%@\nè¡å·ï¼%dè¡\næ¹æ³åï¼%s\nä¿¡æ¯ï¼%@\n******************** ð END ð ********************", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __func__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define FXLog(s, ...)
#endif
