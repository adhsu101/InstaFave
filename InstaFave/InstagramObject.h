//
//  InstagramObject.h
//  PhotoFave
//
//  Created by Mobile Making on 11/8/14.
//  Copyright (c) 2014 Alex Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreLocation;
@import MapKit;

@interface InstagramObject : NSObject

@property NSData *imageData;
@property NSString *username;
@property BOOL *isFavorite;
@property CLLocation *location;
@property MKMapItem *mapItem;
@property NSArray *tags;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
