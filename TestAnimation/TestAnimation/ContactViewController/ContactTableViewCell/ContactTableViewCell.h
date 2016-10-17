//
//  ContactTableViewCell.h
//  TestAnimation
//


#import <UIKit/UIKit.h>

@interface ContactTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageViewContactPhoto;
@property (weak, nonatomic) IBOutlet UILabel *lblMoreDetail;
@property (weak, nonatomic) IBOutlet UIView *viewVisible;
@property (weak, nonatomic) IBOutlet UIView *viewMoreDetail;
@property (weak, nonatomic) IBOutlet UIView *viewMoreMoreDetail;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewMoreMoreDetailHeight; //constant = 50
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewMoreDetailHeight;
@property (weak, nonatomic) IBOutlet UIImageView *imgArrowUp;
@property (weak, nonatomic) IBOutlet UIImageView *imgArrowDown;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintArrowDownBottomSpace;


@property (nonatomic, assign) BOOL withDetails;

- (void)animateOpen;
- (void)animateClosed;


@end
