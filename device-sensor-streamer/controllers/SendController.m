//
//  SendController.m
//  SensorStreamer
//
//  Created by Alex Gittemeier on 3/8/2013.
//  Copyright (c) 2013 Gatormeier Business Consulting. All rights reserved.
//

#import "SendController.h"
@import Charts;

@interface SendController()

@property (nonatomic, strong) NSMutableArray* timesData;
@end

@implementation SendController

- (void)viewDidLoad {
    self.sender = [[Sender alloc] initWithSettings:[[SensorSettings alloc] initWithPreviousStateIfPossible]];
    self.sender.delegate = self;


    self.timesData  = [[NSMutableArray alloc] init];
    LineChartDataSet* accelXData = [[LineChartDataSet alloc] initWithYVals:@[] label:@"X"];
    LineChartDataSet* accelYData = [[LineChartDataSet alloc] initWithYVals:@[] label:@"Y"];
    LineChartDataSet* accelZData = [[LineChartDataSet alloc] initWithYVals:@[] label:@"Z"];

    accelXData.lineWidth = 1;
    accelXData.circleRadius = 1;
    [accelXData setColor:[UIColor redColor]];
    [accelXData setCircleColor:[UIColor redColor]];
    accelXData.fillColor = [UIColor redColor];

    accelYData.lineWidth = 1;
    accelYData.circleRadius = 1;
    [accelYData setColor:[UIColor greenColor]];
    [accelYData setCircleColor:[UIColor greenColor]];
    accelYData.fillColor = [UIColor greenColor];

    accelZData.lineWidth = 1;
    accelZData.circleRadius = 1;
    [accelZData setColor:[UIColor blueColor]];
    [accelZData setCircleColor:[UIColor blueColor]];
    accelZData.fillColor = [UIColor blueColor];


    self.accelView.data = [[LineChartData alloc] initWithXVals:@[] dataSets:@[accelXData, accelYData, accelZData]];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [UIApplication sharedApplication].idleTimerDisabled = YES;

    [self.sender start];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [self.sender stop];
}

- (void)didAccelerate:(CMAccelerometerData *)data error:(NSError *)error
{
//    NSDate *now = [NSDate date];
//    [self.timesData addObject:now];
//
//
//    while ( [[self.timesData objectAtIndex:0] timeIntervalSinceNow] < -5.0 ) {
//        [self.timesData removeObjectAtIndex:0];
//        NSInteger i = 0;//self.accelView.data.xValCount - 1;
////        [self.accelView.data remove:i];
//        [self.accelView.data removeEntryByXIndex:i dataSetIndex:0];
//        [self.accelView.data removeEntryByXIndex:i dataSetIndex:1];
//        [self.accelView.data removeEntryByXIndex:i dataSetIndex:2];
//    }
//
//    [self.accelView.data addXValue:[@([now timeIntervalSinceNow]) stringValue]];
//    [self.accelView.data addEntry:[[ChartDataEntry alloc] initWithValue:data.acceleration.x xIndex:[self.accelView.data xValCount]] dataSetIndex:0];
//    [self.accelView.data addEntry:[[ChartDataEntry alloc] initWithValue:data.acceleration.y xIndex:[self.accelView.data xValCount]] dataSetIndex:1];
//    [self.accelView.data addEntry:[[ChartDataEntry alloc] initWithValue:data.acceleration.z xIndex:[self.accelView.data xValCount]] dataSetIndex:2];
//
//    [self.accelView notifyDataSetChanged];
}

- (void)viewDidUnload {
//    [self setSX:nil];
//    [self setSY:nil];
//    [self setSZ:nil];
//    [self setRX:nil];
//    [self setRY:nil];
//    [self setRZ:nil];
    [super viewDidUnload];
}
@end
