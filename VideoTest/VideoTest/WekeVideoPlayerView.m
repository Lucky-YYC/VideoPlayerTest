//
//  WekeVideoPlayerView.m
//  ios_app_weke
//
//  Created by 王月超 on 2017/12/22.
//  Copyright © 2017年 wyc. All rights reserved.
//

#import "WekeVideoPlayerView.h"
#import "YCSlider.h"
#import "YCPlayerView.h"
#import "RotationScreen.h"
#define PlayerHeight  200*WidthRate

@interface WekeVideoPlayerView(){
    id playbackTimerObserver;
}
@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic,strong) AVPlayerLayer *playerLayer;
@property (nonatomic,strong) AVPlayerItem *playItem;
@property (nonatomic,strong) YCPlayerView *playerView;
//总时长
@property (nonatomic,copy) NSString*totalTime;
//当前时间
@property (nonatomic,copy) NSString*currentTime;
//播放器Playback Rate
@property (nonatomic,assign) CGFloat rate;
//上面工具条
@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)UIButton *backPopBtn;
@property (nonatomic,strong)UILabel *titleLB;
//下面工具条
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)UILabel *allTimeLB;
@property (nonatomic,strong)UILabel *starTimeLB;
@property (nonatomic,strong)UIButton *play_stopBtn;
@property (nonatomic,strong)YCSlider *slider;
@property (nonatomic,strong)UIButton *collectBtn;
@property (nonatomic,strong)UIButton *fullBtn;
/**操作层*/
@property (nonatomic,strong)UIView *touchView;
/**菊花*/
@property (nonatomic,strong)UIActivityIndicatorView *tipView;



@property (nonatomic,strong)UIView *backTapView;
@property (nonatomic,strong)UIView *playOrStopTapView;
@property (nonatomic,strong)UIView *fullBtnTapView;
@property (nonatomic,strong)UIView *collectTapView;
@end


@implementation WekeVideoPlayerView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =rgba(147,147,147,1);
        self.userInteractionEnabled = YES;
        [self setPlayer];
        [self setUI];
        [self setTapUI];
    }
    return self;
}
- (void)setTapUI{
    [self addSubview:self.backTapView];
    CGFloat topViewTop;
    if (kDevice_Is_iPhoneX) {
        topViewTop = 0;
    }else{
        topViewTop = StatusRectHeight;
    }
    self.backTapView.sd_layout
    .leftSpaceToView(self, 0)
    .topSpaceToView(self, topViewTop)
    .heightIs(40)
    .widthIs(50);
}
- (void)setUI{
    //播放器界面
    [self addSubview:self.playerView];
    self.playerView.backgroundColor = [UIColor clearColor];
    self.playerView.sd_layout
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .topSpaceToView(self, 0)
    .bottomSpaceToView(self, 0);
    
    //操作层
    [self addSubview:self.touchView];
    self.touchView.sd_layout
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .topSpaceToView(self, 0)
    .bottomSpaceToView(self, 0);
    
#pragma mark ==========下方工具条==========
    [self.touchView addSubview:self.bottomView];
    self.bottomView.sd_layout
    .bottomSpaceToView(self.touchView, 0)
    .heightIs(30*WidthRate)
    .leftSpaceToView(self.touchView, 0)
    .rightSpaceToView(self.touchView, 0);
    
    //菊花
    
    [self.touchView addSubview:self.tipView];
    self.tipView.sd_layout
    .centerXEqualToView(self.touchView)
    .centerYEqualToView(self.touchView);
    [self.tipView startAnimating];
    
    //播放/暂停按钮
    [self.bottomView addSubview:self.play_stopBtn];
    self.play_stopBtn.sd_layout
    .leftSpaceToView(self.bottomView, 15*WidthRate)
    .centerYEqualToView(self.bottomView)
    .widthIs(self.play_stopBtn.currentBackgroundImage.size.width*WidthRate)
    .heightIs(self.play_stopBtn.currentBackgroundImage.size.height*WidthRate);
    
    //播放时间
    [self.bottomView addSubview:self.starTimeLB];
    self.starTimeLB.sd_layout
    .leftSpaceToView(self.bottomView, 37*WidthRate)
    .centerYEqualToView(self.bottomView)
    .heightIs(10*TextRate);
    [self.starTimeLB setSingleLineAutoResizeWithMaxWidth:MAXFLOAT];
    //全屏按钮
    [self.bottomView addSubview:self.fullBtn];
    self.fullBtn.sd_layout
    .rightSpaceToView(self.bottomView, 8*WidthRate)
    .centerYEqualToView(self.bottomView)
    .heightIs(self.fullBtn.currentBackgroundImage.size.height*WidthRate)
    .widthIs(self.fullBtn.currentBackgroundImage.size.width*WidthRate);
    //收藏
    [self.bottomView addSubview:self.collectBtn];
    self.collectBtn.sd_layout
    .rightSpaceToView(self.fullBtn, 12*WidthRate)
    .centerYEqualToView(self.bottomView)
    .widthIs(self.collectBtn.currentBackgroundImage.size.width *WidthRate)
    .heightIs(self.collectBtn.currentBackgroundImage.size.height *WidthRate);
    //总时间
    [self.bottomView addSubview:self.allTimeLB];
    self.allTimeLB.sd_layout
    .rightSpaceToView(self.collectBtn, 12*WidthRate)
    .centerYEqualToView(self.bottomView)
    .heightIs(10*TextRate);
    [self.allTimeLB setSingleLineAutoResizeWithMaxWidth:MAXFLOAT];
    //进度条
    [self.bottomView addSubview:self.slider];
    self.slider.sd_layout
    .leftSpaceToView(self.starTimeLB, 5*WidthRate)
    .rightSpaceToView(self.allTimeLB, 5*WidthRate)
    .centerYEqualToView(self.bottomView)
    .heightIs(2);
#pragma mark ==========上方工具条==========
    [self.touchView addSubview:self.topView];
    static CGFloat topViewTop;
    if (kDevice_Is_iPhoneX) {
        topViewTop = 0;
    }else{
        topViewTop = StatusRectHeight;
    }
    self.topView.sd_layout
    .topSpaceToView(self.touchView, topViewTop)
    .heightIs(30*WidthRate)
    .leftSpaceToView(self.touchView, 0)
    .rightSpaceToView(self.touchView, 0);
    
    [self.topView addSubview:self.backPopBtn];
    self.backPopBtn.sd_layout
    .leftSpaceToView(self.topView, 15*WidthRate)
    .centerYEqualToView(self.topView)
    .widthIs(self.backPopBtn.currentBackgroundImage.size.width*WidthRate*0.8)
    .heightIs(self.backPopBtn.currentBackgroundImage.size.height*WidthRate*0.8);
    
    
    [self.topView addSubview:self.titleLB];
    self.titleLB.text = @"哈哈哈哈哈哈";
    self.titleLB.sd_layout
    .leftSpaceToView(self.backPopBtn, 15*WidthRate)
    .centerYEqualToView(self.topView)
    .heightIs(16*TextRate);
    [self.titleLB setSingleLineAutoResizeWithMaxWidth:MAXFLOAT];
    
    
}

#pragma mark ==========工具条交互==========
- (void)play_stopBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.isPlaying = !sender.selected;
}
- (void)touchViewClick{
    NSLog(@"全屏");
}

- (void)fullBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if ([RotationScreen isOrientationLandscape]) { // 如果是横屏，
        [RotationScreen forceOrientation:(UIInterfaceOrientationPortrait)]; // 切换为竖屏
    } else {
        [RotationScreen forceOrientation:(UIInterfaceOrientationLandscapeRight)]; // 否则，切换为横屏
    }
}
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    //以verticalClass 来判断横竖屏
    static CGFloat topSpace ;
    if (kDevice_Is_iPhoneX) {
        topSpace = StatusRectHeight;
    }else{
        topSpace = 0;
    }
    if (self.traitCollection.verticalSizeClass != UIUserInterfaceSizeClassCompact) { // 竖屏
        self.frame =  CGRectMake(0, topSpace, screen_width, PlayerHeight);
        self.fullBtn.selected = NO;
    } else { // 横屏
        self.frame =  CGRectMake(0, 0, screen_width, screen_height);
        self.fullBtn.selected = YES;
    }
}
- (void)collectBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
}
- (void)backPopBtnClick{
    if (self.viewController.presentingViewController) {
        [self.viewController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else{
        [self.viewController.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark ==========Slider交互方法==========
-(void)handleSliderPosition:(UISlider *)slider{
    [self.player seekToTime:CMTimeMake(slider.value * [self AllTime], 1)];
}
- (void)sliderDragUp:(UISlider *)slider{
    [self.player seekToTime:CMTimeMake(slider.value * [self AllTime], 1)];
}

#pragma mark ==========setPlayer==========
- (void)setPlayer{
    //创建player
    self.player = [[AVPlayer alloc]init];
    //创建layer
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    // AVLayerVideoGravityResizeAspect 等比例拉伸，会留白
    // AVLayerVideoGravityResizeAspectFill // 等比例拉伸，会裁剪
    // AVLayerVideoGravityResize // 保持原有大小拉伸
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    self.playerView.player = self.player;
    [self.playerView.playerLayer  addSublayer:self.playerLayer];
    
}
- (void)setPlayerLayer{
    //创建item
    self.playItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:_url]];
    [self.player replaceCurrentItemWithPlayerItem:self.playItem];
    [self addKVO];
    [self addNotification];
    [self addPeriodicTimeObserver];
}
- (void)dealloc{
    NSLog(@"%s",__func__);
    [self.player replaceCurrentItemWithPlayerItem:nil];
    [self.playItem removeObserver:self forKeyPath:@"status"];
    [self.playItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.player removeTimeObserver:playbackTimerObserver];
    playbackTimerObserver = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/**添加观察者*/
- (void)addKVO{
    [self.playItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];//播放状态
    [self.playItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil]; //缓存
}
/**添加通知*/
- (void)addNotification{
    // 播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    // 前台通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
    // 后台通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
}
- (void)playbackFinished{
    NSLog(@"播放完成");
    if ([self.delegate respondsToSelector:@selector(WekeVideoDidFinishedPlay)]) {
        [self.delegate WekeVideoDidFinishedPlay];
    }
}
- (void)enterForegroundNotification{
    NSLog(@"进入前台");
}
- (void)enterBackgroundNotification{
    NSLog(@"进入后台");
}
#pragma mark KVO - 检测播放状态
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]){
        AVPlayerItemStatus status = [change[@"new"] integerValue];
        switch (status) {
            case AVPlayerItemStatusReadyToPlay:{
                NSLog(@"readyToPlay");
                self.isPlaying = YES;
            }break;
            case AVPlayerItemStatusFailed:{
                NSLog(@"加载失败");
            }break;
            case AVPlayerItemStatusUnknown:{
                NSLog(@"未知资源");
            }break;
            default:
                break;
        }
    }else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSArray *array=self.playItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
//                    NSLog(@"共缓冲：%.2f",totalBuffer);
    }
}
//FIXME: Tracking time,跟踪时间的改变
-(void)addPeriodicTimeObserver{
    __weak typeof(self) weakSelf = self;
    playbackTimerObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.f, 1.f) queue:NULL usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time);
        float total = CMTimeGetSeconds(weakSelf.playItem.duration);
        if (current) {
            weakSelf.slider.value = current / total;
            weakSelf.currentTime = [NSString stringWithFormat:@"%@",[weakSelf timeFormatted:[weakSelf presentTime]]];
            weakSelf.totalTime = [NSString stringWithFormat:@"%@",[weakSelf timeFormatted:[weakSelf AllTime]]];
        }
    }];
}
- (void)setCurrentTime:(NSString *)currentTime{
    _currentTime = currentTime;
    self.starTimeLB.text = currentTime;
}
- (void)setTotalTime:(NSString *)totalTime{
    _totalTime = totalTime;
    self.allTimeLB.text = totalTime;
}
#pragma mark - timer设置格式
//不带0 格式为0：05
-(NSString *)Lookvideotimr:(NSInteger )timer{
    NSString * AllTime;
    NSInteger time = timer;
    if ((time - time/60 * 60 < 10 && time/60!=0) || time < 10){
        AllTime = [NSString stringWithFormat:@"%ld:0%ld",(long)time/60,(long)(time - time/60 * 60)];
    }
    else{
        AllTime = [NSString stringWithFormat:@"%ld:%ld",(long)time/60,(long)(time - time/60 * 60)];
    }
    return AllTime;
}
//带0  格式为00：06
- (NSString *)timeFormatted:(NSInteger)totalSeconds{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}
//当前播放时间
-(NSInteger )presentTime{
    CGFloat time = 0;
    time = CMTimeGetSeconds(self.player.currentItem.currentTime);
    return time;
}
//总时间
-(NSInteger)AllTime{
    CMTime duration = self.player.currentItem.duration;
    NSInteger seconds = CMTimeGetSeconds(duration);
    return seconds;
}

#pragma mark ==========入口方法==========
- (void)setIsPlaying:(BOOL)isPlaying{
    _isPlaying = isPlaying;
    if (isPlaying) {
        [self.player play];
        [self.tipView stopAnimating];
    }else{
        [self.player pause];
        [self.tipView startAnimating];
    }
}
- (void)setUrl:(NSString *)url{
    _url = url;
    //判断不为空  我这里简单判断了一下
    if (url.length != 0) {
        [self setPlayerLayer];
    }
}



#pragma mark ==========LAZY==========
- (UIView *)touchView{
    if(!_touchView){
        _touchView = [[UIView alloc]init];
        _touchView.backgroundColor = [UIColor clearColor];
        _touchView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchViewClick)];
        [_touchView addGestureRecognizer:tap];
    }
    return _touchView;
}
- (UIView *)bottomView{
    if(!_bottomView){
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = rgba(0,0,0,0.2);
    }
    return _bottomView;
}
- (UIView *)topView{
    if(!_topView){
        _topView = [[UIView alloc]init];
        _topView.backgroundColor = [UIColor clearColor];
    }
    return _topView;
}

- (UIActivityIndicatorView *)tipView{
    if(!_tipView){
        _tipView = [[UIActivityIndicatorView alloc]init];
        _tipView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        _tipView.color = WekeNVColor;
        _tipView.hidesWhenStopped = YES;
    }
    return _tipView;
}
- (YCPlayerView *)playerView{
    if(!_playerView){
        _playerView = [[YCPlayerView alloc]init];
    }
    return _playerView;
}

- (YCSlider *)slider{
    if(!_slider){
        _slider = [[YCSlider alloc]init];
        _slider.minimumTrackTintColor = rgba(255,77,75,1);
        _slider.maximumTrackTintColor = rgba(152,152,152,1);
        _slider.continuous = YES;
        [_slider setThumbImage:[UIImage imageNamed:@"enlightenment_tool_movie_slider_n"] forState:UIControlStateNormal];
        [_slider setThumbImage:[UIImage imageNamed:@"enlightenment_tool_movie_slider_n"] forState:UIControlStateHighlighted];
        [_slider addTarget:self action:@selector(handleSliderPosition:) forControlEvents:UIControlEventValueChanged];
        //滑动拖动后的事件
        [_slider addTarget:self action:@selector(sliderDragUp:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _slider;
}
- (UIButton *)play_stopBtn{
    if(!_play_stopBtn){
        _play_stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _play_stopBtn.adjustsImageWhenHighlighted = NO;
        [_play_stopBtn setBackgroundImage:[UIImage imageNamed:@"enlightenment_tool_movie_button_stop"] forState:UIControlStateNormal];
        [_play_stopBtn setBackgroundImage:[UIImage imageNamed:@"enlightenment_tool_movie_button_play2"] forState:UIControlStateSelected];
        [_play_stopBtn addTarget:self action:@selector(play_stopBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _play_stopBtn;
}
- (UILabel *)starTimeLB{
    if(!_starTimeLB){
        _starTimeLB = [[UILabel alloc]init];
        _starTimeLB.textColor = rgba(255,255,255,1);
        _starTimeLB.text = @"00:00";
        _starTimeLB.font = [UIFont fontWithName:@"Arial" size:10*TextRate];
    }
    return _starTimeLB;
}
- (UILabel *)allTimeLB{
    if(!_allTimeLB){
        _allTimeLB = [[UILabel alloc]init];
        _allTimeLB.text = @"00:00";
        _allTimeLB.textColor = rgba(255,255,255,1);
        _allTimeLB.font = [UIFont fontWithName:@"Arial" size:10*TextRate];
    }
    return _allTimeLB;
}
- (UIButton *)fullBtn{
    if(!_fullBtn){
        _fullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _fullBtn.adjustsImageWhenHighlighted = NO;
        [_fullBtn setBackgroundImage:[UIImage imageNamed:@"enlightenment_tool_movie_button_big"] forState:UIControlStateNormal];
        [_fullBtn setBackgroundImage:[UIImage imageNamed:@"enlightenment_tool_movie_button_little"] forState:UIControlStateSelected];
        [_fullBtn addTarget:self action:@selector(fullBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullBtn;
}
- (UIButton *)collectBtn{
    if(!_collectBtn){
        _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _collectBtn.adjustsImageWhenHighlighted = NO;
        [_collectBtn setBackgroundImage:[UIImage imageNamed:@"enlightenment_tool_movie_button_collection_n"] forState:UIControlStateNormal];
        [_collectBtn setBackgroundImage:[UIImage imageNamed:@"enlightenment_tool_movie_button_collection_t"] forState:UIControlStateSelected];
        [_collectBtn addTarget:self action:@selector(collectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectBtn;
}
- (UIButton *)backPopBtn{
    if(!_backPopBtn){
        _backPopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backPopBtn.adjustsImageWhenHighlighted = NO;
        [_backPopBtn setBackgroundImage:[UIImage imageNamed:@"enlightenment_tool_movie_play_back"] forState:UIControlStateNormal];
        [_backPopBtn addTarget:self action:@selector(backPopBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backPopBtn;
}
- (UILabel *)titleLB{
    if(!_titleLB){
        _titleLB = [[UILabel alloc]init];
        _titleLB.font = [WekeUtil getBoldUIFontWithRate:16];
        _titleLB.textColor = rgba(255,255,255,1);
    }
    return _titleLB;
}

- (UIView *)backTapView{
    if(!_backTapView){
        _backTapView = [[UIView alloc]init];
        _backTapView.userInteractionEnabled = YES;
        _backTapView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backPopBtnClick)];
        [_backTapView addGestureRecognizer:tap];
    }
    return _backTapView;
}

@end
