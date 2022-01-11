@testable import QrWidget

class HomeViewControllerMock: HomeDisplayLogic {
    
    var isDisplayQrCalled = false
    func displayQr(viewModel: Home.FetchQr.ViewModel) {
        isDisplayQrCalled = true
    }
    
    var isForceQrUpdateCalled = false
    func forceQrUpdate(viewModel: Home.ForceQrUpdate.ViewModel) {
        isForceQrUpdateCalled = true
    }
    
    var isOpenScannerCalled = false
    func openScanner() {
        isOpenScannerCalled = true
    }
    
    var isOpenAboutCalled = false
    func openAbout() {
        isOpenAboutCalled = true
    }
}
