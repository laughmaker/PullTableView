//
//  XibTableVC.h
//  PullTabelViewDemo
//
//  Created by line0 on 13-6-14.
//  Copyright (c) 2013年 makeLaugh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullTableView.h"

@interface XibTableVC : UIViewController
@property (weak, nonatomic) IBOutlet PullTableView  *xibTableView;
@property (strong, nonatomic) NSMutableArray        *datas;

@end
