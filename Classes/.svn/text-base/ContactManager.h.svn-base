//
//  ContactManager.h
//  RescueMe
//
//  Created by Tassio Vale on 11/30/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreData/CoreData.h>
#import "Contact.h"

@interface ContactManager : NSObject

@property (nonatomic,retain) NSMutableArray *contactsList;
@property (nonatomic, retain) NSMutableDictionary *namesInTheList;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSArray *sortDescriptors;

-(id)init;
-(NSMutableArray *)getAllContacts;
-(NSMutableArray *)getAllPhones;
-(NSMutableArray *)getAllEmails;
-(NSMutableArray *)getAllTwitterIDs;
-(NSMutableArray *)getAllFacebookIDs;
-(NSMutableArray *)getAllDataOf:(NSString *)aDataType;
-(BOOL)contactAlreadyExists:(NSString *)aName;
-(BOOL)addContactWithName:(NSString *)aName andPhone:(NSString *)aPhone andEmail:(NSString *)anEmail andFacebookID:(NSString *)aFacebookID andTwitterID:(NSString *)aTwitterID;
-(BOOL)removeContact:(Contact *)aContact;
-(BOOL)saveContact:(Contact *)aContact;
-(BOOL)deleteContact:(Contact *)aContact;
-(NSPersistentStoreCoordinator *) persistenceCoordinator;
- (NSURL *)applicationDocumentsDirectory;
- (NSManagedObjectModel *)managedObjectModel;


@end
