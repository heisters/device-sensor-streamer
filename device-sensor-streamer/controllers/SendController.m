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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [UIApplication sharedApplication].idleTimerDisabled = YES;

    [self.sender start];
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
    [self.userAccelView push:data.userAcceleration.x y:data.userAcceleration.y z:data.userAcceleration.z];

    [self.orientationView push:data.attitude.quaternion.x y:data.attitude.quaternion.y z:data.attitude.quaternion.z];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
