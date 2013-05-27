PullTableView
=============

一个简单的下拉刷新、上拉加载更多的TableView
* 基于ego大神的，整理了一下代码，增加易读性。修改为ARC模式，添加详细完整的注释
* 全部接口如下:
* //刷新类型
typedef enum
{
    PRPullDownRefresh,    //下拉刷新
    PRPullUpLoadMore,     //上拉加载更多
    PRPullBoth
}PRRefreshType;

@protocol PullTableViewDelegate;

@interface PullTableView : UITableView <UIScrollViewDelegate>

@property (weak, nonatomic) id <PullTableViewDelegate> pullDelegate;
@property (assign, nonatomic, readonly) PRRefreshType  refreshType;

//如果为上拉加载更多，则headerView为nil;
@property (strong, nonatomic, readonly) RefreshView *headerView;
//如果为下拉刷新则footerView为nil;
@property (strong, nonatomic, readonly) RefreshView *footerView;

//自动滑动到下一页，默认为NO
@property (assign, nonatomic) BOOL autoScrollToNextPage;

- (PullTableView *)initWithFrame:(CGRect)frame refreshType:(PRRefreshType)refreshType;

//在主类中通过ScrollView的两个代理调用这两个方法,必须实现。
- (void)pullTableViewDidScroll:(UIScrollView *)scrollView;
- (void)pullTableViewDidEndDragging:(UIScrollView *)scrollView;

//加载完成后调用以取消菊花旋转
- (void)stopPullTableViewRefresh;


//设置刷新视图中的文字
- (void)setRefreshViewNormalTitle:(NSString *)normalTitle loadingTitle:(NSString *)loadingTitle pullingTitle:(NSString *)pullingTitle atTop:(BOOL)top;
- (void)setRefreshViewSubtitle:(NSString *)subtitle atTop:(BOOL)top;


@end


@protocol PullTableViewDelegate <NSObject>

@optional

/*
 下拉刷新或上拉加载更多必须实现最少其中一个代理。
 */

//开始下拉刷新时调用
- (void)pullTableViewDidStartPullDownRefresh:(PullTableView *)tableView;

//开始上拉加载更多时调用
- (void)pullTableViewDidStartPullUpLoadMore:(PullTableView *)tableView;


/*
 设置刷新时间，若不实现，默认为当前时间。
 */
//下拉刷新完成后的时间
- (NSDate *)pullTableViewPullDownRefreshFinishedDate;

//上拉加载更多完成后的时间
- (NSDate *)pullTableViewPullUpLoadMoreFinishedDate;
