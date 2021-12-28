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
        XCTAssert(presenter.isPresentQrCalled && presenter.isResponseSuccess == true
                  && !presenter.isForceUpdateQrCalled
                  && !presenter.isNavigateCalled)
    }
    
    func testFetchQrFailedUseCase() throws {
        let someQrContent: String? = nil
        provider.returnValue = someQrContent
        
        sut.forceQrUpdate(request: Home.ForceQrUpdate.Request())
        XCTAssert(presenter.isPresentQrCalled && presenter.isResponseSuccess == false
                  && !presenter.isForceUpdateQrCalled
                  && !presenter.isNavigateCalled)
    }
    

    class HomePresentationMock: HomePresentationLogic {

        var isResponseSuccess: Bool? = nil

        var isPresentQrCalled = false
        func presentQr(response: Home.FetchQr.Response) {
            isPresentQrCalled = true
            switch (response.result) {
            case .success:
                isResponseSuccess = true
            case .failure:
                isResponseSuccess = false
            }
        }
        
        var isForceUpdateQrCalled = false
        func forceUpdateQr(response: Home.ForceQrUpdate.Response) {
            isForceUpdateQrCalled = true
            switch (response.result) {
            case .success:
                isResponseSuccess = true
            case .failure:
                isResponseSuccess = false
            }
        }
        
        var isNavigateCalled = false
        func navigate(response: Home.NavigationDestination) {
            isNavigateCalled = true
        }
        
        
    }
    
    class HomeProviderMock: HomeProviderProtocol {
        var returnValue: String? = nil
        func getQr(completition: @escaping (String?) -> Void) {
            completition(returnValue)
        }
    }
}
