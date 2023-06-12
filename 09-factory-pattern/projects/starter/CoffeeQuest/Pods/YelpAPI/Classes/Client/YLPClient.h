//
//  YLPClient.h
//  Pods
//
//  Created by David Chen on 12/7/15.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const kYLPAPIHost;

@interface YLPClient : NSObject

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithAPIKey:(NSString *)APIKey;

@end

NS_ASSUME_NONNULL_END
