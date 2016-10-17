//
//  TransitionViewController.m
//  TestAnimation
//
//  Created by User14 on 31/07/15.
//  Copyright (c) 2015 User14. All rights reserved.
//

#import "TransitionViewController.h"
#import "LibAnimation.h"
#import "UIImage+ImageEffects.h"

typedef enum ScrollDirection {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
} ScrollDirection;

@interface TransitionViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

//somewhere in the header
@property (nonatomic, assign) CGFloat lastContentOffset;
//

@end

@implementation TransitionViewController
{
    NSArray *arrayImage;
    LibAnimation *animate;
    ScrollDirection scrollDirection;
    CGPoint contentOffSet;
    UIImageView *blurImageView;
    UIImage *maskImg;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIGraphicsBeginImageContextWithOptions([UIApplication sharedApplication].keyWindow.bounds.size, true, 1.0);
//    [[UIApplication sharedApplication].keyWindow drawViewHierarchyInRect:[UIApplication sharedApplication].keyWindow.bounds afterScreenUpdates:true];
//    maskImg = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    arrayImage = @[[UIImage imageNamed:@"Digit"],[UIImage imageNamed:@"Digit2"],[UIImage imageNamed:@"Digit4"],[UIImage imageNamed:@"Digit3"]];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openView:)];
    [gesture setDelegate:self];
    gesture.numberOfTapsRequired = 1;
    
    [self.scrollView setDelegate:self];
    [self.scrollView addGestureRecognizer:gesture];
    
    CGSize scrollableSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, self.scrollView.contentSize.height);
    [self.scrollView setContentSize:scrollableSize];
    
    for(UIImageView *imgView in self.images){
        imgView.clipsToBounds = YES;
    }

//    [self getSnapShot];
    
}

-(void)getSnapShot{
    
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, true, 1.0);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:true];

//    UIGraphicsBeginImageContextWithOptions([UIApplication sharedApplication].keyWindow.bounds.size, true, 1.0);
//    [[UIApplication sharedApplication].keyWindow drawViewHierarchyInRect:[UIApplication sharedApplication].keyWindow.bounds afterScreenUpdates:true];

    UIImage *screenshotImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *imgWithBlur = [screenshotImg applyBlurWithRadius:20.0 tintColor:nil saturationDeltaFactor:1.0 maskImage:maskImg];
    blurImageView = [[UIImageView alloc]initWithImage:imgWithBlur];
    blurImageView.frame = self.scrollView.frame;
    
    [self.scrollView addSubview:blurImageView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)openView:(UITapGestureRecognizer *)gesture{
    
    NSLog(@"tapped");
    
    CGPoint point = [gesture locationInView:self.view];
    CGPoint offset = self.scrollView.contentOffset;
    CGPoint contentPoint = CGPointMake(point.x + offset.x, point.y + offset.y);
    
    for (UIView *view in self.scrollView.subviews){
        if (CGRectContainsPoint(view.frame, contentPoint)){
            
            NSLog(@"image view");
            
            CGRect visibleRect = CGRectIntersection(view.frame, self.scrollView.bounds);
            if (scrollDirection == ScrollDirectionDown) {
                visibleRect.origin.y = visibleRect.origin.y-contentOffSet.y+20;
            }else{
                visibleRect.origin.y = visibleRect.origin.y+20;
                visibleRect.size.height = view.frame.size.height;
            }
            
            UIImageView *imgView = (UIImageView *)view;
            
            if ([self.images indexOfObject:imgView] == 0 ||[self.images indexOfObject:imgView] == 2) {
                
                animate = [[LibAnimation alloc]initWithView:view colorForCenterViewWithWhite:0.4 alpha:0.5];
                [animate setFromCenter:CGPointMake(visibleRect.origin.x + visibleRect.size.width/2,visibleRect.origin.y + visibleRect.size.height/2)];
                [animate setFromScale:CGPointMake(1.0, 1.0)];
                [animate setToCenter:self.scrollView.superview.center];
                [animate setToScale:CGPointMake(1.5, 1.5)];
                [animate setStartAlpha:0.2];
                [animate setEndAlpha:1.0];
                [animate setAnimationDuration:1.0];
                [animate setDelayDuration:0.0];
                [animate animateViewFromSquareToSquare];
                
            }else{
             
                animate = [[LibAnimation alloc]initWithImageView:imgView colorForCenterViewWithWhite:0.4 alpha:0.5];
                [animate animateImageViewForImageFromRect:visibleRect];

            }
        }
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.lastContentOffset > scrollView.contentOffset.y){
        scrollDirection = ScrollDirectionDown;
    }
    else if (self.lastContentOffset < scrollView.contentOffset.y){
        scrollDirection = ScrollDirectionUp;
    }
    
    self.lastContentOffset = scrollView.contentOffset.y;
    
    contentOffSet = scrollView.contentOffset;
    
    // do whatever you need to with scrollDirection here.
}


//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    
//    NSLog(@"will scroll");
//    
//}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    
//    [blurImageView removeFromSuperview];
//    blurImageView = nil;
//    
//    UIGraphicsBeginImageContextWithOptions([UIApplication sharedApplication].keyWindow.bounds.size, true, 1.0);
//    [[UIApplication sharedApplication].keyWindow drawViewHierarchyInRect:[UIApplication sharedApplication].keyWindow.bounds afterScreenUpdates:true];
//
//    UIImage *screenshotImg = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    UIImage *imgWithBlur = [screenshotImg applyBlurWithRadius:20.0 tintColor:nil saturationDeltaFactor:1.0 maskImage:maskImg];
//    blurImageView = [[UIImageView alloc]initWithImage:imgWithBlur];
//
//    CGRect frame = self.scrollView.frame;
//    frame.size.height = self.view.frame.size.height;
//    frame.origin.y = 0+contentOffSet.y;
//    
//    blurImageView.frame = frame;
//    
//    [self.scrollView addSubview:blurImageView];
//
//}

//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
//    
//    [blurImageView removeFromSuperview];
//    
//    blurImageView = nil;
//    
//    UIGraphicsBeginImageContextWithOptions([UIApplication sharedApplication].keyWindow.bounds.size, true, 1.0);
//    [[UIApplication sharedApplication].keyWindow drawViewHierarchyInRect:[UIApplication sharedApplication].keyWindow.bounds afterScreenUpdates:true];
//    
//    UIImage *screenshotImg = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    UIImage *imgWithBlur = [screenshotImg applyBlurWithRadius:20.0 tintColor:nil saturationDeltaFactor:1.0 maskImage:maskImg];
//    blurImageView = [[UIImageView alloc]initWithImage:imgWithBlur];
//    blurImageView.frame = self.view.frame;
//    
//    [self.scrollView addSubview:blurImageView];
//    
//}
//



@end
