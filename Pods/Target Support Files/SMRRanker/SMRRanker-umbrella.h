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

#import "SMRRanker.h"
#import "SMRRankerAction.h"
#import "SMRRankerConfig.h"
#import "SMRRankerLifecycleManager.h"
#import "SMRRankerLogDelegate.h"
#import "SMRRankerManager.h"

FOUNDATION_EXPORT double SMRRankerVersionNumber;
FOUNDATION_EXPORT const unsigned char SMRRankerVersionString[];

