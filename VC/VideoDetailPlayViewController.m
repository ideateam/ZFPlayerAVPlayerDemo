//
//  VideoDetailPlayViewController.m
//  ZFPlayerAVPlayerDemo
//
//  Created by Derek on 10/06/18.
//  Copyright © 2018年 Derek. All rights reserved.
//

#import "VideoDetailPlayViewController.h"
#import "ZFPlayer.h"
#import "ZFAVPlayerManager.h"
#import "ZFPlayerControlView.h"
#import "ZFPlayerController.h"
#import <KTVHTTPCache/KTVHTTPCache.h>

@interface VideoDetailPlayViewController ()
@property (nonatomic ,strong) ZFPlayerController *player;
@property (nonatomic ,strong) UIView *containerView;
@property (nonatomic ,strong) UIButton *clickToPlayBTN;
@property (nonatomic ,strong) ZFPlayerControlView *controlView;

@end

@implementation VideoDetailPlayViewController

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor orangeColor];
    
   UIView * containerView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width * 0.5625)];
    containerView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:containerView];
    

    UIImageView *bgShotCut = [[UIImageView alloc] initWithFrame:containerView.frame];
    bgShotCut.image = [UIImage imageNamed:@"loading_bgView"];
    [containerView addSubview:bgShotCut];
    
    self.containerView = containerView;
    
    UIButton *clickToPlayBTN = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [clickToPlayBTN setBackgroundImage:[UIImage imageNamed:@"new_allPlay_44x44_"] forState:UIControlStateNormal];
    [clickToPlayBTN addTarget:self action:@selector(playClickBTN:) forControlEvents:UIControlEventTouchUpInside];
    clickToPlayBTN.center = containerView.center;
    [containerView addSubview:clickToPlayBTN];
    self.clickToPlayBTN = clickToPlayBTN;

    
    UIButton *backBTN = [[UIButton alloc] initWithFrame:CGRectMake(15, 40, 40, 20)];
    [backBTN setTitle:@"<-" forState:UIControlStateNormal];
    backBTN.titleLabel.font = [UIFont systemFontOfSize:20];
    [backBTN addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    [backBTN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[backBTN setBackgroundImage:[UIImage imageNamed:@"backTo"] forState:UIControlStateNormal];
    [self.view addSubview:backBTN];
    
    
    UIButton *changeBTN = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 150, 30)];
    [changeBTN setTitle:@"ChageVideo" forState:UIControlStateNormal];
    changeBTN.titleLabel.font = [UIFont systemFontOfSize:17];
    [changeBTN addTarget:self action:@selector(changeTo) forControlEvents:UIControlEventTouchUpInside];
    [changeBTN setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    //[backBTN setBackgroundImage:[UIImage imageNamed:@"backTo"] forState:UIControlStateNormal];
    [self.view addSubview:changeBTN];
    
}
-(void)changeTo{
    
    [self.controlView resetControlView];
    NSString *URLString = [@"https://ylmtst.yejingying.com/asset/video/20180525184959_mW8WVQVd.mp4" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *proxyURLString = [KTVHTTPCache proxyURLStringWithOriginalURLString:URLString];
    self.player.currentPlayerManager.assetURL = [NSURL URLWithString:proxyURLString];
}
-(void)backTo{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)playClickBTN:(UIButton *)sender{
    
    NSLog(@"btn play click");
    
    [self.controlView resetControlView];
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    /// 播放器相关
    self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
    self.player.controlView = self.controlView;
    @weakify(self)
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self.view endEditing:YES];
        [self setNeedsStatusBarAppearanceUpdate];
    };
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        [self.player enterFullScreen:NO animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.player.orientationObserver.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.player stop];
        });
    };
    NSString *URLString = [@"http://tb-video.bdstatic.com/videocp/12045395_f9f87b84aaf4ff1fee62742f2d39687f.mp4" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *proxyURLString = [KTVHTTPCache proxyURLStringWithOriginalURLString:URLString];
    playerManager.assetURL = [NSURL URLWithString:proxyURLString];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - about keyboard orientation

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        [_controlView showTitle:@"视频标题" coverURLString:@"http://imgsrc.baidu.com/forum/eWH%3D240%2C176/sign=183252ee8bd6277ffb784f351a0c2f1c/5d6034a85edf8db15420ba310523dd54564e745d.jpg" fullScreenMode:ZFFullScreenModeLandscape];
    }
    return _controlView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
