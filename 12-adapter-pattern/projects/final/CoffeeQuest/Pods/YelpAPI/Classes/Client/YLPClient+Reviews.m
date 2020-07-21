//
//  YLPClient+Reviews.m
//  YelpAPI
//
//  Created by Steven Sheldon on 10/21/16.
//
//

#import "YLPClient+Reviews.h"
#import "YLPClientPrivate.h"
#import "YLPResponsePrivate.h"

@implementation YLPClient (Reviews)

- (void)reviewsForBusinessWithId:(NSString *)businessId
               completionHandler:(YLPReviewsCompletionHandler)completionHandler {
    [self reviewsForBusinessWithId:businessId locale:nil completionHandler:completionHandler];
}

- (void)reviewsForBusinessWithId:(NSString *)businessId
                          locale:(nullable NSString *)locale
               completionHandler:(YLPReviewsCompletionHandler)completionHandler {
    NSString *path = [NSString stringWithFormat:@"/v3/businesses/%@/reviews", businessId];
    NSDictionary *params = locale ? @{@"locale": locale} : @{};
    NSURLRequest *request = [self requestWithPath:path params:params];

    [self queryWithRequest:request completionHandler:^(NSDictionary *responseDict, NSError *error) {
        if (error) {
            completionHandler(nil, error);
        } else {
            YLPBusinessReviews *reviews = [[YLPBusinessReviews alloc] initWithDictionary:responseDict];
            completionHandler(reviews, nil);
        }
    }];
}

@end
