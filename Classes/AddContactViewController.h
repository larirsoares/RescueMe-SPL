//
//  AddContactViewController.h
//  RescueMe-SPL-Project
//
//  Created by Tassio Vale on 11/25/12.
//
//

#import <UIKit/UIKit.h>
#import "ContactManager.h"


@interface AddContactViewController : UIViewController <UITextFieldDelegate,UIAlertViewDelegate>;

@property (nonatomic, retain) IBOutlet UITextField *nameContact;
@property (nonatomic, retain) IBOutlet UITextField *emailContact;
@property (nonatomic, retain) IBOutlet UITextField *phoneContact;
@property (nonatomic, retain) ContactManager *contactManager;
@property (nonatomic, retain) UIAlertView *confirmAlert;
@property (nonatomic, retain) UIAlertView *cancelAlert;

-(IBAction) saveNewContact:(id)sender;
-(IBAction)cancelAdding:(id)sender;
-(void) setName:(NSString *)operandName;
-(BOOL) textFieldShouldReturn:(UITextField *)textField; 
-(BOOL) textField: (UITextField*)textField shouldChangeCharactersInRange:(NSRange) range replacementString:(NSString*) string;


- (id)initWithContactManager:(ContactManager *)aManager;

@end
