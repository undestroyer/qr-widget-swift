//
//  HomeInteractorTests.swift
//  QrWidgetTests
//
//  Created by Dmitriy Sazonov on 28.12.21.
//

import XCTest
@testable import QrWidget

class HomeInteractorTests: XCTestCase {

    var sut: HomeInteractor!
    var presenter: HomePresentationMock!
    var provider: HomeProviderMock!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        presenter = HomePresentationMock()
        provider = HomeProviderMock()
        sut = HomeInteractor(presenter: presenter, provider: provider)
    }

    override func tearDownWithError() throws {
        sut = nil
        presenter = nil
        provider = nil
        try super.tearDownWithError()
    }

    func testFetchQrSuccessUseCase() throws {
        let someQrContent: String? = "SOME_QR_CONTENT"
        provider.returnValue = someQrContent
        
        sut.fetchQR(request: Home.FetchQr.Request())
        
        XCTAssert(presenter.isPresentQrCalled
                  && !presenter.isForceUpdateQrCalled
                  && !presenter.isNavigateCalled
                  && presenter.isResponseSuccess == true)
    }
    
    func testFetchQrFailedUseCase() throws {
        let someQrContent: String? = nil
        provider.returnValue = someQrContent
        
        sut.fetchQR(request: Home.FetchQr.Request())
        
        XCTAssert(presenter.isPresentQrCalled
                  && !presenter.isForceUpdateQrCalled
                  && !presenter.isNavigateCalled
                  && presenter.isResponseSuccess == false)
    }
    
    func testForceQrUpdateSuccessUseCase() throws {
        let someQrContent: String? = "SOME_QR_CONTENT"
        provider.returnValue = someQrContent
        
        sut.forceQrUpdate(request: Home.ForceQrUpdate.Request())
        
        XCTAssert(!presenter.isPresentQrCalled
                  && presenter.isForceUpdateQrCalled
                  && !presenter.isNavigateCalled
                  && presenter.isResponseSuccess == true)
    }
    
    func testForceQrUpdateFailedUseCase() throws {
        let someQrContent: String? = nil
        provider.returnValue = someQrContent
        
        sut.forceQrUpdate(request: Home.ForceQrUpdate.Request())
        
        XCTAssert(!presenter.isPresentQrCalled
                  && presenter.isForceUpdateQrCalled
                  && !presenter.isNavigateCalled
                  && presenter.isResponseSuccess == false)
    }
    
    
    func testNavigationToAboutUseCase() throws {
        sut.openAbout(request: Home.Navigate.RequestAbout())
        
        XCTAssert(!presenter.isPresentQrCalled
                  && !presenter.isForceUpdateQrCalled
                  && presenter.isNavigateCalled
                  && presenter.navigationDestination == Home.NavigationDestination.about)
    }
    
    func testNavigationToScannerUseCase() throws {
        sut.openScanner(request: Home.Navigate.RequestScanner())
        
        XCTAssert(!presenter.isPresentQrCalled
                  && !presenter.isForceUpdateQrCalled
                  && presenter.isNavigateCalled
                  && presenter.navigationDestination == Home.NavigationDestination.scanner)
    }
}
