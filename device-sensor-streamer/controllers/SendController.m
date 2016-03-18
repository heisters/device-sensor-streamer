//
//  SendController.m
//  SensorStreamer
//
//  Created by Alex Gittemeier on 3/8/2013.
//  Copyright (c) 2013 Gatormeier Business Consulting. All rights reserved.
//

#import "SendController.h"
#import "SensorStreamer-Swift.h"

@interface SendController()
@end

@implementation SendController

- (void)viewDidLoad {
    self.sender = [[Sender alloc] initWithSettings:[[SensorSettings alloc] initWithPreviousStateIfPossible]];
    self.sender.delegate = self;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(guidedAccessChanged) name:UIAccessibilityGuidedAccessStatusDidChangeNotification object:nil];
    
    self.minimalMonitorView.layer.cornerRadius = self.minimalMonitorView.bounds.size.width/2;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [UIApplication sharedApplication].idleTimerDisabled = YES;

    [self.sender start];
    
    BOOL drawGraph = self.sender.settings.drawMode;
    if (drawGraph) {
        [self addGraphViews];
    }
    else {
        [self removeGraphViews];
    }
}

- (void)addGraphViews {
    CGFloat w = self.view.bounds.size.width;
    CGFloat h = self.view.bounds.size.height / 3;
    
    if (!self.accelView) {
        self.accelView = [[GraphView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
        self.accelView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.accelView];
    }
    
    if (!self.userAccelView) {
        self.userAccelView = [[GraphView alloc] initWithFrame:CGRectMake(0, h, w, h)];
        self.userAccelView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.userAccelView];
    }
    
    if (!self.orientationView) {
        self.orientationView = [[GraphView alloc] initWithFrame:CGRectMake(0, 2*h, w, h)];
        self.orientationView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.orientationView];
    }
}

- (void)removeGraphViews {
    [self.accelView removeFromSuperview];
    self.accelView = nil;
    
    [self.userAccelView removeFromSuperview];
    self.userAccelView = nil;
    
    [self.orientationView removeFromSuperview];
    self.orientationView = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [self.sender stop];
}

- (void)didAccelerate:(CMAccelerometerData *)data error:(NSError *)error
{
    [self.accelView push:data.acceleration.x y:data.acceleration.y z:data.acceleration.z];
}

- (void)didMove:(CMDeviceMotion *)data error:(NSError *)error
{
    self.minimalMonitorView.backgroundColor = [UIColor redColor];
    [self.userAccelView push:data.userAcceleration.x y:data.userAcceleration.y z:data.userAcceleration.z];
    [self.orientationView push:data.attitude.quaternion.x y:data.attitude.quaternion.y z:data.attitude.quaternion.z];
    
    [self performSelector:@selector(turnOffMonitor) withObject:nil afterDelay:0.1];
}

- (void)turnOffMonitor {
    self.minimalMonitorView.backgroundColor = [UIColor whiteColor];
}

- (void)guidedAccessChanged
{
    BOOL enabled = !UIAccessibilityIsGuidedAccessEnabled();
    [self.tabBarController.tabBar setUserInteractionEnabled:enabled];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
