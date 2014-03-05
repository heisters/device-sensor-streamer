//
//  SensorAccelerometerController.m
//  SensorStreamer
//
//  Created by Alex Gittemeier on 3/8/2013.
//  Copyright (c) 2013 Gatormeier Business Consulting. All rights reserved.
//

#import "SensorAccelerometerController.h"

@implementation SensorAccelerometerController

- (void)viewDidLoad {
    AccelerometerSender* sender = [AccelerometerSender sharedSender];
    sender.delegate = self;
    sender.settings = [[SensorSettings alloc] initWithPreviousStateIfPossible];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[AccelerometerSender sharedSender] start];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [[AccelerometerSender sharedSender] stop];
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
