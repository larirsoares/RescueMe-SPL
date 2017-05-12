//
//  FacebookCommunicationController.h
//  RescueMe-SPL
//
//  Created by Bruno Cabral on 4/17/13.
//
//
@class XMPPStream;
#import <Foundation/Foundation.h>
#ifdef FACEBOOK_IMPORT
#import <FacebookSDK/FacebookSDK.h>
#endif

#import "ContactManager.h"

@interface FacebookCommunicationController : NSObject <UIApplicationDelegate>
{
    XMPPStream *xmppStream;
}
- (void)sendMessageToFacebook:(NSString*)textMessage withFriendFacebookID:(NSString*)friendID;
- (void)connect;
@end
