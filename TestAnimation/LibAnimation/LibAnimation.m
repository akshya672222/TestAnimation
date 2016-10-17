//
//  LibAnimation.m
//  LibAnimation
//
//  Created by User14 on 07/08/15.
//  Copyright (c) 2015 User14. All rights reserved.
//

#import "LibAnimation.h"

#pragma mark - main
@interface LibAnimation() <UIGestureRecognizerDelegate>

#pragma mark - properties
//for popup animation
@property(nonatomic,strong)UIView *viewForAnimation;
@property(nonatomic,strong)UIView *viewCopy;
@property(nonatomic,strong)UIImageView *viewImage;
@property(nonatomic,assign)NSInteger animationTypeValue;
@property(nonatomic,strong)UIView *centerView;
@property(nonatomic,assign)CGFloat initialCornerRadius;

//for image pop in animation
@property(nonatomic,strong)UIImageView *imageViewOriginal;
@property(nonatomic,strong)UIImageView *imageViewDuplicate;
@property(nonatomic,assign)CGRect frameOriginal;
@property(nonatomic,assign)CGRect frameForAnimation;

@property(nonatomic,assign)CGFloat toWhiteForCenter;
@property(nonatomic,assign)CGFloat toAlphaForCenter;

@end

@implementation LibAnimation

#pragma mark - synthesizing properties
@synthesize fromScale;
@synthesize toScale;
@synthesize fromCenter;
@synthesize toCenter;
@synthesize animationDuration;
@synthesize startAlpha;
@synthesize endAlpha;
@synthesize delayDuration;
@synthesize viewForAnimation;
@synthesize animationTypeValue;
@synthesize viewImage;
@synthesize centerView;
@synthesize initialCornerRadius;
@synthesize imageViewOriginal;
@synthesize imageViewDuplicate;
@synthesize frameOriginal;
@synthesize frameForAnimation;

#pragma mark - init with view
- (id)initWithView:(UIView *)view colorForCenterViewWithWhite:(CGFloat)white alpha:(CGFloat)alpha{
    self = [super init];
    if (self) {
        
        if([view isKindOfClass:[UIImageView class]]){
            
            UIImageView *imageView = (UIImageView *)view;
            
            UIImage *img = imageView.image;
            UIImage *img2 = [UIImage imageWithCGImage:img.CGImage scale:img.scale orientation:img.imageOrientation];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:img2];
            UIImage *imgCopy = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            
            UIImageView *imageView2 = [[UIImageView alloc]initWithImage:imgCopy];
            imageView2.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
            imageView2.contentMode = UIViewContentModeScaleAspectFill;
            
            self.viewCopy = [[UIView alloc]initWithFrame:view.frame];
            
            [self.viewCopy addSubview:imageView2];
            
        }else{
            
            self.viewCopy = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:view]];

        }
        
        self.initialCornerRadius = self.viewCopy.frame.size.height/2;
        
        self.fromScale = CGPointMake(1.0, 1.0);
        self.toScale = CGPointMake(2.0, 2.0);
        self.fromCenter = view.center;
        self.toCenter = self.viewCopy.superview.center;
        
//        self.toCenter = [UIApplication sharedApplication].keyWindow.center;

        self.animationDuration = 0.5;
        self.delayDuration = 0.0;
        self.startAlpha = 0.0;
        self.endAlpha = 1.0;
        
        //background view
        _toWhiteForCenter = white;
        _toAlphaForCenter = alpha;
        
        self.centerView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        self.centerView.layer.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0].CGColor;
        [self.centerView addSubview:self.viewCopy];
        
    }
    return self;
}

#pragma mark - init with image view
- (id)initWithImageView:(UIImageView *)imageView colorForCenterViewWithWhite:(CGFloat)white alpha:(CGFloat)alpha{
    self = [super init];
    if (self) {
        
        UIImage *img = imageView.image;
        UIImage *img2 = [UIImage imageWithCGImage:img.CGImage scale:img.scale orientation:img.imageOrientation];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:img2];
        UIImage *imgCopy = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        imageViewDuplicate = [[UIImageView alloc]initWithImage:imgCopy];
        [imageViewDuplicate setContentMode:UIViewContentModeScaleAspectFill];
        
        self.imageViewOriginal = imageView;
        
        //background view
        _toWhiteForCenter = white;
        _toAlphaForCenter = alpha;

        self.centerView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        self.centerView.layer.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0].CGColor;
        [self.centerView addSubview:imageViewDuplicate];
        
    }
    return self;
}
#pragma mark init end -

+ (instancetype) shared
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


-(void)addTapHandlingView{
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.centerView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToBackView:)];
    [tapGesture setDelegate:self];
    [self.centerView addGestureRecognizer:tapGesture];
    
}




#pragma mark - put back animation
-(void)goToBackView:(UITapGestureRecognizer *)recognizer{
    
    [self animatePutBack];
    
}


#pragma mark - c to c
-(void)animateViewFromCircleToCircle{
    
    self.animationTypeValue = 0;
    
    [self initialSetupForCircleTransition];
    
    [self animate];
    
}


#pragma mark - s to s
-(void)animateViewFromSquareToSquare{
    
    self.animationTypeValue = 1;
    
    [self initialSetupForSquareTransition];
    
    [self animate];
    
}

#pragma mark - c to s
-(void)animateViewFromCircleToSquare{
    
    self.animationTypeValue = 2;
    
    [self initialSetupForCircleTransition];
    
    [UIView animateWithDuration:self.animationDuration
                          delay:self.delayDuration
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         self.viewCopy.alpha = self.endAlpha;
                         
                         [self.viewCopy.superview layoutIfNeeded];
                         self.viewCopy.transform = CGAffineTransformMakeScale(toScale.x, toScale.y);
                         [self.viewCopy.superview layoutIfNeeded];
                         
                         self.viewCopy.center = toCenter;
                         
                         self.centerView.layer.backgroundColor = [UIColor colorWithWhite:_toWhiteForCenter alpha:_toAlphaForCenter].CGColor;

                         [self addCornerRadiusAnimationOnViewFrom:self.initialCornerRadius To:0.0];
                         
                     } completion:^(BOOL finished) {
                         
                         self.viewCopy.layer.shouldRasterize = NO;
                         
                     }];
    
}

#pragma mark - s to c
-(void)animateViewFromSquareToCircle{
    
    self.animationTypeValue = 3;
    
    [self initialSetupForSquareTransition];
    
    [UIView animateWithDuration:self.animationDuration
                          delay:self.delayDuration
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         self.viewCopy.alpha = self.endAlpha;
                         
                         [self.viewCopy.superview layoutIfNeeded];
                         self.viewCopy.transform = CGAffineTransformMakeScale(toScale.x, toScale.y);
                         [self.viewCopy.superview layoutIfNeeded];
                         
                         self.viewCopy.center = toCenter;
                         
                         self.centerView.layer.backgroundColor = [UIColor colorWithWhite:_toWhiteForCenter alpha:_toAlphaForCenter].CGColor;

                         [self addCornerRadiusAnimationOnViewFrom:0.0 To:self.initialCornerRadius];
                         
                     } completion:^(BOOL finished) {
                         
                         self.viewCopy.layer.shouldRasterize = NO;
                         
                     }];
    
}



#pragma mark - animation setup methods
-(void)initialSetupForCircleTransition{
    
    [self addTapHandlingView];
    
    [self.viewCopy.superview layoutIfNeeded];
    self.viewCopy.center = self.fromCenter;
    [self.viewCopy.superview layoutIfNeeded];
    
    self.viewCopy.layer.cornerRadius = self.initialCornerRadius;
    self.viewCopy.layer.masksToBounds = YES;
    self.viewCopy.layer.shouldRasterize = YES;
    
    self.viewCopy.transform = CGAffineTransformMakeScale(fromScale.x, fromScale.y);
    
    self.viewCopy.alpha = self.startAlpha;
    
}

-(void)initialSetupForSquareTransition{
    
    [self addTapHandlingView];
    
    self.viewCopy.transform = CGAffineTransformMakeScale(fromScale.x, fromScale.y);
    
    [self.viewCopy.superview layoutIfNeeded];
    self.viewCopy.center = self.fromCenter;
    [self.viewCopy.superview layoutIfNeeded];
    
    self.viewCopy.layer.cornerRadius = 0;
    self.viewCopy.layer.masksToBounds = YES;
    self.viewCopy.layer.shouldRasterize = YES;
    
    self.viewCopy.alpha = self.startAlpha;
    
}

-(void)animate{
    
    [UIView animateWithDuration:self.animationDuration
                          delay:self.delayDuration
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         self.viewCopy.alpha = self.endAlpha;
                         
                         [self.viewCopy.superview layoutIfNeeded];
                         self.viewCopy.transform = CGAffineTransformMakeScale(toScale.x, toScale.y);
                         [self.viewCopy.superview layoutIfNeeded];
                         
                         self.centerView.layer.backgroundColor = [UIColor colorWithWhite:_toWhiteForCenter alpha:_toAlphaForCenter].CGColor;

                         self.viewCopy.center = toCenter;
                         
                     } completion:^(BOOL finished) {
                         
                         self.viewCopy.layer.shouldRasterize = NO;
                         
                     }];
    
}


-(void)addCornerRadiusAnimationOnViewFrom:(CGFloat )radius To:(CGFloat)radiusNew{
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    animation.timingFunction = [CAMediaTimingFunction     functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.fromValue = [NSNumber numberWithFloat:radius];
    animation.toValue = [NSNumber numberWithFloat:radiusNew];
    animation.duration = self.animationDuration + self.animationDuration/2;
    [self.viewCopy.layer setCornerRadius:radiusNew];
    [self.viewCopy.layer addAnimation:animation forKey:@"cornerRadius"];
    
}
#pragma mark end of reveal animation methods -



#pragma mark start of put back animation methods
-(void)animatePutBack{
    
    switch(animationTypeValue) {
        case 0:
            [self CToC_Or_SToS_Animation];
            break;
            
        case 1:
            [self CToC_Or_SToS_Animation];
            break;
            
        case 2:
            [self CToSAnimation];
            break;
            
        default:
            [self SToCAnimation];
            break;
    }
}


-(void)CToC_Or_SToS_Animation{
    
    [UIView animateWithDuration:self.animationDuration
                          delay:self.delayDuration
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.viewCopy.transform = CGAffineTransformMakeScale(self.fromScale.x, self.fromScale.y);
                         
                         self.viewCopy.alpha = self.startAlpha;
                         
                         self.viewCopy.center = self.fromCenter;
                         
                         self.centerView.layer.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0].CGColor;
                         
                     } completion:^(BOOL finished) {
                         
                         self.viewCopy.hidden = YES;
                         
                         [self.centerView removeFromSuperview];
                         
                     }];
}

-(void)CToSAnimation{
    
    
    [UIView animateWithDuration:self.animationDuration
                          delay:self.delayDuration
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.viewCopy.transform = CGAffineTransformMakeScale(self.fromScale.x, self.fromScale.y);
                         
                         [self addCornerRadiusAnimationOnViewFrom:0.0 To:self.initialCornerRadius];
                         
                         self.viewCopy.alpha = self.startAlpha;
                         
                         self.viewCopy.center = self.fromCenter;
                         
                         self.centerView.layer.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0].CGColor;

                     } completion:^(BOOL finished) {
                         
                         self.viewCopy.hidden = YES;
                         
                         [self.centerView removeFromSuperview];
                         
                     }];
    
}

-(void)SToCAnimation{
    
    
    [UIView animateWithDuration:self.animationDuration
                          delay:self.delayDuration
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         [self addCornerRadiusAnimationOnViewFrom:self.initialCornerRadius To:0.0];
                         
                         self.viewCopy.transform = CGAffineTransformMakeScale(self.fromScale.x, self.fromScale.y);
                         
                         self.viewCopy.alpha = self.startAlpha;
                         
                         self.viewCopy.center = self.fromCenter;
                         
                         self.centerView.layer.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0].CGColor;

                     } completion:^(BOOL finished) {
                         
                         self.viewCopy.hidden = YES;
                         
                         [self.centerView removeFromSuperview];
                         
                     }];
    
}
#pragma mark put back end


#pragma mark - animation image pop in
-(void)animateImageViewForImageFromRect:(CGRect)rect{
    
    NSLog(@"method called");
    
    self.imageViewDuplicate.frame = rect;
    self.frameOriginal = rect;
    
    
    //frame to animate
    if(self.imageViewOriginal.image.size.height>[UIScreen mainScreen].bounds.size.width){
        
        if (self.imageViewOriginal.image.size.height >= [UIScreen mainScreen].bounds.size.height) {
            
            self.frameForAnimation = CGRectMake(0, ([UIScreen mainScreen].bounds.size.height - [UIScreen mainScreen].bounds.size.width*1.3)/2, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width*1.3);

        }else{
            
            self.frameForAnimation = CGRectMake(0, ([UIScreen mainScreen].bounds.size.height - self.imageViewOriginal.image.size.height)/2, [UIScreen mainScreen].bounds.size.width, self.imageViewOriginal.image.size.height);
            
        }

    }else{
       
        CGFloat ratio;

        ratio = [UIScreen mainScreen].bounds.size.width/self.imageViewOriginal.image.size.width;

        if (self.imageViewOriginal.image.size.height>self.imageViewOriginal.image.size.width) {
            
            if ((ratio*self.imageViewOriginal.image.size.height) >= [UIScreen mainScreen].bounds.size.height) {
                
                ratio = 1.3;
                
            }
            
        }else{
            
            if (self.imageViewOriginal.image.size.width>[UIScreen mainScreen].bounds.size.width) {
                
                ratio = 1.0;
                
            }
            
        }
        
        self.frameForAnimation = CGRectMake(0, ([UIScreen mainScreen].bounds.size.height - (ratio*self.imageViewOriginal.image.size.height))/2, [UIScreen mainScreen].bounds.size.width, ratio*self.imageViewOriginal.image.size.height);

    }

    //animation
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         [[[UIApplication sharedApplication] keyWindow] addSubview:self.centerView];
                         
                         self.imageViewOriginal.hidden =  YES;
                         
                         self.imageViewDuplicate.frame = self.frameForAnimation;
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    //adding gesture recognizer
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToNormal:)];
    gestureRecognizer.delegate = self;
    gestureRecognizer.numberOfTapsRequired = 1;
    [self.centerView addGestureRecognizer:gestureRecognizer];
    
}


-(void)backToNormal:(UITapGestureRecognizer *)gesture{
    
    [self.centerView setBackgroundColor:[UIColor clearColor]];
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         self.imageViewDuplicate.frame = self.frameOriginal;
                         
                     }
                     completion:^(BOOL finished){
                         
                         self.imageViewOriginal.hidden =  NO;
                         
                         [UIView transitionWithView:[UIApplication sharedApplication].keyWindow
                                           duration:0.1
                                            options:UIViewAnimationOptionTransitionCrossDissolve //change to whatever animation you like
                                         animations:^ {
                                             [self.centerView removeFromSuperview];
                                         }
                                         completion:nil];
                     }];
    
}
#pragma mark animation image pop in end

@end
