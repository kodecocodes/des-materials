#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "YLPClient+Business.h"
#import "YLPClient+PhoneSearch.h"
#import "YLPClient+Reviews.h"
#import "YLPClient+Search.h"
#import "YLPClient.h"
#import "YLPCoordinate.h"
#import "YLPQuery.h"
#import "YLPSortType.h"
#import "YLPBusiness.h"
#import "YLPBusinessReviews.h"
#import "YLPCategory.h"
#import "YLPLocation.h"
#import "YLPReview.h"
#import "YLPSearch.h"
#import "YLPUser.h"
#import "YelpAPI.h"

FOUNDATION_EXPORT double YelpAPIVersionNumber;
FOUNDATION_EXPORT const unsigned char YelpAPIVersionString[];

