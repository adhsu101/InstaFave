//
//  UserTableViewController.m
//  PhotoFave
//
//  Created by Mobile Making on 11/9/14.
//  Copyright (c) 2014 Alex Hsu. All rights reserved.
//

#import "UserTableViewController.h"

@interface UserTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *users;

@end

@implementation UserTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.users = [NSMutableArray array];
    
    [self.tableView reloadData];
    
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.users.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *userDict = self.users[indexPath.row];
    cell.textLabel.text = userDict[@"full_name"];
    cell.detailTextLabel.text = userDict[@"username"];
    
    // extract profile picture
    
    NSString *urlString = userDict[@"profile_picture"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    cell.imageView.image = [UIImage imageWithData:imageData];
    
    return cell;
}

#pragma mark - helper methods

- (void)loadUserData:(NSString *)urlString
{
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError)
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Network Error" message:connectionError.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:okButton];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.users = jsonData[@"data"];
            [self.tableView reloadData];
        }
    }];
}

- (NSString *)getID
{
    NSDictionary *user = self.users[[self.tableView indexPathForSelectedRow].row];
    NSString *id = user[@"id"];
    
    return id;
}

@end
