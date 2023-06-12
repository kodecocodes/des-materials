//
//  YLPClient.m
//  Pods
//
//  Created by David Chen on 12/7/15.
//
//

#import <Foundation/Foundation.h>
#import "YLPClient.h"
#import "YLPClientPrivate.h"

NSString *const kYLPAPIHost = @"api.yelp.com";
NSString *const kYLPErrorDomain = @"com.yelp.YelpAPI.ErrorDomain";

@interface YLPClient ()
@property (strong, nonatomic) NSString *APIKey;
@end

@implementation YLPClient

- (instancetype)init {
    return nil;
}

- (instancetype)initWithAPIKey:(NSString *)APIKey {
    if (self = [super init]) {
        _APIKey = APIKey;
    }
    return self;
}

- (NSURLRequest *)requestWithPath:(NSString *)path {
    return [self requestWithPath:path params:nil];
}

- (NSURLRequest *)requestWithPath:(NSString *)path params:(NSDictionary *)params {
    NSURLComponents *urlComponents = [[NSURLComponents alloc] init];
    urlComponents.scheme = @"https";
    urlComponents.host = kYLPAPIHost;
    urlComponents.path = path;

    NSArray *queryItems = [YLPClient queryItemsForParams:params];
    if (queryItems.count > 0) {
        urlComponents.queryItems = queryItems;
    }

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:urlComponents.URL];
    request.HTTPMethod = @"GET";
    NSString *authHeader = [NSString stringWithFormat:@"Bearer %@", self.APIKey];
    [request setValue:authHeader forHTTPHeaderField:@"Authorization"];

    return request;
}

- (void)queryWithRequest:(NSURLRequest *)request
       completionHandler:(void (^)(NSDictionary *jsonResponse, NSError *error))completionHandler {
    [YLPClient queryWithRequest:request completionHandler:completionHandler];
}

#pragma mark Request utilities

+ (void)queryWithRequest:(NSURLRequest *)request
       completionHandler:(void (^)(NSDictionary *jsonResponse, NSError *error))completionHandler {
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *responseJSON;
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        // This case handles cases where the request was processed by the API, thus
        // resulting in a JSON object being passed back into `data`.
        if (!error) {
            responseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        }
        
        if (!error && httpResponse.statusCode == 200) {
            completionHandler(responseJSON, nil);
        } else {
            // If a request fails due to systematic errors with the API then an NSError will be returned.
            error = error ? error : [NSError errorWithDomain:kYLPErrorDomain code:httpResponse.statusCode userInfo:responseJSON];
            completionHandler(nil, error);
        }
    }] resume];
}

+ (NSArray<NSURLQueryItem *> *)queryItemsForParams:(NSDictionary<NSString *, id> *)params {
    NSMutableArray *queryItems = [NSMutableArray array];
    for (NSString *name in params) {
        NSString *value = [params[name] description];
        NSURLQueryItem *queryItem = [NSURLQueryItem queryItemWithName:name value:value];
        [queryItems addObject:queryItem];
    }
    return queryItems;
}

@end
