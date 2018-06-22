//
//  DarkBrightVideoViewController.m
//  ZFPlayerAVPlayerDemo
//
//  Created by Derek on 2018/6/22.
//  Copyright © 2018 Derek. All rights reserved.
//

#import "DarkBrightVideoViewController.h"

#import "VideoListTableViewCell.h"
#import "VideoListModel.h"
#import "UIImageView+WebCache.h"
#import "ZFPlayer.h"
#import "ZFAVPlayerManager.h"
#import "ZFPlayerControlView.h"
#import <KTVHTTPCache/KTVHTTPCache.h>
#import "VideoDetailPlayViewController.h"

@interface DarkBrightVideoViewController ()<UITableViewDelegate,UITableViewDataSource,ZFTableViewCellDelegate,UIScrollViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *urls;
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) ZFAVPlayerManager *playerManager;
@end

@implementation DarkBrightVideoViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    @weakify(self)
    [self.tableView zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
        @strongify(self)
        [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
    }];
    VideoListTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.tableView.shouldPlayIndexPath];
    [cell hideMaskView];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //视图切换的时候，停止播放
    [self.player stop];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView registerClass:[VideoListTableViewCell class] forCellReuseIdentifier:@"cellid"];
    [self.view addSubview:_tableView];
    
//    if (@available(iOS 11.0, *)) {
//        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    } else {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
//    _tableView.separatorColor = [UIColor darkGrayColor];
//    [[UITableView appearance] setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
//    [[UITableView appearance] setSeparatorInset:UIEdgeInsetsZero];
//    [[UITableViewCell appearance] setSeparatorInset:UIEdgeInsetsZero];
//    if ([UITableView instancesRespondToSelector:@selector(setLayoutMargins:)]) {
//        [[UITableView appearance] setLayoutMargins:UIEdgeInsetsZero];
//        [[UITableViewCell appearance] setLayoutMargins:UIEdgeInsetsZero];
//        [[UITableViewCell appearance] setPreservesSuperviewLayoutMargins:NO];
//    }
    
    [self getData];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        __weak __typeof__(self) weakSelf = self;
        [weakSelf getData];
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            [weakSelf.tableView reloadData];
        });
        
    });
    
    // playerManager
    self.playerManager = [[ZFAVPlayerManager alloc] init];
    
    self.player = [[ZFPlayerController alloc] initWithScrollView:self.tableView playerManager:self.playerManager containerViewTag:100];
    self.player.controlView = self.controlView;
    self.player.assetURLs = self.urls;
    self.player.shouldAutoPlay = YES;//开启此开关即可自动播放
    
    @weakify(self)
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self.view endEditing:YES];
        [self setNeedsStatusBarAppearanceUpdate];
        self.tableView.scrollsToTop = !isFullScreen;
    };
    
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        if (self.player.playingIndexPath.row < self.urls.count - 1 && !self.player.isFullScreen) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.player.playingIndexPath.row+1 inSection:0];
            [self playTheVideoAtIndexPath:indexPath scrollToTop:YES];
        } else if (self.player.isFullScreen) {
            [self.player enterFullScreen:NO animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.player.orientationObserver.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.player stopCurrentPlayingCell];
            });
        }else {
            [self.player stopCurrentPlayingCell];
        }
    };
}
-(void)getData{
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:72];
    _urls = [NSMutableArray new];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    // NSLog(@"rootDict = %@",[rootDict valueForKey:@"list"]);
    
    for (NSDictionary * d in [rootDict valueForKey:@"list"] ) {
        
        VideoListModel *model = [VideoListModel modelWithDic:d];
        [array addObject:model];
        [self.urls addObject:[NSURL URLWithString:model.video_url]];
    }
    
    _dataArray = [NSMutableArray arrayWithArray:array];
    NSLog(@"self.urls = %@",self.urls);
    //[_tableView reloadData];
    
    //NSLog(@"------------------%ld---------------",_dataArray.count);
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VideoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
    if (cell == nil) {
        cell = [[VideoListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellid"];
    }
    
    VideoListModel *model = _dataArray[indexPath.row];
    [cell.headerImageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.head]] placeholderImage:[UIImage imageNamed:@"headimg.jpg"]];
    cell.headerNameLabel.text = [NSString stringWithFormat:@"%@",model.nick_name];
    [cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.thumbnail_url]] placeholderImage:[UIImage imageNamed:@"loading_bgView"]];
    cell.VideoLabel.text = [NSString stringWithFormat:@"%@",model.title];
    cell.VideoLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setDelegate:self withIndexPath:indexPath];
    //[cell setDarkMode];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //VideoListTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    return ([UIScreen mainScreen].bounds.size.width * 0.53+50);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
    VideoDetailPlayViewController *v = [VideoDetailPlayViewController new];
    v.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:v animated:YES];
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
#pragma mark - private method

/// play the video
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop {
    [self.player playTheIndexPath:indexPath scrollToTop:scrollToTop];
    [self.controlView resetControlView];
    
    VideoListModel * model = _dataArray[indexPath.row];
    
    [self.controlView showTitle:model.title
                 coverURLString:model.thumbnail_url
                 fullScreenMode:ZFFullScreenModePortrait];
    NSLog(@"self.controlView showTitle %@ =",model.title);
}
- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
    }
    return _controlView;
}

- (void)zf_playTheVideoAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSLog(@"zhi xing le zhe ge ");
    [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSLog(@"scrollViewDidScroll");
    @weakify(self)
    [scrollView zf_filterShouldPlayCellWhileScrolling:^(NSIndexPath *indexPath) {
        if ([indexPath compare:self.tableView.shouldPlayIndexPath] != NSOrderedSame) {
            @strongify(self)
            /// 显示黑色蒙版
            VideoListTableViewCell *cell1 = [self.tableView cellForRowAtIndexPath:self.tableView.shouldPlayIndexPath];
            [cell1 showMaskView];
            /// 隐藏黑色蒙版
            VideoListTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [cell hideMaskView];
        }
    }];
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
