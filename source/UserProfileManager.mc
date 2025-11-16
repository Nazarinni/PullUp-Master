using Toybox.UserProfile;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;

class UserProfileManager {
    static var instance = null;
    
    function initialize() {
    }
    
    static function getInstance() {
        if (instance == null) {
            instance = new UserProfileManager();
        }
        return instance;
    }
    
    function loadProfile() {
        var storage = $.StorageManager.getInstance();
        var profile = storage.profile;
        
        // Try to get data from Garmin user profile
        try {
            var userProfile = UserProfile.getProfile();
            
            if (userProfile != null) {
                // Get weight (in kg)
                if (userProfile.weight != null) {
                    profile.weight = userProfile.weight;
                }
                
                // Get height (in cm)
                if (userProfile.height != null) {
                    profile.height = userProfile.height;
                }
                
                // Get birth year and calculate age
                if (userProfile.birthYear != null) {
                    var currentYear = Gregorian.info(Time.now(), Time.FORMAT_SHORT).year;
                    profile.age = currentYear - userProfile.birthYear;
                }
                
                // Get gender (0 = male, 1 = female)
                if (userProfile.gender != null) {
                    profile.gender = userProfile.gender;
                }
                
                storage.save();
            }
        } catch (e) {
            System.println("Error loading user profile: " + e);
        }
        
        return profile;
    }
    
    function getProfile() {
        return $.StorageManager.getInstance().profile;
    }
}

