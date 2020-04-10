

#ifndef _JSL_SYSLOG_MACRO_H_
#define _JSL_SYSLOG_MACRO_H_

/* 控件台打印 */
#ifdef DEBUG
#define JSLLog(format, ...) printf("[%s] [DEBUG] %s [第%d行] => %s \n", [[JSLLogUtil getCurrentTimeStamp] UTF8String], __PRETTY_FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String])
#else
#define JSLLog(__FORMAT__, ...)
#endif

#endif /* _JSL_SYSLOG_MACRO_H_ */

