using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;

class SettingsView extends WatchUi.View {
    var selectedIndex;
    var menuItems;
    
    function initialize() {
        View.initialize();
        self.selectedIndex = 0;
        self.menuItems = [
            {:label => "Weekly Goal", :action => :weekly_goal},
            {:label => "Workout Type", :action => :workout_type},
            {:label => "Rest Time", :action => :rest_time},
            {:label => "About", :action => :about}
        ];
    }
    
    function onLayout(dc) {
    }
    
    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, 10, Graphics.FONT_SMALL, "Settings", Graphics.TEXT_JUSTIFY_CENTER);
        
        var y = 40;
        var itemHeight = 30;
        for (var i = 0; i < self.menuItems.size(); i++) {
            var item = self.menuItems[i];
            if (i == self.selectedIndex) {
                dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
                dc.fillRectangle(10, y - 2, dc.getWidth() - 20, itemHeight);
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            } else {
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            }
            
            var label = item[:label];
            if (item[:action] == :weekly_goal) {
                var storage = $.StorageManager.getInstance();
                label += ": " + storage.profile.weeklyGoal;
            } else if (item[:action] == :workout_type) {
                var storage = $.StorageManager.getInstance();
                var type = storage.settings[:workoutType];
                if (type == null) {
                    type = "max";
                }
                label += ": " + type;
            } else if (item[:action] == :rest_time) {
                var storage = $.StorageManager.getInstance();
                var restTime = storage.settings[:restTime];
                if (restTime == null) {
                    restTime = 120;
                }
                label += ": " + (restTime / 60) + " min";
            }
            
            dc.drawText(dc.getWidth() / 2, y, Graphics.FONT_SMALL, label, Graphics.TEXT_JUSTIFY_CENTER);
            y += itemHeight + 5;
        }
        
        // Show subscription status
        var subscription = $.SubscriptionManager.getInstance();
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        if (subscription.isProActive()) {
            var daysRemaining = subscription.getDaysRemaining();
            dc.drawText(dc.getWidth() / 2, dc.getHeight() - 20, Graphics.FONT_TINY, 
                "Pro: " + daysRemaining + " days left", Graphics.TEXT_JUSTIFY_CENTER);
        } else {
            dc.drawText(dc.getWidth() / 2, dc.getHeight() - 20, Graphics.FONT_TINY, 
                "Free Version", Graphics.TEXT_JUSTIFY_CENTER);
        }
    }
    
    function onHide() {
    }
}

class SettingsDelegate extends WatchUi.BehaviorDelegate {
    var view;
    
    function initialize(view) {
        BehaviorDelegate.initialize();
        self.view = view;
    }
    
    function onSelect() {
        var action = self.view.menuItems[self.view.selectedIndex][:action];
        
        if (action == :weekly_goal) {
            WatchUi.pushView(new $.WeeklyGoalView(), new $.WeeklyGoalDelegate(), WatchUi.SLIDE_LEFT);
        } else if (action == :workout_type) {
            WatchUi.pushView(new $.WorkoutTypeView(), new $.WorkoutTypeDelegate(), WatchUi.SLIDE_LEFT);
        } else if (action == :rest_time) {
            WatchUi.pushView(new $.RestTimeView(), new $.RestTimeDelegate(), WatchUi.SLIDE_LEFT);
        } else if (action == :about) {
            WatchUi.pushView(new $.AboutView(), new $.AboutDelegate(), WatchUi.SLIDE_LEFT);
        }
        return true;
    }
    
    function onNextPage() {
        self.view.selectedIndex = (self.view.selectedIndex + 1) % self.view.menuItems.size();
        WatchUi.requestUpdate();
        return true;
    }
    
    function onPreviousPage() {
        self.view.selectedIndex = (self.view.selectedIndex - 1 + self.view.menuItems.size()) % self.view.menuItems.size();
        WatchUi.requestUpdate();
        return true;
    }
    
    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }
}

