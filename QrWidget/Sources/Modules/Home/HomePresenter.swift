import UIKit

protocol HomePresentationLogic {
    func presentQr(response: Home.FetchQr.Response)
    func forceUpdateQr(response: Home.ForceQrUpdate.Response)
    func navigate(response: Home.NavigationDestination)
}

class HomePresenter: HomePresentationLogic {
    let qrGenerator: QrGeneratorProtocol
    
    init(qrGenerator: QrGeneratorProtocol = QrGenerator()) {
        self.qrGenerator = qrGenerator
    }
    
    weak var viewController: HomeDisplayLogic?
    
    func presentQr(response: Home.FetchQr.Response) {
        switch response.result {
        case .failure:
            let vm = Home.FetchQr.ViewModel(
                state: Home.ViewControllerState.empty
            )
            viewController?.displayQr(viewModel: vm)
        case let .success(qrs):
            if qrs.isEmpty {
                let vm = Home.FetchQr.ViewModel(state: Home.ViewControllerState.empty)
                viewController?.displayQr(viewModel: vm)
            } else {
                let vm = Home.FetchQr.ViewModel(
                    state: Home.ViewControllerState.result(
                        HomeViewModel(
                            qrs: qrs.map { HomeQrViewModel(
                                id: $0.id,
                                image: qrGenerator.generateQRCode(content: $0.content),
                                name: $0.name) }
                        )
                    )
                )
                viewController?.displayQr(viewModel: vm)
            }
        }
    }
    
    func forceUpdateQr(response: Home.ForceQrUpdate.Response) {
        switch response.result {
        case .failure:
            let vm = Home.ForceQrUpdate.ViewModel(
                state: Home.ViewControllerState.empty
            )
            viewController?.forceQrUpdate(viewModel: vm)
        case let .success(qrs):
            if qrs.isEmpty {
                let vm = Home.ForceQrUpdate.ViewModel(state: Home.ViewControllerState.empty)
                viewController?.forceQrUpdate(viewModel: vm)
            } else {
                let vm = Home.ForceQrUpdate.ViewModel(
                    state: Home.ViewControllerState.result(
                        HomeViewModel(
                            qrs: qrs.map { HomeQrViewModel(
                                id: $0.id,
                                image: qrGenerator.generateQRCode(content: $0.content),
                                name: $0.name) }
                        )
                    )
                )
                viewController?.forceQrUpdate(viewModel: vm)
            }
        }
    }
    
    func navigate(response: Home.NavigationDestination) {
        switch response {
        case .about:
            viewController?.openAbout()
        case .scanner:
            viewController?.openScanner()
        }
    }
}
