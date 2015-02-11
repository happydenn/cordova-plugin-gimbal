//
//  Gimbal.m
//  Gimbal Proximity Beacon Plugin for Cordova
//
//  Created by Denny Tsai on 2/11/15.
//
//

#import "Gimbal.h"
#import <FYX/FYXTransmitter.h>

@implementation Gimbal {
    NSDateFormatter *dateFormatter;
    NSString *startServiceCallbackId;
    NSString *didReceiveSightingCallbackId;
}

- (void)pluginInitialize {
    [super pluginInitialize];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
}

#pragma mark - JavaScript methods

- (void)startService:(CDVInvokedUrlCommand *)command {
    if (command.arguments.count != 3) {
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:command.callbackId];
        return;
    }
    
    NSString *appId = command.arguments[0];
    NSString *appSecret = command.arguments[1];
    NSString *callbackUrl = command.arguments[2];
    startServiceCallbackId = command.callbackId;
    
    [self.commandDelegate runInBackground:^{
        [FYX setAppId:appId appSecret:appSecret callbackUrl:callbackUrl];
        [FYX startService:self];
    }];
}

- (void)stopService:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        [FYX stopService];
    }];
}

- (void)startScanSightings:(CDVInvokedUrlCommand *)command {
    NSString *window = command.arguments[0];
    int windowValue = FYXSightingOptionSignalStrengthWindowMedium;
    
    if (window != nil) {
        if ([window isEqualToString:@"none"]) {
            windowValue = FYXSightingOptionSignalStrengthWindowNone;
            
        } else if ([window isEqualToString:@"small"]) {
            windowValue = FYXSightingOptionSignalStrengthWindowSmall;
            
        } else if ([window isEqualToString:@"large"]) {
            windowValue = FYXSightingOptionSignalStrengthWindowLarge;
        }
    }
    
    [self.commandDelegate runInBackground:^{
        if (self.sightingManager == nil) {
            self.sightingManager = [[FYXSightingManager alloc] init];
            self.sightingManager.delegate = self;
        }
        
        [self.sightingManager scanWithOptions:@{FYXSightingOptionSignalStrengthWindowKey: [NSNumber numberWithInt:windowValue]}];
    }];
}

- (void)didReceiveSighting:(CDVInvokedUrlCommand *)command {
    didReceiveSightingCallbackId = command.callbackId;
}

- (void)stopScanSightings:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        [self.sightingManager stopScan];
    }];
}

#pragma mark - FYXServiceDelegate methods

- (void)serviceStarted {
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:startServiceCallbackId];
}

- (void)startServiceFailed:(NSError *)error {
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:startServiceCallbackId];
}

#pragma mark - FYXSightingDelegate methods

- (void)didReceiveSighting:(FYXTransmitter *)transmitter time:(NSDate *)time RSSI:(NSNumber *)RSSI {
    if (didReceiveSightingCallbackId == nil) { return; }
    
    NSDictionary *result = @{
        @"transmitter": @{
            @"identifier": (transmitter.identifier != nil) ? transmitter.identifier : [NSNull null],
            @"name": (transmitter.name != nil) ? transmitter.name : [NSNull null],
            @"ownerId": (transmitter.ownerId != nil) ? transmitter.ownerId : [NSNull null],
            @"iconUrl": (transmitter.iconUrl != nil) ? transmitter.iconUrl : [NSNull null],
            @"battery": (transmitter.battery != nil) ? transmitter.battery : [NSNull null],
            @"temperature": (transmitter.temperature != nil) ? transmitter.temperature : [NSNull null],
        },
        @"time": [dateFormatter stringFromDate:time],
        @"RSSI": RSSI,
    };
    
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
    pluginResult.keepCallback = [NSNumber numberWithBool:YES];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:didReceiveSightingCallbackId];
}

@end
