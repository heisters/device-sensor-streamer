//
//  SensorSettingsController.h
//  SensorStreamer
//
//  Created by Alex Gittemeier on 3/2/2013.
//  Copyright (c) 2013 Gatormeier Business Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SensorSettings.h"

@interface SensorSettingsController : UITableViewController<UITextFieldDelegate>
#pragma mark Actions

- (IBAction)udpModeChanged:(UISegmentedControl *)sender;
- (IBAction)settingsChanged;

#pragma mark -
#pragma mark Outlets

@property (weak, nonatomic) IBOutlet UISegmentedControl *udpMode;
@property (weak, nonatomic) IBOutlet UITextField *targetAddress;
@property (weak, nonatomic) IBOutlet UISwitch *shouldSendAccelerometerData;
@property (weak, nonatomic) IBOutlet UITextField *accelerometerPort;
@property (weak, nonatomic) IBOutlet UISwitch *shouldSendCameraData;
@property (weak, nonatomic) IBOutlet UITextField *cameraPort;
@property (weak, nonatomic) IBOutlet UISegmentedControl *cameraSource;

#pragma mark -
@end
