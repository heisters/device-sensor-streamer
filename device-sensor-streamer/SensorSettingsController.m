    //
    //  SensorSettingsController.m
    //  SensorStreamer
    //
    //  Created by Alex Gittemeier on 3/2/2013.
    //  Copyright (c) 2013 Gatormeier Business Consulting. All rights reserved.
    //

#import "SensorSettingsController.h"

@interface SensorSettingsController()

@end

@implementation SensorSettingsController
#pragma mark Action handlers

- (IBAction)udpModeChanged:(UISegmentedControl *)sender {
        // Update state state of the address field, but nothing else
    switch ([sender selectedSegmentIndex]) {
        case 0:
            self.targetAddress.enabled = YES;
            self.targetAddress.textColor = [UIColor blackColor];
            break;
        case 1:
            self.targetAddress.enabled = NO;
            self.targetAddress.textColor = [UIColor darkGrayColor];
        default:
            break;
    }

    [self settingsChanged];
}

- (IBAction)settingsChanged {
        // Run validation, and store to database
    [self validateAndApplyInput];
    [self storeInput];

}

#pragma mark -
#pragma mark Validation methods

- (void)validateAndApplyInput {
    NSInteger mode = self.udpMode.selectedSegmentIndex;
    NSString* address = self.targetAddress.text;

    BOOL sendAcceleormeterData  = self.shouldSendAccelerometerData.on;
    NSString* accelerometerPort = self.accelerometerPort.text;

    BOOL sendCameraData = self.shouldSendCameraData.on;
    NSString* cameraPort = self.cameraPort.text;
    NSInteger cameraSource = self.cameraSource.selectedSegmentIndex;
        //TODO: implement validation

        //TODO: put all other info into model object
}

#pragma mark -
#pragma mark DB interface methods

-(void) storeInput {
        //TODO: store in DB model object
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
