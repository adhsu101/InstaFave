//
//  InstagramObject.m
//  PhotoFave
//
//  Created by Mobile Making on 11/8/14.
//  Copyright (c) 2014 Alex Hsu. All rights reserved.
//

#import "InstagramObject.h"

@implementation InstagramObject

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    
    // extract image
    
    NSDictionary *imagesDict = dict[@"images"];
    NSDictionary *standardResDict = imagesDict[@"standard_resolution"];
    NSString *urlString = standardResDict[@"url"];
    NSURL *url = [NSURL URLWithString:urlString];
    self.imageData = [NSData dataWithContentsOfURL:url];
    
//    self = [self initWithObjects:@[[NSData dataWithContentsOfURL:url]] forKeys:@[@"imageData"]];
    
//    @property BOOL isFavorite;
//    @property NSArray *tags;
    
    return self;
}

@end
