//
//  YLPClient+PhoneSearch.m
//  Pods
//
//  Created by David Chen on 1/19/16.
//
//

#import "YLPClient+PhoneSearch.h"
#import "YLPClientPrivate.h"
#import "YLPResponsePrivate.h"
#import "YLPSearch.h"


@implementation YLPClient (PhoneSearch)

- (NSURLRequest *)businessRequestWithParams:(NSDictionary *)params {
    NSString *phoneSearchPath = @"/v3/businesses/search/phone";
    return [self requestWithPath:phoneSearchPath params:params];
}

- (void)businessWithPhoneNumber:(NSString *)phoneNumber
              completionHandler:(YLPPhoneSearchCompletionHandler)completionHandler {
    NSDictionary *params = @{@"phone": phoneNumber};
    NSURLRequest *req = [self businessRequestWithParams:params];
    
    [self queryWithRequest:req completionHandler:^(NSDictionary *responseDict, NSError *error) {
        if (error) {
            completionHandler(nil, error);
        } else {
            YLPSearch *search = [[YLPSearch alloc] initWithDictionary:responseDict];
            completionHandler(search, nil);
        }
    }];
}

@end
