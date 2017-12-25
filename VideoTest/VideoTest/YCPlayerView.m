//
//  YCPlayerView.m
//  ios_app_weke
//
//  Created by 王月超 on 2017/12/22.
//  Copyright © 2017年 wyc. All rights reserved.
//

#import "YCPlayerView.h"

@implementation YCPlayerView
+(Class)layerClass{
    return [AVPlayerLayer class];
}
- (AVPlayer*)player{
    return [(AVPlayerLayer *)[self layer] player];
}
- (void)setPlayer:(AVPlayer *)player{
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}
- (AVPlayerLayer *)playerLayer{
    return (AVPlayerLayer *)self.layer;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
