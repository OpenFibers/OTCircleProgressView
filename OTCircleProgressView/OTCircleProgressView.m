//
//  OTCircleProgressView.m
//  OTCircleProgressViewDemo
//
//  Created by openthread on 6/3/13.
//  Copyright (c) 2013 openthread. All rights reserved.
//

#import "OTCircleProgressView.h"
#import <QuartzCore/QuartzCore.h>

@interface OTCircularProgressLayer : CALayer

@property (nonatomic, strong) UIColor *trackTintColor;
@property (nonatomic, strong) UIColor *progressTintColor;
@property (nonatomic) NSInteger roundedCorners;
@property (nonatomic) CGFloat thicknessRatio;
@property (nonatomic) CGFloat progress;

@end

@implementation OTCircularProgressLayer

@dynamic trackTintColor;
@dynamic progressTintColor;
@dynamic roundedCorners;
@dynamic thicknessRatio;
@dynamic progress;

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    return [key isEqualToString:@"progress"] ? YES : [super needsDisplayForKey:key];
}

- (void)drawInContext:(CGContextRef)context
{
    CGRect rect = self.bounds;
    CGPoint centerPoint = CGPointMake(rect.size.height / 2.0f, rect.size.width / 2.0f);
    
    //Circle radius
    CGFloat radius = MIN(rect.size.height, rect.size.width) / 2.0f;
    
    //Begin radians
    CGFloat beginRadians = ((OTCircleProgressView *)self.delegate).beginRadians;
    
    //Track radians
    CGFloat trackRadians = ((OTCircleProgressView *)self.delegate).trackRadians;
    
    //Progress radians
    CGFloat progress = MIN(self.progress, 1.0f - FLT_EPSILON);
    CGFloat progressRadians = (progress * trackRadians);
    
    if (trackRadians > M_PI * 2)
    {
        trackRadians = M_PI * 2;
    }
    
    CGFloat progressBeginAngel = 3.0f * M_PI_2 + beginRadians;
    CGFloat progressEndAngel = progressBeginAngel + progressRadians;

    CGFloat trackBeginAngel = 3.0f * M_PI_2 + beginRadians;
    CGFloat trackEndAngel = trackBeginAngel + trackRadians;
    
    //If progress color is clear, progress clears track
    if ([self.progressTintColor isEqual:[UIColor clearColor]])
    {
        trackBeginAngel = progressEndAngel;
    }
    
    //Add track path
    CGContextSetFillColorWithColor(context, self.trackTintColor.CGColor);
    CGMutablePathRef trackPath = CGPathCreateMutable();
    CGPathMoveToPoint(trackPath, NULL, centerPoint.x, centerPoint.y);
    CGPathAddArc(trackPath, NULL, centerPoint.x, centerPoint.y, radius, trackBeginAngel, trackEndAngel, NO);
    CGPathCloseSubpath(trackPath);
    CGContextAddPath(context, trackPath);
    CGPathRelease(trackPath);
    
    //If rounded corners setted, add rounded corners to track path.
    if (self.roundedCorners)
    {
        CGFloat pathWidth = radius * self.thicknessRatio;
        
        CGFloat xBegin = radius * (1.0f + ((1.0f - (self.thicknessRatio / 2.0f)) * cosf(trackBeginAngel)));
        CGFloat yBegin = radius * (1.0f + ((1.0f - (self.thicknessRatio / 2.0f)) * sinf(trackBeginAngel)));
        CGPoint beginPoint = CGPointMake(xBegin, yBegin);
        
        CGFloat xOffset = radius * (1.0f + ((1.0f - (self.thicknessRatio / 2.0f)) * cosf(trackEndAngel)));
        CGFloat yOffset = radius * (1.0f + ((1.0f - (self.thicknessRatio / 2.0f)) * sinf(trackEndAngel)));
        CGPoint endPoint = CGPointMake(xOffset, yOffset);
        
        //End round point's path of progress
        CGContextAddEllipseInRect(context, CGRectMake(beginPoint.x - pathWidth / 2.0f, beginPoint.y - pathWidth / 2.0f, pathWidth, pathWidth));
        
        //End round point's path of progress
        CGContextAddEllipseInRect(context, CGRectMake(endPoint.x - pathWidth / 2.0f, endPoint.y - pathWidth / 2.0f, pathWidth, pathWidth));
    }
    
    //Draw track path
    CGContextFillPath(context);
    
    //Add progress path
    if (progress > 0.0f)
    {
        CGContextSetFillColorWithColor(context, self.progressTintColor.CGColor);
        CGMutablePathRef progressPath = CGPathCreateMutable();
        CGPathMoveToPoint(progressPath, NULL, centerPoint.x, centerPoint.y);
        CGPathAddArc(progressPath, NULL, centerPoint.x, centerPoint.y, radius, progressBeginAngel, progressEndAngel, NO);
        CGPathCloseSubpath(progressPath);
        CGContextAddPath(context, progressPath);
        CGPathRelease(progressPath);
    }
    
    //If rounded corners setted, add rounded corners to progress path.
    if (progress > 0.0f && self.roundedCorners)
    {
        CGFloat pathWidth = radius * self.thicknessRatio;
        
        CGFloat xBegin = radius * (1.0f + ((1.0f - (self.thicknessRatio / 2.0f)) * cosf(progressBeginAngel)));
        CGFloat yBegin = radius * (1.0f + ((1.0f - (self.thicknessRatio / 2.0f)) * sinf(progressBeginAngel)));
        CGPoint beginPoint = CGPointMake(xBegin, yBegin);

        CGFloat xOffset = radius * (1.0f + ((1.0f - (self.thicknessRatio / 2.0f)) * cosf(progressEndAngel)));
        CGFloat yOffset = radius * (1.0f + ((1.0f - (self.thicknessRatio / 2.0f)) * sinf(progressEndAngel)));
        CGPoint endPoint = CGPointMake(xOffset, yOffset);
        
        //Begin round point's path of progress
        CGContextAddEllipseInRect(context, CGRectMake(beginPoint.x - pathWidth / 2.0f, beginPoint.y - pathWidth / 2.0f, pathWidth, pathWidth));
        
        //End round point's path of progress
        CGContextAddEllipseInRect(context, CGRectMake(endPoint.x - pathWidth / 2.0f, endPoint.y - pathWidth / 2.0f, pathWidth, pathWidth));
    }
    
    //Draw progress
    CGContextFillPath(context);

    //Clear center
    CGContextSetBlendMode(context, kCGBlendModeClear);
    CGFloat innerRadius = radius * (1.0f - self.thicknessRatio);
    CGPoint newCenterPoint = CGPointMake(centerPoint.x - innerRadius, centerPoint.y - innerRadius);
    CGContextAddEllipseInRect(context, CGRectMake(newCenterPoint.x, newCenterPoint.y, innerRadius * 2.0f, innerRadius * 2.0f));
    CGContextFillPath(context);
}

@end

@implementation OTCircleProgressView
@synthesize beginRadians = _beginRadians;
@synthesize trackRadians = _trackRadians;

//Designated initializer
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setTrackTintColor:[[UIColor whiteColor] colorWithAlphaComponent:0.3f]];
        [self setProgressTintColor:[UIColor whiteColor]];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setThicknessRatio:0.3f];
        [self setRoundedCorners:NO];
        
        [self setIndeterminateDuration:2.0f];
        [self setIndeterminate:NO];
        
        [self setTrackRadians:2 * M_PI];
        
        [self setFrame:frame];
    }
    return self;
}

//Secondary initializer
- (id)init
{
    self = [self initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 40.0f)];
    return self;
}

//Forcely set height same as width, to avoid draw disorder
- (void)setFrame:(CGRect)frame
{
    CGRect newFrame = frame;
    newFrame.size.height = newFrame.size.width;
    [super setFrame:newFrame];
}

+ (Class)layerClass
{
    return [OTCircularProgressLayer class];
}

- (OTCircularProgressLayer *)circularProgressLayer
{
    return (OTCircularProgressLayer *)self.layer;
}

- (void)didMoveToWindow
{
    CGFloat windowContentsScale = self.window.screen.scale;
    self.circularProgressLayer.contentsScale = windowContentsScale;
}

#pragma mark - Progress

- (CGFloat)progress
{
    return self.circularProgressLayer.progress;
}

- (void)setProgress:(CGFloat)progress
{
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    [self setProgress:progress animated:animated animationDuration:-1];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated animationDuration:(NSTimeInterval)animationDuration
{
    CGFloat pinnedProgress = MIN(MAX(progress, 0.0f), 1.0f);
    if (animated)
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"progress"];
        if (animationDuration > 0)
        {
            animation.duration = animationDuration;
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        }
        else
        {
            // Same duration as UIProgressView animation
            animation.duration = fabs(self.progress - pinnedProgress);
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        }
        animation.fromValue = [NSNumber numberWithFloat:self.progress];
        animation.toValue = [NSNumber numberWithFloat:pinnedProgress];
        [self.circularProgressLayer addAnimation:animation forKey:@"progress"];
    }
    else
    {
        [self.circularProgressLayer setNeedsDisplay];
    }
    self.circularProgressLayer.progress = pinnedProgress;
}

#pragma mark - UIAppearance methods

- (UIColor *)trackTintColor
{
    return self.circularProgressLayer.trackTintColor;
}

- (void)setTrackTintColor:(UIColor *)trackTintColor
{
    self.circularProgressLayer.trackTintColor = trackTintColor;
    [self.circularProgressLayer setNeedsDisplay];
}

- (UIColor *)progressTintColor
{
    return self.circularProgressLayer.progressTintColor;
}

- (void)setProgressTintColor:(UIColor *)progressTintColor
{
    self.circularProgressLayer.progressTintColor = progressTintColor;
    [self.circularProgressLayer setNeedsDisplay];
}

- (BOOL)roundedCorners
{
    return self.roundedCorners;
}

- (void)setRoundedCorners:(BOOL)roundedCorners
{
    self.circularProgressLayer.roundedCorners = roundedCorners;
    [self.circularProgressLayer setNeedsDisplay];
}

- (CGFloat)thicknessRatio
{
    return self.circularProgressLayer.thicknessRatio;
}

- (void)setThicknessRatio:(CGFloat)thicknessRatio
{
    self.circularProgressLayer.thicknessRatio = MIN(MAX(thicknessRatio, 0.f), 1.f);
    [self.circularProgressLayer setNeedsDisplay];
}

- (BOOL)indeterminate
{
    CAAnimation *spinAnimation = [self.layer animationForKey:@"indeterminateAnimation"];
    return (spinAnimation == nil ? 0 : 1);
}

- (void)setIndeterminate:(BOOL)indeterminate
{
    if (indeterminate && !self.indeterminate)
    {
        CABasicAnimation *spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        spinAnimation.byValue = [NSNumber numberWithFloat:2.0f*M_PI];
        spinAnimation.duration = self.indeterminateDuration;
        spinAnimation.repeatCount = HUGE_VALF;
        [self.layer addAnimation:spinAnimation forKey:@"indeterminateAnimation"];
    }
    else
    {
        [self.layer removeAnimationForKey:@"indeterminateAnimation"];
    }
}

- (void)setBeginRadians:(CGFloat)beginPoint
{
    CGFloat normalizedBeginPoint = [OTCircleProgressView normalizeCircleAngle:beginPoint];
    _beginRadians = normalizedBeginPoint;
}

- (void)setTrackRadians:(CGFloat)circleLength
{
    CGFloat normalizedCircleLength = [OTCircleProgressView normalizeCircleAngle:circleLength];
    _trackRadians = normalizedCircleLength;
    [self.circularProgressLayer setNeedsDisplay];
}

+ (CGFloat)normalizeCircleAngle:(CGFloat)circleAngle
{
    CGFloat normalizedAngle = MIN(MAX(circleAngle, 0), M_PI * 2);
    normalizedAngle = (normalizedAngle == 0 ? M_PI * 2 : normalizedAngle);
    return normalizedAngle;
}

@end
