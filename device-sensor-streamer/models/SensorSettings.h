//
//  SensorSettings.h
//  SensorStreamer
//
//  Created by Alex Gittemeier on 3/3/2013.
//  Copyright (c) 2013 Gatormeier Business Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark Public properties
@interface SensorSettings : NSObject

@property (nonatomic, getter = isUsingBroadcast) BOOL usingBroadcast;
@property (nonatomic, strong) NSString* targetAddress;

@property (nonatomic, getter = isAccelerometerSendingData) BOOL accelerometerSendingData;
@property (nonatomic) NSInteger accelerometerPort;

@property (nonatomic, getter = isCameraSendingData) BOOL cameraSendingData;
@property (nonatomic) NSInteger cameraPort;
@property (nonatomic, getter = isUsingFrontCamera) BOOL usingFrontCamera;

#pragma mark -
#pragma mark Public methods

- (BOOL) setAccelerometerPortWithString:(NSString* )string;
- (BOOL) setCameraPortWithString:(NSString* )string;

-(id) initWithPreviousStateIfPossible;
-(BOOL) hasPreviousState;

#pragma mark -
@end
