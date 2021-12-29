@testable import QrWidget

class HomeInteractorMock: HomeBusinessLogic {
    var isFetchQrCalled = false
    func fetchQR(request: Home.FetchQr.Request) {
        isFetchQrCalled = true
    }

    var isForceQrUpdateCalled = false
    func forceQrUpdate(request: Home.ForceQrUpdate.Request) {
        isForceQrUpdateCalled = true
    }

    var isOpenScannerCalled = false
    func openScanner(request: Home.Navigate.RequestScanner) {
        isOpenScannerCalled = true
    }

    var isOpenAboutCalled = false
    func openAbout(request: Home.Navigate.RequestAbout) {
        isOpenAboutCalled = true
    }
}

