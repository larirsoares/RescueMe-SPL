//
//  ImportContactViewController.h
//  RescueMe-SPL-Project
//
//  Created by Tassio Vale on 11/25/12.
//
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <CoreData/CoreData.h>
#import "ContactManager.h"
#import "Contact.h"

#ifdef FACEBOOK_IMPORT
    #import <FacebookSDK/FacebookSDK.h>

#endif
typedef enum {FACEBOOK,TWITTER,PHONEBOOK,NONE} CurrentPage;

#ifdef FACEBOOK_IMPORT
@interface ImportContactViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate,UIAlertViewDelegate,FBFriendPickerDelegate>
#else
@interface ImportContactViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate,UIAlertViewDelegate>
#endif
{
	@private
	NSString *contactName;
	NSString *phone;
	NSString *email;
    NSString *facebookId;
    CurrentPage page;
    
}

@property (nonatomic, retain) ContactManager *contactManager;
@property (nonatomic, retain) UIAlertView *alert;

- (id)initWithContactManager:(ContactManager *)aManager;
-(void)showAlertWithContactName:(NSString *)aName;
-(IBAction)phoneImport:(id)sender;
-(IBAction)facebookImport:(id)sender;
-(IBAction)twitterImport:(id)sender;

@end
