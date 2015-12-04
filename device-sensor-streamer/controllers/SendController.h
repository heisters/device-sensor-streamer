//
//  SendController.h
//  SensorStreamer
//
//  Created by Alex Gittemeier on 3/8/2013.
//  Copyright (c) 2013 Gatormeier Business Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sender.h"

@interface SendController : UITableViewController< MotionDelegate >
@property (strong, nonatomic) Sender *sender;
@property (weak, nonatomic) IBOutlet UISlider *sX;
@property (weak, nonatomic) IBOutlet UISlider *sY;
@property (weak, nonatomic) IBOutlet UISlider *sZ;

@property (weak, nonatomic) IBOutlet UILabel *rX;
@property (weak, nonatomic) IBOutlet UILabel *rY;
@property (weak, nonatomic) IBOutlet UILabel *rZ;

@end
