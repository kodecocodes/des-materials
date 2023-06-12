//
//  NSDictionary+YLPUtils.m
//  YelpAPI
//
//  Created by Steven Sheldon on 11/17/16.
//
//

#import "YLPResponsePrivate.h"

@implementation NSDictionary (YLPUtils)

- (id)ylp_objectMaybeNullForKey:(id)key {
    id obj = self[key];
    if ([obj isEqual:[NSNull null]]) {
        return nil;
    }
    return obj;
}

@end
