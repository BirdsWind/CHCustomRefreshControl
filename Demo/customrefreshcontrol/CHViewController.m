//
//  CHViewController.m
//  customrefreshcontrol
//
//  Created by Cecilia Humlelu on 28/05/14.
//  Copyright (c) 2014 Cecilia Humlelu. All rights reserved.
//

#import "CHViewController.h"
#import "CHCustomRefreshControl.h"

@interface CHViewController () <CHRefreshControlDelegate>
@property CHCustomRefreshControl *refreshControl;
@property BOOL reloading;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, assign) CGFloat lastContentOffset;

@end

@implementation CHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    if (self.refreshControl == nil) {
		self.refreshControl  = [[CHCustomRefreshControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableview.bounds.size.height, self.view.frame.size.width, self.tableview.bounds.size.height)];
		self.refreshControl .delegate = self;
		[self.tableview addSubview:self.refreshControl ];
	}

}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    return 10;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    
    NSString *identifier = @"customCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.textLabel.text = @"give me label";
    
    return cell;
    
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.refreshControl chRefreshScrollViewDidScroll:scrollView WithLastContentOffset:self.lastContentOffset];
    self.lastContentOffset = scrollView.contentOffset.y;
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[self.refreshControl chRefreshScrollViewDidEndDragging:scrollView];
}
	
#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[self.refreshControl chRefreshScrollViewDataSourceDidFinishedLoading:self.tableview];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)chRefreshControlDelegateDidTriggerRefresh:(CHCustomRefreshControl*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)chRefreshControlDelegateDataSourceIsLoading:(CHCustomRefreshControl*)view{
	
	return _reloading; // should return if data source model is reloading
	
}


@end
