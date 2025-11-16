using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;

class RestTimeView extends WatchUi.View {
    var restTime; // in seconds
    
    function initialize() {
        View.initialize();
        var storage = $.StorageManager.getInstance();
        self.restTime = storage.settings[:restTime];
        if (self.restTime == null) {
            self.restTime = 120; // 2 minutes default
        }
    }
    
    function onLayout(dc) {
    }
    
    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, 10, Graphics.FONT_SMALL, "Rest Time", Graphics.TEXT_JUSTIFY_CENTER);
        
        var minutes = self.restTime / 60;
        var seconds = self.restTime % 60;
        
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2 - 10, Graphics.FONT_NUMBER_MEDIUM, 
            minutes.toString() + ":" + seconds.format("%02d"), Graphics.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2 + 30, Graphics.FONT_SMALL, "between sets", Graphics.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, dc.getHeight() - 20, Graphics.FONT_TINY, 
            "Up/Down: Adjust | Select: Save", Graphics.TEXT_JUSTIFY_CENTER);
    }
}

class RestTimeDelegate extends WatchUi.BehaviorDelegate {
    var view;
    
    function initialize(view) {
        BehaviorDelegate.initialize();
        self.view = view;
    }
    
    function onSelect() {
        var storage = $.StorageManager.getInstance();
        storage.settings[:restTime] = self.view.restTime;
        storage.save();
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }
    
    function onNextPage() {
        self.view.restTime += 15;
        if (self.view.restTime > 600) { // Max 10 minutes
            self.view.restTime = 600;
        }
        WatchUi.requestUpdate();
        return true;
    }
    
    function onPreviousPage() {
        self.view.restTime -= 15;
        if (self.view.restTime < 30) { // Min 30 seconds
            self.view.restTime = 30;
        }
        WatchUi.requestUpdate();
        return true;
    }
    
    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }
}

