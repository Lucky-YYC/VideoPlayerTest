//
//  WekeUtil.m
//  ios_app_weke
//
//  Created by 王月超 on 2017/12/11.
//  Copyright © 2017年 wyc. All rights reserved.
//

#import "WekeUtil.h"
#import<CommonCrypto/CommonDigest.h>
@implementation WekeUtil


+ (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

+(id)toJsonObject:(NSString*)string {
    
    if (nil == string) {
        return nil;
    }
    
    NSError* error = nil;
    NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    return dict;
}

+(long)getTimestampSecond {
    return [[NSDate date] timeIntervalSince1970];
}

+(long long)getTimestamp {
    return [[NSDate date] timeIntervalSince1970] * 1000;
}
+(NSString*)getTimestampString {
    long long timestamp = [[NSDate date] timeIntervalSince1970];
    return [NSString stringWithFormat:@"%lld", timestamp];
}

+(UIFont*)getUIFontWithRate:(NSInteger)number{
   return  [UIFont fontWithName:@"PingFangSC-Regular" size:number*TextRate];
}
+ (UIFont*)getUIFontWithoutRate:(NSInteger)number{
     return  [UIFont fontWithName:@"PingFangSC-Regular" size:number];
}
+ (UIFont *)getBoldUIFontWithRate:(NSInteger)number{
    return  [UIFont fontWithName:@"PingFangSC-Semibold" size:number*TextRate];
}
+ (UIFont *)getBoldUIFontWithoutRateBold:(NSInteger)number{
     return  [UIFont fontWithName:@"PingFangSC-Semibold" size:number];
}


//计算缓存大小
+( float )readCacheSize{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES) firstObject];
    return [self folderSizeAtPath:cachePath];
}
+ (float)folderSizeAtPath:( NSString *) folderPath{
    NSFileManager * manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject]) != nil ){
        //获取文件全路径
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
    }
    return (folderSize+[SDImageCache sharedImageCache].getSize)/( 1024.0 * 1024.0);
}
// 计算 单个文件的大小
+(long long) fileSizeAtPath:( NSString *) filePath{
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath :filePath]){
        return [[manager attributesOfItemAtPath :filePath error : nil] fileSize];
    }
    return 0;
}
//秒数转时间格式
+ (NSString *)timeFormatted:(int)totalSeconds{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    //    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}
+(UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)newSize{
    CGFloat scale = [[UIScreen mainScreen]scale];
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
