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

@interface SearchViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UITextField *searchField;
@property NSDictionary *instagramDictionaries;
@property NSMutableArray *instagramObjects;

@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadJSONData];
}

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
    
    return cell;
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
