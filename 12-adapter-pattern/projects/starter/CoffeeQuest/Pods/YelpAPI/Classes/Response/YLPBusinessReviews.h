//
//  YLPBusinessReviews.h
//  YelpAPI
//
//  Created by Steven Sheldon on 10/21/16.
//
//

#import <Foundation/Foundation.h>

@class YLPReview;

NS_ASSUME_NONNULL_BEGIN

@interface YLPBusinessReviews : NSObject

@property (nonatomic, readonly) NSArray<YLPReview *> *reviews;
@property (nonatomic, readonly) NSUInteger total;

@end

NS_ASSUME_NONNULL_END
