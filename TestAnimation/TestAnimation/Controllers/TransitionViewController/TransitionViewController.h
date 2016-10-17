//
//  TransitionViewController.h
//  TestAnimation
//
//  Created by User14 on 31/07/15.
//  Copyright (c) 2015 User14. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransitionViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *images;

@end
