    //
    //  AccelerometerSender.m
    //  SensorStreamer
    //
    //  Created by Alex Gittemeier on 3/8/2013.
    //  Copyright (c) 2013 Gatormeier Business Consulting. All rights reserved.
    //

#import "AccelerometerSender.h"
#import <OSCPack.h>

@interface AccelerometerSender ()

@property (nonatomic, strong) OSCPackSender *osc;
@property (nonatomic) BOOL hasConnected;
@property (nonatomic) BOOL isRunning;
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) NSOperationQueue *deviceQueue;
@property (nonatomic, strong) NSOperationQueue *accelQueue;
@property (nonatomic, strong) NSOperationQueue *gyroQueue;
@property (nonatomic, strong) NSString *deviceId;
@end

@implementation AccelerometerSender

- (id)initWithSettings:(SensorSettings *)settings
{
    self = [super init];
    if ( self ) {
        _settings = settings;

        self.isRunning = NO;

        self.osc = [[OSCPackSender alloc] initWithHost:self.settings.targetAddress port:self.settings.accelerometerPort];
        [self.osc enableBroadcast];

        self.deviceId = [[UIDevice currentDevice] name];

        self.motionManager = [CMMotionManager new];
        self.motionManager.deviceMotionUpdateInterval = 1.0 / vACCELEROMETER_RATE;
        self.motionManager.accelerometerUpdateInterval = 1.0 / vACCELEROMETER_RATE;
        self.motionManager.gyroUpdateInterval = 1.0 / vACCELEROMETER_RATE;

        self.deviceQueue = [NSOperationQueue new];
        self.accelQueue = [NSOperationQueue new];
        self.gyroQueue = [NSOperationQueue new];

        [self.deviceQueue setMaxConcurrentOperationCount:1];
        [self.accelQueue setMaxConcurrentOperationCount:1];
        [self.gyroQueue setMaxConcurrentOperationCount:1];
    }

    return self;
}

- (void)start
{
    if ( self.isRunning ) return;

    CMDeviceMotionHandler motionHandler = ^(CMDeviceMotion *motion, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self didMove:motion error:error];
        });
    };

    CMAccelerometerHandler accelHandler = ^(CMAccelerometerData *accelerometerData, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self didAccel:accelerometerData error:error];
        });
    };

    CMGyroHandler gyroHandler = ^(CMGyroData *gyroData, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self didGyro:gyroData error:error];
        });
    };


    [self.motionManager startDeviceMotionUpdatesToQueue:self.deviceQueue withHandler:motionHandler];
    [self.motionManager startAccelerometerUpdatesToQueue:self.accelQueue withHandler:accelHandler];
    [self.motionManager startGyroUpdatesToQueue:self.gyroQueue withHandler:gyroHandler];


    self.isRunning = YES;
}

- (void)stop
{
    [self.motionManager stopDeviceMotionUpdates];
    [self.deviceQueue waitUntilAllOperationsAreFinished];

    [self.motionManager stopAccelerometerUpdates];
    [self.accelQueue waitUntilAllOperationsAreFinished];

    [self.motionManager stopGyroUpdates];
    [self.gyroQueue waitUntilAllOperationsAreFinished];

    [self.osc close];

    self.isRunning = NO;
}

- (void)didMove:(CMDeviceMotion *)data error:(NSError *)error
{
    [[[[[self.message to:@"/user_accel"]
        addFloat:data.userAcceleration.x] addFloat:data.userAcceleration.y] addFloat:data.userAcceleration.z]
     send];

    if ( [self.delegate respondsToSelector:@selector(didMove:error:)] )
        [self.delegate didMove:data error:error];
}

- (void)didAccel:(CMAccelerometerData *)data error:(NSError *)error
{
    [[[[[self.message to:@"/accel"]
        addFloat:data.acceleration.x] addFloat:data.acceleration.y] addFloat:data.acceleration.z]
     send];

    if ( [self.delegate respondsToSelector:@selector(didAccelerate:error:)] )
        [self.delegate didAccelerate:data error:error];
}

- (void)didGyro:(CMGyroData *)data error:(NSError *)error
{
    [[[[[self.message to:@"/gyro"]
       addFloat:data.rotationRate.x] addFloat:data.rotationRate.y] addFloat:data.rotationRate.z]
     send];

    if ( [self.delegate respondsToSelector:@selector(didGyrate:error:)] )
        [self.delegate didGyrate:data error:error];
}

- (OSCPackMessageBuilder *)message
{
    return [[self.osc message] add:self.deviceId];
}

@end
