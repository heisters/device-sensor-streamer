//
//  AccelerometerSender.h
//  SensorStreamer
//
//  Created by Alex Gittemeier on 3/8/2013.
//  Copyright (c) 2013 Gatormeier Business Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SensorSettings.h"
#import "GCDAsyncUdpSocket.h"

@interface AccelerometerSender : NSObject<UIAccelerometerDelegate>

@property (nonatomic, strong) SensorSettings* settings;
@property (nonatomic, weak) id<UIAccelerometerDelegate> delegate;
+ (AccelerometerSender* )sharedSender;

@end
