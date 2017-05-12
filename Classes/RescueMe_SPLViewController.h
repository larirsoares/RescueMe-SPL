//
//  RescueMe_SPLViewController.h
//  RescueMe-SPL-Project
//
//  Created by Loreno on 13/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "ContactManager.h"
#import "Location.h"

#ifdef EMAIL_DESTINATION
#import <MessageUI/MFMailComposeViewController.h>
#endif

#ifdef FACEBOOK_IMPORT
#import "FacebookCommunicationController.h"
#endif

#ifdef TWITTER_IMPORT
#import "TwitterCommunicationController.h"
#endif

@interface RescueMe_SPLViewController : UIViewController <MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, CoreLocationControllerDelegate>

@property (nonatomic, retain) IBOutlet UIButton *redButton;
@property (nonatomic, retain) IBOutlet UIImageView *backGroundImageView;

#ifdef FACEBOOK_IMPORT
@property (readwrite, retain) id facebookController;
#endif

//property do location
@property (nonatomic, retain) Location *CLController; 
@property float latitudeLabel;
@property float longitudeLabel;

-(IBAction)redButtonPressed:(UIButton *)sender;

#ifdef EMAIL_DESTINATION
-(void)emailDestination;
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
#endif

-(void)SMSDestination;
+(NSString*)getRescueMessage;

@end

