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
    self.headerImageV = headerImage;
    
    UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(41, 5, 100, 30)];
    self.headerNameLabel = nameLable;
    
    UIImageView *coverImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 37,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * 0.5)];
    coverImage.image = [UIImage imageNamed:@"loading_bgView"];
    self.coverImageV = coverImage;
    
    UIButton *playBTN = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [playBTN setBackgroundImage:[UIImage imageNamed:@"new_allPlay_44x44_"] forState:UIControlStateNormal];
    playBTN.center = coverImage.center;
    self.playBtn = playBTN;
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, [UIScreen mainScreen].bounds.size.width-20, 40)];
    titleLable.font = [UIFont systemFontOfSize:14];
    titleLable.textColor = [UIColor whiteColor];
    self.VideoLabel= titleLable;
    
    [self.contentView addSubview:headerImage];
    [self.contentView addSubview:nameLable];
    [self.contentView addSubview:coverImage];
    [self.contentView addSubview:playBTN];
    [coverImage addSubview:titleLable];
    
    //self.cellHight = 37 + coverImage.frame.size.height + 40 + 5;
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
