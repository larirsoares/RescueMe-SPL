//
//  RescueMe_SPLViewController.m
//  RescueMe-SPL-Project
//
//  Created by Loreno on 13/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "RescueMe_SPLViewController.h"


@implementation RescueMe_SPLViewController{
    //variaveis do location
    Location *CLController;
}

@synthesize redButton;
@synthesize backGroundImageView;
@synthesize CLController;
static NSString *latitude;
static NSString * longitude;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Help me!", @"Help me!");
        self.tabBarItem.image = [UIImage imageNamed:@"helpme"];
    }
    return self;
}

-(IBAction)redButtonPressed:(UIButton *)sender
{
    //NSLog(@"Button pressed");
    [self SMSDestination];
    
#ifdef FACEBOOK_IMPORT
    //Facebook
    FacebookCommunicationController *facebookController = [[FacebookCommunicationController alloc] init];
    self.facebookController = facebookController;
    [facebookController connect];
#endif
    
#ifdef TWITTER_IMPORT
    //Twitter
    TwitterCommunicationController *twitterController = [[TwitterCommunicationController alloc] init];
    self.facebookController = twitterController;
    [twitterController sendToAllContacts];
#endif
    
#ifdef EMAIL_DESTINATION
    [self emailDestination];
#endif
}

/*
 // The designated initializer. Override to perform setup that is required before the view is loaded.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//do location
	CLController = [[Location alloc] init];
	CLController._delegate = self;
	[CLController.locMgr startUpdatingLocation];
	
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        // code for 4-inch screen
        //NSLog(@"Iphone 5");
        self.backGroundImageView.image = [UIImage imageNamed:@"background568"];
        
        CGRect redButtomFrame = self.redButton.frame;
        
        self.redButton.frame = CGRectMake(redButtomFrame.origin.x, redButtomFrame.origin.y + 42, redButtomFrame.size.width, redButtomFrame.size.height);
        
        
    } else {
        // code for 3.5-inch screen
        //NSLog(@"Iphone outro");
    }
    
    [redButton setImage:[UIImage imageNamed:@"botao"] forState:UIControlStateNormal];
    [redButton setImage:[UIImage imageNamed:@"botaoPressed"] forState:UIControlStateHighlighted];
}



/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


//location
- (void)locationUpdate:(CLLocation *)location {
    
	latitude = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
	longitude = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
	//longitudeLabel = [NSString stringWithFormat:@"%1.6d", location.coordinate.longitude];
}

- (void)locationError:(NSError *)error {
	
}

- (void)dealloc {
	//[CLController release];
    //[super dealloc];
}

+(NSString*)getRescueMessage{
    NSString *message = [[NSString alloc] init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *code = @"CODE_HERE";
    NSString *url = @"URL_HERE";
    NSString *selectedLanguage = @"selectedLanguage"; // the key for the data
    NSString *language = [defaults stringForKey:selectedLanguage];
    
    if ([language isEqualToString:@"GERMAN"]) {
        message = [NSString stringWithFormat:@"Hallo, du hast auf meiner Liste der Notfall-Kontakte sind, dann passiert etwas, bitte geben Sie den Code %@ in %@rescueme/web/index.php mich zu verfolgen. \n \n Diese Nachricht wurde automatisch von RescueMe-App gesendet.", code, url];
    }
    else
        if ([language isEqualToString:@"PORTUGUESE"]) {
            message = [NSString stringWithFormat:@"Olá, você está na minha lista de contatos de emergência, algo aconteceu, por favor digite o código %@ em %@rescueme/web/index.php para me rastrear. \n \n Esta menssagem foi enviada automaticamente pela RescueMe app.", code, url];
        }else
            if ([language isEqualToString:@"SPANISH"]) {
                message = [NSString stringWithFormat:@"Hola, estás en mi lista de contactos de emergencia, algo sucedió, por favor, introduzca el código %@ en %@rescueme/web/index.php para mí seguir. \n \n Este mensaje fue enviado de forma automática por aplicación para el iPhone RescueMe.", code, url];
            }else
                
                if ([language isEqualToString:@"FRENCH"]) {
                    message = [NSString stringWithFormat:@"Bonjour, vous êtes sur ma liste de contacts d'urgence, quelque chose s'est passé, s'il vous plaît entrez le code %@ en %@rescueme/web/index.php de me retrouver. \n \n Ce message a été envoyé automatiquement par application Rescueme.", code, url];
                }else{
                    message = [NSString stringWithFormat:@"Hello, you are in my emergency contact list, something happened, please enter the code %@ in %@rescueme/web/index.php to track me down.\n\n This message was sent automatically by RescueMe app.\n\nThis message was sent when I was in the following location: latitude %@ / longitude %@", code, url, latitude, longitude];
                }
    return message;
}

#ifdef EMAIL_DESTINATION
-(void)emailDestination{
    
    if ([MFMailComposeViewController canSendMail]){
        NSString *emailTitle = @"Please, help me! (this is not a virus)";
        // Email Content
        NSString *messageBody = [RescueMe_SPLViewController getRescueMessage];
        // To address
        NSArray *toRecipents = [[[ContactManager alloc] init] getAllEmails];
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
    }else{
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Unable to send e-mail" message:@"Your phone is not able to send e-mail" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
		
        [errorAlert show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"E-mail sent!");
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}
#endif

- (void) SMSDestination{
    if([MFMessageComposeViewController canSendText]){
        MFMessageComposeViewController *smsController =[[MFMessageComposeViewController alloc] init];
        
        [smsController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
        smsController.body = [RescueMe_SPLViewController getRescueMessage];
        smsController.recipients = [[[ContactManager alloc] init] getAllPhones];
        smsController.messageComposeDelegate = self;
        [self presentViewController:smsController animated:YES completion:NULL];
    }
    else{
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Unable to send SMS" message:@"Your phone is not able to send SMS" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
		
        [errorAlert show];
        //[errorAlert release];
    }
    
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"SMS Cancelled");
            break;
            
        case MessageComposeResultFailed:
            NSLog(@"SMS Failed");
            break;
            
        case MessageComposeResultSent:
            NSLog(@"SMS Sent");
            break;
            
        default:
            break;
    }
    [self dismissViewControllerAnimated:NO completion:NULL];
    //[self sendEmailWithTrackCode:self.trackCode];
    
}

@end
