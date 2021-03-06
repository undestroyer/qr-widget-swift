import UIKit

enum Home {
    // MARK: Use cases
    enum FetchQr {
        struct Request { }

        struct Response {
            var result: FetchQrResult
        }

        struct ViewModel {
            var state: ViewControllerState
        }
    }
    
    enum ForceQrUpdate {
        struct Request { }
        
        struct Response {
            var result: ForceQrUpdateResult
        }

        struct ViewModel {
            var state: ViewControllerState
        }
    }
    
    enum Navigate {
        struct RequestAbout {}
        
        struct RequestScanner {}
        
        struct Response {
            var destination: NavigationDestination
        }
    }

    enum FetchQrResult {
        case failure
        case success(String)
    }
    
    enum ForceQrUpdateResult {
        case failure
        case success(String)
    }

    enum ViewControllerState {
        case loading
        case result(HomeViewModel)
    }
    
    enum NavigationDestination {
        case about
        case scanner
    }
}
