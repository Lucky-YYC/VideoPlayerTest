//
//  WekeVideoPlayerView.h
//  ios_app_weke
//
//  Created by 王月超 on 2017/12/22.
//  Copyright © 2017年 wyc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol WekeVideoPlayerDelegate <NSObject>

@optional

/** 播放完毕 */
- (void)WekeVideoDidFinishedPlay;


@end


@interface WekeVideoPlayerView : UIView



/**传入URL即可播放*/
@property (nonatomic,copy)NSString *url;

//是否正在播放
@property (nonatomic,assign) BOOL isPlaying;
//是否全屏
@property (nonatomic,assign) BOOL isFullScreen;

@property (nonatomic,weak) id <WekeVideoPlayerDelegate>delegate;
@end
