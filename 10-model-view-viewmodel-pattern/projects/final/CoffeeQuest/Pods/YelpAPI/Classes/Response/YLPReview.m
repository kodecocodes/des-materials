//
//  YLPReview.m
//  Pods
//
//  Created by David Chen on 1/13/16.
//
//

#import "YLPReview.h"
#import "YLPUser.h"
#import "YLPResponsePrivate.h"

@implementation YLPReview

- (instancetype)initWithDictionary:(NSDictionary *)reviewDict {
    if (self = [super init]) {
        _rating = [reviewDict[@"rating"] doubleValue];
        _excerpt = reviewDict[@"text"];
        _timeCreated = [self.class dateFromTimestamp:reviewDict[@"time_created"]];
        _user = [[YLPUser alloc] initWithDictionary:reviewDict[@"user"]];
    }
    
    return self;
}

+ (NSDate *)dateFromTimestamp:(NSString *)timestamp {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd' 'HH:mm:ss";
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"PST"];
    });

    return [dateFormatter dateFromString:timestamp];
}

@end
