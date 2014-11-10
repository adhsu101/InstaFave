//
//  ViewController.m
//  InstaFave
//
//  Created by Mobile Making on 11/8/14.
//  Copyright (c) 2014 Alex Hsu. All rights reserved.
//

#import "FavoritesViewController.h"
#import "SearchViewController.h"
#import "CustomCollectionViewCell.h"

@import MapKit;

@interface FavoritesViewController () <UICollectionViewDelegate, UICollectionViewDataSource, MKMapViewDelegate, UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property NSMutableArray *favInstagramDictionaries;

@end

@implementation FavoritesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.favInstagramDictionaries = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self load];
    [self.collectionView reloadData];
}

#pragma mark - Collection View delegate methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.favInstagramDictionaries.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *instagramDictionary = self.favInstagramDictionaries[indexPath.item];
    UIImage *image = [UIImage imageWithData:instagramDictionary[@"imageData"]];
    cell.imageView.image = image;
    [cell.starView setHidden:YES];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *instagramDict = self.favInstagramDictionaries[indexPath.item];
    [self.favInstagramDictionaries removeObject:instagramDict];
    [self save];
    [self.collectionView reloadData];
    
}

#pragma mark - IBActions

- (IBAction)onSegmentedControlChanged:(UISegmentedControl *)sender
{

    switch (sender.selectedSegmentIndex)
    {
        case 0:
        {
            [UIView transitionFromView:self.mapView
                                toView:self.collectionView duration:0.5
                               options:(UIViewAnimationOptionTransitionFlipFromLeft | UIViewAnimationOptionShowHideTransitionViews)
                            completion:^(BOOL finished) {
                                nil;
                            }];
        }
            break;
        case 1:
        {
            [UIView transitionFromView:self.collectionView
                                toView:self.mapView
                              duration:0.5 options:UIViewAnimationOptionTransitionFlipFromRight | UIViewAnimationOptionShowHideTransitionViews
                            completion:^(BOOL finished) {
                                nil;
                            }];
        }
            break;
        default: 
            break; 
    }
    
}

- (IBAction)onCellLongPressed:(UILongPressGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    
    UIImage *selectedImage = [UIImage imageWithData:[self.favInstagramDictionaries[indexPath.row] objectForKey:@"imageData"]];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[selectedImage] applicationActivities:nil];
//    UIActionSheet *shareSheet = [[UIActionSheet alloc] initWithTitle:@"Share this photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Tweet", @"Email", nil];
//    [shareSheet showInView:self.view];
    [self presentViewController:activityVC animated:YES completion:nil];
}

#pragma mark - helper methods

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
