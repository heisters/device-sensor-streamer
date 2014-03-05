    //
    //  AccelerometerSender.m
    //  SensorStreamer
    //
    //  Created by Alex Gittemeier on 3/8/2013.
    //  Copyright (c) 2013 Gatormeier Business Consulting. All rights reserved.
    //

#import "AccelerometerSender.h"

@interface AccelerometerSender ()

@property (nonatomic, strong) GCDAsyncUdpSocket* socket;
@property (nonatomic) BOOL hasConnected;
@property (nonatomic) BOOL isRunning;
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) NSOperationQueue *deviceQueue;
@property (nonatomic, strong) NSOperationQueue *accelQueue;
@property (nonatomic, strong) NSOperationQueue *gyroQueue;
@end

@implementation AccelerometerSender

- (id)init
{
    self = [super init];
    if ( self ) {
        self.isRunning = NO;

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

    [self connect];

    CMDeviceMotionHandler motionHandler = ^(CMDeviceMotion *motion, NSError *error) {
        [self didMove:motion error:error];
    };

    CMAccelerometerHandler accelHandler = ^(CMAccelerometerData *accelerometerData, NSError *error) {
        [self didAccel:accelerometerData error:error];
    };

    CMGyroHandler gyroHandler = ^(CMGyroData *gyroData, NSError *error) {
        [self didGyro:gyroData error:error];
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

    [self.socket closeAfterSending];

    self.isRunning = NO;
}

- (void)connect
{
    if ( [self.socket isClosed] ) self.hasConnected = NO;

    if (!self.hasConnected) {
        NSError* err = nil;
        if (![self.socket connectToHost:self.settings.targetAddress onPort:self.settings.accelerometerPort error:&err])
        {
            NSLog(@"Socket Error: %@", err);
        }
        self.hasConnected = YES;
    }
}

- (void)didMove:(CMDeviceMotion *)data error:(NSError *)error
{
    double x = data.userAcceleration.x;
    double y = data.userAcceleration.y;
    double z = data.userAcceleration.z;

    [self sendData:@"USER_ACCEL" data:[NSString stringWithFormat:@"%f:%f:%f", x, y, z]];

    if ( [self.delegate respondsToSelector:@selector(didMove:error:)] )
        [self.delegate didMove:data error:error];
}

- (void)didAccel:(CMAccelerometerData *)data error:(NSError *)error
{
    double x = data.acceleration.x;
    double y = data.acceleration.y;
    double z = data.acceleration.z;

    [self sendData:@"ACCEL" data:[NSString stringWithFormat:@"%f:%f:%f", x, y, z]];

    if ( [self.delegate respondsToSelector:@selector(didAccelerate:error:)] )
        [self.delegate didAccelerate:data error:error];
}

- (void)didGyro:(CMGyroData *)data error:(NSError *)error
{
    double x = data.rotationRate.x;
    double y = data.rotationRate.y;
    double z = data.rotationRate.z;

    [self sendData:@"GYRO" data:[NSString stringWithFormat:@"%f:%f:%f", x, y, z]];

    if ( [self.delegate respondsToSelector:@selector(didGyrate:error:)] )
        [self.delegate didGyrate:data error:error];
}

- (void)sendData:(NSString *)label data:(NSString *)data
{
    NSString *packet = [NSString stringWithFormat:@"%@:%@:%@", [self packetHeader], label, data];
    [self.socket sendData:[packet dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
}

- (NSString *)packetHeader {
    NSString* uuid = [[UIDevice currentDevice] name];
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    return [NSString stringWithFormat:@"AccSend1.0:%@:%.0f", uuid, now];
}

#pragma mark -
#pragma mark Property methods

-(GCDAsyncUdpSocket* )socket {
    if (!_socket) {
        _socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }

    return _socket;
}

#pragma mark -
#pragma mark Singleton methods

static AccelerometerSender* sharedRef;

+ (AccelerometerSender* )sharedSender {
    if (!sharedRef) {
        sharedRef = [[self alloc] init];
    }

    return sharedRef;
}

@end
