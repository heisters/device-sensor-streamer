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

@end

@implementation AccelerometerSender

- (void)startDaemon {
    UIAccelerometer* accelerometer = [UIAccelerometer sharedAccelerometer];
    accelerometer.updateInterval = 1 / vACCELEROMETER_RATE;
    accelerometer.delegate = self;
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    if (self.delegate) {
        [self.delegate accelerometer:accelerometer didAccelerate:acceleration];
    }
    if (self.settings) {
        if (self.settings.isAccelerometerSendingData) {
            if (!self.hasConnected) {
                NSError* err = nil;
                if (![self.socket connectToHost:self.settings.targetAddress onPort:self.settings.accelerometerPort error:&err])
                {
                    NSLog(@"Socket Error: %@", err);
                }
                self.hasConnected = YES;
            }

            double x = acceleration.x;
            double y = acceleration.y;
            double z = acceleration.z;

            NSString* packet = [NSString stringWithFormat:@"%@:%f:%f:%f", [self packetHeader], x, y, z];

            [self.socket sendData:[packet dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
        }
        else if (self.hasConnected) {
            [self.socket close];
            self.hasConnected = NO;
        }
    }
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
        [sharedRef startDaemon];
    }

    return sharedRef;
}

@end
