using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;

class PullUpMasterApp extends Application.AppBase {
    
    function initialize() {
        AppBase.initialize();
    }
    
    // Return the initial view of your application here
    function getInitialView() {
        return [ new $.MainView(), new $.MainDelegate() ];
    }
    
    function onStart(state) {
        // Initialize storage and load user data
        $.StorageManager.getInstance(); // This already initializes and loads
        $.UserProfileManager.getInstance().loadProfile();
        $.SubscriptionManager.getInstance().checkSubscription();
    }
    
    function onStop(state) {
        // Save any pending data
        $.StorageManager.getInstance().save();
    }
}

