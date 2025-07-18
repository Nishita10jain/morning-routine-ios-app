import SwiftUI

struct ContentView: View {
    @EnvironmentObject var notificationManager: NotificationManager
    @EnvironmentObject var alarmManager: AlarmManager
    @State private var selectedTime = Date()
    @State private var showingAlarmSet = false
    @State private var showingExerciseView = false
    @State private var currentStreak = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Header
                VStack {
                    Text("🌅 Morning Routine")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Build your 5 AM Club habit")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Current Streak
                VStack {
                    Text("🔥 Current Streak")
                        .font(.headline)
                        .foregroundColor(.orange)
                    
                    Text("\(currentStreak) days")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.orange)
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(15)
                
                // Alarm Setting
                VStack(spacing: 20) {
                    Text("Set Your Morning Alarm")
                        .font(.headline)
                    
                    DatePicker("Wake Up Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                    
                    Button(action: {
                        alarmManager.setAlarm(for: selectedTime)
                        showingAlarmSet = true
                    }) {
                        Text("Set Alarm")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(15)
                
                // Quick Start Exercise (for testing)
                Button(action: {
                    showingExerciseView = true
                }) {
                    Text("Start Exercise Now")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
                
                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingExerciseView) {
            ExerciseView()
        }
        .alert("Alarm Set!", isPresented: $showingAlarmSet) {
            Button("OK") { }
        } message: {
            Text("Your morning alarm has been set for \(selectedTime, formatter: timeFormatter)")
        }
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(NotificationManager())
            .environmentObject(AlarmManager())
    }
} 