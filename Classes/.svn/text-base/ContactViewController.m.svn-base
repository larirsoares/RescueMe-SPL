//
//  ContactViewController.m
//  RescueMe-SPL-Project
//
//  Created by Tassio Vale on 11/22/12.
//
//

#import "ContactViewController.h"
#import "AddContactViewController.h"
#import "ImportContactViewController.h" 
#import "DeleteButton.h"
#import <QuartzCore/QuartzCore.h>

@interface ContactViewController ()

@end

@implementation ContactViewController


@synthesize contactManager, deleteAlert;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Contacts", @"Contacts");
        self.tabBarItem.image = [UIImage imageNamed:@"rescue"];
        //self.tabBarItem.image = [UIImage imageNamed:@"gear"];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    contactManager = [[ContactManager alloc] init];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(viewAddContactScreen:)];
    self.navigationItem.leftBarButtonItem = addButton;
	
    UIBarButtonItem *importButton = [[UIBarButtonItem alloc] initWithTitle:@"Import" style:UIBarButtonItemStylePlain target:self action:@selector(viewImportContactScreen:)];
    self.navigationItem.rightBarButtonItem = importButton;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    UITableView *tableView = (UITableView *) self.view;
    [tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)viewAddContactScreen:(id)sender{
    //NSLog(@"viewAddContact");
    
    AddContactViewController *addContactViewController = [[AddContactViewController alloc] initWithContactManager:contactManager];
    
    [self.navigationController pushViewController:addContactViewController animated:YES];
}

-(IBAction)viewImportContactScreen:(id)sender{
    //NSLog(@"viewImportContact");
    
    ImportContactViewController *importContactViewController = [[ImportContactViewController alloc] initWithContactManager:contactManager];
    
    [self.navigationController pushViewController:importContactViewController animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [contactManager.contactsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    // Configure the cell...
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSMutableArray *list = [contactManager getAllContacts];
    
    if(list.count > (indexPath.row))
    {
	Contact *contact = [list objectAtIndex:indexPath.row];
    
	//NSLog(@"Nome: %@",[contact name]);
    cell.textLabel.text = [contact name];
    
    //Close button
    //DeleteButton *deleteButton = [DeleteButton buttonWithType:UIButtonTypeRoundedRect];
    DeleteButton *deleteButton = [[DeleteButton alloc] init];
    deleteButton.frame = CGRectMake(0, 0, 80, 30);
    
    deleteButton.backgroundColor = [UIColor redColor];
    deleteButton.layer.borderColor = [UIColor blackColor].CGColor;
    deleteButton.layer.borderWidth = 0.5f;
    deleteButton.layer.cornerRadius = 10.0f;
        
    [deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(buttonDeletePressed:) forControlEvents:UIControlEventTouchUpInside];
    
    deleteButton.contact = contact;
    
    cell.accessoryView=deleteButton;
    }
    
    return cell;
}

-(void)buttonDeletePressed:(id)sender
{
    NSLog(@"Button delete pressed");
    DeleteButton *clicked = (DeleteButton *) sender;
    
    contactToDelete= clicked.contact;
    
    NSString *alertMessage = @"Do you really want to delete this contact?";
    
    deleteAlert = [[UIAlertView alloc] initWithTitle:@"Confirm delete" message:alertMessage delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
    
    [deleteAlert show];
    
    

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if(alertView == deleteAlert){
        if (buttonIndex == 1) {
            //NSLog(@"OK");
            [contactManager removeContact:contactToDelete];
            
            //Reload data afeter delete
            UITableView *tableView = (UITableView *) self.view;
            [tableView reloadData];
        } else {
            //NSLog(@"Cancel");
        }
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"didSelectRowAtIndexPath");

}

@end
