//
//  CHRefreshControl.h
//  customrefreshcontrol
//
//  Created by Cecilia Humlelu on 29/05/14.
//  Copyright (c) 2014 Cecilia Humlelu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    CHPullRefreshDragging = 0,
	CHPullRefreshLoading,
} CHPullRefreshState;





@protocol CHRefreshControlDelegate;

@interface CHRefreshControl : UIView

@property(nonatomic,weak) id <CHRefreshControlDelegate> delegate;

- (void)refreshLastUpdatedDate;
- (void)chRefreshScrollViewDidScroll:(UIScrollView *) aScrollView WithLastContentOffset:(CGFloat)lastContentOffset;
- (void)chRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)chRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end

@protocol CHRefreshControlDelegate <NSObject>

- (void)chRefreshControlDelegateDidTriggerRefresh:(CHRefreshControl*)view;
- (BOOL)chRefreshControlDelegateDataSourceIsLoading:(CHRefreshControl*)view;

//TODO: what is this
@optional
- (NSDate*)chRefreshControlDataSourceLastUpdated:(CHRefreshControl*)view;

@end


