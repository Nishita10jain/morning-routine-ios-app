import Foundation
import CoreMotion

class MotionManager: ObservableObject {
    @Published var isMoving = false
    
    private let motionManager = CMMotionManager()
    private let queue = OperationQueue()
    private var lastAcceleration: Double = 0
    private let movementThreshold: Double = 0.5
    private var movementTimer: Timer?
    
    init() {
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .userInteractive
    }
    
    func startMotionDetection() {
        guard motionManager.isAccelerometerAvailable else {
            print("Accelerometer not available")
            return
        }
        
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates(to: queue) { [weak self] data, error in
            guard let self = self, let data = data else { return }
            
            // Calculate acceleration magnitude
            let acceleration = sqrt(
                data.acceleration.x * data.acceleration.x +
                data.acceleration.y * data.acceleration.y +
                data.acceleration.z * data.acceleration.z
            )
            
            // Check if there's significant movement
            let accelerationChange = abs(acceleration - self.lastAcceleration)
            
            DispatchQueue.main.async {
                if accelerationChange > self.movementThreshold {
                    self.isMoving = true
                    // Reset timer when movement is detected
                    self.resetMovementTimer()
                }
            }
            
            self.lastAcceleration = acceleration
        }
    }
    
    func stopMotionDetection() {
        motionManager.stopAccelerometerUpdates()
        movementTimer?.invalidate()
        movementTimer = nil
        isMoving = false
    }
    
    private func resetMovementTimer() {
        movementTimer?.invalidate()
        movementTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [weak self] _ in
            DispatchQueue.main.async {
                self?.isMoving = false
            }
        }
    }
    
    deinit {
        stopMotionDetection()
    }
} 