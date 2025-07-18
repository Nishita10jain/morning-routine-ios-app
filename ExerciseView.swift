import SwiftUI
import AVFoundation
import CoreMotion

struct ExerciseView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var cameraManager = CameraManager()
    @StateObject private var motionManager = MotionManager()
    
    @State private var exerciseTimeRemaining: TimeInterval = 20 * 60 // 20 minutes
    @State private var isExerciseActive = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // Camera preview
            CameraPreviewView(cameraManager: cameraManager)
                .ignoresSafeArea()
            
            // Overlay UI
            VStack {
                // Top bar
                HStack {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(8)
                    
                    Spacer()
                    
                    // Timer display
                    Text(timeString(from: exerciseTimeRemaining))
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(8)
                }
                .padding()
                
                Spacer()
                
                // Exercise status
                VStack(spacing: 20) {
                    if isExerciseActive {
                        Text("✅ Exercise Detected")
                            .font(.headline)
                            .foregroundColor(.green)
                    } else {
                        Text("⚠️ No Movement Detected")
                            .font(.headline)
                            .foregroundColor(.orange)
                    }
                    
                    // Progress bar
                    ProgressView(value: (20 * 60 - exerciseTimeRemaining) / (20 * 60))
                        .progressViewStyle(LinearProgressViewStyle(tint: .green))
                        .scaleEffect(x: 1, y: 2, anchor: .center)
                        .padding(.horizontal)
                }
                .padding()
                .background(Color.black.opacity(0.5))
                .cornerRadius(15)
                .padding()
                
                Spacer()
                
                // Start/Stop button
                Button(action: {
                    if isExerciseActive {
                        stopExercise()
                    } else {
                        startExercise()
                    }
                }) {
                    Text(isExerciseActive ? "Stop Exercise" : "Start Exercise")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isExerciseActive ? Color.red : Color.green)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .onReceive(timer) { _ in
            if isExerciseActive && exerciseTimeRemaining > 0 {
                exerciseTimeRemaining -= 1
                
                // Check if user is still moving
                if !motionManager.isMoving {
                    // User stopped moving, show alert
                    alertMessage = "Please continue exercising! You have \(Int(exerciseTimeRemaining / 60)) minutes remaining."
                    showingAlert = true
                }
                
                if exerciseTimeRemaining <= 0 {
                    // Exercise completed
                    completeExercise()
                }
            }
        }
        .onAppear {
            cameraManager.checkPermissions()
            motionManager.startMotionDetection()
        }
        .onDisappear {
            motionManager.stopMotionDetection()
        }
        .alert("Exercise Alert", isPresented: $showingAlert) {
            Button("Continue") {
                // User acknowledged, continue monitoring
            }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func startExercise() {
        isExerciseActive = true
        exerciseTimeRemaining = 20 * 60
        cameraManager.startRecording()
    }
    
    private func stopExercise() {
        isExerciseActive = false
        cameraManager.stopRecording()
        motionManager.stopMotionDetection()
    }
    
    private func completeExercise() {
        isExerciseActive = false
        cameraManager.stopRecording()
        motionManager.stopMotionDetection()
        
        alertMessage = "🎉 Congratulations! You've completed your 20-minute morning exercise!"
        showingAlert = true
        
        // Dismiss after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct CameraPreviewView: UIViewRepresentable {
    let cameraManager: CameraManager
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        cameraManager.previewLayer.frame = view.bounds
        view.layer.addSublayer(cameraManager.previewLayer)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        cameraManager.previewLayer.frame = uiView.bounds
    }
} 