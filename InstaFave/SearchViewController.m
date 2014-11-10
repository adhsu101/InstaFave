//
//  SearchViewController.m
//  InstaFave
//
//  Created by Mobile Making on 11/8/14.
//  Copyright (c) 2014 Alex Hsu. All rights reserved.
//

#import "SearchViewController.h"
#import "CustomCollectionViewCell.h"
#import "UserTableViewController.h"

#define kURL @"https://api.instagram.com/v1/media/popular?client_id=1e046625455d45bd80b2d2dbcf414d69"
#define kTagSearchURL @"https://api.instagram.com/v1/tags/%@/media/recent?access_token=793661.1e04662.d098f8d039df4d0f94962c5846ab97e4"
#define kUserMediaURL @"https://api.instagram.com/v1/users/%@/media/recent/?access_token=793661.1e04662.d098f8d039df4d0f94962c5846ab97e4"
#define kUserSearch @"https://api.instagram.com/v1/users/search?q=%@&access_token=793661.1e04662.d098f8d039df4d0f94962c5846ab97e4"


@interface SearchViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, UITabBarControllerDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIView *userContainerView;
@property UserTableViewController *userListVC;
@property (strong, nonatomic) IBOutlet UITextField *searchField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *searchTypeControl;
@property NSMutableArray *instagramDictionaries;
@property NSMutableArray *favInstagramDictionaries;

@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.favInstagramDictionaries = [NSMutableArray array];
    self.tabBarController.delegate = self;
    [self loadInstagramData:kURL];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self load];
    [self.collectionView reloadData];
}

#pragma mark - Collection View delegates

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.instagramDictionaries.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *instagramDictionary = self.instagramDictionaries[indexPath.item];
    UIImage *image = [UIImage imageWithData:instagramDictionary[@"imageData"]];
    cell.imageView.image = image;
    
    if ([self.favInstagramDictionaries containsObject:instagramDictionary])
    {
        [cell.starView setHidden:NO];
    }
    else
    {
        [cell.starView setHidden:YES];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *instagramDict = self.instagramDictionaries[indexPath.item];
    CustomCollectionViewCell *cell = (CustomCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell.starView setHidden:!cell.starView.isHidden];
    
    if ([self.favInstagramDictionaries containsObject:instagramDict])
    {
        [self.favInstagramDictionaries removeObject:instagramDict];
    }
    else
    {
        [self.favInstagramDictionaries addObject:instagramDict];
    }
    
    [self save];

}

#pragma mark - text field delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *searchString = [textField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    if (![searchString isEqualToString:@""])
    {

        NSString *urlString = [NSString string];
        if (self.searchTypeControl.selectedSegmentIndex == 0)
        {
            searchString = [searchString stringByReplacingOccurrencesOfString:@" " withString:@""];
            urlString = [NSString stringWithFormat:kTagSearchURL, searchString];
            [self loadInstagramData:urlString];
        }
        else
        {
            [self.collectionView setHidden:YES];
            [self.userContainerView setHidden:NO];

            searchString = [searchString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            urlString = [NSString stringWithFormat:kUserSearch, searchString];
            [self.userListVC loadUserData:urlString];
            
        }
    }
    
    [textField resignFirstResponder];
    return YES;
    
}

#pragma mark - IBActions

- (IBAction)onSearchButtonTapped:(UIBarButtonItem *)sender
{
    [self textFieldShouldReturn:self.searchField];
}

- (IBAction)onSegmentedControlTapped:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0)
    {
        [self.collectionView setHidden:NO];
        [self.userContainerView setHidden:YES];
    }
    else
    {
        [self.collectionView setHidden:YES];
        [self.userContainerView setHidden:NO];
    }
}

- (IBAction)unwindFromUserListSegue:(UIStoryboardSegue *)segue
{
    NSString *id = [self.userListVC getID];
    NSString *urlString = [NSString stringWithFormat:kUserMediaURL, id];
    [self loadInstagramData:urlString];
    [self.collectionView setHidden:NO];
    [self.userContainerView setHidden:YES];    
}

#pragma mark - helper methods

- (void)loadInstagramData:(NSString *)urlString
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
            NSArray *arrayOfRawInstagramDictionaries = jsonData[@"data"];
            [self processDictionaries:arrayOfRawInstagramDictionaries];
            [self.collectionView reloadData];
        }
    }];
}

- (void)processDictionaries:(NSArray *)arrayOfRawDictionaries
{
    self.instagramDictionaries = [NSMutableArray array];
    
    for (NSDictionary *instagramDict in arrayOfRawDictionaries)
    {
        // extract id
        NSString *id = instagramDict[@"id"];
        
        // extract username
        NSDictionary *user = instagramDict[@"user"];
        NSString *username = user[@"username"];
        
        // extract image
        NSDictionary *imagesDict = instagramDict[@"images"];
        NSDictionary *standardResDict = imagesDict[@"standard_resolution"];
        NSString *urlString = standardResDict[@"url"];
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        
        // extract location data
        float latitude = 0.0;
        float longitude = 0.0;
        if (instagramDict[@"location"] != [NSNull null])
        {
            NSDictionary *location = instagramDict[@"location"];
            latitude = [location[@"latitude"] floatValue];
            longitude = [location[@"longitude"] floatValue];
        }

        // create simplified dictionary
        NSDictionary *processedDict = [[NSDictionary alloc] initWithObjects:@[id, username, imageData, [NSString stringWithFormat:@"%f", latitude], [NSString stringWithFormat:@"%f", longitude]] forKeys:@[@"id", @"username", @"imageData", @"latitude", @"longitude"]];
        [self.instagramDictionaries addObject:processedDict];
    }
    
}

- (void)save
{
    NSURL *plistURL = [[self documentsDirectoryURL]URLByAppendingPathComponent:@"faves.plist"];
    [self.favInstagramDictionaries writeToURL:plistURL atomically:YES];

}

- (void)load
{
    NSURL *plistURL = [[self documentsDirectoryURL]URLByAppendingPathComponent:@"faves.plist"];
    self.favInstagramDictionaries = [NSMutableArray arrayWithContentsOfURL:plistURL];
    if (self.favInstagramDictionaries == nil)
    {
        self.favInstagramDictionaries = [NSMutableArray array];
    }
}

- (NSURL *)documentsDirectoryURL
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *url = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
    return url;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.userListVC = segue.destinationViewController;
}

@end
