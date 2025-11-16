using Toybox.Application.Storage;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;

class StorageManager {
    static var instance = null;
    
    static const KEY_SESSIONS = "sessions";
    static const KEY_PROFILE = "profile";
    static const KEY_SUBSCRIPTION = "subscription";
    static const KEY_SETTINGS = "settings";
    
    var sessions;
    var profile;
    var settings;
    
    static function getInstance() {
        if (instance == null) {
            instance = new StorageManager();
            instance.load();
        }
        return instance;
    }
    
    function initialize() {
        self.sessions = [];
        self.profile = null;
        self.settings = {};
    }
    
    function load() {
        // Load sessions
        var sessionsData = Storage.getValue(KEY_SESSIONS);
        if (sessionsData != null && sessionsData instanceof Array) {
            self.sessions = [];
            for (var i = 0; i < sessionsData.size(); i++) {
                try {
                    var session = $.WorkoutSession.fromStorage(sessionsData[i]);
                    self.sessions.add(session);
                } catch (e) {
                    System.println("Error loading session: " + e);
                }
            }
        } else {
            self.sessions = [];
        }
        
        // Load profile
        var profileData = Storage.getValue(KEY_PROFILE);
        if (profileData != null) {
            self.profile = $.UserProfile.fromStorage(profileData);
        } else {
            self.profile = new $.UserProfile();
        }
        
        // Load settings
        self.settings = Storage.getValue(KEY_SETTINGS);
        if (self.settings == null) {
            self.settings = {
                :workoutType => "max",
                :restTime => 120, // seconds
                :notifications => true
            };
        }
    }
    
    function save() {
        // Save sessions
        var sessionsData = [];
        for (var i = 0; i < self.sessions.size(); i++) {
            sessionsData.add(self.sessions[i].toStorage());
        }
        Storage.setValue(KEY_SESSIONS, sessionsData);
        
        // Save profile
        Storage.setValue(KEY_PROFILE, self.profile.toStorage());
        
        // Save settings
        Storage.setValue(KEY_SETTINGS, self.settings);
    }
    
    function addSession(session) {
        self.sessions.add(session);
        self.updateProfileStats(session);
        self.save();
    }
    
    function updateProfileStats(session) {
        // Update max reps if needed
        for (var i = 0; i < session.sets.size(); i++) {
            if (session.sets[i][:reps] > self.profile.maxReps) {
                self.profile.maxReps = session.sets[i][:reps];
            }
        }
        
        // Update max daily total
        if (session.totalReps > self.profile.maxDailyTotal) {
            self.profile.maxDailyTotal = session.totalReps;
        }
        
        self.save();
    }
    
    function getSessionsForPeriod(startDate, endDate) {
        var filtered = [];
        for (var i = 0; i < self.sessions.size(); i++) {
            var session = self.sessions[i];
            if (session.date.greaterThan(startDate) && session.date.lessThan(endDate)) {
                filtered.add(session);
            }
        }
        return filtered;
    }
    
    function getTodaySessions() {
        var now = Time.now();
        var today = Gregorian.moment({
            :year => Gregorian.info(now, Time.FORMAT_SHORT).year,
            :month => Gregorian.info(now, Time.FORMAT_SHORT).month,
            :day => Gregorian.info(now, Time.FORMAT_SHORT).day,
            :hour => 0,
            :minute => 0
        });
        var tomorrow = today.add(new Time.Duration(24 * 60 * 60));
        return self.getSessionsForPeriod(today, tomorrow);
    }
    
    function getThisWeekSessions() {
        var now = Time.now();
        var info = Gregorian.info(now, Time.FORMAT_SHORT);
        var weekStart = Gregorian.moment({
            :year => info.year,
            :month => info.month,
            :day => info.day - info.day_of_week,
            :hour => 0,
            :minute => 0
        });
        return self.getSessionsForPeriod(weekStart, now);
    }
    
    function getThisMonthSessions() {
        var now = Time.now();
        var info = Gregorian.info(now, Time.FORMAT_SHORT);
        var monthStart = Gregorian.moment({
            :year => info.year,
            :month => info.month,
            :day => 1,
            :hour => 0,
            :minute => 0
        });
        return self.getSessionsForPeriod(monthStart, now);
    }
    
    function getLast30DaysSessions() {
        var now = Time.now();
        var thirtyDaysAgo = now.subtract(new Time.Duration(30 * 24 * 60 * 60));
        return self.getSessionsForPeriod(thirtyDaysAgo, now);
    }
}

