using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;

class WeeklyGoalView extends WatchUi.View {
    var goal;
    
    function initialize() {
        View.initialize();
        var storage = $.StorageManager.getInstance();
        self.goal = storage.profile.weeklyGoal;
        if (self.goal == null || self.goal == 0) {
            self.goal = 50;
        }
    }
    
    function onLayout(dc) {
    }
    
    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, 10, Graphics.FONT_SMALL, "Weekly Goal", Graphics.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2 - 10, Graphics.FONT_NUMBER_HOT, 
            self.goal.toString(), Graphics.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2 + 30, Graphics.FONT_SMALL, "pull-ups per week", Graphics.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, dc.getHeight() - 20, Graphics.FONT_TINY, 
            "Up/Down: Adjust | Select: Save", Graphics.TEXT_JUSTIFY_CENTER);
    }
}

class WeeklyGoalDelegate extends WatchUi.BehaviorDelegate {
    var view;
    
    function initialize(view) {
        BehaviorDelegate.initialize();
        self.view = view;
    }
    
    function onSelect() {
        var storage = $.StorageManager.getInstance();
        storage.profile.weeklyGoal = self.view.goal;
        storage.save();
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }
    
    function onNextPage() {
        self.view.goal += 5;
        if (self.view.goal > 1000) {
            self.view.goal = 1000;
        }
        WatchUi.requestUpdate();
        return true;
    }
    
    function onPreviousPage() {
        self.view.goal -= 5;
        if (self.view.goal < 5) {
            self.view.goal = 5;
        }
        WatchUi.requestUpdate();
        return true;
    }
    
    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }
}

