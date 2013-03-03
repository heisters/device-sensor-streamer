//
//  SensorSettings.m
//  SensorStreamer
//
//  Created by Alex Gittemeier on 3/3/2013.
//  Copyright (c) 2013 Gatormeier Business Consulting. All rights reserved.
//

#import "SensorSettings.h"

#define kBROADCASTING               @"broadcasting"
#define kTARGET_ADDRESS             @"targetAddress"

#define kACCELEROMETER_SENDING_DATA @"accelerometerSendingData"
#define kACCELEROMETER_PORT         @"accelerometerPort"

#define kCAMERA_SENDING_DATA        @"cameraSendingData"
#define kCAMERA_PORT                @"cameraPort"
#define kUSING_FRONT_CAMERA         @"usingFrontCamera"


@implementation SensorSettings

- (BOOL) setTargetAddressWithString:(NSString* )string {
    NSURL* url = [[NSURL alloc] initWithString:string];
    if (url) {
        self.targetAddress = url;
        return YES;
    } else {
        return NO;
    }
}

- (BOOL) setAccelerometerPortWithString:(NSString* )string {
    NSInteger port = [string integerValue];
    if ([[NSString stringWithFormat:@"%d", port] isEqualToString:string]) {
        self.accelerometerPort = port;
        return YES;
    } else {
        return NO;
    }
}

- (BOOL) setCameraPortWithString:(NSString* )string {
    NSInteger port = [string integerValue];
    if ([[NSString stringWithFormat:@"%d", port] isEqualToString:string]) {
        self.cameraPort = port;
        return YES;
    } else {
        return NO;
    }
}

- (void) updatePersistentState {
    NSUserDefaults* defaults = [[NSUserDefaults alloc] init];
    [defaults setBool:self.broadcasting forKey:kBROADCASTING];
    [defaults setObject:self.targetAddress forKey:kTARGET_ADDRESS];
    [defaults setBool:self.accelerometerSendingData forKey:kACCELEROMETER_SENDING_DATA];
    [defaults setInteger:self.accelerometerPort forKey:kACCELEROMETER_PORT];
    [defaults setBool:self.cameraSendingData forKey:kCAMERA_SENDING_DATA];
    [defaults setInteger:self.cameraPort forKey:kCAMERA_PORT];
    [defaults setBool:self.usingFrontCamera forKey:kUSING_FRONT_CAMERA];
}

- (id) initWithPreviousState {
    self = [super init];
    if (self) {
        NSUserDefaults* defaults = [[NSUserDefaults alloc] init];
        self.broadcasting = [defaults boolForKey:kBROADCASTING];
        self.targetAddress = [defaults objectForKey:kTARGET_ADDRESS];
        self.accelerometerSendingData = [defaults boolForKey:kACCELEROMETER_SENDING_DATA];
        self.accelerometerPort = [defaults integerForKey:kACCELEROMETER_PORT];
        self.cameraSendingData = [defaults boolForKey:kCAMERA_SENDING_DATA];
        self.cameraPort = [defaults integerForKey:kCAMERA_PORT];
        self.usingFrontCamera = [defaults boolForKey:kUSING_FRONT_CAMERA];
    }
    return self;
}


#pragma mark Special getters and setters

-(void) setBroadcasting:(BOOL)broadcasting {
    _broadcasting = broadcasting;

    [self updatePersistentState];
}

-(void) setTargetAddress:(NSURL* )targetAddress {
    
    _targetAddress = targetAddress;

    [self updatePersistentState];
}

-(void) setAccelerometerSendingData:(BOOL)accelerometerSendingData {
    _accelerometerSendingData = accelerometerSendingData;

    [self updatePersistentState];
}

-(void) setAccelerometerPort:(NSInteger)accelerometerPort {
    _accelerometerPort = accelerometerPort;

    [self updatePersistentState];
}

-(void) setCameraSendingData:(BOOL)cameraSendingData {
    _cameraSendingData = cameraSendingData;

    [self updatePersistentState];
}

-(void) setCameraPort:(NSInteger)cameraPort {
    _cameraPort = cameraPort;

    [self updatePersistentState];
}

-(void) setUsingFrontCamera:(BOOL)usingFrontCamera {
    _usingFrontCamera = usingFrontCamera;

    [self updatePersistentState];
}

#pragma mark -
@end
