//
//  VideoListTableViewCell.m
//  ZFPlayerAVPlayerDemo
//
//  Created by Karl on 2018/6/13.
//  Copyright © 2018 Derek. All rights reserved.
//

#import "VideoListTableViewCell.h"

@implementation VideoListTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self setUI];
        
    }
    return self;
}

-(void)setUI{
    
    UIImageView *headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
    headerImage.clipsToBounds = YES;
    headerImage.layer.cornerRadius = 15;
    self.headerImageV = headerImage;
    
    UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(45, 5, 100, 30)];
    self.headerNameLabel = nameLable;
    
    UIImageView *coverImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 37,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * 0.52)];
    coverImage.userInteractionEnabled = YES;
    coverImage.contentMode = UIViewContentModeScaleAspectFill;
    coverImage.clipsToBounds = YES;
    coverImage.tag = 100;
    //coverImage.image = [UIImage imageNamed:@"loading_bgView"];
    self.coverImageView = coverImage;
    
    UIButton *playBTN = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [playBTN setBackgroundImage:[UIImage imageNamed:@"new_allPlay_44x44_"] forState:UIControlStateNormal];
    playBTN.userInteractionEnabled = YES;
    playBTN.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 128/2+37);
    [playBTN addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.playBtn = playBTN;
    
    UILabel *VideoLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, [UIScreen mainScreen].bounds.size.width-20, 40)];
    VideoLabel.font = [UIFont systemFontOfSize:14];
    VideoLabel.numberOfLines = 2;
    VideoLabel.textColor = [UIColor redColor];
    self.VideoLabel= VideoLabel;
    
    UIView * fullMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height )];
    fullMaskView.userInteractionEnabled = YES;
    fullMaskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    
    self.fullMaskView = fullMaskView;
    
    [self.contentView addSubview:headerImage];
    [self.contentView addSubview:nameLable];
    [self.contentView addSubview:coverImage];
    [self.coverImageView addSubview:playBTN];
    [self.coverImageView addSubview:VideoLabel];
    [self.contentView addSubview:fullMaskView];
    
    //self.cellHight = 37 + coverImage.frame.size.height + 40 + 5;
}
- (void)playBtnClick:(UIButton *)sender {
    NSLog(@"playBtnClick");
    if ([self.delegate respondsToSelector:@selector(zf_playTheVideoAtIndexPath:)]) {
        [self.delegate zf_playTheVideoAtIndexPath:self.indexPath];
    }
}
- (void)setDelegate:(id<ZFTableViewCellDelegate>)delegate withIndexPath:(NSIndexPath *)indexPath {
    self.delegate = delegate;
    self.indexPath = indexPath;
}
- (UIView *)fullMaskView {
    if (!_fullMaskView) {
        _fullMaskView = [UIView new];
        _fullMaskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    }
    return _fullMaskView;
}
- (void)setNormalMode {
    self.fullMaskView.hidden = YES;
    self.VideoLabel.textColor = [UIColor blackColor];
    self.headerNameLabel.textColor = [UIColor blackColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)showMaskView {
    [UIView animateWithDuration:0.3 animations:^{
        self.fullMaskView.alpha = 1;
    }];
}

- (void)hideMaskView {
    [UIView animateWithDuration:0.3 animations:^{
        self.fullMaskView.alpha = 0;
    }];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
