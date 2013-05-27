//
//  LoadingView.h
//  ILovePostcardHD
//
//  Created by 振东 何 on 12-7-18.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuartzCore/QuartzCore.h"


#define kPROffsetY      55.f        //上下拉触发距离
#define kPRAnimationDuration 0.18f  //动画时间

typedef enum
{
    kPRStateNormal = 0,
    kPRStatePulling,
    kPRStateLoading,
    kPRStateHitTheEnd
} PRState;

@interface RefreshView : UIView

//默认显示刷新状态，可自行设定要显示的文字
@property (nonatomic, strong) UILabel *titleLabel;

//显示在刷新状态下面，默认为日期，可自行设定
@property (nonatomic, strong) UILabel *subtitleLabel;

//刷新动画
@property (nonatomic, strong) UIImageView             *arrowView;
@property (nonatomic, strong) CALayer                 *arrowLayer;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@property (nonatomic, getter = isLoading) BOOL loading;
@property (nonatomic, getter = isAtTop)   BOOL atTop;

//刷新状态
@property (nonatomic, assign) PRState state;

//刷新三种状态对应的文字
@property (nonatomic, strong) NSString                *normalTitle;
@property (nonatomic, strong) NSString                *pullingTitle;
@property (nonatomic, strong) NSString                *loadingTitle;

//刷新状态对应下面的文字
@property (nonatomic, strong) NSString                *subtitle;


- (id)initWithFrame:(CGRect)frame atTop:(BOOL)top;

//默认状态下的刷新日期
- (void)updateRefreshDate:(NSDate *)date;

//设置刷新状态
- (void)setState:(PRState)state animated:(BOOL)animated;

@end
