//
//  YLPLocation.m
//  Pods
//
//  Created by David Chen on 1/12/16.
//
//

#import "YLPLocation.h"
#import "YLPCoordinate.h"
#import "YLPResponsePrivate.h"

@implementation YLPLocation

- (instancetype)initWithDictionary:(NSDictionary *)location coordinate:(YLPCoordinate *)coordinate {
    if (self = [super init]) {
        _city = location[@"city"];
        _stateCode = location[@"state"];
        _postalCode = location[@"zip_code"];
        _countryCode = location[@"country"];
        
        NSMutableArray *address = [NSMutableArray array];
        for (NSString *addressKey in @[@"address1", @"address2", @"address3"]) {
            NSString *addressLine = [location ylp_objectMaybeNullForKey:addressKey];
            // Skip empty lines
            if (addressLine.length > 0) {
                [address addObject:addressLine];
            }
        }
        _address = address;

        _coordinate = coordinate;
    }
    
    return self;
}

@end
