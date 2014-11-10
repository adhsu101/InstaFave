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
    
    // Configure the cell...
    
    return cell;
}

@end
