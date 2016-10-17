//
//  ContactViewController.h
//  TestAnimation
//


#import <UIKit/UIKit.h>
#import "ContactTableViewCell.h"

@interface ContactViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableViewContact;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewContactProfile;

@property(strong,nonatomic)ContactTableViewCell *cell;

- (IBAction)addbtn:(id)sender;
- (IBAction)contactbtn:(id)sender;
- (IBAction)emailbtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewProfileHolder;

@property (weak, nonatomic) IBOutlet UIView *viewTabBar;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTableViewTopSpaceFromLayoutGuide;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTableViewTopSpace;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTableViewBottomSpaceFromLayoutGuide;

@property (weak, nonatomic) IBOutlet UIView *viewTransitionContainer;

@end
