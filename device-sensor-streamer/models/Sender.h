//
//  Sender.h
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

@interface Sender : NSObject

@property (nonatomic, strong, readonly) SensorSettings* settings;
@property (nonatomic, weak) id<MotionDelegate> delegate;
- (id)initWithSettings:(SensorSettings *)settings;
- (void)start;
- (void)stop;
- (void)bang;
@end
