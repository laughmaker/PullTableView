//
//  LoadingView.m
//  ILovePostcardHD
//
//  Created by 振东 何 on 12-7-18.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "RefreshView.h"

#define kPRMargin       6.f        //箭头距离左边的宽度

#define kPRLabelHeight  20.f


#define kPRArrowWidth   20.f
#define kPRArrowHeight  30.f


@implementation RefreshView

- (id)initWithFrame:(CGRect)frame atTop:(BOOL)top
{
    self = [super initWithFrame:frame];
    if (self)
    {
        if (top)
        {
            self.normalTitle = @"下拉刷新";
            self.pullingTitle = @"释放刷新";
            self.loadingTitle = @"刷新中...";            
        }
        else
        {
            self.normalTitle = @"上拉加载更多";
            self.pullingTitle = @"释放加载更多";
            self.loadingTitle = @"加载中...";
        }

        self.atTop = top;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor clearColor];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:15.f];
        self.titleLabel.textColor = [UIColor darkTextColor];
        self.titleLabel.textAlignment = UITextAlignmentCenter;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.titleLabel];
        
        self.subtitleLabel = [[UILabel alloc] init];
        self.subtitleLabel.font = [UIFont systemFontOfSize:13.f];
        self.subtitleLabel.textColor = [UIColor darkTextColor];
        self.subtitleLabel.textAlignment = UITextAlignmentCenter;
        self.subtitleLabel.backgroundColor = [UIColor clearColor];
        self.subtitleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.subtitleLabel];
        
        self.arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20) ];
        
        self.arrowLayer = [CALayer layer];
        self.arrowLayer.frame = CGRectMake(0, 0, 20, 20);
        self.arrowLayer.contentsGravity = kCAGravityResizeAspect;
        self.arrowLayer.contents = (id)[UIImage imageWithCGImage:[UIImage imageNamed:@"arrowDown.png"].CGImage scale:1 orientation:UIImageOrientationDown].CGImage;
        [self.layer addSublayer:self.arrowLayer];
        
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:self.activityView];
        
        [self layouts];
    }
    return self;
}

- (void)setSubTitle:(NSString *)subtitle
{
    _subtitle = subtitle;
    self.subtitleLabel.text = subtitle;
}

- (void)setNormalTitle:(NSString *)normalTitle
{
    _normalTitle = normalTitle;
    self.titleLabel.text = normalTitle;
}

- (void)layouts
{
    CGSize size = self.frame.size;
    CGRect stateFrame, dateFrame, arrowFrame;
    
    float x = 0, y = 0;
    if (self.isAtTop)
    {
        y = size.height - kPRLabelHeight;
        dateFrame = CGRectMake(0, y, size.width, kPRLabelHeight);
        
        y = y - kPRLabelHeight;
        stateFrame = CGRectMake(0, y, size.width, kPRLabelHeight);
        
        x = kPRMargin;
        y = size.height - kPRArrowHeight - 3;
        arrowFrame = CGRectMake(6 * x, y, kPRArrowWidth, kPRArrowHeight);
        
        UIImage *arrow = [UIImage imageNamed:@"arrowDown.png"];
        self.arrowLayer.contents = (id)arrow.CGImage;
    }
    else
    {
        stateFrame = CGRectMake(0, y, size.width, kPRLabelHeight );
        
        y = y + kPRLabelHeight;
        dateFrame = CGRectMake(0, y, size.width, kPRLabelHeight);
        
        x = kPRMargin;
        y = y - kPRLabelHeight / 2 - 5;
        arrowFrame = CGRectMake(6 * x, y, kPRArrowWidth, kPRArrowHeight);
        
        UIImage *arrow = [UIImage imageNamed:@"arrowUp.png"];        
        self.arrowLayer.contents = (id)arrow.CGImage;
        self.titleLabel.text = self.pullingTitle;
    }
    
    self.titleLabel.frame    = stateFrame;
    self.subtitleLabel.frame     = dateFrame;
    self.arrowView.frame     = arrowFrame;
    self.activityView.center = self.arrowView.center;
    self.arrowLayer.frame         = arrowFrame;
    self.arrowLayer.transform     = CATransform3DIdentity;
}

- (void)setState:(PRState)state
{
    [self setState:state animated:YES];
}

- (void)setState:(PRState)state animated:(BOOL)animated
{
    float duration = animated ? kPRAnimationDuration : 0.f;
    if (self.state != state)
    {
        _state = state;
        if (self.state == kPRStateLoading)
        {    //Loading
            self.arrowLayer.hidden = YES;
            self.activityView.hidden = NO;
            [self.activityView startAnimating];
            
            self.loading = YES;
            if (self.isAtTop)
            {
                self.titleLabel.text = self.loadingTitle;
            }
            else
            {
                self.titleLabel.text = self.loadingTitle;
            }
        }
        else if (self.state == kPRStatePulling && !self.loading)
        {    //Scrolling
            self.arrowLayer.hidden = NO;
            self.activityView.hidden = YES;
            [self.activityView stopAnimating];
            
            [CATransaction begin];
            [CATransaction setAnimationDuration:duration];
            self.arrowLayer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            [CATransaction commit];
            
            if (self.isAtTop)
            {
                self.titleLabel.text = self.pullingTitle;
            }
            else
            {
                self.titleLabel.text = self.pullingTitle;
            }
        }
        else if (self.state == kPRStateNormal && !self.loading)
        {    //Reset
            self.arrowLayer.hidden = NO;
            self.activityView.hidden = YES;
            [self.activityView stopAnimating];
            
            [CATransaction begin];
            [CATransaction setAnimationDuration:duration];
            self.arrowLayer.transform = CATransform3DIdentity;
            [CATransaction commit];
            
            if (self.isAtTop)
            {
                self.titleLabel.text = self.normalTitle;
            }
            else
            {
                self.titleLabel.text = self.normalTitle;
            }
        }
        else if (self.state == kPRStateHitTheEnd)
        {
            if (!self.isAtTop)
            {    //footer
                self.arrowLayer.hidden = YES;
                self.titleLabel.text = NSLocalizedString(@"没有了哦", @"");
            }
        }
    }
}

- (void)updateRefreshDate :(NSDate *)date
{
    if (self.subtitle)
    {
        [self.subtitleLabel setText:self.subtitle];
    }
    else
    {
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
        dateFormater.dateFormat = @"yyyy-MM-dd HH:mm";
        NSString *dateString = [dateFormater stringFromDate:date];
        NSString *title = NSLocalizedString(@"今天", nil);
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:NSYearCalendarUnit|
                                        NSMonthCalendarUnit|
                                        NSDayCalendarUnit
                                                   fromDate:date
                                                     toDate:[NSDate date]
                                                    options:0];
        int year  = [components year];
        int month = [components month];
        int day   = [components day];
        if (year == 0 && month == 0 && day < 3)
        {
            if (day == 0)
            {
                title = NSLocalizedString(@"今天",nil);
            }
            else if (day == 1)
            {
                title = NSLocalizedString(@"昨天",nil);
            }
            else if (day == 2)
            {
                title = NSLocalizedString(@"前天",nil);
            }
            dateFormater.dateFormat = [NSString stringWithFormat:@"%@ HH:mm",title];
            dateString = [dateFormater stringFromDate:date];
        }
        self.subtitleLabel.text = [NSString stringWithFormat:@"最后更新: %@", dateString];
    }
}


@end

