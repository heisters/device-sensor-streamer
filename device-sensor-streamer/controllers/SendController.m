//
//  SendController.m
//  SensorStreamer
//
//  Created by Alex Gittemeier on 3/8/2013.
//  Copyright (c) 2013 Gatormeier Business Consulting. All rights reserved.
//

#import "SendController.h"

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
    self.sX.value = data.acceleration.x;
    self.sY.value = data.acceleration.y;
    self.sZ.value = data.acceleration.z;

    self.rX.text = [NSString stringWithFormat:@"X: %.2f G's", data.acceleration.x];
    self.rY.text = [NSString stringWithFormat:@"Y: %.2f G's", data.acceleration.y];
    self.rZ.text = [NSString stringWithFormat:@"Z: %.2f G's", data.acceleration.z];
}

- (void)viewDidUnload {
    [self setSX:nil];
    [self setSY:nil];
    [self setSZ:nil];
    [self setRX:nil];
    [self setRY:nil];
    [self setRZ:nil];
    [super viewDidUnload];
}
@end
