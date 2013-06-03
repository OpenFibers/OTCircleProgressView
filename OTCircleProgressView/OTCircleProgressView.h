//
//  OTCircleProgressView.h
//  OTCircleProgressViewDemo
//
//  Created by openthread on 6/3/13.
//  Copyright (c) 2013 openthread. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface OTCircleProgressView : UIView

@property (nonatomic, retain) UIColor *trackTintColor;
@property (nonatomic, retain) UIColor *progressTintColor;
@property (nonatomic, assign) BOOL roundedCorners;
@property (nonatomic, assign) CGFloat thicknessRatio;

@property (nonatomic, assign) BOOL indeterminate;
@property (nonatomic, assign) CGFloat indeterminateDuration;

@property (nonatomic, assign) CGFloat beginPoint;
@property (nonatomic, assign) CGFloat circleLength;

@property (nonatomic, assign) CGFloat progress;
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end
