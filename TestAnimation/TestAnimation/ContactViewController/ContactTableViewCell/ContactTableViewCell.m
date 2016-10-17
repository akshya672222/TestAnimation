//
//  ContactTableViewCell.m
//  TestAnimation
//


#import "ContactTableViewCell.h"

@implementation ContactTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    self.withDetails = NO;
    self.backgroundView = nil;
    self.constraintViewMoreDetailHeight.constant = 0;
    self.constraintViewMoreMoreDetailHeight.constant = 0;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setWithDetails:(BOOL)withDetails {
    _withDetails = withDetails;
    
    if (withDetails) {
        
        self.constraintViewMoreDetailHeight.priority = 250;
        self.constraintViewMoreMoreDetailHeight.priority = 250;

    } else {

        self.constraintViewMoreDetailHeight.priority = 999;
        self.constraintViewMoreMoreDetailHeight.priority = 999;
    }
}

- (void)animateOpen {
    
    
//    UIColor *originalBackgroundColor = self.contentView.backgroundColor;
//    self.contentView.backgroundColor = [UIColor clearColor];
//    
//    self.contentView.backgroundColor = originalBackgroundColor;


}

- (void)animateClosed {
    
    
//    UIColor *originalBackgroundColor = self.contentView.backgroundColor;
//    self.contentView.backgroundColor = [UIColor clearColor];
//    
//    self.contentView.backgroundColor = originalBackgroundColor;

    
}




@end
