//
//  YLPLocation.h
//  Pods
//
//  Created by David Chen on 1/12/16.
//
//

#import <Foundation/Foundation.h>

@class YLPCoordinate;

NS_ASSUME_NONNULL_BEGIN

@interface YLPLocation : NSObject

@property (nonatomic, readonly, copy) NSString *city;
@property (nonatomic, readonly, copy) NSString *stateCode;
@property (nonatomic, readonly, copy) NSString *postalCode;
@property (nonatomic, readonly, copy) NSString *countryCode;

@property (nonatomic, readonly, copy) NSArray<NSString *> *address;

@property (nonatomic, readonly, nullable) YLPCoordinate *coordinate;

@end

NS_ASSUME_NONNULL_END
