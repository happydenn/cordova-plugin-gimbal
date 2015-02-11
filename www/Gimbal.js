/**
 * Cordova Gimbal Plugin
 */

cordova.define('io.hpd.cordova.gimbal.Gimbal', function(require, exports, module) {

    var exec = require('cordova/exec');

    exports.startService = function(appId, appSecret, callbackUrl, success, failed) {
        exec(success, failed, 'Gimbal', 'startService', [appId, appSecret, callbackUrl]);
    };

    exports.stopService = function() {
        exec(function() {}, function() {}, 'Gimbal', 'stopService', []);
    };

    exports.startScanSightings = function(smoothWindow) {
        if (typeof smoothWindow === 'undefined') {
            smoothWindow = '';
        }
        
        exec(function() {}, function() {}, 'Gimbal', 'startScanSightings', [smoothWindow]);
    };

    exports.didReceiveSighting = function(success) {
        exec(success, function() {}, 'Gimbal', 'didReceiveSighting', []);
    };

    exports.stopScanSightings = function() {
        exec(function() {}, function() {}, 'Gimbal', 'stopScanSightings', []);
    };

});
