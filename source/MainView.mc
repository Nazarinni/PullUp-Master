using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;

class MainView extends WatchUi.View {
    var menuItems;
    var selectedIndex;
    
    function initialize() {
        View.initialize();
        self.menuItems = [
            {:label => "Start Workout", :action => :start_workout},
            {:label => "History", :action => :history},
            {:label => "Settings", :action => :settings}
        ];
        
        // Add Pro features if active
        var subscription = $.SubscriptionManager.getInstance();
        if (subscription.isProActive()) {
            self.menuItems.add({:label => "AI Coach", :action => :ai_coach});
        } else {
            self.menuItems.add({:label => "Upgrade to Pro", :action => :upgrade});
        }
        
        self.selectedIndex = 0;
    }
    
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
    }
    
    function onShow() {
    }
    
    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, 10, Graphics.FONT_SMALL, "PullUp Master", Graphics.TEXT_JUSTIFY_CENTER);
        
        // Draw menu items
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
            dc.drawText(dc.getWidth() / 2, y, Graphics.FONT_SMALL, item[:label], Graphics.TEXT_JUSTIFY_CENTER);
            y += itemHeight + 5;
        }
        
        // Show today's stats at bottom
        var storage = $.StorageManager.getInstance();
        var todaySessions = storage.getTodaySessions();
        var todayTotal = 0;
        for (var i = 0; i < todaySessions.size(); i++) {
            todayTotal += todaySessions[i].totalReps;
        }
        
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, dc.getHeight() - 20, Graphics.FONT_TINY, "Today: " + todayTotal + " reps", Graphics.TEXT_JUSTIFY_CENTER);
    }
    
    function onHide() {
    }
}

class MainDelegate extends WatchUi.BehaviorDelegate {
    var view;
    
    function initialize(view) {
        BehaviorDelegate.initialize();
        self.view = view;
    }
    
    function onSelect() {
        var menuItems = self.view.menuItems;
        var selectedIndex = self.view.selectedIndex;
        
        if (selectedIndex < menuItems.size()) {
            var action = menuItems[selectedIndex][:action];
            
            if (action == :start_workout) {
                WatchUi.pushView(new $.WorkoutView(), new $.WorkoutDelegate(), WatchUi.SLIDE_LEFT);
            } else if (action == :history) {
                WatchUi.pushView(new $.HistoryView(), new $.HistoryDelegate(), WatchUi.SLIDE_LEFT);
            } else if (action == :settings) {
                WatchUi.pushView(new $.SettingsView(), new $.SettingsDelegate(), WatchUi.SLIDE_LEFT);
            } else if (action == :ai_coach) {
                WatchUi.pushView(new $.AICoachView(), new $.AICoachDelegate(), WatchUi.SLIDE_LEFT);
            } else if (action == :upgrade) {
                WatchUi.pushView(new $.UpgradeView(), new $.UpgradeDelegate(), WatchUi.SLIDE_LEFT);
            }
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

