//
//  TwitterImportViewController.h
//  RescueMe-SPL
//
//  Created by Bruno Cabral on 4/29/13.
//
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "ContactManager.h"

@interface TwitterImportViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    __unsafe_unretained UITableView *_tableView;
    __unsafe_unretained UIActivityIndicatorView *_activityIndicatorView;
    
    NSMutableArray *_dataSource;
@private
	NSString *contactName;
    NSString *twitterId;
}

@property (nonatomic, unsafe_unretained) IBOutlet UITableView *tableView;
@property (nonatomic, unsafe_unretained) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, retain) UIAlertView *noAccountAlert;
@property (nonatomic, retain) UIAlertView *addContactAlert;
@property (nonatomic, retain) ContactManager *contactManager;
- (void) getFriends;
- (void) updateView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil contactManager:(ContactManager *)aManager;

@end
