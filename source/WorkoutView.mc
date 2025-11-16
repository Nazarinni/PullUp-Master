using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Time;
using Toybox.Timer;

class WorkoutView extends WatchUi.View {
    var currentSession;
    var currentSet;
    var currentReps;
    var restTimer;
    var isResting;
    var restTimeRemaining;
    var workoutTimer;
    
    function initialize() {
        View.initialize();
        var storage = $.StorageManager.getInstance();
        var workoutType = storage.settings[:workoutType];
        if (workoutType == null) {
            workoutType = "max";
        }
        self.currentSession = new $.WorkoutSession(workoutType);
        self.currentSet = 0;
        self.currentReps = 0;
        self.isResting = false;
        self.restTimeRemaining = 0;
        self.restTimer = null;
        self.workoutTimer = new Timer.Timer();
    }
    
    function onLayout(dc) {
        setLayout(Rez.Layouts.WorkoutLayout(dc));
    }
    
    function onShow() {
    }
    
    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, 10, Graphics.FONT_SMALL, "Workout", Graphics.TEXT_JUSTIFY_CENTER);
        
        if (self.isResting) {
            // Show rest timer
            dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
            dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2 - 20, Graphics.FONT_NUMBER_HOT, 
                self.formatTime(self.restTimeRemaining), Graphics.TEXT_JUSTIFY_CENTER);
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2 + 30, Graphics.FONT_SMALL, "Rest", Graphics.TEXT_JUSTIFY_CENTER);
        } else {
            // Show set and rep counter
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(dc.getWidth() / 2, 40, Graphics.FONT_MEDIUM, "Set " + (self.currentSet + 1), Graphics.TEXT_JUSTIFY_CENTER);
            
            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2 - 10, Graphics.FONT_NUMBER_HOT, 
                self.currentReps.toString(), Graphics.TEXT_JUSTIFY_CENTER);
            
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2 + 40, Graphics.FONT_SMALL, "Reps", Graphics.TEXT_JUSTIFY_CENTER);
            
            // Show total reps
            dc.drawText(dc.getWidth() / 2, dc.getHeight() - 40, Graphics.FONT_SMALL, 
                "Total: " + self.currentSession.totalReps, Graphics.TEXT_JUSTIFY_CENTER);
        }
        
        // Show controls hint
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, dc.getHeight() - 20, Graphics.FONT_TINY, 
            "Up/Down: Reps | Select: Save Set", Graphics.TEXT_JUSTIFY_CENTER);
    }
    
    function formatTime(seconds) {
        var mins = seconds / 60;
        var secs = seconds % 60;
        return mins.format("%02d") + ":" + secs.format("%02d");
    }
    
    function startRestTimer(restTime) {
        self.isResting = true;
        self.restTimeRemaining = restTime;
        
        self.restTimer = new Timer.Timer();
        self.restTimer.start(method(:onRestTimerTick), 1000, true);
    }
    
    function onRestTimerTick() {
        self.restTimeRemaining--;
        if (self.restTimeRemaining <= 0) {
            self.isResting = false;
            if (self.restTimer != null) {
                self.restTimer.stop();
                self.restTimer = null;
            }
        }
        WatchUi.requestUpdate();
    }
    
    function saveSet() {
        if (self.currentReps > 0) {
            var storage = $.StorageManager.getInstance();
            var restTime = storage.settings[:restTime];
            if (restTime == null) {
                restTime = 120;
            }
            
            self.currentSession.addSet(self.currentReps, restTime);
            self.currentSet++;
            self.currentReps = 0;
            
            // Start rest timer
            self.startRestTimer(restTime);
        }
        WatchUi.requestUpdate();
    }
    
    function completeWorkout() {
        if (self.restTimer != null) {
            self.restTimer.stop();
        }
        
        var storage = $.StorageManager.getInstance();
        storage.addSession(self.currentSession);
        
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        WatchUi.pushView(new $.WorkoutSummaryView(self.currentSession), new $.WorkoutSummaryDelegate(), WatchUi.SLIDE_LEFT);
    }
    
    function onHide() {
        if (self.restTimer != null) {
            self.restTimer.stop();
        }
    }
}

class WorkoutDelegate extends WatchUi.BehaviorDelegate {
    var view;
    
    function initialize(view) {
        BehaviorDelegate.initialize();
        self.view = view;
    }
    
    function onSelect() {
        if (self.view.isResting) {
            // Skip rest
            self.view.isResting = false;
            if (self.view.restTimer != null) {
                self.view.restTimer.stop();
            }
        } else {
            // Save current set
            self.view.saveSet();
        }
        WatchUi.requestUpdate();
        return true;
    }
    
    function onNextPage() {
        if (!self.view.isResting) {
            self.view.currentReps++;
            WatchUi.requestUpdate();
        }
        return true;
    }
    
    function onPreviousPage() {
        if (!self.view.isResting && self.view.currentReps > 0) {
            self.view.currentReps--;
            WatchUi.requestUpdate();
        }
        return true;
    }
    
    function onBack() {
        // Complete workout
        self.view.completeWorkout();
        return true;
    }
}

