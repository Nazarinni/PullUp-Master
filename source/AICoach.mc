using Toybox.System;
using Toybox.Time;

class AICoach {
    static const MIN_SESSIONS_FOR_AI = 3;
    
    function initialize() {
    }
    
    // Generate workout recommendation based on user history and profile
    function generateRecommendation() {
        var storage = $.StorageManager.getInstance();
        var profile = storage.profile;
        var subscription = $.SubscriptionManager.getInstance();
        
        // Check if Pro is active
        if (!subscription.isProActive()) {
            return null;
        }
        
        // Get recent training history
        var recentSessions = storage.getLast30DaysSessions();
        
        if (recentSessions.size() < MIN_SESSIONS_FOR_AI) {
            // Not enough data, return basic recommendation
            return self.getBasicRecommendation(profile);
        }
        
        // Calculate training metrics
        var metrics = self.calculateMetrics(recentSessions, profile);
        
        // Determine workout type based on history
        var workoutType = self.determineWorkoutType(metrics, profile);
        
        // Generate sets and reps
        var suggestedSets = self.generateSets(workoutType, metrics, profile);
        
        // Calculate intensity (1-10 scale)
        var intensity = self.calculateIntensity(metrics, profile);
        
        // Generate reasoning
        var reasoning = self.generateReasoning(workoutType, metrics, profile);
        
        return new $.WorkoutRecommendation(workoutType, suggestedSets, intensity, reasoning);
    }
    
    function getBasicRecommendation(profile) {
        var maxReps = profile.maxReps > 0 ? profile.maxReps : 5;
        var sets = [
            {:reps => maxReps, :restTime => 120},
            {:reps => maxReps - 1, :restTime => 120},
            {:reps => maxReps - 2, :restTime => 120}
        ];
        return new $.WorkoutRecommendation("mixed", sets, 5, "Starting recommendation");
    }
    
    function calculateMetrics(sessions, profile) {
        var metrics = {
            :totalVolume => 0,
            :averageRepsPerSet => 0,
            :sessionsCount => sessions.size(),
            :daysSinceLastWorkout => 0,
            :weeklyVolume => 0,
            :fatigueFactor => 1.0
        };
        
        // Calculate total volume and average
        var totalSets = 0;
        var totalReps = 0;
        for (var i = 0; i < sessions.size(); i++) {
            var session = sessions[i];
            metrics[:totalVolume] += session.totalReps;
            totalSets += session.sets.size();
            totalReps += session.totalReps;
        }
        
        if (totalSets > 0) {
            metrics[:averageRepsPerSet] = totalReps.toFloat() / totalSets;
        }
        
        // Calculate days since last workout
        if (sessions.size() > 0) {
            var lastSession = sessions[sessions.size() - 1];
            var now = Time.now();
            var diff = now.subtract(lastSession.date);
            metrics[:daysSinceLastWorkout] = (diff.value() / (24 * 60 * 60)).toNumber();
        }
        
        // Calculate weekly volume
        var weekSessions = $.StorageManager.getInstance().getThisWeekSessions();
        for (var i = 0; i < weekSessions.size(); i++) {
            metrics[:weeklyVolume] += weekSessions[i].totalReps;
        }
        
        // Calculate fatigue factor based on recent activity
        metrics[:fatigueFactor] = self.calculateFatigueFactor(sessions);
        
        return metrics;
    }
    
    function calculateFatigueFactor(sessions) {
        if (sessions.size() < 2) {
            return 1.0;
        }
        
        // Check workouts in last 3 days
        var now = Time.now();
        var threeDaysAgo = now.subtract(new Time.Duration(3 * 24 * 60 * 60));
        var recentCount = 0;
        var recentVolume = 0;
        
        for (var i = sessions.size() - 1; i >= 0; i--) {
            if (sessions[i].date.greaterThan(threeDaysAgo)) {
                recentCount++;
                recentVolume += sessions[i].totalReps;
            } else {
                break;
            }
        }
        
        // Higher fatigue if many recent workouts
        if (recentCount >= 3) {
            return 0.7; // Reduce intensity
        } else if (recentCount == 2) {
            return 0.85;
        } else if (recentCount == 1) {
            return 0.95;
        }
        
        return 1.0; // Fresh
    }
    
    function determineWorkoutType(metrics, profile) {
        var weeklyGoal = profile.weeklyGoal;
        var currentWeekly = metrics[:weeklyVolume];
        var progress = weeklyGoal > 0 ? (currentWeekly.toFloat() / weeklyGoal) : 0;
        
        // If behind on weekly goal, suggest endurance
        if (progress < 0.5) {
            return "endurance";
        }
        
        // If max reps haven't improved recently, suggest strength
        if (metrics[:averageRepsPerSet] < profile.maxReps * 0.8) {
            return "strength";
        }
        
        // Default to mixed
        return "mixed";
    }
    
    function generateSets(workoutType, metrics, profile) {
        var maxReps = profile.maxReps > 0 ? profile.maxReps : 5;
        var baseReps = (maxReps * metrics[:fatigueFactor]).toNumber();
        if (baseReps < 1) {
            baseReps = 1;
        }
        
        var sets = [];
        var restTime = 120; // Default 2 minutes
        
        if (workoutType.equals("strength")) {
            // Lower reps, higher intensity, longer rest
            restTime = 180;
            sets.add({:reps => baseReps, :restTime => restTime});
            sets.add({:reps => baseReps - 1, :restTime => restTime});
            sets.add({:reps => baseReps - 2, :restTime => restTime});
            if (baseReps >= 3) {
                sets.add({:reps => baseReps - 2, :restTime => restTime});
            }
        } else if (workoutType.equals("endurance")) {
            // Higher volume, shorter rest
            restTime = 90;
            var enduranceReps = (baseReps * 0.7).toNumber();
            if (enduranceReps < 1) {
                enduranceReps = 1;
            }
            for (var i = 0; i < 5; i++) {
                sets.add({:reps => enduranceReps, :restTime => restTime});
            }
        } else {
            // Mixed: moderate reps and rest
            restTime = 120;
            sets.add({:reps => baseReps, :restTime => restTime});
            sets.add({:reps => baseReps - 1, :restTime => restTime});
            sets.add({:reps => baseReps - 1, :restTime => restTime});
            sets.add({:reps => baseReps - 2, :restTime => restTime});
        }
        
        return sets;
    }
    
    function calculateIntensity(metrics, profile) {
        var maxReps = profile.maxReps > 0 ? profile.maxReps : 5;
        var avgReps = metrics[:averageRepsPerSet];
        
        if (avgReps == 0) {
            return 5; // Default moderate intensity
        }
        
        // Intensity based on how close average is to max
        var ratio = avgReps / maxReps;
        var intensity = (ratio * 7 + 3).toNumber(); // Scale 3-10
        
        // Adjust for fatigue
        intensity = (intensity * metrics[:fatigueFactor]).toNumber();
        
        if (intensity < 1) {
            intensity = 1;
        } else if (intensity > 10) {
            intensity = 10;
        }
        
        return intensity;
    }
    
    function generateReasoning(workoutType, metrics, profile) {
        var weeklyGoal = profile.weeklyGoal;
        var currentWeekly = metrics[:weeklyVolume];
        var progress = weeklyGoal > 0 ? (currentWeekly.toFloat() / weeklyGoal * 100).toNumber() : 0;
        
        if (workoutType.equals("strength")) {
            return "Focus on strength. Build max reps.";
        } else if (workoutType.equals("endurance")) {
            return "Endurance focus. " + progress + "% of weekly goal.";
        } else {
            return "Balanced workout. " + progress + "% weekly progress.";
        }
    }
    
    // Estimate 1RM or max reps prediction (Pro feature)
    function estimateMaxReps(profile, recentSessions) {
        if (recentSessions.size() < 2) {
            return profile.maxReps;
        }
        
        // Simple linear regression based on recent performance
        var maxReps = profile.maxReps;
        var recentMax = 0;
        
        for (var i = 0; i < recentSessions.size(); i++) {
            var session = recentSessions[i];
            for (var j = 0; j < session.sets.size(); j++) {
                if (session.sets[j][:reps] > recentMax) {
                    recentMax = session.sets[j][:reps];
                }
            }
        }
        
        // Estimate based on trend (simplified)
        return recentMax > maxReps ? recentMax : maxReps;
    }
}

