//
//  Contact.h
//  RescueMe-SPL
//
//  Created by Loreno on 11/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Contact :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * facebookID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * twitterID;

@end



