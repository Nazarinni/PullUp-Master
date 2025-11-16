using Toybox.Time;
using Toybox.Time.Gregorian;

// Workout session data
class WorkoutSession {
    var id;
    var date;
    var workoutType;
    var sets; // Array of {reps: Number, restTime: Number}
    var totalReps;
    var notes;
    
    function initialize(workoutType) {
        self.id = System.getTimer();
        self.date = Time.now();
        self.workoutType = workoutType;
        self.sets = [];
        self.totalReps = 0;
        self.notes = "";
    }
    
    function addSet(reps, restTime) {
        self.sets.add({
            :reps => reps,
            :restTime => restTime
        });
        self.totalReps += reps;
    }
    
    function toStorage() {
        return {
            :id => self.id,
            :date => self.date.value(),
            :workoutType => self.workoutType,
            :sets => self.sets,
            :totalReps => self.totalReps,
            :notes => self.notes
        };
    }
    
    static function fromStorage(data) {
        var session = new WorkoutSession(data[:workoutType]);
        session.id = data[:id];
        session.date = new Time.Moment(data[:date]);
        session.sets = data[:sets];
        session.totalReps = data[:totalReps];
        session.notes = data[:notes];
        return session;
    }
}

// User profile data
class UserProfile {
    var weight; // kg
    var height; // cm
    var age;
    var gender; // 0 = male, 1 = female
    var weeklyGoal; // target pull-ups per week
    var maxReps; // personal best single set
    var maxDailyTotal; // personal best daily total
    
    function initialize() {
        self.weight = null;
        self.height = null;
        self.age = null;
        self.gender = null;
        self.weeklyGoal = 50;
        self.maxReps = 0;
        self.maxDailyTotal = 0;
    }
    
    function toStorage() {
        return {
            :weight => self.weight,
            :height => self.height,
            :age => self.age,
            :gender => self.gender,
            :weeklyGoal => self.weeklyGoal,
            :maxReps => self.maxReps,
            :maxDailyTotal => self.maxDailyTotal
        };
    }
    
    static function fromStorage(data) {
        var profile = new UserProfile();
        if (data != null) {
            profile.weight = data[:weight];
            profile.height = data[:height];
            profile.age = data[:age];
            profile.gender = data[:gender];
            profile.weeklyGoal = data[:weeklyGoal] != null ? data[:weeklyGoal] : 50;
            profile.maxReps = data[:maxReps] != null ? data[:maxReps] : 0;
            profile.maxDailyTotal = data[:maxDailyTotal] != null ? data[:maxDailyTotal] : 0;
        }
        return profile;
    }
}

// Training history statistics
class TrainingStats {
    var totalSessions;
    var totalReps;
    var weeklyVolume; // Array of weekly totals
    var monthlyVolume; // Array of monthly totals
    var last30DaysVolume;
    var averageRepsPerSession;
    
    function initialize() {
        self.totalSessions = 0;
        self.totalReps = 0;
        self.weeklyVolume = [];
        self.monthlyVolume = [];
        self.last30DaysVolume = 0;
        self.averageRepsPerSession = 0;
    }
    
    function calculate(sessions) {
        self.totalSessions = sessions.size();
        self.totalReps = 0;
        self.last30DaysVolume = 0;
        
        var now = Time.now();
        var thirtyDaysAgo = now.subtract(new Time.Duration(30 * 24 * 60 * 60));
        
        for (var i = 0; i < sessions.size(); i++) {
            var session = sessions[i];
            self.totalReps += session.totalReps;
            
            if (session.date.greaterThan(thirtyDaysAgo)) {
                self.last30DaysVolume += session.totalReps;
            }
        }
        
        if (self.totalSessions > 0) {
            self.averageRepsPerSession = self.totalReps.toFloat() / self.totalSessions;
        }
        
        // Calculate weekly and monthly volumes
        self.calculatePeriodVolumes(sessions);
    }
    
    function calculatePeriodVolumes(sessions) {
        self.weeklyVolume = [];
        self.monthlyVolume = [];
        
        // Group by week and month
        var weekMap = {};
        var monthMap = {};
        
        for (var i = 0; i < sessions.size(); i++) {
            var session = sessions[i];
            var info = Gregorian.info(session.date, Time.FORMAT_SHORT);
            var weekKey = info.year + "-W" + info.week;
            var monthKey = info.year + "-" + info.month;
            
            if (weekMap[weekKey] == null) {
                weekMap[weekKey] = 0;
            }
            weekMap[weekKey] += session.totalReps;
            
            if (monthMap[monthKey] == null) {
                monthMap[monthKey] = 0;
            }
            monthMap[monthKey] += session.totalReps;
        }
        
        // Convert to arrays
        var weekKeys = weekMap.keys();
        for (var i = 0; i < weekKeys.size(); i++) {
            self.weeklyVolume.add({
                :period => weekKeys[i],
                :volume => weekMap[weekKeys[i]]
            });
        }
        
        var monthKeys = monthMap.keys();
        for (var i = 0; i < monthKeys.size(); i++) {
            self.monthlyVolume.add({
                :period => monthKeys[i],
                :volume => monthMap[monthKeys[i]]
            });
        }
    }
}

// AI Coach recommendation
class WorkoutRecommendation {
    var workoutType; // "strength", "endurance", "mixed"
    var suggestedSets; // Array of {reps: Number, restTime: Number}
    var intensity; // 1-10 scale
    var reasoning; // Text explanation
    
    function initialize(workoutType, suggestedSets, intensity, reasoning) {
        self.workoutType = workoutType;
        self.suggestedSets = suggestedSets;
        self.intensity = intensity;
        self.reasoning = reasoning;
    }
}

