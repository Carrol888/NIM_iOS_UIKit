//
//  NTESSessionListCell.m
//  NIMDemo
//
//  Created by chris on 15/2/10.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NIMSessionListCell.h"
#import "NIMAvatarImageView.h"
#import "UIView+NIM.h"
#import "NIMKitUtil.h"
#import "NIMBadgeView.h"
#import "UIColor+NIM.h"


@interface NIMSessionListCell ()

@property (nonatomic,strong) UILabel *projectLabel;
@property (nonatomic,strong) NIMRecentSession *recent;
@property (nonatomic,assign) BOOL isProject;

@end

@implementation NIMSessionListCell
#define AvatarWidth 40
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _avatarImageView = [[NIMAvatarImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [self addSubview:_avatarImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font            = [UIFont systemFontOfSize:15.f];
        [self addSubview:_nameLabel];
        
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.font            = [UIFont systemFontOfSize:14.f];
        _messageLabel.textColor       = [UIColor lightGrayColor];
        [self addSubview:_messageLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font            = [UIFont systemFontOfSize:14.f];
        _timeLabel.textColor       = [UIColor lightGrayColor];
        [self addSubview:_timeLabel];
        
        _projectLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _projectLabel.backgroundColor = [UIColor clearColor];
        _projectLabel.font            = [UIFont systemFontOfSize:12.f];
        _projectLabel.textColor       = [UIColor lightGrayColor];
        [self addSubview:_projectLabel];

        _badgeView = [NIMBadgeView viewWithBadgeTip:@""];
        [self addSubview:_badgeView];
    }
    return self;
}


#define NameLabelMaxWidth    160.f
#define MessageLabelMaxWidth 200.f
- (void)refresh:(NIMRecentSession*)recent{
    self.recent = recent;
    
    if (recent.session.sessionType != NIMSessionTypeP2P) {
        self.contentView.backgroundColor = [[UIColor colorWithHexString:@"#1AB843"] colorWithAlphaComponent:0.06];
    } else {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:recent.session.sessionId];
    
    if (team && team.serverCustomInfo != nil) {
        // 这是群
        NSDictionary *dict = [self convertJson:team.serverCustomInfo];
        NSLog(@"proj dict >> %@\n",dict);
        NSString *projName = dict[@"projInfo"][@"projName"];
        
        if (projName) {
           
            self.isProject = YES;
            self.projectLabel.text = projName;
            self.projectLabel.hidden = NO;
        } else {
            self.projectLabel.hidden = NO;
            self.projectLabel.text = @"";
        }
        
    } else {
        self.isProject = NO;
        self.projectLabel.hidden = YES;
        self.projectLabel.text = @"";
    }
    
   
    
    self.nameLabel.nim_width = self.nameLabel.nim_width > NameLabelMaxWidth ? NameLabelMaxWidth : self.nameLabel.nim_width;
    self.messageLabel.nim_width = self.messageLabel.nim_width > MessageLabelMaxWidth ? MessageLabelMaxWidth : self.messageLabel.nim_width;
    if (recent.unreadCount) {
        self.badgeView.hidden = NO;
        self.badgeView.badgeValue = @(recent.unreadCount).stringValue;
    }else{
        self.badgeView.hidden = YES;
    }
}

- (NSDictionary *)convertJson:(NSString *)jsonString {
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    return dic;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //Session List
    NSInteger sessionListAvatarLeft             = 15;
    NSInteger sessionListNameTop                = 15;
    NSInteger sessionListNameLeftToAvatar       = 15;
    NSInteger sessionListMessageLeftToAvatar    = 15;
    NSInteger sessionListMessageBottom          = 15;
    NSInteger sessionListTimeRight              = 15;
    NSInteger sessionListTimeTop                = 15;
    NSInteger sessionBadgeTimeBottom            = 15;
    NSInteger sessionBadgeTimeRight             = 15;
    
    _avatarImageView.nim_left    = sessionListAvatarLeft;
    _avatarImageView.nim_centerY = self.nim_height * .5f;
    
    NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:self.recent.session.sessionId];

    if (!self.isProject) {
        _nameLabel.nim_top           = sessionListNameTop;
        _nameLabel.nim_left          = _avatarImageView.nim_right + sessionListNameLeftToAvatar;
        _messageLabel.nim_left       = _avatarImageView.nim_right + sessionListMessageLeftToAvatar;
        _messageLabel.nim_bottom     = self.nim_height - sessionListMessageBottom;
        _timeLabel.nim_right         = self.nim_width - sessionListTimeRight;
        _timeLabel.nim_top           = sessionListTimeTop;
        _badgeView.nim_right         = self.nim_width - sessionBadgeTimeRight;
        _badgeView.nim_bottom        = self.nim_height - sessionBadgeTimeBottom;
        
    } else {
        
        _nameLabel.nim_top           = 5;
        _nameLabel.nim_left          = _avatarImageView.nim_right + sessionListNameLeftToAvatar;
        _messageLabel.nim_left       = _avatarImageView.nim_right + sessionListMessageLeftToAvatar;
        _messageLabel.nim_bottom     = self.nim_height - 5;
        _timeLabel.nim_right         = self.nim_width - sessionListTimeRight;
        _timeLabel.nim_top           = sessionListTimeTop;
        _badgeView.nim_right         = self.nim_width - sessionBadgeTimeRight;
        _badgeView.nim_bottom        = self.nim_height - sessionBadgeTimeBottom;
        
        self.projectLabel.nim_top = self.nameLabel.nim_bottom + 5;
        self.projectLabel.nim_left = _nameLabel.nim_left;
        [self.projectLabel sizeToFit];
    }
   
}



@end
