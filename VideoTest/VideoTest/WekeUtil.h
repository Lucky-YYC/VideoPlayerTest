//
//  WekeUtil.h
//  ios_app_weke
//
//  Created by 王月超 on 2017/12/11.
//  Copyright © 2017年 wyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WekeUtil : NSObject
+(BOOL)isLogin;
//MD5加密
+ (NSString *) md5:(NSString *) input ;
 /**
  获取秒时间戳
  */
+(long)getTimestampSecond;
/**
 获取毫秒时间戳
 */
+(long long)getTimestamp;
/**
 获取字符串时间戳
 */
+(NSString*)getTimestampString;

+(UIFont*)getUIFontWithRate:(NSInteger)number;

+(UIFont *)getUIFontWithoutRate:(NSInteger)number;

+ (UIFont *)getBoldUIFontWithRate:(NSInteger)number;

+ (UIFont *)getBoldUIFontWithoutRateBold:(NSInteger)number;


/**
 获取缓存
 */
+( float )readCacheSize;

/**
 秒数转换成时间格式

 @param totalSeconds 总时间
 */
+ (NSString *)timeFormatted:(int)totalSeconds;

/**
 * 改变图片的大小适配图片
 */
+(UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)newSize;
@end
