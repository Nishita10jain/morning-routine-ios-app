import Foundation
import UserNotifications

class AlarmManager: ObservableObject {
    @Published var currentAlarmTime: Date?
    @Published var snoozeCount = 0
    @Published var maxSnoozes = 2
    
    private let notificationManager = NotificationManager()
    
    func setAlarm(for date: Date) {
        currentAlarmTime = date
        snoozeCount = 0
        
        // Cancel any existing alarms
        notificationManager.cancelAlarm(identifier: "morning_alarm")
        
        // Schedule the new alarm
        notificationManager.scheduleAlarm(for: date, identifier: "morning_alarm")
        
        // Setup notification categories for snooze/exercise actions
        notificationManager.setupNotificationCategories()
    }
    
    func snooze() {
        guard snoozeCount < maxSnoozes else {
            // No more snoozes allowed
            return
        }
        
        snoozeCount += 1
        
        // Schedule a snooze notification for 2 minutes later
        let snoozeTime = Date().addingTimeInterval(120) // 2 minutes
        notificationManager.scheduleAlarm(for: snoozeTime, identifier: "snooze_alarm_\(snoozeCount)")
    }
    
    func startExercise() {
        // Reset snooze count when exercise starts
        snoozeCount = 0
        
        // Cancel any snooze alarms
        for i in 1...maxSnoozes {
            notificationManager.cancelAlarm(identifier: "snooze_alarm_\(i)")
        }
    }
    
    func canSnooze() -> Bool {
        return snoozeCount < maxSnoozes
    }
    
    func getRemainingSnoozes() -> Int {
        return maxSnoozes - snoozeCount
    }
} 