//
//  YLPCoordinate.m
//  Pods
//
//  Created by David Chen on 1/13/16.
//
//

#import "YLPCoordinate.h"

@implementation YLPCoordinate
- (instancetype)initWithLatitude:(double)latitude longitude:(double)longitude {
    if (self = [super init]) {
        _latitude = latitude;
        _longitude = longitude;
    }
    return self;
}


- (NSString *)description {
    return [NSString stringWithFormat:@"%f,%f", self.latitude, self.longitude];
}
@end
