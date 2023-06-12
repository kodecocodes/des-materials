//
//  YLPUser.m
//  Pods
//
//  Created by David Chen on 1/13/16.
//
//

#import "YLPUser.h"
#import "YLPResponsePrivate.h"

@implementation YLPUser

- (instancetype)initWithDictionary:(NSDictionary *)userDict {
    if (self = [super init]) {
        _name = userDict[@"name"];
        NSString *imageURLString = [userDict ylp_objectMaybeNullForKey:@"image_url"];
        _imageURL = imageURLString ? [NSURL URLWithString:imageURLString] : nil;
    }
    return self;
}

@end
