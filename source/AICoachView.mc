using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;

class AICoachView extends WatchUi.View {
    var recommendation;
    var coach;
    
    function initialize() {
        View.initialize();
        self.coach = new $.AICoach();
        self.recommendation = self.coach.generateRecommendation();
    }
    
    function onLayout(dc) {
    }
    
    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        
        var subscription = $.SubscriptionManager.getInstance();
        if (!subscription.isProActive()) {
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
            dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_MEDIUM, 
                "Pro Feature", Graphics.TEXT_JUSTIFY_CENTER);
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2 + 30, Graphics.FONT_SMALL, 
                "Upgrade to unlock", Graphics.TEXT_JUSTIFY_CENTER);
            return;
        }
        
        if (self.recommendation == null) {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_SMALL, 
                "Not enough data", Graphics.TEXT_JUSTIFY_CENTER);
            return;
        }
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, 10, Graphics.FONT_SMALL, "AI Coach", Graphics.TEXT_JUSTIFY_CENTER);
        
        // Show workout type
        var typeLabel = "Mixed";
        if (self.recommendation.workoutType.equals("strength")) {
            typeLabel = "Strength";
        } else if (self.recommendation.workoutType.equals("endurance")) {
            typeLabel = "Endurance";
        }
        
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, 40, Graphics.FONT_MEDIUM, typeLabel, Graphics.TEXT_JUSTIFY_CENTER);
        
        // Show intensity
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(10, 70, Graphics.FONT_SMALL, "Intensity:", Graphics.TEXT_JUSTIFY_LEFT);
        dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() - 10, 70, Graphics.FONT_SMALL, 
            self.recommendation.intensity + "/10", Graphics.TEXT_JUSTIFY_RIGHT);
        
        // Show recommended sets
        var y = 100;
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(10, y, Graphics.FONT_SMALL, "Recommended Sets:", Graphics.TEXT_JUSTIFY_LEFT);
        
        y += 25;
        var sets = self.recommendation.suggestedSets;
        var maxDisplay = 4; // Limit display for small screens
        for (var i = 0; i < sets.size() && i < maxDisplay; i++) {
            var set = sets[i];
            dc.drawText(20, y, Graphics.FONT_TINY, 
                "Set " + (i + 1) + ": " + set[:reps] + " reps (" + (set[:restTime] / 60) + " min rest)", 
                Graphics.TEXT_JUSTIFY_LEFT);
            y += 18;
        }
        
        if (sets.size() > maxDisplay) {
            dc.drawText(20, y, Graphics.FONT_TINY, "... " + (sets.size() - maxDisplay) + " more sets", 
                Graphics.TEXT_JUSTIFY_LEFT);
        }
        
        // Show reasoning
        if (self.recommendation.reasoning.length() > 0) {
            dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
            dc.drawText(dc.getWidth() / 2, dc.getHeight() - 30, Graphics.FONT_TINY, 
                self.recommendation.reasoning, Graphics.TEXT_JUSTIFY_CENTER);
        }
    }
    
    function onHide() {
    }
}

class AICoachDelegate extends WatchUi.BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();
    }
    
    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }
}

