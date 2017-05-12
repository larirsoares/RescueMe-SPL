//
//  AddContactViewController.m
//  RescueMe-SPL-Project
//
//  Created by Tassio Vale on 11/25/12.
//
//

#import "AddContactViewController.h"

@interface AddContactViewController ()

@end

@implementation AddContactViewController
@synthesize nameContact, emailContact, phoneContact, confirmAlert, cancelAlert;

@synthesize contactManager;

- (id)initWithContactManager:(ContactManager *)aManager
{
    self = [super init];
    if (self) {
        contactManager = aManager;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Do any additional setup after loading the view from its nib.
    self.title = @"Add contact";
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

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

-(void)setName:(NSString *)operandName
{
	//	name = operandName;
}

-(IBAction)saveNewContact:(id)sender
{	
	
	if ([nameContact.text length] == 0) {
		
		NSString *alertMessage = [NSString stringWithFormat:@"Choose a name for your RescueMe contact"];
		
		confirmAlert = [[UIAlertView alloc] initWithTitle:@"Add new contact" message:alertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
				
		}
	
	else if([phoneContact.text length] == 0){
	
		NSString *alertMessage = [NSString stringWithFormat:@"Choose a phone number for your RescueMe contact"];
		
		confirmAlert = [[UIAlertView alloc] initWithTitle:@"Add new contact" message:alertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	}
	
	else if(![emailContact.text isEqualToString:@""] ){
			
			NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
			NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
			
			//no Valid email address
			if ([emailTest evaluateWithObject:emailContact.text] == NO) 
			{
				NSString *alertMessage = [NSString stringWithFormat:@"Choose a correct e-mail for your RescueMe contact"];
				
				confirmAlert = [[UIAlertView alloc] initWithTitle:@"Add new contact" message:alertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
				
			}
			//Valid email address
			else {
				NSString *alertMessage = [NSString stringWithFormat:@"Do you want to add %@ as a RescueMe contact?", nameContact.text];
				
				confirmAlert = [[UIAlertView alloc] initWithTitle:@"Add new contact" message:alertMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
			}

	}
	
	else {
		NSString *alertMessage = [NSString stringWithFormat:@"Do you want to add %@ as a RescueMe contact?", nameContact.text];
		
		confirmAlert = [[UIAlertView alloc] initWithTitle:@"Add new contact" message:alertMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
	}

    [confirmAlert show];
    //[confirmAlert release];
}

-(IBAction)cancelAdding:(id)sender
{
    NSString *alertMessage = @"Do you want to cancel this action?";
    
    cancelAlert = [[UIAlertView alloc] initWithTitle:@"Cancel this action" message:alertMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    
    [cancelAlert show];
    //[cancelAlert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if(alertView == cancelAlert){
        if (buttonIndex == 1) {
            //NSLog(@"OK");
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            //NSLog(@"Cancel");
        }
    }else
        if(alertView == confirmAlert){
            if (buttonIndex == 1) {
                //NSLog(@"OK");
                if([contactManager contactAlreadyExists:nameContact.text]){
                    UIAlertView *existsAlert = [[UIAlertView alloc] initWithTitle:@"Contact already exists" message:@"This contact already exists" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
                    [existsAlert show];
  //                  [existsAlert release];
                }else{
                    [contactManager addContactWithName:nameContact.text andPhone:phoneContact.text andEmail:emailContact.text andFacebookID:@"0" andTwitterID:@""];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            } else {
                //NSLog(@"Cancel");
            }
        }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

-(BOOL) textField: (UITextField*)textField shouldChangeCharactersInRange:(NSRange) range replacementString:(NSString*) string 
{
	NSInteger len = [textField.text length];
	if ( len >= 40 && ![string isEqualToString:@""])
	{
		[textField resignFirstResponder];
		return NO;
	}
	return YES;
}


@end

