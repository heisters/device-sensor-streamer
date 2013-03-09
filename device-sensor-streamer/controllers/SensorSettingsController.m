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
        self.udpMode.selectedSegmentIndex = (usingBrodacast ? 1 : 0);
        self.targetAddress.text = self.sensorSettings.targetAddress;

        self.shouldSendAccelerometerData.on = self.sensorSettings.isAccelerometerSendingData;
        self.accelerometerPort.text = [NSString stringWithFormat:@"%d", self.sensorSettings.accelerometerPort];

        self.shouldSendCameraData.on = self.sensorSettings.isCameraSendingData;
        self.cameraPort.text = [NSString stringWithFormat:@"%d", self.sensorSettings.cameraPort];
        BOOL usingFront = self.sensorSettings.isUsingFrontCamera;
        self.cameraSource.selectedSegmentIndex = (usingFront ? 0 : 1);

            // Update states of segment buttons
        [self udpModeChanged:self.udpMode];
    }
}

- (IBAction)udpModeChanged:(UISegmentedControl *)sender {
        // Update state state of the address field, but nothing else
    switch ([sender selectedSegmentIndex]) {
        case 0:
            self.targetAddress.enabled = YES;
                // Return text to what it was set
            self.targetAddress.text = self.sensorSettings.targetAddress;
            break;
        case 1:
            self.targetAddress.enabled = NO;
                // Allow placeholder text to "show" thru
            self.targetAddress.text = @"";
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

    BOOL sendCameraData = self.shouldSendCameraData.on;
    NSString* cameraPort = self.cameraPort.text;
    NSInteger cameraSource = self.cameraSource.selectedSegmentIndex;
    BOOL cameraFront = (cameraSource == 0);

        // Set direct settings
    self.sensorSettings.usingBroadcast = usingBroadcast;
    self.sensorSettings.accelerometerSendingData = sendAccelerometerData;
    self.sensorSettings.cameraSendingData = sendCameraData;
    self.sensorSettings.usingFrontCamera = cameraFront;
    if (!usingBroadcast) {
            // Treat broadcast as special case: keep current value
        self.sensorSettings.targetAddress = address;
    }
        // Set settings that require internal validation
    if ([self.sensorSettings setAccelerometerPortWithString:accelerometerPort]) {
        self.accelerometerPort.backgroundColor = [UIColor whiteColor];
    } else {
        self.accelerometerPort.backgroundColor = [UIColor redColor];
    }
    
    if ([self.sensorSettings setCameraPortWithString:cameraPort]) {
        self.cameraPort.backgroundColor = [UIColor whiteColor];
    } else {
        self.cameraPort.backgroundColor = [UIColor redColor];
    }

    [self.sensorSettings updatePersistentState];
}

#pragma mark -
#pragma mark UI controller methods

- (void)viewDidUnload {
    [self setTargetAddress:nil];
    [self setUdpMode:nil];
    [self setShouldSendAccelerometerData:nil];
    [self setAccelerometerPort:nil];
    [self setShouldSendCameraData:nil];
    [self setCameraPort:nil];
    [self setCameraSource:nil];
    [super viewDidUnload];
}

- (BOOL)textFieldShouldReturn:(UITextField*)sender
{
    [sender resignFirstResponder];
    return YES;
}

#pragma mark -
@end
