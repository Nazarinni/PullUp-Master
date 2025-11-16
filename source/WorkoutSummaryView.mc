using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;

class WorkoutSummaryView extends WatchUi.View {
    var session;
    
    function initialize(session) {
        View.initialize();
        self.session = session;
    }
    
    function onLayout(dc) {
    }
    
    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, 10, Graphics.FONT_SMALL, "Workout Complete!", Graphics.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, 50, Graphics.FONT_NUMBER_MEDIUM, 
            self.session.totalReps.toString(), Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, 80, Graphics.FONT_SMALL, "Total Reps", Graphics.TEXT_JUSTIFY_CENTER);
        
        dc.drawText(dc.getWidth() / 2, 110, Graphics.FONT_SMALL, 
            "Sets: " + self.session.sets.size(), Graphics.TEXT_JUSTIFY_CENTER);
        
        // Check for PRs
        var storage = $.StorageManager.getInstance();
        var profile = storage.profile;
        var isPR = false;
        var prText = "";
        
        for (var i = 0; i < self.session.sets.size(); i++) {
            if (self.session.sets[i][:reps] == profile.maxReps && profile.maxReps > 0) {
                isPR = true;
                prText = "New Max Reps PR!";
                break;
            }
        }
        
        if (self.session.totalReps == profile.maxDailyTotal && profile.maxDailyTotal > 0) {
            isPR = true;
            prText = "New Daily Total PR!";
        }
        
        if (isPR) {
            dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
            dc.drawText(dc.getWidth() / 2, 140, Graphics.FONT_SMALL, prText, Graphics.TEXT_JUSTIFY_CENTER);
        }
        
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, dc.getHeight() - 20, Graphics.FONT_TINY, 
            "Press Back to continue", Graphics.TEXT_JUSTIFY_CENTER);
    }
}

class WorkoutSummaryDelegate extends WatchUi.BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();
    }
    
    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }
}

