using Toybox.Application.Storage;
using Toybox.System;
using Toybox.Time;

class SubscriptionManager {
    static var instance = null;
    
    static const KEY_SUBSCRIPTION_STATUS = "subscription_status";
    static const KEY_SUBSCRIPTION_EXPIRY = "subscription_expiry";
    static const GRACE_PERIOD_DAYS = 7;
    
    var isPro;
    var expiryDate;
    
    function initialize() {
        self.isPro = false;
        self.expiryDate = null;
    }
    
    static function getInstance() {
        if (instance == null) {
            instance = new SubscriptionManager();
        }
        return instance;
    }
    
    function checkSubscription() {
        var status = Storage.getValue(KEY_SUBSCRIPTION_STATUS);
        var expiryValue = Storage.getValue(KEY_SUBSCRIPTION_EXPIRY);
        
        if (status == true && expiryValue != null) {
            self.expiryDate = new Time.Moment(expiryValue);
            var now = Time.now();
            
            // Check if subscription is still valid (including grace period)
            if (self.expiryDate.greaterThan(now)) {
                self.isPro = true;
            } else {
                // Check grace period
                var gracePeriodEnd = self.expiryDate.add(new Time.Duration(GRACE_PERIOD_DAYS * 24 * 60 * 60));
                if (gracePeriodEnd.greaterThan(now)) {
                    self.isPro = true; // Still in grace period
                } else {
                    self.isPro = false;
                    self.expireSubscription();
                }
            }
        } else {
            self.isPro = false;
        }
    }
    
    function activateSubscription(months) {
        var now = Time.now();
        var duration = months * 30 * 24 * 60 * 60; // Approximate month duration
        self.expiryDate = now.add(new Time.Duration(duration));
        
        Storage.setValue(KEY_SUBSCRIPTION_STATUS, true);
        Storage.setValue(KEY_SUBSCRIPTION_EXPIRY, self.expiryDate.value());
        
        self.isPro = true;
    }
    
    function expireSubscription() {
        Storage.setValue(KEY_SUBSCRIPTION_STATUS, false);
        self.isPro = false;
    }
    
    function isProActive() {
        return self.isPro;
    }
    
    function getDaysRemaining() {
        if (self.expiryDate == null || !self.isPro) {
            return 0;
        }
        
        var now = Time.now();
        if (self.expiryDate.lessThan(now)) {
            return 0;
        }
        
        var diff = self.expiryDate.subtract(now);
        return (diff.value() / (24 * 60 * 60)).toNumber();
    }
}

