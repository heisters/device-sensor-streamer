    //
    //  SensorSettings.m
    //  SensorStreamer
    //
    //  Created by Alex Gittemeier on 3/3/2013.
    //  Copyright (c) 2013 Gatormeier Business Consulting. All rights reserved.
    //

#import "SensorSettings.h"

#define kSETTINGS_DICTIONARY        @"dictionarySettings"

#define kUSING_BROADCAST            @"usingBroadcast"
#define kTARGET_ADDRESS             @"targetAddress"
#define kTARGET_BROADCAST_ADDRESS   @"targetBroadcastAddress"

#define kACCELEROMETER_SENDING_DATA @"accelerometerSendingData"
#define kACCELEROMETER_PORT         @"accelerometerPort"

#define kDRAW_MODE @"drawMode"

@interface SensorSettings ()

@property (nonatomic, strong) NSUserDefaults* defaults;

@end

@implementation SensorSettings

-(BOOL) setAccelerometerPortWithString:(NSString* )string {
    NSInteger port = [string integerValue];
    if ([[NSString stringWithFormat:@"%ld", (long)port] isEqualToString:string]) {
        self.accelerometerPort = port;
        return YES;
    } else {
        return NO;
    }
}


-(void) writeState {
    NSDictionary* settingsDictionary =
    @{kUSING_BROADCAST: [NSNumber numberWithBool:self.usingBroadcast],
      kTARGET_ADDRESS: self.targetAddress,
      kTARGET_BROADCAST_ADDRESS: self.targetBroadcastAddress,
      kACCELEROMETER_SENDING_DATA: [NSNumber numberWithBool:self.accelerometerSendingData],
      kACCELEROMETER_PORT: [NSString stringWithFormat:@"%ld", (long)self.accelerometerPort],
      kDRAW_MODE: [NSNumber numberWithBool:self.drawMode]
      };

    [self.defaults setObject:settingsDictionary forKey:kSETTINGS_DICTIONARY];
    [self.defaults synchronize];
}

-(void) readState {
    if ([self hasPreviousState]) {
        NSDictionary* settingsDictionary = [self.defaults objectForKey:kSETTINGS_DICTIONARY];

        self.usingBroadcast = [[settingsDictionary objectForKey:kUSING_BROADCAST] boolValue];
        self.targetAddress = [settingsDictionary objectForKey:kTARGET_ADDRESS];
        self.targetBroadcastAddress = [settingsDictionary objectForKey:kTARGET_BROADCAST_ADDRESS];
        self.accelerometerPort = [[settingsDictionary objectForKey:kACCELEROMETER_PORT] integerValue];
        self.accelerometerSendingData = [[settingsDictionary objectForKey:kACCELEROMETER_SENDING_DATA] boolValue];
        self.drawMode = [[settingsDictionary objectForKey:kDRAW_MODE] boolValue];
    }
}

-(id) initWithPreviousStateIfPossible {
    self = [super init];
    if (self) {
        [self readState];
    }
    return self;
}

-(BOOL) hasPreviousState {
    return ([self.defaults objectForKey:kSETTINGS_DICTIONARY] != nil);
}


#pragma mark Special getters and setters

-(NSUserDefaults* )defaults {
    if (!_defaults) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}

-(NSString* )targetAddress {
    if (!_targetAddress) {
        //Serves as default "Unicast address"
        _targetAddress = @"192.168.x.x";
    }
    return _targetAddress;
}

-(NSString *)targetBroadcastAddress {
    if ( !_targetBroadcastAddress ) {
        _targetBroadcastAddress = @"255.255.255.255";
    }
    return _targetBroadcastAddress;
}

#pragma mark -
@end
