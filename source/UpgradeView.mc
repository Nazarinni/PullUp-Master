using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;

class UpgradeView extends WatchUi.View {
    function initialize() {
        View.initialize();
    }
    
    function onLayout(dc) {
    }
    
    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        
        dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, 20, Graphics.FONT_MEDIUM, "Upgrade to Pro", Graphics.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, 60, Graphics.FONT_SMALL, "$1/month", Graphics.TEXT_JUSTIFY_CENTER);
        
        var y = 100;
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(10, y, Graphics.FONT_TINY, "• AI Coaching", Graphics.TEXT_JUSTIFY_LEFT);
        y += 20;
        dc.drawText(10, y, Graphics.FONT_TINY, "• Advanced Analytics", Graphics.TEXT_JUSTIFY_LEFT);
        y += 20;
        dc.drawText(10, y, Graphics.FONT_TINY, "• Progress Predictions", Graphics.TEXT_JUSTIFY_LEFT);
        y += 20;
        dc.drawText(10, y, Graphics.FONT_TINY, "• Pro Workout Programs", Graphics.TEXT_JUSTIFY_LEFT);
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, dc.getHeight() - 30, Graphics.FONT_SMALL, 
            "Purchase via Garmin", Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, dc.getHeight() - 10, Graphics.FONT_TINY, 
            "Connect IQ Store", Graphics.TEXT_JUSTIFY_CENTER);
    }
}

class UpgradeDelegate extends WatchUi.BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();
    }
    
    function onSelect() {
        // In a real implementation, this would trigger the purchase flow
        // For now, we'll simulate activation (for testing)
        var subscription = $.SubscriptionManager.getInstance();
        subscription.activateSubscription(1); // 1 month
        
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        WatchUi.requestUpdate();
        return true;
    }
    
    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }
}

