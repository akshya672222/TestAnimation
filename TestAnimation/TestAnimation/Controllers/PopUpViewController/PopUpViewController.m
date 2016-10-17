//
//  PopUpViewController.m
//  TestAnimation
//
//  Created by User14 on 05/08/15.
//  Copyright (c) 2015 User14. All rights reserved.
//

#import "PopUpViewController.h"
#import "AppDelegate.h"

#define myAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface PopUpViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintPopUpViewTopSpaceFromView; //constant = 174

@end

@implementation PopUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewBg.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.6];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    [self.viewPopUp setAlpha:0.0];
    
    [myAppDelegate.contactViewC.view layoutIfNeeded];
    
    myAppDelegate.contactViewC.constraintTableViewTopSpaceFromLayoutGuide.constant = myAppDelegate.contactViewC.cell.frame.origin.y + (myAppDelegate.contactViewC.cell.frame.size.height/2);

    myAppDelegate.contactViewC.constraintTableViewBottomSpaceFromLayoutGuide.constant = myAppDelegate.contactViewC.view.frame.size.height - myAppDelegate.contactViewC.constraintTableViewTopSpaceFromLayoutGuide.constant + (myAppDelegate.contactViewC.cell.frame.size.height/2);
    
    [UIView animateWithDuration:1.8f animations:^{
        
        [myAppDelegate.contactViewC.view layoutIfNeeded];
        
    }];

    self.lblDetail.text = myAppDelegate.contactViewC.cell.lblName.text;
    
    [self.view layoutIfNeeded];
    self.constraintPopupViewHeight.constant = myAppDelegate.contactViewC.cell.frame.size.height;
    self.constraintPopUpViewTopSpaceFromView.constant = myAppDelegate.contactViewC.cell.frame.origin.y;//+20;
    [self.view layoutIfNeeded];
    
    
    self.constraintPopupViewHeight.constant = 200;
    self.constraintPopUpViewTopSpaceFromView.constant = (self.viewPopUp.superview.frame.size.height - self.constraintPopupViewHeight.constant)/2;
    
    [UIView animateWithDuration:1.5 delay:1.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        [self.viewPopUp setAlpha:1.0];
        
        [self.view layoutIfNeeded];
        
    } completion:nil];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)closeViewTap:(id)sender {
    
    [self.view layoutIfNeeded];
    self.constraintPopupViewHeight.constant = myAppDelegate.contactViewC.cell.frame.size.height;
    self.constraintPopUpViewTopSpaceFromView.constant = myAppDelegate.contactViewC.cell.frame.origin.y;//+20;
    [UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
        CATransition *transitionAnimation = [CATransition animation];
        [transitionAnimation setType:kCATransitionFade];
        [transitionAnimation setDuration:1.0f];
        [transitionAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [transitionAnimation setFillMode:kCAFillModeBoth];
        
        [myAppDelegate.contactViewC.viewTransitionContainer.layer addAnimation:transitionAnimation forKey:@"changeView"];
        
        for(UIView *view in myAppDelegate.contactViewC.viewTransitionContainer.subviews){
            [view removeFromSuperview];
        }
        
        [myAppDelegate.contactViewC.viewTransitionContainer setHidden:YES];

    }];

    
    [myAppDelegate.contactViewC.view layoutIfNeeded];
    myAppDelegate.contactViewC.constraintTableViewBottomSpaceFromLayoutGuide.constant = 0;
    myAppDelegate.contactViewC.constraintTableViewTopSpaceFromLayoutGuide.constant = 0;
    [UIView animateWithDuration:3.0 delay:0.7 options:UIViewAnimationOptionLayoutSubviews animations:^{
        [myAppDelegate.contactViewC.view layoutIfNeeded];
    } completion:nil];
}

-(void)shutPopUp{
    
    
}

@end
