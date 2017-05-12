//
//  HowToUseViewController.m
//  RescueMe-SPL
//
//  Created by Tassio Vale on 4/19/13.
//
//

#import "HowToUseViewController.h"
#import "HowToUseStep2ViewController.h"

@interface HowToUseViewController ()

@end

@implementation HowToUseViewController

@synthesize navigationController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil navigatorController:(UINavigationController *)navController
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationController = navController;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextScreen:)];
    self.navigationItem.rightBarButtonItem = nextButton;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(IBAction)nextScreen:(id)sender{
    HowToUseStep2ViewController *howToUseStep2ViewController = [[HowToUseStep2ViewController alloc] initWithNibName:@"HowToUseStep2ViewController" bundle:nil];
    [self.navigationController pushViewController:howToUseStep2ViewController animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
