import AVFoundation

protocol ScanBusinessLogic {
    func startScanner(request: Scan.StartScan.Request)
    func foundQr(request: Scan.FoundQr.Request)
}

class ScanInteractor: ScanBusinessLogic {
    let presenter: ScanPresentationLogic
    let provider: ScanProviderProtocol
    
    init(presenter: ScanPresentationLogic = ScanPresenter(), provider: ScanProviderProtocol = ScanProvider()) {
        self.presenter = presenter
        self.provider = provider
    }
    
    func startScanner(request: Scan.StartScan.Request) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    self.presenter.presentStartScanResult(response: Scan.StartScan.Response(result: .success))
                } else {
                    self.presenter.presentStartScanResult(response: Scan.StartScan.Response(result: .permissionIssue))
                }
            })
        case .restricted, .denied:
            presenter.presentStartScanResult(response: Scan.StartScan.Response(result: .permissionIssue))
        case .authorized:
            presenter.presentStartScanResult(response: Scan.StartScan.Response(result: .success))
        default:
            presenter.presentStartScanResult(response: Scan.StartScan.Response(result: .unknownIssue))
        }
    }
    
    func foundQr(request: Scan.FoundQr.Request) {
        provider.saveQr(content: request.payload)
        NotificationCenter.default.post(name: NSNotification.Name(NotificationCenterConstants.newQrScanned), object: nil)
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        presenter.presentFouncQrResult(response: Scan.FoundQr.Response())
    }
}
