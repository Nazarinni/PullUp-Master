using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;

class AboutView extends WatchUi.View {
    function initialize() {
        View.initialize();
    }
    
    function onLayout(dc) {
    }
    
    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, 10, Graphics.FONT_SMALL, "PullUp Master", Graphics.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, 40, Graphics.FONT_TINY, "Version 1.0.0", Graphics.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        var y = 70;
        dc.drawText(dc.getWidth() / 2, y, Graphics.FONT_TINY, "Plan, track, and improve", Graphics.TEXT_JUSTIFY_CENTER);
        y += 20;
        dc.drawText(dc.getWidth() / 2, y, Graphics.FONT_TINY, "your pull-up training", Graphics.TEXT_JUSTIFY_CENTER);
        
        y += 40;
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, y, Graphics.FONT_TINY, "Free: Basic tracking", Graphics.TEXT_JUSTIFY_CENTER);
        y += 20;
        dc.drawText(dc.getWidth() / 2, y, Graphics.FONT_TINY, "Pro: AI Coaching", Graphics.TEXT_JUSTIFY_CENTER);
    }
}

class AboutDelegate extends WatchUi.BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();
    }
    
    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }
}

