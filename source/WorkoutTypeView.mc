using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;

class WorkoutTypeView extends WatchUi.View {
    var selectedIndex;
    var types;
    
    function initialize() {
        View.initialize();
        self.types = ["max", "pyramid", "emom", "custom"];
        var storage = $.StorageManager.getInstance();
        var currentType = storage.settings[:workoutType];
        if (currentType == null) {
            currentType = "max";
        }
        self.selectedIndex = 0;
        for (var i = 0; i < self.types.size(); i++) {
            if (self.types[i].equals(currentType)) {
                self.selectedIndex = i;
                break;
            }
        }
    }
    
    function onLayout(dc) {
    }
    
    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, 10, Graphics.FONT_SMALL, "Workout Type", Graphics.TEXT_JUSTIFY_CENTER);
        
        var labels = ["3x Max Reps", "Pyramid", "EMOM 10 min", "Custom"];
        var y = 50;
        var itemHeight = 35;
        
        for (var i = 0; i < labels.size(); i++) {
            if (i == self.selectedIndex) {
                dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
                dc.fillRectangle(10, y - 2, dc.getWidth() - 20, itemHeight);
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            } else {
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            }
            dc.drawText(dc.getWidth() / 2, y, Graphics.FONT_SMALL, labels[i], Graphics.TEXT_JUSTIFY_CENTER);
            y += itemHeight + 5;
        }
    }
}

class WorkoutTypeDelegate extends WatchUi.BehaviorDelegate {
    var view;
    
    function initialize(view) {
        BehaviorDelegate.initialize();
        self.view = view;
    }
    
    function onSelect() {
        var storage = $.StorageManager.getInstance();
        storage.settings[:workoutType] = self.view.types[self.view.selectedIndex];
        storage.save();
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }
    
    function onNextPage() {
        self.view.selectedIndex = (self.view.selectedIndex + 1) % self.view.types.size();
        WatchUi.requestUpdate();
        return true;
    }
    
    function onPreviousPage() {
        self.view.selectedIndex = (self.view.selectedIndex - 1 + self.view.types.size()) % self.view.types.size();
        WatchUi.requestUpdate();
        return true;
    }
    
    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }
}

