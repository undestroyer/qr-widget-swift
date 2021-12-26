import Foundation

protocol ScanPresentationLogic {
    func presentStartScanResult(response: Scan.StartScan.Response)
    func presentFouncQrResult(response: Scan.FoundQr.Response)
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
}
