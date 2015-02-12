# Cordova Gimbal Plugin

A Cordova plugin for scanning and interacting with [Qualcomm Gimbal](http://gimbal.com) beacons.


## Supported Platforms

- iOS (7.1 and above)


## Supported SDK Features

- Proximity service
- Sightings scanning


## Requirements

- Gimbal Manager account
- Gimbal SDK (The latest version can be obtained from Gimbal Manager web app)


## Installation

### Plugin Setup

```text
cordova plugin add io.hpd.cordova.gimbal
```

Or, alternatively you can install the bleeding edge version from Github:

```text
cordova plugin add https://github.com/happydenn/cordova-plugin-gimbal.git
```

### Gimbal SDK Setup

From the Gimbal SDK, drag and drop the following frameworks from the __Frameworks__ folder to the __Frameworks__ group inside the Xcode project. Be sure to copy the files when asked by Xcode.

```text
Common.embeddedframework
ContextCore.embeddedframework
ContextLocation.embeddedframework
FYX.framework
NetworkServices.embeddedframework
```

Add the following to your project's Info.plist to enable using Bluetooth beacons in background mode.

```xml
<key>UIBackgroundModes</key>
<array>
    <string>bluetooth-central</string>
</array>
```

Finally for iOS 8 and later, you need to add a new entry to your Xcode project's Info.plist to properly request for permission to use the location service which is required by Gimbal SDK.

```xml
<key>NSLocationAlwaysUsageDescription</key>
<string>Specifies the reason for accessing the user's location information.</string>
```


## Usage

The plugin's API is contained inside the ```Gimbal``` object, which is not available until after the ```deviceready``` event.

To be able to use the Gimbal SDK, first you need to start the service. Call the following function with your App ID, App Secret and Callback URL to start the service. (You can get the credentials by creating a new app in Gimbal Manager.)

```javascript
// Gimbal is not available until deviceready
document.addEventListener('deviceready', function() {
	Gimbal.startService('appId', 'appSecret', 'callback://url', function() {
		// service started
		// ...
	}, function() {
		// service not started
		// ...
	});
}, false);
```

After the service has started, you then need to add the callback that will be called every time a Gimbal is sighted. You should register the callback before you call ```startScanSightings```.

Finally, after you have registered the callback, simply call ```startScanSightings``` to start monitoring Gimbal beacons!

Below is a complete example that will start scanning for beacons right after ```deviceready``` event.

```javascript
// Gimbal is not available until deviceready
document.addEventListener('deviceready', function() {
	Gimbal.startService('appId', 'appSecret', 'callback://url', function() {
		// register callback before starting
		Gimbal.didReceiveSighting(function(result) {
			console.log(result); // log the result
		});

		// start scanning
		Gimbal.startScanSightings();
	});
}, false);
```


## TODO

- Implement rest of the Gimbal SDK. Will implement features related to beacons first though.
- Include Android support after the Android Gimbal SDK is out of beta. (https://gimbal.com/doc/proximity_overview.html#platforms)


## Plugin API

### Gimbal.startService(appId, appSecret, callbackUrl, success[, failed])

Start Gimbal service with specified credentials.

- appId: Application ID
- appSecret: Application secret
- callbackUrl: Callback URL
- success: Callback function that runs after the service has started
- failed: Callback function that runs after the service has failed to start

### Gimbal.stopService()

Stop Gimbal service.

### Gimbal.startScanSightings([smoothWindow])

Start scanning for beacon sightings. (Must be called after the service has started.)

- smoothWindow (default: "medium"): Specify a window to "smooth out" RSSI values. Possible values are ```small```, ```medium```, ```large``` and ```none```. Explaination here: https://gimbal.com/doc/proximity/ios.html#scan_with_options

### Gimbal.didReceiveSighting(callback)

Register a callback function that is called every time a beacon is sighted.

- callback: Callback function to be called. Takes one ```result``` argument that contains the sighting result.

#### Sighting result object

- transmitter: An object containing information about the sighted beacon.
  - identifier
  - name
  - ownerId
  - iconUrl
  - battery
  - temperature
- time: Time when the sighting occured.
- RSSI: Signal strength of the sighting.

### Gimbal.stopScanSightings()

Stop scanning for beacon sightings.
