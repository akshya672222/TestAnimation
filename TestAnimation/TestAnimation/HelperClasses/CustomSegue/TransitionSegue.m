//
//  TransitionSegue.m
//  TestAnimation
//
//  Created by User14 on 31/07/15.
//  Copyright (c) 2015 User14. All rights reserved.
//

#import "TransitionSegue.h"
#import "ContactViewController.h"
#import "PopUpViewController.h"
#import "AppDelegate.h"

#define myAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@implementation TransitionSegue

- (void) perform {
    
    
    ContactViewController *src = (ContactViewController *)self.sourceViewController;
    UIViewController *dst = (UIViewController *)self.destinationViewController;
    
    for(UIView *view  in src.viewTransitionContainer.subviews){
        [view removeFromSuperview];
    }
    
    src.viewTransitionContainer.hidden = NO;

    CATransition *transitionAnimation = [CATransition animation];
    [transitionAnimation setType:kCATransitionFade];
//    [transitionAnimation setSubtype:kCATransitionFromRight];
    [transitionAnimation setDuration:1.0f];
    [transitionAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [transitionAnimation setFillMode:kCAFillModeBoth];
    
    [src.viewTransitionContainer.layer addAnimation:transitionAnimation forKey:@"changeView"];
    
    [src.viewTransitionContainer addSubview:dst.view];
    
}

@end
