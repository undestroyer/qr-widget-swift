import Foundation

protocol ScanPresentationLogic {
    func presentStartScanResult(response: Scan.StartScan.Response)
    func presentFouncQrResult(response: Scan.FoundQr.Response)
    func presentCallPickFromGalleryResult(response: Scan.CallPickFromGallery.Response)
}

class ScanPresenter: ScanPresentationLogic {
    weak var viewController: ScanDisplayLogic?
    
    func presentStartScanResult(response: Scan.StartScan.Response) {
        DispatchQueue.main.async {
            var vm: Scan.StartScan.ViewModel
            switch response.result {
            case .permissionIssue:
                vm = Scan.StartScan.ViewModel(state: .permissionIssueOccured)
            case .unknownIssue:
                vm = Scan.StartScan.ViewModel(state: .unknownError)
            case .success:
                vm = Scan.StartScan.ViewModel(state: .started)
            }
            self.viewController?.displayStartScanResult(vm: vm)
        }
    }
    
    func presentFouncQrResult(response: Scan.FoundQr.Response) {
        let vm = Scan.FoundQr.ViewModel(state: .finished)
        viewController?.displayFoundScanResult(vm: vm)
    }
    
    func presentCallPickFromGalleryResult(response: Scan.CallPickFromGallery.Response) {
        switch response.result {
        case .success:
            viewController?.displayGalleryPicker()
        case .permissionForbidden:
            viewController?.displayGalleryForbiddenAlert()
        case .permissionNotGranted:
            viewController?.displayGalleryPermissionRequest()
        }
    }
}
