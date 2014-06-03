//
//  CHRefreshControl.m
//  customrefreshcontrol
//
//  Created by Cecilia Humlelu on 29/05/14.
//  Copyright (c) 2014 Cecilia Humlelu. All rights reserved.
//

#import "CHCustomRefreshControl.h"
#import <QuartzCore/QuartzCore.h>



#define IMAGERADIUS 12
CGFloat const chCONTENTOFFSETLIMIT = 65.0;

CGFloat const MinCONTENTOFFSETY = 0.0;
CGFloat const MaxCONTENTOFFSETY = 90.0;

@interface CHCustomRefreshControl()

@property CALayer *layerGroup;
@property CALayer *imageLogo;
@property CAShapeLayer *imageCirle;
@property CAShapeLayer *imageBackgroundCirle;
@property UIActivityIndicatorView *activityView;
@property CHPullRefreshState state;
@property CABasicAnimation *drawStrokeAnimation;
@property CABasicAnimation *drawRotationAnimation;



- (void)setState:(CHPullRefreshState)aState withScrollView:(UIScrollView *)ascrollView withLastContentOffset:(CGFloat)lastContentOffset;
@end

@implementation CHCustomRefreshControl

@synthesize state = _state;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        //TODO: change color
		self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        

        self.layerGroup = [CALayer layer];
        self.layerGroup.backgroundColor = [UIColor clearColor].CGColor;
        self.layerGroup.frame = CGRectMake(frame.size.width/2 - IMAGERADIUS, frame.size.height - IMAGERADIUS * 2 -1,IMAGERADIUS *2,IMAGERADIUS*2);
        
        
        
        self.imageBackgroundCirle = [self createCircleWithfillColor:[UIColor whiteColor                                                          ] strokeColor:[UIColor colorWithRed:221.0/255.0 green:221.0/255.0  blue:221.0/255.0  alpha:1]];
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
            self.imageBackgroundCirle.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		[ self.layerGroup addSublayer: self.imageBackgroundCirle];
        self.imageCirle = [self createCircleWithfillColor:[UIColor clearColor] strokeColor:[UIColor colorWithRed:97.0/255.0 green:197.0/255.0 blue:0.0/255.0 alpha:1]];
        
		
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
            self.imageCirle.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		[self.layerGroup addSublayer: self.imageCirle];
        
		self.imageLogo = [CALayer layer];
		self.imageLogo.frame = CGRectMake(IMAGERADIUS*0.5, IMAGERADIUS*0.5, IMAGERADIUS, IMAGERADIUS);
		self.imageLogo.contentsGravity = kCAGravityResizeAspect;
		self.imageLogo.contents = (id)[UIImage imageNamed:@"logo-front"].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			self.imageLogo.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
       
		[self.layerGroup addSublayer:self.imageLogo];
       // [self.layer addSublayer:self.layerGroup];
         [self.layer addSublayer:self.layerGroup];
		
		self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		self.activityView.frame = CGRectMake((frame.size.width - 20.0)/2, frame.size.height - 40.0f, 20.0f, 20.0f);
		[self addSubview:self.activityView];
		
		[self setState: CHPullRefreshNone withScrollView:nil withLastContentOffset:0];
        
        
        self.drawStrokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        [self.drawStrokeAnimation setRemovedOnCompletion:NO];
        [self.drawStrokeAnimation setFillMode:kCAFillModeForwards];
        
        
        self.drawRotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        self.drawRotationAnimation.removedOnCompletion = NO;
        self.drawRotationAnimation.fillMode = kCAFillModeForwards;

    }
    return self;
}

- (void)refreshLastUpdatedDate;{
    
}

#pragma mark ScrollView
- (void)chRefreshScrollViewDidScroll:(UIScrollView *) aScrollView WithLastContentOffset:(CGFloat)lastContentOffset;{
    if (_state == CHPullRefreshLoading) {
		
		CGFloat offset = MAX(aScrollView.contentOffset.y * -1, 0);
        
        //TODO: what is this 60 ?
		offset = MIN(offset, 60);
		aScrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
		
	} else if (aScrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(chRefreshControlDelegateDataSourceIsLoading:)]) {
			_loading = [_delegate chRefreshControlDelegateDataSourceIsLoading:self];
		}
		
		if(!_loading){
            if(aScrollView.contentOffset.y < 0)
                 [self setState:CHPullRefreshDragging withScrollView:aScrollView withLastContentOffset:lastContentOffset];
            else
                 [self setState:CHPullRefreshNone withScrollView:nil withLastContentOffset:0];
                
        }
		
		if (aScrollView.contentInset.top != 0) {
			aScrollView.contentInset = UIEdgeInsetsZero;
		}
		
	}

}
- (void)chRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;{
    BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(chRefreshControlDelegateDataSourceIsLoading:)]) {
		_loading = [_delegate chRefreshControlDelegateDataSourceIsLoading:self];
	}
	
    
    //TODO: what is this 65?  test use
	if (scrollView.contentOffset.y <= - 2*chCONTENTOFFSETLIMIT && !_loading) {
		
		if ([_delegate respondsToSelector:@selector(chRefreshControlDelegateDidTriggerRefresh:)]) {
			[_delegate chRefreshControlDelegateDidTriggerRefresh:self];
		}
		
        
		[self setState:CHPullRefreshLoading withScrollView:scrollView withLastContentOffset:scrollView.contentOffset.y];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
		
	}
	
}
- (void)chRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;{
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[self setState:CHPullRefreshNone withScrollView:scrollView withLastContentOffset:scrollView.contentOffset.y];
}



#pragma mark Private methods

-(CAShapeLayer *)createCircleWithfillColor:(UIColor *)aFillColor strokeColor:(UIColor *)aStrokeColor;{
    // Set up the shape of the circle
   
    CAShapeLayer *circle = [CAShapeLayer layer];
    // Make a circular shape
    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*IMAGERADIUS, 2.0*IMAGERADIUS)
                                             cornerRadius:IMAGERADIUS].CGPath;
    //2 is stroke width
    circle.frame = CGRectMake(0, 0, IMAGERADIUS*2, IMAGERADIUS*2); //CGRectMake(frame.size.width/2 - radius, frame.size.height - radius * 2 - 5 , radius *2, radius *2);
    
    // Configure the apperence of the circle
    circle.fillColor = aFillColor.CGColor;
    circle.strokeColor = aStrokeColor.CGColor; //[UIColor colorWithRed:97.0/255.0 green:197.0/255.0 blue:0.0/255.0 alpha:1].CGColor;
    circle.lineWidth = 2;
    
//    circle.strokeStart = 0;
//    circle.strokeEnd = 0;
    
    return circle;

}



- (void)setState:(CHPullRefreshState)aState withScrollView:(UIScrollView *)ascrollView withLastContentOffset:(CGFloat)lastContentOffset;{
    
    switch (aState) {
        case CHPullRefreshNone:
            self.layerGroup.hidden = YES;
            self.activityView.hidden = YES;
//            [self updateProgressWithScroll:ascrollView withLastContentOffset:lastContentOffset];
			break;
		case CHPullRefreshDragging:
            self.layerGroup.hidden = NO;
            self.activityView.hidden = YES;
           [self updateProgressWithScroll:ascrollView withLastContentOffset:lastContentOffset];
			break;
		case CHPullRefreshLoading:
            self.activityView.hidden = NO;
            self.layerGroup.hidden = YES;
			[self.activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	self.state = aState;
    
}


#define degToRad(angle) angle*M_PI/180.0

-(void)updateProgressWithScroll:(UIScrollView *)scrollView withLastContentOffset:(CGFloat)lastContentOffset{
    
    
    if(lastContentOffset >= -MaxCONTENTOFFSETY && lastContentOffset <-MinCONTENTOFFSETY ){
        
        CGFloat aMin = (lastContentOffset+MinCONTENTOFFSETY)/fabsf(MaxCONTENTOFFSETY - MinCONTENTOFFSETY);
        CGFloat aMax = (scrollView.contentOffset.y + MinCONTENTOFFSETY)/fabsf(MaxCONTENTOFFSETY - MinCONTENTOFFSETY);
        
        
        CGFloat lastDegress = degToRad(sin(0.5 * M_PI * aMin)*180.0);
        CGFloat currentDegress = degToRad(sin(0.5 * M_PI * aMax)*180.0);
        self.drawRotationAnimation.fromValue = [NSNumber numberWithFloat:lastDegress];
        self.drawRotationAnimation.toValue = [NSNumber numberWithFloat:currentDegress];
        [self.imageLogo addAnimation:self.drawRotationAnimation forKey:@"transform.rotation.z"];
        
#warning there is a bug here.
        
        if(self.imageCirle.strokeEnd == 1)
           self.imageCirle.strokeEnd = 0;
        CGFloat fromStrokeValue = [self.imageCirle.presentationLayer strokeEnd];
        CGFloat toStrokeValue = fabsf(sin(0.5 * M_PI * aMax));
        
         self.drawStrokeAnimation.fromValue = [NSNumber numberWithFloat:fromStrokeValue]; //[NSNumber numberWithFloat:fabsf(sin(0.5 * M_PI * aMin))];
         self.drawStrokeAnimation.toValue   = [NSNumber numberWithFloat:toStrokeValue];
       // self.drawStrokeAnimation.duration = fabs(toStrokeValue - fromStrokeValue);;
        [self.imageCirle addAnimation: self.drawStrokeAnimation forKey:@"strokeEnd"];
   
        NSLog(@"self.drawStrokeAnimation.fromValue %@",self.drawStrokeAnimation.fromValue);
        
        
        

        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
       // opacityAnimation.repeatCount         = 1.0;  // Animate only once..
    
        // Animate from no part of the stroke being drawn to the entire stroke being drawn
        opacityAnimation.fromValue = [NSNumber numberWithFloat:fabsf(aMin)];
        opacityAnimation.toValue   = [NSNumber numberWithFloat:fabsf(aMax)];
        [opacityAnimation setRemovedOnCompletion:NO];
        [opacityAnimation setFillMode:kCAFillModeForwards];
    
        // Experiment with timing to get the appearence to look the way you want
        opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
        // Add the animation to the circle
        [self.layerGroup addAnimation:opacityAnimation forKey:@"drawOpacity"];
        
        

        NSLog(@"last content offset %f and current offset %f",lastContentOffset, scrollView.contentOffset.y);
        CGPoint position = self.layerGroup.position;
    
        NSLog(@"position %@",NSStringFromCGPoint(position));
    
        
        CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        
        NSLog(@"position %@",NSStringFromCGPoint(position));
        CGPoint fromPoint = CGPointMake(position.x, position.y + aMin*15);
        NSValue *prevVal = [NSValue valueWithCGPoint:fromPoint];
        NSLog(@"fromPoint %@",NSStringFromCGPoint(fromPoint));
        [moveAnimation setFromValue:prevVal];
        CGPoint toPoint = CGPointMake(position.x , position.y + aMax*15);
        [moveAnimation setToValue:[NSValue valueWithCGPoint:toPoint]];
        
        
        NSLog(@"toPoint %@",NSStringFromCGPoint(toPoint));
        moveAnimation.removedOnCompletion = NO;
        moveAnimation.fillMode = kCAFillModeForwards;
        
        [self.layerGroup addAnimation:moveAnimation forKey:@"flow"];

        
    }
    

    
    
  
    
    
}




@end
