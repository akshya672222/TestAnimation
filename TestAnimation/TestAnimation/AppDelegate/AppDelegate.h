//
//  AppDelegate.h
//  TestAnimation
//


#import <UIKit/UIKit.h>
#import "ContactViewController.h"
#import "PopUpViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,strong)NSMutableArray *arrayContactData;

@property(nonatomic,strong)NSIndexPath *indexPath;

@property(nonatomic,strong)ContactViewController *contactViewC;

@property(nonatomic,strong)PopUpViewController *popUPViewC;

@end

