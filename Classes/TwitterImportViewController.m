//
//  TwitterImportViewController.m
//  RescueMe-SPL
//
//  Created by Bruno Cabral on 4/29/13.
//
//

#import "TwitterImportViewController.h"


@implementation TwitterImportViewController
@synthesize tableView = _tableView, activityIndicatorView = _activityIndicatorView;
@synthesize dataSource = _dataSource;
@synthesize noAccountAlert;
@synthesize addContactAlert;
@synthesize contactManager;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil contactManager:(ContactManager *)aManager
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        contactManager = aManager;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataSource = [NSMutableArray arrayWithCapacity:100];
	// Do any additional setup after loading the view.
    [self getFriends];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Table View Data Source Methods
//Init table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dataSource) {
        return 1;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataSource) {
        return [self.dataSource count];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell Identifier";
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    
    NSDictionary *friend = [self.dataSource objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [friend objectForKey:@"name"];
    cell.imageView.image = [UIImage imageNamed:@"placeholder"];
    
    dispatch_queue_t queue = dispatch_queue_create("com.rise.task", NULL);
    dispatch_queue_t main = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        NSURL *imageURL = [NSURL URLWithString:[friend objectForKey:@"profile_image_url"]];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        dispatch_async(main, ^{
            cell.imageView.image = [UIImage imageWithData:imageData];
        });
    });
    
   //dispatch_release(queue);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *friend = [self.dataSource objectAtIndex:indexPath.row];
    NSString *alertMessage = [NSString stringWithFormat:@"Do you want to add %@ as a RescueMe contact?", [friend objectForKey:@"name"]];
    self->contactName = [friend objectForKey:@"name"];
    
    NSString *str;
    
    str = [NSString stringWithFormat:@"%d",[friend objectForKey:@"id"]];
    
    
    self->twitterId = str;
    
    addContactAlert = [[UIAlertView alloc] initWithTitle:@"Add new contact" message:alertMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    [addContactAlert show];
    
}


-(void) updateView{
    if (self.dataSource) {
        
        [self.tableView setHidden:NO];
        [self.activityIndicatorView stopAnimating];
        [self.tableView reloadData];
        
    } else {
        NSLog(@"Update without dataSOurce");
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if(alertView == noAccountAlert){
        [self.navigationController popViewControllerAnimated:YES];
    }else
        if(alertView == addContactAlert){
            if (buttonIndex == 1) {
                //NSLog(@"OK");
                if([contactManager contactAlreadyExists:contactName]){
                    UIAlertView *existsAlert = [[UIAlertView alloc] initWithTitle:@"Contact already exists" message:@"This contact already exists" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
                    [existsAlert show];
                    //                  [existsAlert release];
                }else{
                    [contactManager addContactWithName:contactName andPhone:@"" andEmail:@"" andFacebookID:@"0" andTwitterID:twitterId];
                    //[self.navigationController popViewControllerAnimated:YES];
                    //[self.navigationController popViewControllerAnimated:YES];
                    //[self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:2] animated:YES];
                    NSInteger noOfViewControllers = [self.navigationController.viewControllers count];
                    [self.navigationController
                     popToViewController:[self.navigationController.viewControllers
                                          objectAtIndex:(noOfViewControllers-3)] animated:YES];
                    
                }
                
            } else {
                //NSLog(@"Cancel");
            }
        }
}

- (void) getFriends{
    [self.tableView setHidden:YES];
    [self.activityIndicatorView startAnimating];
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
            
            if (accounts.count) {
                ACAccount *twitterAccount = [accounts objectAtIndex:0];
                
                NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/followers/list.json"];
                
                NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                [parameters setObject:@"20" forKey:@"count"];
                //[parameters setObject:@"1" forKey:@"include_entities"];
                
                TWRequest *request = [[TWRequest alloc] initWithURL:url parameters:parameters requestMethod:TWRequestMethodGET];
                [request setAccount:twitterAccount];
                
                [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    if (responseData) {
                        NSError *error = nil;
                        NSDictionary *friendsDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
                        
                        
                        if ([friendsDictionary valueForKey:@"users"]) {
                            [self.dataSource addObjectsFromArray:[friendsDictionary valueForKey:@"users"]];
                        }
                        
                        
                        
                        NSString *nextCursor = nil;
                        
                        if ([friendsDictionary valueForKey:@"next_cursor_str"]) {
                            nextCursor = [friendsDictionary valueForKey:@"next_cursor_str"];
                        }
                        
                        
                        
                        if (self.dataSource) {
                            dispatch_async(dispatch_get_main_queue(), ^(void) {
                                [self.tableView setHidden:NO];
                                [self.activityIndicatorView stopAnimating];
                                [self.tableView reloadData];
                                //[self updateView];
                            });
                            
                            
                        } else {
                            NSLog(@"Error %@ with user info %@.", error, error.userInfo);
                        }
                        
                    }
                }];
            }
            
        } else {
            //NSLog(@"The user does not grant us permission to access its Twitter account(s).");
            //[self.navigationController popViewControllerAnimated:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                noAccountAlert = [[UIAlertView alloc] initWithTitle:@"No Twitter Account Detected" message:@"Please go into your device's settings menu to add your Twitter account." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [noAccountAlert show];
                
            });

        }
    }];
}

@end
