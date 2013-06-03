//
//  ViewController.m
//  OTCircleProgressViewDemo
//
//  Created by openthread on 6/3/13.
//  Copyright (c) 2013 openthread. All rights reserved.
//

#import "ViewController.h"
#import "OTCircleProgressView.h"

@interface ViewController ()

@end

@implementation ViewController
{
    OTCircleProgressView *_halfCircleProgressView;
    OTCircleProgressView *_circleProgressView;
    OTCircleProgressView *_solidCircleProgressView;
    OTCircleProgressView *_sectorCircleProgressView;
    NSTimer *_timer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _halfCircleProgressView = [[OTCircleProgressView alloc] initWithFrame:CGRectMake(40, 40, 100, 100)];
    _halfCircleProgressView.roundedCorners = YES;
    _halfCircleProgressView.beginRadians = 5 * M_PI_4;
    _halfCircleProgressView.trackRadians = 5 * M_PI_4;
    [self.view addSubview:_halfCircleProgressView];
    
    _circleProgressView = [[OTCircleProgressView alloc] initWithFrame:CGRectMake(180, 40, 100, 100)];
    _circleProgressView.roundedCorners = YES;
    [self.view addSubview:_circleProgressView];
    
    _solidCircleProgressView = [[OTCircleProgressView alloc] initWithFrame:CGRectMake(40, 180, 100, 100)];
    _solidCircleProgressView.roundedCorners = NO;
    _solidCircleProgressView.thicknessRatio = 1.0f;
    [self.view addSubview:_solidCircleProgressView];
    
    _sectorCircleProgressView = [[OTCircleProgressView alloc] initWithFrame:CGRectMake(180, 180, 100, 100)];
    _sectorCircleProgressView.roundedCorners = NO;
    _sectorCircleProgressView.beginRadians = 4 * M_PI_4;
    _sectorCircleProgressView.trackRadians = 6 * M_PI_4;
    _sectorCircleProgressView.thicknessRatio = 1.0f;
    _sectorCircleProgressView.progressTintColor = [UIColor colorWithRed:38/255.0f green:62/255.0f blue:102/255.0f alpha:1.0f];
    _sectorCircleProgressView.trackTintColor = [UIColor colorWithRed:74/255.0f green:160/255.0f blue:94/255.0f alpha:1.0f];
    [self.view addSubview:_sectorCircleProgressView];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5f
                                              target:self
                                            selector:@selector(changeProgress)
                                            userInfo:nil
                                             repeats:YES];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"indeterminate" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(indeterminate) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(100, 320, 120, 44);
    [self.view addSubview:button];
}

- (void)changeProgress
{
    NSArray *progressViewArray = @[_halfCircleProgressView,
                                   _circleProgressView,
                                   _solidCircleProgressView,
                                   _sectorCircleProgressView];
    for (OTCircleProgressView *progressView in progressViewArray)
    {
        CGFloat progress = progressView.progress;
        progress += 0.2;
        if (progress > 1)
        {
            progress = 0;
            [progressView setProgress:progress animated:NO];
        }
        else
        {
            [progressView setProgress:progress animated:YES];
        }
    }
}

- (void)indeterminate
{
    NSArray *progressViewArray = @[_halfCircleProgressView,
                                   _circleProgressView,
                                   _solidCircleProgressView,
                                   _sectorCircleProgressView];
    for (OTCircleProgressView *progressView in progressViewArray)
    {
        progressView.indeterminate = !progressView.indeterminate;
    }
}

@end
