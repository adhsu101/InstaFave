//
//  SearchViewController.m
//  InstaFave
//
//  Created by Mobile Making on 11/8/14.
//  Copyright (c) 2014 Alex Hsu. All rights reserved.
//

#import "SearchViewController.h"
#import "CustomCollectionViewCell.h"
#import "InstagramObject.h"
#define kURL @"https://api.instagram.com/v1/media/popular?client_id=1e046625455d45bd80b2d2dbcf414d69"
#define kTagURL @"https://api.instagram.com/v1/tags/snow/media/recent?access_token=793661.1e04662.d098f8d039df4d0f94962c5846ab97e4"
#define kUserMediaURL @"https://api.instagram.com/v1/users/489110643/media/recent/?client_id=1e046625455d45bd80b2d2dbcf414d69"
#define kUserSearch @"https://api.instagram.com/v1/users/search?q=jack&access_token=ACCESS-TOKEN"

@interface SearchViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UITextField *searchField;
@property NSDictionary *instagramDictionaries;
@property NSMutableArray *instagramObjects;
@property NSMutableArray *favInstagramObjects;

@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.favInstagramObjects = [NSMutableArray array];
    [self loadJSONData];
}

#pragma mark - Collection View delegates

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.instagramDictionaries.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    InstagramObject *instagramObject = self.instagramObjects[indexPath.item];
    UIImage *image = [UIImage imageWithData:instagramObject.imageData];
    cell.imageView.image = image;
    
    if (instagramObject.isFavorite == NO)
    {
        [cell.starView setHidden:YES];
    }
    else
    {
        [cell.starView setHidden:NO];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    InstagramObject *instagramObject = self.instagramObjects[indexPath.item];
    CustomCollectionViewCell *cell = (CustomCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    instagramObject.isFavorite = !instagramObject.isFavorite;
    [cell.starView setHidden:!cell.starView.isHidden];
    
    if ([self.favInstagramObjects containsObject:instagramObject])
    {
        [self.favInstagramObjects removeObject:instagramObject];
    }
    else
    {
        [self.favInstagramObjects addObject:instagramObject];
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
    
    NSURL *url = [NSURL URLWithString:kUserMediaURL];
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
            self.instagramDictionaries = jsonData[@"data"];
            [self processDictionaries];
            [self.collectionView reloadData];
        }
    }];
}

- (void)processDictionaries
{
    self.instagramObjects = [NSMutableArray array];
    
    for (NSDictionary *instagramDict in self.instagramDictionaries)
    {
        InstagramObject *instagramObject = [[InstagramObject alloc] initWithDict:instagramDict];
        [self.instagramObjects addObject:instagramObject];
    }
    
}

@end
