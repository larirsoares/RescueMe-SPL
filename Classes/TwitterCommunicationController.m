//
//  TwitterCommunicationController.m
//  RescueMe-SPL
//
//  Created by Bruno Cabral on 4/29/13.
//
//

#import "TwitterCommunicationController.h"
#import "RescueMe_SPLViewController.h"
@implementation TwitterCommunicationController

-(void) sendToAllContacts
{
    NSMutableArray* contacts = [[[ContactManager alloc] init] getAllTwitterIDs];
    
    for(NSString* twitterid in contacts) {
        [self sendTwitt:[RescueMe_SPLViewController getRescueMessage] andId:twitterid];
        printf("Message sent!\n");
    }
}


-(void) sendTwitt:(NSString*)text andId:(NSString*)id
{
    if ([TWTweetComposeViewController canSendTweet])
    {
        // Create account store, followed by a twitter account identifier
        // At this point, twitter is the only account type available
        ACAccountStore *account = [[ACAccountStore alloc] init];
        ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        // Request access from the user to access their Twitter account
        [account requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error)
         {
             // Did user allow us access?
             if (granted == YES)
             {
                 // Populate array with all available Twitter accounts
                 NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
                 
                 // Sanity check
                 if ([arrayOfAccounts count] > 0)
                 {
                     // Keep it simple, use the first account available
                     ACAccount *acct = [arrayOfAccounts objectAtIndex:0];
                     
                     // Build a twitter request
                     
                     NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                     [parameters setObject:id forKey:@"user_id"];
                     [parameters setObject:text forKey:@"text"];
                     
                     
                     TWRequest *postRequest = [[TWRequest alloc] initWithURL:
                                               [NSURL URLWithString:@"http://api.twitter.com/1/direct_messages/new.json"]
                                                                  parameters:parameters requestMethod:TWRequestMethodPOST];
                     
                     // Post the request
                     [postRequest setAccount:acct];
                     
                     // Block handler to manage the response
                     [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) 
                      {
                          NSLog(@"Twitter response, HTTP response: %i", [urlResponse statusCode]);
                      }];
                 }
             }
         }];
    }
}

@end
