//
//  ImportContactViewController.m
//  RescueMe-SPL-Project
//
//  Created by Tassio Vale on 11/25/12.
//
//

#import "ImportContactViewController.h"
#import "TwitterImportViewController.h"

@interface ImportContactViewController ()
#ifdef FACEBOOK_IMPORT
@property (retain, nonatomic) FBFriendPickerViewController *friendPickerController;
#endif
@end

@implementation ImportContactViewController

@synthesize contactManager;
@synthesize alert;
#ifdef FACEBOOK_IMPORT
@synthesize friendPickerController = _friendPickerController;
#endif
- (id)initWithContactManager:(ContactManager *)aManager
{
    self = [super init];
    if (self) {
        contactManager = aManager;
        facebookId = @"0";
        page = NONE;
    }
    return self;
}

//#ifdef PHONE_IMPORT
- (IBAction)phoneImport:(id)sender {
    ABPeoplePickerNavigationController *picker =
    [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    [picker.topViewController.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    
    [self presentViewController:picker animated:YES completion:NULL];
}
//#endif


- (IBAction)facebookImport:(id)sender {
#ifdef FACEBOOK_IMPORT
    //Set our page as facebook
    page = FACEBOOK;
    
    //Now we gonna open the facebook screen
    // Do any additional setup after loading the view from its nib.
    if ((!FBSession.activeSession.isOpen)) {
        // if the session is closed, then we open it here, and establish a handler for state changes
        
        NSArray *permissions =  [NSArray arrayWithObjects:@"xmpp_login", nil];
        
        /*
         [FBSession.activeSession openWithCompletionHandler:^(FBSession *session,
         FBSessionState state,
         NSError *error) {
         */
        [FBSession openActiveSessionWithReadPermissions:permissions
                                           allowLoginUI:YES completionHandler:^(FBSession *session,
                                                                                FBSessionState state,
                                                                                NSError *error) {
                                               switch (state) {
                                                   case FBSessionStateClosedLoginFailed:
                                                   {
                                                       UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                           message:error.localizedDescription
                                                                                                          delegate:nil
                                                                                                 cancelButtonTitle:@"OK"
                                                                                                 otherButtonTitles:nil];
                                                       [alertView show];
                                                   }
                                                       break;
                                                   default:
                                                       [self.friendPickerController loadData];
                                               }
                                           }];
    }

    
    if (self.friendPickerController == nil) {
        // Create friend picker, and get data loaded into it.
        self.friendPickerController = [[FBFriendPickerViewController alloc] init];
        self.friendPickerController.title = @"Facebook Friends";
        self.friendPickerController.delegate = self;
        self.friendPickerController.allowsMultipleSelection = NO;
    }
    
    [self.friendPickerController loadData];
    [self.friendPickerController clearSelection];
    
    //Animate !
    [self presentViewController:self.friendPickerController animated:YES completion:NULL];

#else
    NSString *alertMessage = @"Your version do not support this feature.";
    
    alert = [[UIAlertView alloc] initWithTitle:@"Not avaliable" message:alertMessage delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
    
    [alert show];
	[alert release];
    
#endif
    
    
    
}

#ifdef FACEBOOK_IMPORT
-(void)facebookViewControllerDoneWasPressed:(id)sender {
    
    // we pick up the users from the selection
    //Right now we just pick the name
    
    
    //We do not selected anything
    if((self.friendPickerController.selection == nil) || (self.friendPickerController.selection.count <= 0))
    {
        [self dismissViewControllerAnimated:YES completion:NULL];
        return;
    }
    
    
    id<FBGraphUser> user = self.friendPickerController.selection[0];
    
    contactName = user.name;
    facebookId = user.id;
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self showAlertWithContactName:contactName];
}

- (void)facebookViewControllerCancelWasPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}
#endif




//
- (IBAction)twitterImport:(id)sender {
#ifdef TWITTER_IMPORT
    page = TWITTER;
    //TwitterImportViewController *twitterImportViewController = [[TwitterImportViewController alloc] initWithNibName:@"ViewController"  bundle:nil];
    TwitterImportViewController *twitterImportViewController = [[TwitterImportViewController alloc] initWithNibName:@"ViewController"  bundle:nil contactManager:contactManager];
    
    [self.navigationController pushViewController:twitterImportViewController animated:YES];
     //[twitterImportViewController getFriends];
#else
    NSString *alertMessage = @"Your version do not support this feature.";
    
    alert = [[UIAlertView alloc] initWithTitle:@"Not avaliable" message:alertMessage delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
    
    [alert show];
	[alert release];
    
#endif

}


- (void)getContactInfo:(ABRecordRef)person{
    
    NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *lastName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    
    if (firstName && lastName) {
        contactName = [[NSString alloc] initWithFormat:@"%@ %@", firstName, lastName];
    }
    
    if (firstName && !lastName) {
        contactName = firstName;
    }
    
    if (!firstName && lastName) {
        contactName = lastName;
    }
    
    if (!firstName && !lastName) {
        contactName = @"";
    }
    
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,kABPersonPhoneProperty);
    
    if (ABMultiValueGetCount(phoneNumbers) > 0) {
        phone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
    }
    else{
        
        phone = @"";
    }
    
    ABMultiValueRef emails = ABRecordCopyValue(person,kABPersonEmailProperty);
    
    if (ABMultiValueGetCount(emails) > 0) {
        email = (__bridge NSString*)ABMultiValueCopyValueAtIndex(emails, 0);
    }
    else{
        
        email = @"";
    }
    
    //    NSLog(@"Nome: %@", contactName);
    //    NSLog(@"Email: %@", email);
    //    NSLog(@"Celular: %@", phone);
    
    [self showAlertWithContactName:contactName];
}

-(void)showAlertWithContactName:(NSString *)aName
{
    NSString *alertMessage = [NSString stringWithFormat:@"Do you want to add %@ as a RescueMe contact?", aName];
    
    alert = [[UIAlertView alloc] initWithTitle:@"Import contact" message:alertMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    
    [alert show];
//	[alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (buttonIndex == 1) {
        //NSLog(@"OK");
        if(contactName != nil){
            if([contactManager contactAlreadyExists:contactName]){
                UIAlertView *existsAlert = [[UIAlertView alloc] initWithTitle:@"Contact already exists" message:@"This contact already exists" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
                [existsAlert show];
 //               [existsAlert release];
            }else{
                [self.contactManager addContactWithName:contactName andPhone:phone andEmail:email andFacebookID:facebookId andTwitterID:@""];
                [self.navigationController popViewControllerAnimated:YES];
                page = NONE;
            }
        }
	}
    else {
        //NSLog(@"Cancel");
	}
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    [self getContactInfo:person];
    [self dismissViewControllerAnimated:YES completion:NULL];
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Import from:";

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
