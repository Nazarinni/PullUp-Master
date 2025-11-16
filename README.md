# PullUp Master - Garmin Connect IQ App

A comprehensive pull-up training application for Garmin watches that helps you plan, track, and improve your pull-up performance with AI-assisted coaching.

## Features

### Free Version
- **Pull-up Planning**: Set weekly goals and choose from predefined workout schemes
- **Workout Tracking**: Log sets and reps during workouts with rest timers
- **Progress Tracking**: View daily, weekly, and monthly pull-up volume
- **Personal Records**: Track max reps in a single set and max daily total
- **User Profile Integration**: Automatically imports weight, height, age, and gender from Garmin profile

### Pro Version ($1/month)
- **AI-Assisted Coaching**: Get personalized workout recommendations based on your training history
- **Advanced Analytics**: View smoothed progress curves and rate-of-change insights
- **Adaptive Training Plans**: Workouts adjust based on performance, fatigue, and goals
- **Max Rep Prediction**: Estimated 1RM and max-rep predictions
- **Pro Workout Programs**: Specialized programs for strength, endurance, and weighted pull-ups

## Project Structure

```
PullUp-Master/
├── manifest.json          # App configuration and metadata
├── monkey.jungle          # Build configuration
├── source/                # Monkey C source files
│   ├── PullUpMasterApp.mc # Main app entry point
│   ├── DataModels.mc      # Data structures (Workout, Profile, Stats)
│   ├── StorageManager.mc  # Data persistence
│   ├── UserProfileManager.mc # Garmin profile integration
│   ├── SubscriptionManager.mc # Pro subscription handling
│   ├── AICoach.mc         # AI coaching logic
│   ├── MainView.mc        # Home screen
│   ├── WorkoutView.mc     # Workout tracking screen
│   ├── WorkoutSummaryView.mc # Post-workout summary
│   ├── HistoryView.mc     # Progress and statistics
│   ├── SettingsView.mc    # App settings
│   ├── AICoachView.mc     # AI recommendations (Pro)
│   ├── UpgradeView.mc     # Subscription upgrade screen
│   └── [Settings sub-views]
└── resources/             # Resources
    ├── strings.xml        # Localized strings
    ├── layouts.xml        # UI layouts
    └── Rez.mc            # Resource access module
```

## Development Setup

### Prerequisites
1. Garmin Connect IQ SDK (version 4.1.0 or later)
2. Eclipse with Garmin Connect IQ plugin (recommended) or command-line tools
3. Garmin device for testing (or simulator)
4. **Note**: You'll need to create a 48x48 PNG icon file at `resources/icons/icon.png` before building

### Building the App

1. Install Garmin Connect IQ SDK from [Garmin Developer Portal](https://developer.garmin.com/connect-iq/)
2. Install Java JDK 8 or later
3. Create app icon: `resources/icons/icon.png` (48x48 PNG) - **Required before building**
4. Open the project in Eclipse or use command-line tools
5. Build using the Connect IQ SDK:
   ```bash
   monkeyc -f monkey.jungle -o bin/pullup-master.prg
   ```

### Running Locally

**Quick Start:**
```bash
# Build
monkeyc -f monkey.jungle -o bin/pullup-master.prg

# Run in simulator
monkeydo bin/pullup-master.prg fenix6
```

**For detailed setup instructions, see [SETUP.md](SETUP.md)**

### Testing

1. Use Garmin Connect IQ Simulator for initial testing
2. Deploy to physical device using Garmin Express or Connect IQ Manager
3. Test on multiple device models to ensure compatibility

## Key Components

### Data Models
- **WorkoutSession**: Represents a single workout with sets, reps, and timestamps
- **UserProfile**: Stores user data (weight, height, age, goals, PRs)
- **TrainingStats**: Calculates statistics from workout history
- **WorkoutRecommendation**: AI-generated workout suggestions (Pro)

### Storage
- Uses `Toybox.Application.Storage` for persistent data
- Stores workout sessions, user profile, settings, and subscription status
- Automatic save/load on app start/stop

### AI Coaching
- Rules-based algorithm (can be extended with ML models)
- Considers:
  - Training history (last 30 days)
  - Current max reps
  - Weekly goal progress
  - Fatigue estimation
  - User characteristics

### Subscription Management
- Monthly subscription at $1/month
- Grace period handling (7 days)
- Cached subscription status
- Pro features locked/unlocked based on status

## Workout Types

1. **3x Max Reps**: Three sets at maximum effort
2. **Pyramid**: Progressive rep scheme (e.g., 1-2-3-2-1)
3. **EMOM 10 min**: Every Minute On the Minute for 10 minutes
4. **Custom**: User-defined workout

## UI Navigation

- **Up/Down buttons**: Navigate menus, adjust values
- **Select button**: Confirm selection, save set
- **Back button**: Go back, complete workout

## Monetization

- Free version available in Garmin Connect IQ Store
- Pro upgrade via in-app purchase (Garmin Pay integration)
- Subscription managed through Garmin's payment system

## Future Enhancements

- Weighted pull-up support with external sensors
- Integration with Garmin Strength Training API
- Community challenges and leaderboards
- Cloud sync for long-term history
- Advanced ML-based coaching models

## License

Copyright (c) 2024 PullUp Master. All rights reserved.

## Support

For issues, feature requests, or questions, please contact: support@pullupmaster.com

For issues, feature requests, or questions, please contact: support@pullupmaster.com




