//
//  ScanViewController.swift
//  QrWidget
//
//  Created by Dmitriy Sazonov on 19.12.21.
//

import AVFoundation
import UIKit

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession? = nil
    var previewLayer: AVCaptureVideoPreviewLayer? = nil
    
    var customView: ScanView? { view as? ScanView }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        self.view = ScanView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        createScannerLayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (captureSession?.isRunning == false) {
            captureSession?.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if (captureSession?.isRunning == true) {
            captureSession?.stopRunning()
        }
    }
    
    func createScannerLayer() {
        self.captureSession = AVCaptureSession()
        guard let captureSession = captureSession,
              let videoCaptureDevice = AVCaptureDevice.default(for: .video),
              let customView = customView else {
            return
        }

        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }

        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        guard let previewLayer = previewLayer else {
            return
        }

        previewLayer.frame = customView.scannerContainer.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        customView.scannerContainer.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }

    func found(code: String) {
        print(code)
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    // MARK: - AVCaptureMetadataOutputObjectsDelegate
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            captureSession?.stopRunning()

            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                guard let stringValue = readableObject.stringValue else { return }
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                found(code: stringValue)
            }

            dismiss(animated: true)
        }
}
