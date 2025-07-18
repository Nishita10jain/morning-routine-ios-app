# Morning Routine App - iOS PoC

A SwiftUI-based iOS app that helps you build a consistent morning exercise routine using the 20-20-20 method from the 5 AM Club book.

## Features

### Core Features (PoC)
- **Alarm Setting**: Set your morning wake-up time
- **Limited Snooze**: Only 2 snooze attempts allowed
- **Camera Recording**: Records your exercise session for verification
- **Movement Detection**: Basic motion detection using CoreMotion
- **20-Minute Timer**: Tracks your 20-minute exercise session
- **Streak Tracking**: Tracks your daily completion streak
- **Local Notifications**: Alarm notifications with snooze/exercise actions

### Future Scope
- Advanced AI/ML exercise recognition
- Posture analysis and feedback
- Meditation and learning routine modules
- Subscription model for advanced features

## Requirements

- iOS 15.0+
- Xcode 13.0+
- iPhone with camera and accelerometer

## Setup Instructions

### 1. Open in Xcode
1. Open Xcode
2. Choose "Open a project or file"
3. Navigate to the `MorningRoutineiOS` folder
4. Select the folder and click "Open"

### 2. Configure Project
1. Select the project in the navigator
2. Choose your target device (iPhone)
3. Update the Bundle Identifier if needed
4. Ensure your Apple Developer account is configured

### 3. Build and Run
1. Connect your iPhone to your Mac
2. Select your device from the device dropdown
3. Click the "Run" button (▶️) or press Cmd+R

## Permissions Required

The app will request the following permissions:
- **Camera**: To record exercise sessions
- **Microphone**: To record audio during exercise
- **Notifications**: To send alarm notifications

## How It Works

### Alarm Flow
1. User sets their wake-up time
2. App schedules a local notification for that time
3. When notification fires, user can:
   - Snooze (max 2 times)
   - Start Exercise (opens camera view)

### Exercise Flow
1. Camera opens and starts recording
2. Motion detection monitors user movement
3. 20-minute timer counts down
4. If user stops moving, alert is shown
5. When 20 minutes complete, session ends

### Limitations (iOS Constraints)
- Cannot force DND mode (user must enable manually)
- Cannot keep camera running in background
- Cannot create persistent alarms like system Clock app
- Background execution is limited

## Project Structure

```
MorningRoutineiOS/
├── MorningRoutineApp.swift      # Main app entry point
├── ContentView.swift            # Main UI view
├── ExerciseView.swift           # Camera and exercise view
├── NotificationManager.swift    # Handles local notifications
├── AlarmManager.swift          # Manages alarm and snooze logic
├── CameraManager.swift         # Camera recording functionality
├── MotionManager.swift         # Movement detection
├── Info.plist                 # App permissions and configuration
└── README.md                  # This file
```

## Testing

### Test Alarm Functionality
1. Set alarm for 1-2 minutes in the future
2. Put app in background
3. Wait for notification to fire
4. Test snooze and exercise start actions

### Test Exercise Recording
1. Tap "Start Exercise Now" button
2. Grant camera permissions when prompted
3. Move around to test motion detection
4. Complete the 20-minute session

## Troubleshooting

### Common Issues
1. **Camera not working**: Check camera permissions in Settings
2. **Notifications not working**: Check notification permissions
3. **Build errors**: Ensure iOS deployment target is set to 15.0+
4. **Motion detection not working**: Ensure device has accelerometer

### Debug Tips
- Check Xcode console for error messages
- Verify permissions are granted in device Settings
- Test on physical device (simulator has limited camera/motion)

## Next Steps for Development

1. **Enhanced Motion Detection**: Implement more sophisticated movement analysis
2. **AI/ML Integration**: Add TensorFlow Lite or CoreML for exercise recognition
3. **Data Persistence**: Store streaks and exercise history
4. **UI Polish**: Add animations and better visual feedback
5. **Background Processing**: Implement background app refresh for better alarm handling

## License

This is a proof-of-concept project for educational purposes. 