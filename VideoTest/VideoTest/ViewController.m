//
//  ViewController.m
//  VideoTest
//
//  Created by 王月超 on 2017/12/25.
//  Copyright © 2017年 wyc. All rights reserved.
//

#import "ViewController.h"
#import "WekeVideoPlayerView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WekeVideoPlayerView *player = [[WekeVideoPlayerView alloc]init];
    [self.view addSubview:player];
    player.url = @"";
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
