@testable import QrWidget

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
    var navigationDestination: Home.NavigationDestination?
    func navigate(response: Home.NavigationDestination) {
        isNavigateCalled = true
        navigationDestination = response
    }
}
