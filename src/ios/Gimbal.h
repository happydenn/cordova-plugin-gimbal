//
//  Gimbal.h
//  Gimbal Proximity Beacon Plugin for Cordova
//
//  Created by Denny Tsai on 2/11/15.
//
//

#import <Foundation/Foundation.h>
#import <Cordova/CDV.h>
#import <FYX/FYX.h>
#import <FYX/FYXSightingManager.h>

@interface Gimbal : CDVPlugin <FYXServiceDelegate, FYXSightingDelegate>

@property (nonatomic, strong) FYXSightingManager *sightingManager;

- (void)startService:(CDVInvokedUrlCommand *)command;
- (void)stopService:(CDVInvokedUrlCommand *)command;

- (void)startScanSightings:(CDVInvokedUrlCommand *)command;
- (void)didReceiveSighting:(CDVInvokedUrlCommand *)command;
- (void)stopScanSightings:(CDVInvokedUrlCommand *)command;

@end
