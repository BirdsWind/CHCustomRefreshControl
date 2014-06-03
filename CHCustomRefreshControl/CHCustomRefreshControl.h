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
    CHPullRefreshNone,
	CHPullRefreshLoading,
} CHPullRefreshState;





@protocol CHRefreshControlDelegate;

@interface CHCustomRefreshControl : UIControl

@property(nonatomic,weak) id <CHRefreshControlDelegate> delegate;

- (void)refreshLastUpdatedDate;
- (void)chRefreshScrollViewDidScroll:(UIScrollView *) aScrollView WithLastContentOffset:(CGFloat)lastContentOffset;
- (void)chRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)chRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end

@protocol CHRefreshControlDelegate <NSObject>

- (void)chRefreshControlDelegateDidTriggerRefresh:(CHCustomRefreshControl*)view;
- (BOOL)chRefreshControlDelegateDataSourceIsLoading:(CHCustomRefreshControl*)view;

//TODO: what is this
@optional
- (NSDate*)chRefreshControlDataSourceLastUpdated:(CHCustomRefreshControl*)view;

@end


