//
//  CITransitionHelper.m
//
//  Copyright (c) 2013 Shuichi Tsutsumi. All rights reserved.
//

#import "CITransitionHelper.h"

@implementation CITransitionHelper

+ (CIFilter *)transitionWithType:(CITransitionType)type extent:(CIVector *)extent {
    
    return [CITransitionHelper transitionWithType:type
                                           extent:extent
                                      optionImage:nil];
}

+ (CIFilter *)transitionWithType:(CITransitionType)type extent:(CIVector *)extent optionImage:(CIImage *)optionImage
{
    CIFilter *transition;
    
    switch (type) {
            
        case kCITransitionTypeDissolve:
        default:
        {
            transition = [CIFilter filterWithName: @"CIDissolveTransition"];
            
            break;
        }
        case kCITransitionTypeCopyMachine:
        {
            transition = [CIFilter filterWithName:@"CICopyMachineTransition"
                                    keysAndValues:
                          kCIInputExtentKey, extent,
                          kCIInputColorKey, [CIColor colorWithRed:.6 green:1 blue:.8 alpha:1],
                          kCIInputAngleKey, @0.0,
                          kCIInputWidthKey, @40.0,
                          @"inputOpacity", @1.0,
                          nil];
            
            break;
        }
        case kCITransitionTypeDisintegrateWithMask:
        {
            NSAssert(optionImage, @"no maskImage");
            transition = [CIFilter filterWithName: @"CIDisintegrateWithMaskTransition"
                                    keysAndValues:
                          kCIInputMaskImageKey, optionImage,
                          @"inputShadowRadius", @10.0,
                          @"inputShadowDensity", @0.7,
                          @"inputShadowOffset", [CIVector vectorWithX:0.0  Y:-0.05 * extent.CGRectValue.size.height],
                          nil];
            
            break;
        }
        case kCITransitionTypeFlash:
        {
            transition = [CIFilter filterWithName: @"CIFlashTransition"
                                    keysAndValues: @"inputExtent", extent,
                          kCIInputCenterKey,[CIVector vectorWithX:0.3*extent.CGRectValue.size.width
                                                                Y:0.7*extent.CGRectValue.size.height],
                          kCIInputColorKey, [CIColor colorWithRed:1.0 green:0.8 blue:0.6 alpha:1],
                          @"inputMaxStriationRadius", @2.5,
                          @"inputStriationStrength", @0.5,
                          @"inputStriationContrast", @1.37,
                          @"inputFadeThreshold", @0.85,
                          nil];
            
            break;
        }
        case kCITransitionTypeMod:
        {
            transition = [CIFilter filterWithName: @"CIModTransition"
                                    keysAndValues:
                          kCIInputCenterKey,[CIVector vectorWithX:0.5*extent.CGRectValue.size.width
                                                                Y:0.5*extent.CGRectValue.size.height],
                          kCIInputAngleKey, @(M_PI*0.1),
                          kCIInputRadiusKey, @30.0,
                          @"inputCompression", @10.0,
                          nil];
            
            break;
        }
        case kCITransitionTypeSwipe:
        {
            transition = [CIFilter filterWithName:@"CISwipeTransition"
                                    keysAndValues:
                          kCIInputExtentKey, extent,
                          kCIInputColorKey, [CIColor colorWithRed:0 green:0 blue:0 alpha:0],
                          kCIInputAngleKey, @(0.3 * M_PI),
                          kCIInputWidthKey, @80.0,
                          @"inputOpacity", @0.0,
                          nil];
            
            break;
        }
        case kCITransitionTypePageCurl:
        {
            NSAssert(optionImage, @"no shadingImage");
            transition = [CIFilter filterWithName: @"CIPageCurlTransition"
                                    keysAndValues:
                          kCIInputShadingImageKey, optionImage,
                          kCIInputAngleKey, @(-M_PI*0.25),
                          nil];
            
            break;
        }
        case kCITransitionTypePageCurlWithShadow:
        {
            transition = [CIFilter filterWithName: @"CIPageCurlWithShadowTransition"
                                    keysAndValues:
                          kCIInputAngleKey, @(-M_PI*0.25),
                          nil];
            
            break;
        }
        case kCITransitionTypeRipple:
        {
            NSAssert(optionImage, @"no shadingImage");
            transition = [CIFilter filterWithName: @"CIRippleTransition"
                                    keysAndValues:
                          kCIInputShadingImageKey, optionImage,
                          kCIInputCenterKey, [CIVector vectorWithX:0.5*extent.CGRectValue.size.width
                                                                 Y:0.5*extent.CGRectValue.size.height],
                          nil];
            
            break;
        }
    }
    
    return transition;
}

@end
