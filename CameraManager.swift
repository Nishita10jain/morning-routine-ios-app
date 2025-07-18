import AVFoundation
import UIKit

class CameraManager: NSObject, ObservableObject {
    @Published var isAuthorized = false
    @Published var isRecording = false
    
    var captureSession: AVCaptureSession?
    var videoOutput: AVCaptureMovieFileOutput?
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override init() {
        super.init()
        setupCaptureSession()
    }
    
    private func setupCaptureSession() {
        captureSession = AVCaptureSession()
        
        guard let captureSession = captureSession else { return }
        
        // Add video input
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            print("Failed to get video device")
            return
        }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoDevice)
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            }
        } catch {
            print("Error setting up video input: \(error)")
            return
        }
        
        // Add audio input
        guard let audioDevice = AVCaptureDevice.default(for: .audio) else {
            print("Failed to get audio device")
            return
        }
        
        do {
            let audioInput = try AVCaptureDeviceInput(device: audioDevice)
            if captureSession.canAddInput(audioInput) {
                captureSession.addInput(audioInput)
            }
        } catch {
            print("Error setting up audio input: \(error)")
        }
        
        // Setup video output
        videoOutput = AVCaptureMovieFileOutput()
        if let videoOutput = videoOutput, captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }
        
        // Setup preview layer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
    }
    
    func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            DispatchQueue.main.async {
                self.isAuthorized = true
                self.startSession()
            }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    self.isAuthorized = granted
                    if granted {
                        self.startSession()
                    }
                }
            }
        case .denied, .restricted:
            DispatchQueue.main.async {
                self.isAuthorized = false
            }
        @unknown default:
            DispatchQueue.main.async {
                self.isAuthorized = false
            }
        }
    }
    
    private func startSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession?.startRunning()
        }
    }
    
    func startRecording() {
        guard let videoOutput = videoOutput, !isRecording else { return }
        
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let videoName = "exercise_\(Date().timeIntervalSince1970).mov"
        let videoURL = documentsPath.appendingPathComponent(videoName)
        
        videoOutput.startRecording(to: videoURL, recordingDelegate: self)
        
        DispatchQueue.main.async {
            self.isRecording = true
        }
    }
    
    func stopRecording() {
        guard isRecording else { return }
        
        videoOutput?.stopRecording()
        
        DispatchQueue.main.async {
            self.isRecording = false
        }
    }
}

extension CameraManager: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Recording error: \(error)")
        } else {
            print("Recording saved to: \(outputFileURL)")
            // For PoC, we can delete the file immediately since we don't want to store it
            try? FileManager.default.removeItem(at: outputFileURL)
        }
    }
} 