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
                state: Home.ViewControllerState.result(
                    HomeViewModel(
                        image: UIImage(systemName: "qrcode")!,
                        isPlaceholder: false
                    )
                )
            )
            viewController?.displayQr(viewModel: vm)
        case let .success(qrContent):
            let vm = Home.FetchQr.ViewModel(
                state: Home.ViewControllerState.result(
                    HomeViewModel(
                        image: qrGenerator.generateQRCode(
                            content: qrContent
                        ),
                        isPlaceholder: false
                    )
                )
            )
            viewController?.displayQr(viewModel: vm)
        }
    }
    
    func forceUpdateQr(response: Home.ForceQrUpdate.Response) {
        switch response.result {
        case .failure:
            let vm = Home.ForceQrUpdate.ViewModel(
                state: Home.ViewControllerState.result(
                    HomeViewModel(
                        image: UIImage(systemName: "qrcode")!,
                        isPlaceholder: false
                    )
                )
            )
            viewController?.forceQrUpdate(viewModel: vm)
        case let .success(qrContent):
            let vm = Home.ForceQrUpdate.ViewModel(
                state: Home.ViewControllerState.result(
                    HomeViewModel(
                        image: qrGenerator.generateQRCode(
                            content: qrContent
                        ),
                        isPlaceholder: false
                    )
                )
            )
            viewController?.forceQrUpdate(viewModel: vm)
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
