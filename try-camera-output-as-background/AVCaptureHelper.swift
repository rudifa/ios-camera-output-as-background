//
//  AVCaptureHelper.swift
//  try-camera-output-as-background
//
//  Created by Rudolf Farkas on 12.01.22.
//

// adapted from https://coderedirect.com/questions/534341/set-up-camera-on-the-background-of-uiview

import AVFoundation
import UIKit

// AVCaptureVideoDataOutputSampleBufferDelegate protocol and related methods
class AVCaptureHelper: NSObject {
    static let shared = AVCaptureHelper()

    override private init() {
        super.init()
        beginSession()
    }

    // Camera Capture required properties
    var videoDataOutput: AVCaptureVideoDataOutput!
    var videoDataOutputQueue: DispatchQueue!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var captureDevice: AVCaptureDevice!
    let session = AVCaptureSession()
    var currentFrame: CIImage!
    var isRunning = false

    var parentView: UIView!

    /// Display video capture in the parent view as background
    /// - Parameter view: parent view
    func displayAVCapture(in parentView: UIView) {
        self.parentView = parentView

        previewLayer.frame = parentView.layer.bounds
        parentView.layer.insertSublayer(previewLayer, at: 0)
    }

    func startCamera() {
        if !isRunning {
            session.startRunning()
            isRunning = true
        }
    }

    func stopCamera() {
        if isRunning {
            session.stopRunning()
            isRunning = false
        }
    }

    private func beginSession() {
        session.sessionPreset = AVCaptureSession.Preset.vga640x480
        guard let device = AVCaptureDevice
            .default(AVCaptureDevice.DeviceType.builtInWideAngleCamera,
                     for: .video,
                     position: AVCaptureDevice.Position.back)
        else {
            return
        }
        captureDevice = device
        var deviceInput: AVCaptureDeviceInput!
        do {
            deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            guard deviceInput != nil else {
                print("error: cant get deviceInput")
                return
            }

            if session.canAddInput(deviceInput) {
                session.addInput(deviceInput)
            }

            videoDataOutput = AVCaptureVideoDataOutput()
            videoDataOutput.alwaysDiscardsLateVideoFrames = true
            videoDataOutputQueue = DispatchQueue(label: "VideoDataOutputQueue")
            videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)

            if session.canAddOutput(videoDataOutput) {
                session.addOutput(videoDataOutput)
            }

            videoDataOutput.connection(with: AVMediaType.video)?.isEnabled = true

            previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.videoGravity = .resizeAspectFill

            startCamera()
        } catch let error as NSError {
            deviceInput = nil
            print("error: \(error.localizedDescription)")
        }
    }
}

extension AVCaptureHelper: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        currentFrame = convertImageFromCMSampleBufferRef(sampleBuffer)
    }

    private func convertImageFromCMSampleBufferRef(_ sampleBuffer: CMSampleBuffer) -> CIImage {
        let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        let ciImage = CIImage(cvImageBuffer: pixelBuffer)
        return ciImage
    }
}
