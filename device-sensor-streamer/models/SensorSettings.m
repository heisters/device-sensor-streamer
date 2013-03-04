    //
    //  SensorSettings.m
    //  SensorStreamer
    //
    //  Created by Alex Gittemeier on 3/3/2013.
    //  Copyright (c) 2013 Gatormeier Business Consulting. All rights reserved.
    //

#import "SensorSettings.h"

#define kUSING_BROADCAST            @"usingBroadcast"
#define kTARGET_ADDRESS             @"targetAddress"

#define kACCELEROMETER_SENDING_DATA @"accelerometerSendingData"
#define kACCELEROMETER_PORT         @"accelerometerPort"

#define kCAMERA_SENDING_DATA        @"cameraSendingData"
#define kCAMERA_PORT                @"cameraPort"
#define kUSING_FRONT_CAMERA         @"usingFrontCamera"

@interface SensorSettings ()

@property (nonatomic, strong) NSUserDefaults* defaults;

@end

@implementation SensorSettings

-(BOOL) setAccelerometerPortWithString:(NSString* )string {
    NSInteger port = [string integerValue];
    if ([[NSString stringWithFormat:@"%d", port] isEqualToString:string]) {
        self.accelerometerPort = port;
        return YES;
    } else {
        return NO;
    }
}

-(BOOL) setCameraPortWithString:(NSString* )string {
    NSInteger port = [string integerValue];
    if ([[NSString stringWithFormat:@"%d", port] isEqualToString:string]) {
        self.cameraPort = port;
        return YES;
    } else {
        return NO;
    }
}

-(void) updatePersistentState {
    [self.defaults setBool:self.usingBroadcast forKey:kUSING_BROADCAST];
    [self.defaults setObject:self.targetAddress forKey:kTARGET_ADDRESS];
    [self.defaults setBool:self.accelerometerSendingData forKey:kACCELEROMETER_SENDING_DATA];
    [self.defaults setInteger:self.accelerometerPort forKey:kACCELEROMETER_PORT];
    [self.defaults setBool:self.cameraSendingData forKey:kCAMERA_SENDING_DATA];
    [self.defaults setInteger:self.cameraPort forKey:kCAMERA_PORT];
    [self.defaults setBool:self.usingFrontCamera forKey:kUSING_FRONT_CAMERA];
    [self.defaults synchronize];
}

-(id) initWithPreviousStateIfPossible {
    self = [super init];
    if (self) {
        if ([self hasPreviousState]) {
            self.usingBroadcast = [self.defaults boolForKey:kUSING_BROADCAST];
            self.targetAddress = [self.defaults stringForKey:kTARGET_ADDRESS];
            self.accelerometerSendingData = [self.defaults boolForKey:kACCELEROMETER_SENDING_DATA];
            self.accelerometerPort = [self.defaults integerForKey:kACCELEROMETER_PORT];
            self.cameraSendingData = [self.defaults boolForKey:kCAMERA_SENDING_DATA];
            self.cameraPort = [self.defaults integerForKey:kCAMERA_PORT];
            self.usingFrontCamera = [self.defaults boolForKey:kUSING_FRONT_CAMERA];
        }
    }
    return self;
}

-(BOOL) hasPreviousState {
    return ([self.defaults objectForKey:kTARGET_ADDRESS] != nil);
}


#pragma mark Special getters and setters

-(NSUserDefaults* )defaults {
    if (!_defaults) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}

-(void) setUsingBroadcast:(BOOL)usingBroadcast {
    _usingBroadcast = usingBroadcast;

    [self updatePersistentState];
}

-(void) setTargetAddress:(NSString* )targetAddress {

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
