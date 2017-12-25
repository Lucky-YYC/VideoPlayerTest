//
//  YCPlayerView.h
//  ios_app_weke
//
//  Created by 王月超 on 2017/12/22.
//  Copyright © 2017年 wyc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface YCPlayerView : UIView
@property(nonatomic,strong)AVPlayer * player;

@property(nonatomic,strong)AVPlayerLayer * playerLayer;
@end
