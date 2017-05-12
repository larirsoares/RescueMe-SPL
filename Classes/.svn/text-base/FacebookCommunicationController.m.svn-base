//
//  FacebookCommunicationController.m
//  RescueMe-SPL
//
//  Created by Bruno Cabral on 4/17/13.
//
//

#import "FacebookCommunicationController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "XMPP.h"
#import "RescueMe_SPLViewController.h"

#define FACEBOOK_APP_ID @"370546396320150"

@implementation FacebookCommunicationController


- (id)init
{
    self = [super init];
    if(self) {
        //init here
    }
    return self;
}

- (void) connect
{
        
    // it is also possible to use init, but then we need to also set xmppStream.appId and xmppStream.hostName
	xmppStream = [[XMPPStream alloc] initWithFacebookAppId:FACEBOOK_APP_ID];
	
	[xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    
    if (!FBSession.activeSession.isOpen) {
        // if the session is closed, then we open it here, and establish a handler for state changes
        //BIG problem ! We dont have an active session
        printf("We dont have an active facebook session");
        
        NSArray *permissions =  [NSArray arrayWithObjects:@"xmpp_login", nil];
        
        /*
         [FBSession.activeSession openWithCompletionHandler:^(FBSession *session,
         FBSessionState state,
         NSError *error) {
         */
        [FBSession openActiveSessionWithReadPermissions:permissions
                                           allowLoginUI:NO completionHandler:^(FBSession *session,
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
                                                       break;
                                               }
                                           }];
        //Now connect
        NSError *error = nil;
        if (![xmppStream connect:&error])
        {
            printf("Facebook connect failed");
            //self.viewController.statusLabel.text = @"XMPP connect failed";
        }
    }
    else
    {
        //We logged in !
        NSError *error = nil;
        if (![xmppStream connect:&error])
        {
            printf("Facebook connect failed");
            //self.viewController.statusLabel.text = @"XMPP connect failed";
        }
    }

    
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPStream Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
	
    if (![xmppStream isSecure])
    {
        printf("Facebook connecting ...");
        NSError *error = nil;
        BOOL result = [xmppStream secureConnection:&error];
        
        if (result == NO)
        {
            printf("Facebook connecting failed");
        }
    }
    else
    {
        printf("Facebook connecting secure ...");
        NSError *error = nil;
        BOOL result = [xmppStream authenticateWithFacebookAccessToken:FBSession.activeSession.accessToken error:&error];
        
        if (result == NO)
        {
           printf("Facebook auth failed");
        }
    }
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
	printf("Facebook connected secure...");
}


- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
	//printf("Facebook authenticated !\n");
    NSMutableArray* contacts = [[[ContactManager alloc] init] getAllFacebookIDs];
    
    for(NSString* facebookid in contacts) {
        [self sendMessageToFacebook:[RescueMe_SPLViewController getRescueMessage] withFriendFacebookID:facebookid];
        printf("Message sent!\n");
    }
    
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
	printf("Facebook auth failed");
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
	printf("Facebook disconnected");
}

//Send a message
- (void)sendMessageToFacebook:(NSString*)textMessage withFriendFacebookID:(NSString*)friendID {
    
    if([textMessage length] > 0) {
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:textMessage];
        
        NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
        [message addAttributeWithName:@"xmlns" stringValue:@"http://www.facebook.com/xmpp/messages"];
        [message addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"-%@@chat.facebook.com",friendID]];
        [message addChild:body];
        [xmppStream sendElement:message];
    }
}




@end
