//
//  SearchViewController.m
//  InstaFave
//
//  Created by Mobile Making on 11/8/14.
//  Copyright (c) 2014 Alex Hsu. All rights reserved.
//

#import "SearchViewController.h"
#import "CustomCollectionViewCell.h"

#define kURL @"https://api.instagram.com/v1/media/popular?client_id=1e046625455d45bd80b2d2dbcf414d69"
#define kTagURL @"https://api.instagram.com/v1/tags/snow/media/recent?access_token=793661.1e04662.d098f8d039df4d0f94962c5846ab97e4"
#define kUserMediaURL @"https://api.instagram.com/v1/users/215829852/media/recent/?client_id=1e046625455d45bd80b2d2dbcf414d69"
#define kUserSearch @"https://api.instagram.com/v1/users/search?q=jack&access_token=ACCESS-TOKEN"

@interface SearchViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, UITabBarControllerDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UITextField *searchField;
@property NSMutableArray *instagramDictionaries;
@property NSMutableArray *favInstagramDictionaries;

@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.favInstagramDictionaries = [NSMutableArray array];
    self.tabBarController.delegate = self;
    [self loadJSONData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self load];
}

#pragma mark - Tab Bar Controller delegate methods

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    
    [self save];
    
    return YES;
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
    
//    if (instagramObject.isFavorite == NO)
//    {
//        [cell.starView setHidden:YES];
//    }
//    else
//    {
//        [cell.starView setHidden:NO];
//    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *instagramDict = self.instagramDictionaries[indexPath.item];
    CustomCollectionViewCell *cell = (CustomCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    instagramObject.isFavorite = !instagramObject.isFavorite;
    [cell.starView setHidden:!cell.starView.isHidden];
    
    if ([self.favInstagramDictionaries containsObject:instagramDict])
    {
        [self.favInstagramDictionaries removeObject:instagramDict];
    }
    else
    {
        [self.favInstagramDictionaries addObject:instagramDict];
    }

}

#pragma mark - IBActions

- (IBAction)onSearchButtonTapped:(UIBarButtonItem *)sender
{

}

- (IBAction)onSegmentedControlValueChanged:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0)
    {
        NSLog(@"0");
    }
    else
    {
        NSLog(@"1");
    }
}


#pragma mark - helper methods

- (void)loadJSONData
{
    
    NSURL *url = [NSURL URLWithString:kURL];
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

@end
