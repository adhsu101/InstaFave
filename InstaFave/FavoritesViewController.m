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

@interface FavoritesViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MKMapViewDelegate, UIActionSheetDelegate>
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
    [self addAnnotationsToMapView];
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
    [self removeAnnotation:instagramDict];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGSize cellSize = CGSizeMake(screenWidth, screenWidth);

    return cellSize;
}

#pragma mark - map view delegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoDark];

    return pin;
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

- (void)addAnnotationsToMapView
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    for (NSDictionary *favDict in self.favInstagramDictionaries)
    {
        double latitude = [favDict[@"latitude"] doubleValue];
        double longitude = [favDict[@"longitude"] doubleValue];
        
        if (latitude != 0.0 || longitude != 0.0)
        {
            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(latitude, longitude);
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.coordinate = coord;
            annotation.subtitle = favDict[@"username"];
            [self.mapView addAnnotation:annotation];
        }
    }
//    [self frameAnnotations];
}

- (void)removeAnnotation:(NSDictionary *)instagramDict
{
    for (MKPointAnnotation *annotation in [self.mapView annotations])
    {
        if (annotation.coordinate.latitude == [instagramDict[@"latitude"] doubleValue] && annotation.coordinate.longitude == [instagramDict[@"longitude"] doubleValue])
        {
            [self.mapView removeAnnotation:annotation];
            break;
        }
    }
}

@end
