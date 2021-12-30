//
//  ScanViewController.swift
//  QrWidget
//
//  Created by Dmitriy Sazonov on 19.12.21.
//

import AVFoundation
import UIKit
import Photos
import PhotosUI

protocol ScanDisplayLogic: AnyObject {
    func displayStartScanResult(vm: Scan.StartScan.ViewModel)
    func displayFoundScanResult(vm: Scan.FoundQr.ViewModel)
    func displayGalleryPermissionRequest()
    func displayGalleryPicker()
    func displayGalleryForbiddenAlert()
    func displayManualInput()
}

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, ScanDisplayLogic, PHPickerViewControllerDelegate {
    
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
        customView.galleryBtn.addTarget(self, action: #selector(onPickFromGalleryTapped), for: .touchUpInside)
        customView.manualInputBtn.addTarget(self, action: #selector(onManualInputTapped), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
            let ac = UIAlertController(title: NSLocalizedString("Permission error", comment: "Permission error"), message: NSLocalizedString("Permission error occured. Please open Settings - Privacy - Camera and check QrWidget permission.", comment: "Permission error occured. Please open Settings - Privacy - Camera and check QrWidget permission."), preferredStyle: .alert)
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
    
    func displayGalleryPermissionRequest() {
        DispatchQueue.main.async {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { _ in
                self.interactor.openGallery(request: Scan.CallPickFromGallery.Request())
            }
        }
    }
    
    func displayGalleryPicker() {
        DispatchQueue.main.async {
            var configuration = PHPickerConfiguration(photoLibrary: .shared())
            let newFilter = PHPickerFilter.images
            configuration.filter = newFilter
            let pickerController = PHPickerViewController(configuration: configuration)
            pickerController.delegate = self
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    func displayGalleryForbiddenAlert() {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: NSLocalizedString("Permission error", comment: "Permission error"), message: NSLocalizedString("Permission error occured. Please open Settings - Privacy - Photo and check QrWidget permission.", comment: "Permission error occured. Please open Settings - Privacy - Photo and check QrWidget permission."), preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default))
            self.present(ac, animated: true)
        }
    }
    
    
    func displayManualInput() {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: NSLocalizedString("Type QR content", comment: "Type QR content"), message: nil, preferredStyle: .alert)
            ac.addTextField { textField in
                textField.placeholder = "QR"
            }
            let confirmAction = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default) { _ in
                self.interactor.foundQr(request: Scan.FoundQr.Request(payload: ac.textFields?.first?.text ?? ""))
            }
            ac.addAction(confirmAction)
            ac.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel))
            self.present(ac, animated: true)
        }
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
    
    // MARK: - PHPickerViewControllerDelegate
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        guard results.indices.contains(0) else {
            return // nothing was picked
        }
        DispatchQueue.main.async {
            picker.dismiss(animated: true, completion: nil)
        }
        let pickedPhoto = results[0]
        pickedPhoto.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
            switch (reading, error) {
            case (.none, let .some(e)):
                fatalError(e.localizedDescription)
            case (let .some(data), .none):
                guard let image = CIImage(image: data as! UIImage) else {
                    return
                }
                let detector = CIDetector(ofType: CIDetectorTypeQRCode,
                                          context: nil,
                                          options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
                let features = detector?.features(in: image) ?? []
                let qrs = features.compactMap { ($0 as? CIQRCodeFeature)?.messageString }
                guard !qrs.isEmpty else {
                    DispatchQueue.main.async {
                        let ac = UIAlertController(title: NSLocalizedString("QR not found", comment: "QR not found"), message: NSLocalizedString("QR was not found on a picked photo. Please pick another photo or use scanner.", comment: "QR was not found on a picked photo. Please pick another photo or use scanner."), preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default))
                        self.present(ac, animated: true)
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.interactor.foundQr(request: Scan.FoundQr.Request(payload: qrs[0]))
                    self.dismiss(animated: true)
                }
            default:
                fatalError("Invalid state, both optionals are set or both are null in PHPickerViewControllerDelegate")
            }
        }
    }
    
    // MARK: - objc
    @objc func onCloseTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func onPickFromGalleryTapped() {
        interactor.openGallery(request: Scan.CallPickFromGallery.Request())
    }
    
    @objc func onManualInputTapped() {
        interactor.openManualInput(request: Scan.CallManualInput.Request())
    }
}
