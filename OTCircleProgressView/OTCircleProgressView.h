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

@property (nonatomic, retain) UIColor *trackTintColor;//Change track color
@property (nonatomic, retain) UIColor *progressTintColor;//Change progress color
@property (nonatomic, assign) BOOL roundedCorners;//Set whether track has roundedCorners

//Change annulus thickness [0, 1]
@property (nonatomic, assign) CGFloat thicknessRatio;

@property (nonatomic, assign) BOOL indeterminate;//Set whether track rotate
@property (nonatomic, assign) CGFloat indeterminateDuration;//Set track rotate duration

//Set the begin point of ciculation [0, 2 * PI]
@property (nonatomic, assign) CGFloat beginRadians;

//Set the circle length of ciculation (0, 2 * PI]
@property (nonatomic, assign) CGFloat trackRadians;

@property (nonatomic, assign) CGFloat progress;

//If animated, animates same duration as UIProgressView animation, easy in out.
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

//If animated and `animationDuration` is negative, animates same duration as UIProgressView animation, animate curve is easy in out.
//If animated and `animationDuration` is positive, animates for animationDuration, animate curve is linear.
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated animationDuration:(NSTimeInterval)animationDuration;

@end
