//
//  TransitionView.m
//  CITransitionSample
//
//  Created by shuichi on 13/03/10.
//  Copyright (c) 2013年 Shuichi Tsutsumi. All rights reserved.
//

#import "TransitionView.h"
#import "CITransitionHelper.h"


@interface TransitionView ()
<GLKViewDelegate>
{
    NSTimeInterval  base;
    CGRect imageRect;
}
@property (nonatomic, strong) CIImage *image1;
@property (nonatomic, strong) CIImage *image2;
@property (nonatomic, strong) CIImage *maskImage;
@property (nonatomic, strong) CIImage *shadingImage;
@property (nonatomic, strong) CIVector *extent;
@property (nonatomic, strong) CIFilter *transition;
@property (nonatomic, strong) CIContext *myContext;
@end


@implementation TransitionView

- (void)awakeFromNib {

    // 遷移前後の画像とマスク画像を生成
    UIImage *uiImage1    = [UIImage imageNamed:@"sample1.jpg"];
    UIImage *uiImage2    = [UIImage imageNamed:@"sample2.jpg"];
    UIImage *uiMaskImage = [UIImage imageNamed:@"mask.jpg"];
    UIImage *uiShadingImage = [UIImage imageNamed:@"restrictedshine.tiff"];
    
    self.image1    = [CIImage imageWithCGImage:uiImage1.CGImage];
    self.image2    = [CIImage imageWithCGImage:uiImage2.CGImage];
    self.maskImage = [CIImage imageWithCGImage:uiMaskImage.CGImage];
    self.shadingImage = [CIImage imageWithCGImage:uiShadingImage.CGImage];
    
    // 表示領域を示す矩形（CGRect型）
    imageRect = CGRectMake(0, 0, uiImage1.size.width, uiImage1.size.height);
    

    // 遷移アニメーションが起こる領域を示す矩形（CIVector型）
    self.extent = [CIVector vectorWithX:0
                                      Y:0
                                      Z:uiImage1.size.width
                                      W:uiImage2.size.height];
    
    // 遷移アニメーション制御の基準となる時刻
    base = [NSDate timeIntervalSinceReferenceDate];    

    // 遷移アニメーションを制御するタイマー
    [NSTimer scheduledTimerWithTimeInterval:1.0/30.0
                                     target:self
                                   selector:@selector(onTimer:)
                                   userInfo:nil
                                    repeats:YES];

    // EAGLDelegateの設定
    self.delegate = self;
    
    // コンテキスト生成
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    self.myContext = [CIContext contextWithEAGLContext:self.context];
}


// =============================================================================
#pragma mark - Private

- (CIImage *)imageForTransitionAtTime:(float)time
{
    // 遷移前後の画像をtimeによって切り替える
    if (fmodf(time, 2.0) < 1.0f)
    {
        [self.transition setValue:self.image1 forKey:@"inputImage"];
        [self.transition setValue:self.image2 forKey:@"inputTargetImage"];
    }
    else
    {
        [self.transition setValue:self.image2 forKey:@"inputImage"];
        [self.transition setValue:self.image1 forKey:@"inputTargetImage"];
    }
    
    // 遷移アニメーションの時間を指定
    CGFloat transitionTime = 0.5 * (1 - cos(fmodf(time, 1.0f) * M_PI));
    
    [self.transition setValue:@(transitionTime) forKey:@"inputTime"];
    
    // フィルタ処理実行
    CIImage *transitionImage = [self.transition valueForKey:@"outputImage"];
    
    return transitionImage;
}


// =============================================================================
#pragma mark - Public

- (void)changeTransition:(NSUInteger)transitionIndex {
    
    CITransitionType type;
    CIImage *optionImage;
    
    switch (transitionIndex) {
            
        case 0:
        default:
            type = kCITransitionTypeDissolve;
            break;
            
        case 1:
            type = kCITransitionTypeCopyMachine;
            break;
            
        case 2:
            type = kCITransitionTypeFlash;
            break;
            
        case 3:
            type = kCITransitionTypeMod;
            break;
            
        case 4:
            type = kCITransitionTypeSwipe;
            break;
            
        case 5:
            type = kCITransitionTypeDisintegrateWithMask;
            optionImage = self.maskImage;
            break;

        case 6:
            type = kCITransitionTypePageCurl;
            optionImage = self.shadingImage;
            break;

        case 7:
            type = kCITransitionTypePageCurlWithShadow;
//            optionImage = self.shadingImage;
            break;

        case 8:
            type = kCITransitionTypeRipple;
            optionImage = self.shadingImage;
            break;
    }
    
    if (optionImage) {
        self.transition = [CITransitionHelper transitionWithType:type
                                                          extent:self.extent
                                                     optionImage:optionImage];
    }
    else {
        self.transition = [CITransitionHelper transitionWithType:type
                                                          extent:self.extent];
    }
}

- (NSString *)currentFilterName {
    
    return self.transition.name;
}


// =============================================================================
#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        // 遷移前後の画像をtimeによって切り替える
        float t = 0.4 * ([NSDate timeIntervalSinceReferenceDate] - base);
        
        CIImage *image = [self imageForTransitionAtTime:t];

        // 描画領域を示す矩形
        CGFloat scale = [[UIScreen mainScreen] scale];
        CGRect destRect = CGRectMake(0, self.bounds.size.height * scale - imageRect.size.height,
                                     imageRect.size.width,
                                     imageRect.size.height);

        dispatch_async(dispatch_get_main_queue(), ^{

            [self.myContext drawImage:image
                               inRect:destRect
                             fromRect:imageRect];
        });
    });
}


// =============================================================================
#pragma mark - Timer Handler

- (void)onTimer:(NSTimer *)timer {

    [self setNeedsDisplay];
}




@end
