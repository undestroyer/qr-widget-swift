import XCTest
@testable import QrWidget

class HomePresenterTests: XCTestCase {
    
    var sut: HomePresenter!
    var viewController: HomeViewControllerMock!
    var qrGenerator: QrGeneratorMock!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        qrGenerator = QrGeneratorMock()
        viewController = HomeViewControllerMock()
        sut = HomePresenter(qrGenerator: qrGenerator)
        sut.viewController = viewController
    }

    override func tearDownWithError() throws {
        sut = nil
        viewController = nil
        try super.tearDownWithError()
    }

    func testPresentQrSuccessUseCase() throws {
        sut.presentQr(response: Home.FetchQr.Response(result: .success("some")))
        
        XCTAssert(viewController.isDisplayQrCalled
                  && qrGenerator.isGenerateQRCodeCalled
                  && !viewController.isForceQrUpdateCalled
                  && !viewController.isOpenAboutCalled
                  && !viewController.isOpenScannerCalled)
    }
    
    func testPresentQrFailedUseCase() throws {
        sut.presentQr(response: Home.FetchQr.Response(result: .failure))
        
        XCTAssert(viewController.isDisplayQrCalled
                  && !qrGenerator.isGenerateQRCodeCalled
                  && !viewController.isForceQrUpdateCalled
                  && !viewController.isOpenAboutCalled
                  && !viewController.isOpenScannerCalled)
    }

    func testForceUpdateQrSuccessUseCase() throws {
        sut.forceUpdateQr(response: Home.ForceQrUpdate.Response(result: .success("some")))
        
        XCTAssert(!viewController.isDisplayQrCalled
                  && qrGenerator.isGenerateQRCodeCalled
                  && viewController.isForceQrUpdateCalled
                  && !viewController.isOpenAboutCalled
                  && !viewController.isOpenScannerCalled)
    }
    
    func testForceUpdateQrFailedUseCase() throws {
        sut.forceUpdateQr(response: Home.ForceQrUpdate.Response(result: .failure))
        
        XCTAssert(!viewController.isDisplayQrCalled
                  && !qrGenerator.isGenerateQRCodeCalled
                  && viewController.isForceQrUpdateCalled
                  && !viewController.isOpenAboutCalled
                  && !viewController.isOpenScannerCalled)
    }

    func testNavigateToScannerUseCase() throws {
        sut.navigate(response: Home.NavigationDestination.scanner)
        
        XCTAssert(!viewController.isDisplayQrCalled
                  && !qrGenerator.isGenerateQRCodeCalled
                  && !viewController.isForceQrUpdateCalled
                  && !viewController.isOpenAboutCalled
                  && viewController.isOpenScannerCalled)
    }
    
    func testNavigateToAboutUseCase() throws {
        sut.navigate(response: Home.NavigationDestination.about)
        
        XCTAssert(!viewController.isDisplayQrCalled
                  && !qrGenerator.isGenerateQRCodeCalled
                  && !viewController.isForceQrUpdateCalled
                  && viewController.isOpenAboutCalled
                  && !viewController.isOpenScannerCalled)
    }
    
}
