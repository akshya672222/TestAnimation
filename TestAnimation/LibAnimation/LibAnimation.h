//
//  LibAnimation.h
//  LibAnimation
//
//  Created by User14 on 07/08/15.
//  Copyright (c) 2015 User14. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LibAnimation : NSObject


#pragma mark - animation for popup
/**
 Load object with view which is to animate.
 */
- (id)initWithView:(UIView *)view colorForCenterViewWithWhite:(CGFloat)white alpha:(CGFloat)alpha;

/**
 Initial center for the view from where animation is to be started. Center provide points from where animation is to be started.
 */
@property(nonatomic,assign)CGPoint fromCenter;


/**
 Center where view will move from initial center while animating. This provide point where animation is to be ended.
 */
@property(nonatomic,assign)CGPoint toCenter;


/**
 Initial scale of view from which animation is to be started. For popup animation then set fromScale smaller than toScale or vice versa.
 */
@property(nonatomic,assign)CGPoint fromScale;

/**
 End scale of view which will be gained at end of the animation.
 */
@property(nonatomic,assign)CGPoint toScale;

/**
 Time duration for which animation is to be performed.
 */
@property(nonatomic,assign)CGFloat animationDuration;

/**
 Delay time before animation start.
 */
@property(nonatomic,assign)CGFloat delayDuration;

/**
 Initial alpha for view from which view will start animation. For animating hiden view to show then set startAlpha less than endAlpha.
 */
@property(nonatomic,assign)CGFloat startAlpha;

/**
 End alpha value for view at which view will end animation.
 */
@property(nonatomic,assign)CGFloat endAlpha;

/**
 Animation of view from circle to circle transition. For proper animation of circle transition UIView with rounded corner is must. This method is used on thumbnail of circular view. For using circle animation properly please keep "Width" and "Height" of view same.
 */
-(void)animateViewFromCircleToCircle;

/**
 Animation of view from circle to square transition. For proper animation of circle transition UIView with rounded corner is must. This method is used on thumbnail of circular view. For using circle animation properly please keep "Width" and "Height" of view same.
 */
-(void)animateViewFromCircleToSquare;

/**
 Animation of view from square to circle transition. This method is used on thumbnail of square view. For using circle animation properly please keep "Width" and "Height" of view same.
 */
-(void)animateViewFromSquareToCircle;

/**
 Animation of view from square to square transition. This method is used on thumbnail of square view.
 */
-(void)animateViewFromSquareToSquare;



#pragma mark - animation for image pop in full screen
/**
 Load object with image view which is to animate for pop in.
 */
- (id)initWithImageView:(UIImageView *)imageView colorForCenterViewWithWhite:(CGFloat)white alpha:(CGFloat)alpha;

/**
 Call animation method for initialized object with its frame visible in view from where it is to be picked.
 */
-(void)animateImageViewForImageFromRect:(CGRect)rect;


@end
