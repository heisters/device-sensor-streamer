//
//  SensorSettingsController.m
//  SensorStreamer
//
//  Created by Alex Gittemeier on 3/2/2013.
//  Copyright (c) 2013 Gatormeier Business Consulting. All rights reserved.
//

#import "SensorSettingsController.h"

@interface SensorSettingsController()

@property (nonatomic, strong) SensorSettings* sensorSettings;

@end

@implementation SensorSettingsController

-(SensorSettings* )sensorSettings {
    if (!_sensorSettings) {
        _sensorSettings = [[SensorSettings alloc] initWithPreviousStateIfPossible];
    }
    return _sensorSettings;
}

#pragma mark Action handlers

- (void) viewDidLoad {
    if ([self.sensorSettings hasPreviousState]) {
        BOOL usingBrodacast = self.sensorSettings.isUsingBroadcast;
        NSString *host = usingBrodacast ? self.sensorSettings.targetBroadcastAddress : self.sensorSettings.targetAddress;
        self.udpMode.selectedSegmentIndex = (usingBrodacast ? 1 : 0);
        self.targetAddress.text = host;

        self.shouldSendAccelerometerData.on = self.sensorSettings.isAccelerometerSendingData;
        self.accelerometerPort.text = [NSString stringWithFormat:@"%ld", (long)self.sensorSettings.accelerometerPort];

        // Update states of segment buttons
        [self udpModeChanged:self.udpMode];
    }
}

- (IBAction)udpModeChanged:(UISegmentedControl *)sender {
    // Update state state of the address field, but nothing else
    switch ([sender selectedSegmentIndex]) {
        case 0:
            self.targetAddress.text = self.sensorSettings.targetAddress;
            break;
        case 1:
            self.targetAddress.text = self.sensorSettings.targetBroadcastAddress;
        default:
            break;
    }

    [self settingsChanged];
}

- (IBAction)settingsChanged {
        // store to database, and apply to running models
    [self storeInput];
    
}

#pragma mark -
#pragma mark Other methods

- (void)storeInput {
    NSInteger mode = self.udpMode.selectedSegmentIndex;
    BOOL usingBroadcast = (mode == 1);
    NSString* address = self.targetAddress.text;

    BOOL sendAccelerometerData  = self.shouldSendAccelerometerData.on;
    NSString* accelerometerPort = self.accelerometerPort.text;

    // Set direct settings
    self.sensorSettings.usingBroadcast = usingBroadcast;
    self.sensorSettings.accelerometerSendingData = sendAccelerometerData;
    if ( usingBroadcast ) {
        self.sensorSettings.targetBroadcastAddress = address;
    } else {
        // Treat broadcast as special case: keep current value
        self.sensorSettings.targetAddress = address;
    }
    // Set settings that require internal validation
    if ([self.sensorSettings setAccelerometerPortWithString:accelerometerPort]) {
        self.accelerometerPort.backgroundColor = [UIColor whiteColor];
    } else {
        self.accelerometerPort.backgroundColor = [UIColor redColor];
    }

    [self.sensorSettings writeState];
}

#pragma mark -
#pragma mark UI controller methods

- (void)viewDidUnload {
    [self setTargetAddress:nil];
    [self setUdpMode:nil];
    [self setShouldSendAccelerometerData:nil];
    [self setAccelerometerPort:nil];
    [super viewDidUnload];
}

- (BOOL)textFieldShouldReturn:(UITextField*)sender
{
    [sender resignFirstResponder];
    return YES;
}

#pragma mark -
@end
