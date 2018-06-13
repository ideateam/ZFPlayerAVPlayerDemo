//
//  VideoViewController.m
//  ZFPlayerAVPlayerDemo
//
//  Created by Derek on 10/06/18.
//  Copyright © 2018年 Derek. All rights reserved.
//

#import "VideoViewController.h"
#import "VideoListTableViewCell.h"
#import "VideoListModel.h"

@interface VideoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getData];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[VideoListTableViewCell class] forCellReuseIdentifier:@"cellid"];
    [self.view addSubview:_tableView];
    
    //解决上拉跳跃式加载问题
//    if (@available(iOS 11.0, *)) {
//        _tableView.estimatedRowHeight = 0;
//        _tableView.estimatedSectionFooterHeight = 0;
//        _tableView.estimatedSectionHeaderHeight = 0;
//        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    }
    
    
}
-(void)getData{
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:72];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
   // NSLog(@"rootDict = %@",[rootDict valueForKey:@"list"]);
    
    for (NSDictionary * d in [rootDict valueForKey:@"list"] ) {
        
        VideoListModel *model = [VideoListModel modelWithDic:d];
        [array addObject:model];
        
    }
    
    _dataArray = [NSMutableArray arrayWithArray:array];
    
    [_tableView reloadData];
    
    //NSLog(@"------------------%ld---------------",_dataArray.count);
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VideoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
    if (cell == nil) {
        cell = [[VideoListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellid"];
    }
    
    VideoListModel *model = _dataArray[indexPath.row];
    cell.headerImageV = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.head]]]];
    cell.headerNameLabel.text = [NSString stringWithFormat:@"%@",model.nick_name];
    //cell.coverImageV = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.thumbnail_url]]]];
    //cell.coverImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_bgView"]];
    //loading_bgView
    cell.VideoLabel.text = [NSString stringWithFormat:@"%@",model.title];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //VideoListTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    return 250;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
