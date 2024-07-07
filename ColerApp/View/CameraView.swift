//
//  CameraView.swift
//  ColerApp
//
//  Created by Nikita Nikandrov on 07.07.2024.
//

import UIKit
import AVFoundation

class CameraView: UIView {
    
    private var captureSession: AVCaptureSession?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        checkCameraAuthorizationStatus()
        setupCircleOverlay()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        checkCameraAuthorizationStatus()
        setupCircleOverlay()
    }
    
    private func checkCameraAuthorizationStatus() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.setupCamera()
                    }
                }
            }
        case .denied, .restricted:
            print("Access denied or restricted")
        @unknown default:
            fatalError("Unknown authorization status")
        }
    }
    
    private func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .high
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession?.addInput(input)
        } catch {
            print("Error unable to initialize camera:  \(error.localizedDescription)")
            return
        }
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        videoPreviewLayer?.frame = self.layer.bounds
        if let videoPreviewLayer = videoPreviewLayer {
            self.layer.addSublayer(videoPreviewLayer)
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession?.startRunning()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        videoPreviewLayer?.frame = self.bounds
    }
    
    private func setupCircleOverlay() {
        let circleDiameter: CGFloat = 50.0
        let circleView = UIView(frame: CGRect(x: 0, y: 0, width: circleDiameter, height: circleDiameter))
        circleView.center = self.center
        circleView.backgroundColor = .clear
        circleView.layer.borderColor = UIColor.lightGray.cgColor
        circleView.layer.borderWidth = 5
        circleView.layer.cornerRadius = circleDiameter / 2
        self.addSubview(circleView)
        
        circleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circleView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            circleView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            circleView.widthAnchor.constraint(equalToConstant: circleDiameter),
            circleView.heightAnchor.constraint(equalToConstant: circleDiameter)
        ])
    }
}
