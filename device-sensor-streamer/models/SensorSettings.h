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
@property (nonatomic, strong) NSString* targetBroadcastAddress;

@property (nonatomic, getter = isAccelerometerSendingData) BOOL accelerometerSendingData;
@property (nonatomic) NSInteger accelerometerPort;

#pragma mark -
#pragma mark Public methods

- (BOOL) setAccelerometerPortWithString:(NSString* )string;

-(id) initWithPreviousStateIfPossible;
-(BOOL) hasPreviousState;
-(void) writeState;
-(void) readState;

#pragma mark -
@end
