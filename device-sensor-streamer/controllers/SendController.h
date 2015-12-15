//
//  SendController.h
//  SensorStreamer
//
//  Created by Alex Gittemeier on 3/8/2013.
//  Copyright (c) 2013 Gatormeier Business Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sender.h"

@class GraphView;

@interface SendController : UIViewController< MotionDelegate >
@property (weak, nonatomic) IBOutlet GraphView *accelView;
@property (weak, nonatomic) IBOutlet GraphView *orientationView;
@property (weak, nonatomic) IBOutlet GraphView *userAccelView;
@property (strong, nonatomic) Sender *sender;
@end
