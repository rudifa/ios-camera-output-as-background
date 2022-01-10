//
//  ViewController.swift
//  try-camera-output-as-background
//
//  Created by Rudolf Farkas on 10.01.22.
//

import AVFoundation
import UIKit

// class ViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//    }
//
//
// }

class ViewController: UIViewController {
    var previewView: UIView!
    var boxView: UIView!

    // Camera Capture requiered properties
    var videoDataOutput: AVCaptureVideoDataOutput!
    var videoDataOutputQueue: DispatchQueue!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var captureDevice: AVCaptureDevice!
    let session = AVCaptureSession()
    var currentFrame: CIImage!
    var done = false

    override func viewDidLoad() {
        super.viewDidLoad()
        previewView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        previewView.contentMode = .scaleAspectFit
        view.addSubview(previewView)

        // Add a box view
        boxView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 200))
        boxView.backgroundColor = UIColor.green
        boxView.alpha = 0.3
        view.addSubview(boxView)

        setupAVCapture()
    }

    override func viewWillAppear(_: Bool) {
        if !done {
            session.startRunning()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override var shouldAutorotate: Bool {
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft ||
            UIDevice.current.orientation == UIDeviceOrientation.landscapeRight ||
            UIDevice.current.orientation == UIDeviceOrientation.unknown
        {
            return false
        } else {
            return true
        }
    }
}

// AVCaptureVideoDataOutputSampleBufferDelegate protocol and related methods
extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func setupAVCapture() {
        session.sessionPreset = AVCaptureSession.Preset.vga640x480
        guard let device = AVCaptureDevice
            .default(AVCaptureDevice.DeviceType.builtInWideAngleCamera,
                     for: .video,
                     position: AVCaptureDevice.Position.back)
        else {
            return
        }
        captureDevice = device
        beginSession()
        done = true
    }

    func beginSession() {
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
            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspect

            let rootLayer: CALayer = previewView.layer
            rootLayer.masksToBounds = true
            previewLayer.frame = rootLayer.bounds
            rootLayer.addSublayer(previewLayer)
            session.startRunning()
        } catch let error as NSError {
            deviceInput = nil
            print("error: (error.localizedDescription)")
        }
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        currentFrame = convertImageFromCMSampleBufferRef(sampleBuffer)
    }

    // clean up AVCapture
    func stopCamera() {
        session.stopRunning()
        done = false
    }

    func convertImageFromCMSampleBufferRef(_ sampleBuffer: CMSampleBuffer) -> CIImage {
        let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        let ciImage = CIImage(cvImageBuffer: pixelBuffer)
        return ciImage
    }
}
