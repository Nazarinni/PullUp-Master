using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;

class HistoryView extends WatchUi.View {
    var viewMode; // :today, :week, :month, :records
    var stats;
    
    function initialize() {
        View.initialize();
        self.viewMode = :today;
        self.stats = new $.TrainingStats();
    }
    
    function onLayout(dc) {
    }
    
    function onShow() {
        self.updateStats();
    }
    
    function updateStats() {
        var storage = $.StorageManager.getInstance();
        var sessions = [];
        
        if (self.viewMode == :today) {
            sessions = storage.getTodaySessions();
        } else if (self.viewMode == :week) {
            sessions = storage.getThisWeekSessions();
        } else if (self.viewMode == :month) {
            sessions = storage.getThisMonthSessions();
        } else {
            sessions = storage.sessions;
        }
        
        self.stats.calculate(sessions);
    }
    
    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        var title = "History";
        if (self.viewMode == :today) {
            title = "Today";
        } else if (self.viewMode == :week) {
            title = "This Week";
        } else if (self.viewMode == :month) {
            title = "This Month";
        } else if (self.viewMode == :records) {
            title = "Records";
        }
        dc.drawText(dc.getWidth() / 2, 10, Graphics.FONT_SMALL, title, Graphics.TEXT_JUSTIFY_CENTER);
        
        if (self.viewMode == :records) {
            self.drawRecords(dc);
        } else {
            self.drawStats(dc);
        }
    }
    
    function drawStats(dc) {
        var y = 40;
        
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, y, Graphics.FONT_NUMBER_MEDIUM, 
            self.stats.totalReps.toString(), Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, y + 25, Graphics.FONT_SMALL, "Total Reps", Graphics.TEXT_JUSTIFY_CENTER);
        
        y += 60;
        dc.drawText(10, y, Graphics.FONT_SMALL, "Sessions: " + self.stats.totalSessions, Graphics.TEXT_JUSTIFY_LEFT);
        
        if (self.stats.averageRepsPerSession > 0) {
            y += 25;
            dc.drawText(10, y, Graphics.FONT_SMALL, 
                "Avg/Session: " + self.stats.averageRepsPerSession.format("%.1f"), Graphics.TEXT_JUSTIFY_LEFT);
        }
        
        // Show weekly goal progress if applicable
        var storage = $.StorageManager.getInstance();
        var profile = storage.profile;
        if (self.viewMode == :week && profile.weeklyGoal > 0) {
            y += 30;
            var progress = (self.stats.totalReps.toFloat() / profile.weeklyGoal * 100).toNumber();
            dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
            dc.drawText(10, y, Graphics.FONT_SMALL, 
                "Goal: " + progress + "% (" + self.stats.totalReps + "/" + profile.weeklyGoal + ")", 
                Graphics.TEXT_JUSTIFY_LEFT);
        }
    }
    
    function drawRecords(dc) {
        var storage = $.StorageManager.getInstance();
        var profile = storage.profile;
        var y = 40;
        
        dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, y, Graphics.FONT_MEDIUM, "Personal Records", Graphics.TEXT_JUSTIFY_CENTER);
        
        y += 40;
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(10, y, Graphics.FONT_SMALL, "Max Reps (1 set):", Graphics.TEXT_JUSTIFY_LEFT);
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() - 10, y, Graphics.FONT_NUMBER_MEDIUM, 
            profile.maxReps.toString(), Graphics.TEXT_JUSTIFY_RIGHT);
        
        y += 35;
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(10, y, Graphics.FONT_SMALL, "Max Daily Total:", Graphics.TEXT_JUSTIFY_LEFT);
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() - 10, y, Graphics.FONT_NUMBER_MEDIUM, 
            profile.maxDailyTotal.toString(), Graphics.TEXT_JUSTIFY_RIGHT);
        
        // Show Pro analytics if available
        var subscription = $.SubscriptionManager.getInstance();
        if (subscription.isProActive()) {
            y += 50;
            dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
            dc.drawText(10, y, Graphics.FONT_TINY, "30-Day Volume:", Graphics.TEXT_JUSTIFY_LEFT);
            var recentSessions = storage.getLast30DaysSessions();
            var volume = 0;
            for (var i = 0; i < recentSessions.size(); i++) {
                volume += recentSessions[i].totalReps;
            }
            dc.drawText(dc.getWidth() - 10, y, Graphics.FONT_TINY, volume.toString(), Graphics.TEXT_JUSTIFY_RIGHT);
        }
    }
    
    function onHide() {
    }
}

class HistoryDelegate extends WatchUi.BehaviorDelegate {
    var view;
    
    function initialize(view) {
        BehaviorDelegate.initialize();
        self.view = view;
    }
    
    function onNextPage() {
        // Cycle through view modes
        if (self.view.viewMode == :today) {
            self.view.viewMode = :week;
        } else if (self.view.viewMode == :week) {
            self.view.viewMode = :month;
        } else if (self.view.viewMode == :month) {
            self.view.viewMode = :records;
        } else {
            self.view.viewMode = :today;
        }
        self.view.updateStats();
        WatchUi.requestUpdate();
        return true;
    }
    
    function onPreviousPage() {
        // Cycle backwards
        if (self.view.viewMode == :today) {
            self.view.viewMode = :records;
        } else if (self.view.viewMode == :week) {
            self.view.viewMode = :today;
        } else if (self.view.viewMode == :month) {
            self.view.viewMode = :week;
        } else {
            self.view.viewMode = :month;
        }
        self.view.updateStats();
        WatchUi.requestUpdate();
        return true;
    }
    
    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }
}

