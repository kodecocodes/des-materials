//
//  YLPBusinessReviews.m
//  YelpAPI
//
//  Created by Steven Sheldon on 10/21/16.
//
//

#import "YLPBusinessReviews.h"
#import "YLPResponsePrivate.h"

@implementation YLPBusinessReviews

- (instancetype)initWithDictionary:(NSDictionary *)reviewsDict {
    if (self = [super init]) {
        _total = [reviewsDict[@"total"] unsignedIntegerValue];
        _reviews = [self.class reviewsFromJSONArray:reviewsDict[@"reviews"]];
    }
    return self;
}

+ (NSArray *)reviewsFromJSONArray:(NSArray *)reviewsJSON {
    NSMutableArray<YLPReview *> *reviews = [[NSMutableArray alloc] init];
    for (NSDictionary *review in reviewsJSON) {
        [reviews addObject:[[YLPReview alloc] initWithDictionary:review]];
    }
    return reviews;
}

@end
