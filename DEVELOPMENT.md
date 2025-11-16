# Development Guide - PullUp Master

## Quick Start

1. **Install Garmin Connect IQ SDK**
   - Download from https://developer.garmin.com/connect-iq/
   - Install Eclipse with Connect IQ plugin (recommended)

2. **Open Project**
   - Import project into Eclipse
   - Or use command-line tools with `monkeyc`

3. **Build**
   ```bash
   monkeyc -f monkey.jungle -o bin/pullup-master.prg
   ```

4. **Test**
   - Use Connect IQ Simulator
   - Deploy to physical device via Garmin Express

## Architecture Overview

### Core Components

1. **PullUpMasterApp** - Main application entry point
2. **StorageManager** - Singleton for data persistence
3. **UserProfileManager** - Handles Garmin profile integration
4. **SubscriptionManager** - Manages Pro subscription status
5. **AICoach** - Generates workout recommendations (Pro)

### Data Flow

```
App Start
  ├─> StorageManager.getInstance() - Loads saved data
  ├─> UserProfileManager.loadProfile() - Imports Garmin data
  └─> SubscriptionManager.checkSubscription() - Validates Pro status

Workout Flow
  ├─> WorkoutView - User logs sets/reps
  ├─> WorkoutSession - Stores workout data
  └─> StorageManager.addSession() - Saves to storage

AI Coaching (Pro)
  ├─> AICoach.generateRecommendation()
  ├─> Analyzes last 30 days of training
  ├─> Calculates metrics (volume, fatigue, progress)
  └─> Returns WorkoutRecommendation
```

## Key Features Implementation

### Workout Tracking
- Real-time rep counting with Up/Down buttons
- Automatic rest timer between sets
- Session summary with PR detection

### Progress Tracking
- Daily, weekly, monthly views
- Personal records (max reps, max daily total)
- Weekly goal progress tracking

### AI Coaching (Pro)
- Rules-based algorithm (extensible to ML)
- Considers:
  - Training volume (last 30 days)
  - Current max reps
  - Weekly goal progress
  - Fatigue estimation
  - Days since last workout

### Subscription Management
- Monthly subscription at $1/month
- 7-day grace period after expiry
- Cached status for offline use
- Pro features locked/unlocked dynamically

## Storage Schema

### Keys
- `sessions` - Array of WorkoutSession data
- `profile` - UserProfile data
- `subscription_status` - Boolean
- `subscription_expiry` - Timestamp
- `settings` - App settings (workout type, rest time, etc.)

### Data Format
- Sessions stored as arrays of dictionaries
- Profile stored as dictionary
- All data serialized/deserialized via toStorage()/fromStorage()

## UI Navigation

### Main Menu
- Start Workout
- History
- Settings
- AI Coach (Pro) / Upgrade to Pro (Free)

### Workout Screen
- Up/Down: Adjust rep count
- Select: Save set and start rest timer
- Back: Complete workout

### History Screen
- Up/Down: Cycle through views (Today/Week/Month/Records)
- Back: Return to main menu

## Testing Checklist

### Free Version
- [ ] Start workout and log sets
- [ ] View history (today/week/month)
- [ ] Check personal records
- [ ] Set weekly goal
- [ ] Change workout type
- [ ] Adjust rest time

### Pro Version
- [ ] AI Coach generates recommendations
- [ ] Subscription status displays correctly
- [ ] Pro features unlock after purchase
- [ ] Grace period works correctly
- [ ] Advanced analytics display

### Edge Cases
- [ ] First launch (no data)
- [ ] No Garmin profile data
- [ ] Subscription expiry
- [ ] Large number of sessions
- [ ] Invalid data in storage

## Known Limitations

1. **Icon**: Placeholder icon file - needs actual 48x48 PNG
2. **Subscription**: Purchase flow simulated - needs Garmin Pay integration
3. **AI Model**: Currently rules-based - can be extended with ML
4. **Cloud Sync**: Not implemented - all data local only
5. **Companion App**: Not created - Pro features work offline

## Extension Points

### Adding New Workout Types
1. Add type to `WorkoutTypeView.mc`
2. Implement logic in `WorkoutView.mc`
3. Update settings storage

### Enhancing AI Coach
1. Modify `AICoach.mc`
2. Add more metrics to `calculateMetrics()`
3. Improve `generateSets()` algorithm
4. Optionally integrate ML model

### Adding Analytics
1. Extend `TrainingStats` class
2. Add new calculations
3. Create new view for display
4. Make Pro-only if desired

## Performance Considerations

- Storage operations are synchronous - keep data size reasonable
- Limit session history (consider archiving old data)
- Cache subscription status to avoid repeated checks
- Optimize UI updates

## Deployment Checklist

1. [ ] Create app icon (48x48 PNG)
2. [ ] Test on multiple device models
3. [ ] Verify all permissions in manifest
4. [ ] Test subscription flow
5. [ ] Validate data persistence
6. [ ] Check memory usage
7. [ ] Test on different SDK versions
8. [ ] Prepare store listing
9. [ ] Submit to Garmin Connect IQ Store

## Resources

- [Garmin Connect IQ Developer Guide](https://developer.garmin.com/connect-iq/developer-guide/)
- [Monkey C Language Reference](https://developer.garmin.com/connect-iq/monkey-c/)
- [Connect IQ API Reference](https://developer.garmin.com/connect-iq/api-docs/)

