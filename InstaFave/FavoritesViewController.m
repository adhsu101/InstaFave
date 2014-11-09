//
//  ViewController.m
//  InstaFave
//
//  Created by Mobile Making on 11/8/14.
//  Copyright (c) 2014 Alex Hsu. All rights reserved.
//

#import "FavoritesViewController.h"

@interface FavoritesViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

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

@end
