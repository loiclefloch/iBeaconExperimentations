//
//  ViewController.m
//  iBeaconTest
//
//  Created by Loïc Lefloch on 30/06/15.
//  Copyright (c) 2015 PayMyTable. All rights reserved.
//

#import "ViewController.h"
@import CoreLocation;

#define UUID @"B9407F30-F5F8-466E-AFF9-25556B57FE6D" // Francois iBeacon id

@interface ViewController () <CLLocationManagerDelegate>
    @property (weak, nonatomic) IBOutlet UILabel *theLabel;
    @property CLLocationManager *locationManager;
    @property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.theLabel.text = @"0 beacon (s)";
}

- (void)viewDidAppear:(BOOL)animated {
    // This location manager will be used to notify the user of region state transitions.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }

    // if region monitoring is enabled, update the region being monitored
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:UUID];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"com.pmttest"];

    self.beaconRegion.notifyOnEntry = true;
    self.beaconRegion.notifyOnExit = true;
    self.beaconRegion.notifyEntryStateOnDisplay = true;

    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    self.theLabel.text = @"";

    NSMutableString* str = [[NSMutableString alloc] init];
    NSString *title;
    [str appendString:[NSString stringWithFormat:@"%d beacon(s)\n", beacons.count]];

    for (CLBeacon* beacon in beacons) {
        switch (beacon.proximity)
        {
        case CLProximityImmediate:
            title = NSLocalizedString(@"Immediate", @"Immediate section header title");
            break;

        case CLProximityNear:
            title = NSLocalizedString(@"Near", @"Near section header title");
            break;

        case CLProximityFar:
            title = NSLocalizedString(@"Far", @"Far section header title");
            break;

        default:
            title = NSLocalizedString(@"Unknown", @"Unknown section header title");
            break;
        }
        [str appendString:[NSString stringWithFormat:@"Maj: %@, Min: %@, prox: %@\n", beacon.major, beacon.minor, title]];
    }
    self.theLabel.text = str;
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"Failed monitoring region: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location manager failed: %@", error);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
