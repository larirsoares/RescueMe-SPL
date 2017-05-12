//
//  HowToUseViewController.h
//  RescueMe-SPL
//
//  Created by Tassio Vale on 4/19/13.
//
//

#import <UIKit/UIKit.h>

@interface HowToUseViewController : UIViewController

@property (nonatomic,retain) IBOutlet UINavigationController *navigationController;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil navigatorController:(UINavigationController *)navController;
-(IBAction)nextScreen:(id)sender;

@end
