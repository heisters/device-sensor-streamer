//
//  AccelerometerSender.h
//  SensorStreamer
//
//  Created by Alex Gittemeier on 3/8/2013.
//  Copyright (c) 2013 Gatormeier Business Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import "SensorSettings.h"

@protocol MotionDelegate <NSObject>
@optional
- (void)didAccelerate:(CMAccelerometerData *)data error:(NSError *)error;
- (void)didGyrate:(CMGyroData *)data error:(NSError *)error;
- (void)didMove:(CMDeviceMotion *)data error:(NSError *)error;
@end

@interface AccelerometerSender : NSObject

@property (nonatomic, strong) SensorSettings* settings;
@property (nonatomic, weak) id<MotionDelegate> delegate;
+ (AccelerometerSender* )sharedSender;
- (void)start;
- (void)stop;
@end
