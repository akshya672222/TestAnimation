//
//  PopUpViewController.h
//  TestAnimation
//
//  Created by User14 on 05/08/15.
//  Copyright (c) 2015 User14. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopUpViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *viewBg;
@property (weak, nonatomic) IBOutlet UIView *viewPopUp;
- (IBAction)closeViewTap:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintPopupViewHeight; //constant = 200
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintPopUpCenterY; //constant = 10

@property(assign,nonatomic) CGRect frameToStartAnimation;

@end
