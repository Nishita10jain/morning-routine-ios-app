import Foundation
import UserNotifications

class NotificationManager: ObservableObject {
    @Published var isAuthorized = false
    
    func requestPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                self.isAuthorized = granted
            }
            
            if let error = error {
                print("Notification permission error: \(error)")
            }
        }
    }
    
    func scheduleAlarm(for date: Date, identifier: String) {
        let content = UNMutableNotificationContent()
        content.title = "🌅 Time to Exercise!"
        content.body = "Your morning routine is waiting. Let's get moving!"
        content.sound = .default
        content.categoryIdentifier = "ALARM_CATEGORY"
        
        // Create date components for the alarm
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Alarm scheduled successfully for \(date)")
            }
        }
    }
    
    func cancelAlarm(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    func setupNotificationCategories() {
        let snoozeAction = UNNotificationAction(
            identifier: "SNOOZE_ACTION",
            title: "Snooze (2 min)",
            options: []
        )
        
        let startExerciseAction = UNNotificationAction(
            identifier: "START_EXERCISE_ACTION",
            title: "Start Exercise",
            options: [.foreground]
        )
        
        let category = UNNotificationCategory(
            identifier: "ALARM_CATEGORY",
            actions: [snoozeAction, startExerciseAction],
            intentIdentifiers: [],
            options: []
        )
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
} 