//
//  VideoListTableViewCell.h
//  ZFPlayerAVPlayerDemo
//
//  Created by Karl on 2018/6/13.
//  Copyright © 2018 Derek. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoListTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *  headerImageV;
@property (nonatomic,strong) UILabel *  headerNameLabel;
@property (nonatomic,strong) UIImageView *  coverImageV;
@property (nonatomic, strong) UIView *fullMaskView;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UILabel *VideoLabel;
@property (nonatomic, assign) int cellHight;


@end

NS_ASSUME_NONNULL_END
