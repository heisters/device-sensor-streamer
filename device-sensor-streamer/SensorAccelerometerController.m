//
//  SensorAccelerometerController.m
//  SensorStreamer
//
//  Created by Alex Gittemeier on 3/8/2013.
//  Copyright (c) 2013 Gatormeier Business Consulting. All rights reserved.
//

#import "SensorAccelerometerController.h"

    // number is in hz
#define vACCELEROMETER_RATE     50

@implementation SensorAccelerometerController

- (void)viewDidLoad {
    UIAccelerometer* accelerometer = [UIAccelerometer sharedAccelerometer];
    accelerometer.updateInterval = 1 / vACCELEROMETER_RATE;
    accelerometer.delegate = self;
}

    // Using deprecated methods in a pinch. ssh...
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {

    self.sX.value = acceleration.x;
    self.sY.value = acceleration.y;
    self.sZ.value = acceleration.z;

    self.rX.text = [NSString stringWithFormat:@"X: %.2f G's",acceleration.x];
    self.rY.text = [NSString stringWithFormat:@"Y: %.2f G's",acceleration.y];
    self.rZ.text = [NSString stringWithFormat:@"Z: %.2f G's",acceleration.z];
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
