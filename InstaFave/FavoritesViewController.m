//
//  ViewController.m
//  InstaFave
//
//  Created by Mobile Making on 11/8/14.
//  Copyright (c) 2014 Alex Hsu. All rights reserved.
//

#import "FavoritesViewController.h"

@import MapKit;

@interface FavoritesViewController () <UICollectionViewDelegate, UICollectionViewDataSource, MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation FavoritesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - IBActions

- (IBAction)onSegmentedControlChanged:(UISegmentedControl *)sender
{

    switch (self.segmentedControl.selectedSegmentIndex)
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

@end
