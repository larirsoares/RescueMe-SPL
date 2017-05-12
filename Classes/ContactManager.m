//
//  ContactManager.m
//  RescueMe
//
//  Created by Tassio Vale on 11/30/12.
//
//

#import "ContactManager.h"
#import "Contact.h"

@implementation ContactManager

@synthesize contactsList;
@synthesize managedObjectContext;
@synthesize sortDescriptors;
@synthesize namesInTheList;

-(id)init
{
    self = [super init];
    if (self) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:[self persistenceCoordinator]];
        
        namesInTheList = [[NSMutableDictionary alloc] init];
        contactsList = [self getAllContacts];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                            initWithKey:@"name" ascending:YES];
        sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    }
    return self;
}

-(NSMutableArray *)getAllContacts
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Contact"
                                              inManagedObjectContext:managedObjectContext];
    [request setSortDescriptors:sortDescriptors];
    [request setEntity:entity];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
        return [[NSMutableArray alloc] init];
    }else{
		for(Contact *c in mutableFetchResults){
            //			NSLog(@"Nome: %@", c.name);
            [namesInTheList setObject:c forKey:c.name];
        }
        return mutableFetchResults;
    }
}

-(BOOL)addContactWithName:(NSString *)aName andPhone:(NSString *)aPhone andEmail:(NSString *)anEmail andFacebookID:(NSString *)aFacebookID andTwitterID:(NSString *)aTwitterID
{
    Contact *contact = (Contact *)[NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:managedObjectContext];
    [contact setName:aName];
    [contact setPhone:aPhone];
    [contact setEmail:anEmail];
    [contact setFacebookID:aFacebookID];
    [contact setTwitterID:aTwitterID];
    
    [namesInTheList setValue:contact forKey:aName];
    return [self saveContact:contact];
}

-(BOOL)removeContact:(Contact *)aContact
{
    if(contactsList != nil){
        [self deleteContact:aContact];
        return YES;
    }
    return NO;
}

//Core data management

-(BOOL)contactAlreadyExists:(NSString *)aName
{
    if([namesInTheList valueForKey:aName] != nil)
        return YES;
    else
        return NO;
}

-(BOOL)saveContact:(Contact *)aContact
{
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        return NO;
    }else
        contactsList = [self getAllContacts];
    return YES;
}

-(BOOL)deleteContact:(Contact *)aContact
{
     NSError *error = nil;
    
    Contact *contact = (Contact *)[namesInTheList valueForKey:aContact.name];
    
    //Code to delete contact from core data.
    if(contact != nil){
        [namesInTheList removeObjectForKey:contact.name];
        [contactsList removeObject:contact];
        [managedObjectContext deleteObject:contact];
        [managedObjectContext save:&error];
        contactsList = [self getAllContacts];
        
    }

    
    

}

-(NSPersistentStoreCoordinator *)persistenceCoordinator
{
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ContactModel.sqlite"];
    
    NSError *error = nil;
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
	
    if (![coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
    }
    return coordinator;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel
{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ContactModel" withExtension:@"mom"];
    //NSLog(@"%@", modelURL);
    
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return managedObjectModel;
}

-(NSMutableArray *)getAllPhones{
    return [self getAllDataOf:@"phone"];
}

-(NSMutableArray *)getAllEmails{
    return [self getAllDataOf:@"email"];
}

-(NSMutableArray *)getAllTwitterIDs{
    return [self getAllDataOf:@"twitterID"];
}

-(NSMutableArray *)getAllFacebookIDs{
    return [self getAllDataOf:@"facebookID"];
}

-(NSMutableArray *)getAllDataOf:(NSString *)aDataType{
    NSMutableArray *array = [self getAllContacts];
    NSMutableArray *dataList = [[NSMutableArray alloc] init];
    
    int i, count = [array count];
    for (i=0; i < count; i++) {
        Contact *contact = [array objectAtIndex:i];
        
        //NSString *str = [[contact valueForKey:aDataType] copy];
        NSString* newstring = [[contact valueForKey:aDataType] copy];
        if(!newstring)
            continue;
        
        [dataList addObject:newstring];
    }
    return dataList;
}

@end
