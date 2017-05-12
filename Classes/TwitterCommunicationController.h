//
//  TwitterCommunicationController.h
//  RescueMe-SPL
//
//  Created by Bruno Cabral on 4/29/13.
//
//

#import <Foundation/Foundation.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "ContactManager.h"
@interface TwitterCommunicationController : NSObject
-(void) sendToAllContacts;
@end
