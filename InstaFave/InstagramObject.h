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
@property BOOL isFavorite;
@property float longitude;
@property float latitude;
@property NSArray *tags;
@property NSString *photoID;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
