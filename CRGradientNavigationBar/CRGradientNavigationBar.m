//
//  CRGradientNavigationBar.m
//  CRGradientNavigationBar
//
//  Created by Christian Roman on 19/10/13.
//  Copyright (c) 2013 Christian Roman. All rights reserved.
//

#import "CRGradientNavigationBar.h"
#import <QuartzCore/QuartzCore.h>

@interface CRGradientNavigationBar ()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation CRGradientNavigationBar

static CGFloat const kDefaultOpacity = 0.5f;

- (void)setBarTintGradientColors:(NSArray *)barTintGradientColors
{
    // create the gradient layer
    if (self.gradientLayer == nil) {
        self.gradientLayer = [CAGradientLayer layer];
        self.gradientLayer.opacity = self.translucent ? kDefaultOpacity : 1.0f;
        
        if( self.translucent)
        {
            [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
            [self setShadowImage:[UIImage new]];
        }
    }
    
    NSMutableArray * colors = nil;
    if (barTintGradientColors != nil)
    {
        colors = [NSMutableArray arrayWithCapacity:[barTintGradientColors count]];
        
        // determine elements in the array are colours
        // and add them to the colors array
        [barTintGradientColors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[UIColor class]])
            {
                // UIColor class
                [colors addObject:(id)[obj CGColor]];
            }
            else if ( CFGetTypeID( (__bridge void *)obj ) == CGColorGetTypeID() )
            {
                // CGColorRef
                [colors addObject:obj];
            }
            else
            {
                // obj is not a supported type
                @throw [NSException exceptionWithName:@"BarTintGraidentColorsError" reason:@"object in barTintGradientColors array is not a UIColor or CGColorRef" userInfo:nil];
            }
        }];
        
        self.barTintColor = [UIColor clearColor];
        self.tintColor = [UIColor clearColor];
    }
    
    // set the graident colours to the laery
    self.gradientLayer.colors = colors;
}

#pragma mark - UIView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // allow all layout subviews call to adjust the frame
    if ( self.gradientLayer != nil )
    {
        CGRect bounds = self.bounds;
        CGFloat statusBarHeight;

        if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
            statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.width;
        } else {
            statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        }
        
        self.gradientLayer.frame = CGRectMake(0, 0 - statusBarHeight,
                                              CGRectGetWidth(bounds),
                                              CGRectGetHeight(bounds) + statusBarHeight);
        
        // make sure the graident layer is at position 1
        [self.layer insertSublayer:self.gradientLayer atIndex:1];
    }
}

@end
