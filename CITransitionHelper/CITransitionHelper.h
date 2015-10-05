//
//  CITransitionHelper.h
//
//  Copyright (c) 2013 Shuichi Tsutsumi. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    kCITransitionTypeCopyMachine,
    kCITransitionTypeDisintegrateWithMask,
    kCITransitionTypeDissolve,
    kCITransitionTypeFlash,
    kCITransitionTypeMod,
    kCITransitionTypeSwipe,
    kCITransitionTypePageCurl,
    kCITransitionTypePageCurlWithShadow,
    kCITransitionTypeRipple,

    // --- not supported ----
    kCITransitionTypeBarSwipe,
} CITransitionType;


@interface CITransitionHelper : NSObject

+ (CIFilter *)transitionWithType:(CITransitionType)type
                          extent:(CIVector *)extent;

+ (CIFilter *)transitionWithType:(CITransitionType)type
                          extent:(CIVector *)extent
                     optionImage:(CIImage *)optionImage;

@end
