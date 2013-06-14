//
//  XibTableVC.m
//  PullTabelViewDemo
//
//  Created by line0 on 13-6-14.
//  Copyright (c) 2013年 makeLaugh. All rights reserved.
//

#import "XibTableVC.h"

@interface XibTableVC ()

@end

@implementation XibTableVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.datas = [NSMutableArray array];
    for (int i = 0; i < 15; i++)
    {
        NSString *str = [NSString stringWithFormat:@"cell%d", i];
        [self.datas addObject:str];
    }
    
    [self.xibTableView setRefreshType:PRPullBoth];
}

- (void)addData
{
    for (int i = 0; i < 10; i++)
    {
        NSString *str = [NSString stringWithFormat:@"cell%d", i + self.datas.count];
        [self.datas addObject:str];
    }
    [self.xibTableView reloadData];
}


#pragma mark - DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"pullTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell.textLabel setText:[self.datas objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - PullTableView Delegate

- (void)pullTableViewDidStartPullDownRefresh:(PullTableView *)tableView
{
    [tableView performSelector:@selector(stopPullTableViewRefresh) withObject:nil afterDelay:2];
}

- (void)pullTableViewDidStartPullUpLoadMore:(PullTableView *)tableView
{
    [self performSelector:@selector(addData) withObject:nil afterDelay:2];
    [tableView performSelector:@selector(stopPullTableViewRefresh) withObject:nil afterDelay:2];
}


#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.xibTableView pullTableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.xibTableView pullTableViewDidEndDragging:scrollView];
}

@end
