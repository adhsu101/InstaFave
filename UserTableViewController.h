//
//  UserTableViewController.h
//  PhotoFave
//
//  Created by Mobile Making on 11/9/14.
//  Copyright (c) 2014 Alex Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserTableViewController : UIViewController

- (void)loadUserData:(NSString *)urlString;
- (NSString *)getID;

@end
