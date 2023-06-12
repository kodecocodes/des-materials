//
//  YLPReview.h
//  Pods
//
//  Created by David Chen on 1/13/16.
//
//

#import <Foundation/Foundation.h>

@class YLPUser;

NS_ASSUME_NONNULL_BEGIN

@interface YLPReview : NSObject

@property(nonatomic, readonly, copy) NSString *excerpt;

@property(nonatomic, readonly, copy) NSDate *timeCreated;

@property(nonatomic, readonly) double rating;

@property(nonatomic, readonly) YLPUser *user;

@end

NS_ASSUME_NONNULL_END
