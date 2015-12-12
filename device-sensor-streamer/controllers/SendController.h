//
//  SendController.h
//  SensorStreamer
//
//  Created by Alex Gittemeier on 3/8/2013.
//  Copyright (c) 2013 Gatormeier Business Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sender.h"

@class LineChartView;

@interface SendController : UITableViewController< MotionDelegate >
@property (weak, nonatomic) IBOutlet LineChartView *accelView;
@property (strong, nonatomic) Sender *sender;
@end
