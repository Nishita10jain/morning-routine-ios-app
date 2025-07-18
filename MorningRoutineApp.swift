import SwiftUI
import UserNotifications

@main
struct MorningRoutineApp: App {
    @StateObject private var notificationManager = NotificationManager()
    @StateObject private var alarmManager = AlarmManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(notificationManager)
                .environmentObject(alarmManager)
                .onAppear {
                    notificationManager.requestPermissions()
                }
        }
    }
} 