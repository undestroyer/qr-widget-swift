//
//  ScanViewController.swift
//  QrWidget
//
//  Created by Dmitriy Sazonov on 19.12.21.
//

import AVFoundation
import UIKit

protocol ScanDisplayLogic: AnyObject {
    func displayStartScanResult(vm: Scan.StartScan.ViewModel)
    func displayFoundScanResult(vm: Scan.FoundQr.ViewModel)
}

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, ScanDisplayLogic {
    
    let interactor: ScanBusinessLogic
    var state: Scan.ViewControllerState
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
    override var shouldAutorotate: Bool { false }
    
    var captureSession: AVCaptureSession? = nil
    var previewLayer: AVCaptureVideoPreviewLayer? = nil
    
    var customView: ScanView? { view as? ScanView }
    
    init(interactor: ScanBusinessLogic, initialState: Scan.ViewControllerState = .loading) {
        self.interactor = interactor
        self.state = initialState
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = ScanView(frame: UIScreen.main.bounds)
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let customView = customView else {
            return
        }
        customView.closeBtn.addTarget(self, action: #selector(onCloseTapped), for: .touchUpInside)
        
        interactor.startScanner(request: Scan.StartScan.Request())
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
    
    func failed() {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: NSLocalizedString("Scanning not supported", comment: "Scanning not supported"), message: NSLocalizedString("Your device does not support scanning a code from an item. Please use a device with a camera.", comment: "Your device does not support scanning a code from an item. Please use a device with a camera."), preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default))
            self.present(ac, animated: true)
            self.captureSession = nil
        }
    }
    
    func showPermissionInfo() {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: NSLocalizedString("Permission error", comment: "Permission error"), message: NSLocalizedString("Permission error occured. Please open Settings - Privacy - Qr Widget and check Camera permission.", comment: "Permission error occured. Please open Settings - Privacy - Qr Widget and check Camera permission."), preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default))
            self.present(ac, animated: true)
        }
    }
    
    func showUnknownError() {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: NSLocalizedString("Unknown error", comment: "Unknown error"), message: NSLocalizedString("Unknown error occured. Please try restart / reinstall the app. If nothing helps - contact me at undestroyer@gmail.com", comment: "Unknown error occured. Please try restart / reinstall the app. If nothing helps - contact me at undestroyer@gmail.com"), preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: NSLocalizedString("Open Mail app", comment: "Open Mail app"), style: .default, handler: { action in
                if let url = URL(string: "mailto:undestroyer@gmail.com") {
                    UIApplication.shared.open(url)
                }
            }))
            ac.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default))
            self.present(ac, animated: true)
        }
    }
    
    // MARK: - ScanDisplayLogic
    func displayStartScanResult(vm: Scan.StartScan.ViewModel) {
        switch vm.state {
        case .started:
            createScannerLayer()
        case .permissionIssueOccured:
            showPermissionInfo()
        default:
            showUnknownError()
        }
    }
    
    func displayFoundScanResult(vm: Scan.FoundQr.ViewModel) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - AVCaptureMetadataOutputObjectsDelegate
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            captureSession?.stopRunning()

            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                guard let stringValue = readableObject.stringValue else { return }
                interactor.foundQr(request: Scan.FoundQr.Request(payload: stringValue))
            }

            dismiss(animated: true)
        }
    
    // MARK: - objc
    @objc func onCloseTapped() {
        dismiss(animated: true, completion: nil)
    }
}
