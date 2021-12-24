import WidgetKit
protocol HomeBusinessLogic {
    func fetchQR(request: Home.FetchQr.Request)
    func forceQrUpdate(request: Home.ForceQrUpdate.Request)
    func openScanner(request: Home.Navigate.RequestScanner)
    func openAbout(request: Home.Navigate.RequestAbout)
}

class HomeInteractor: HomeBusinessLogic {
    let presenter: HomePresentationLogic
    let provider: HomeProviderProtocol

    init(
        presenter: HomePresentationLogic = HomePresenter(),
        provider: HomeProviderProtocol = HomeProvider())
    {
        self.presenter = presenter
        self.provider = provider
    }

    func forceQrUpdate(request: Home.ForceQrUpdate.Request) {
        provider.getQr { qrContent in
            guard let qrContent = qrContent else {
                self.presenter.presentQr(response: Home.FetchQr.Response(result: Home.FetchQrResult.failure))
                return
            }
            self.presenter.presentQr(response: Home.FetchQr.Response(result: Home.FetchQrResult.success(qrContent)))
        }
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func fetchQR(request: Home.FetchQr.Request) {
        provider.getQr { qrContent in
            guard let qrContent = qrContent else {
                self.presenter.presentQr(response: Home.FetchQr.Response(result: Home.FetchQrResult.failure))
                return
            }
            self.presenter.presentQr(response: Home.FetchQr.Response(result: Home.FetchQrResult.success(qrContent)))
        }
    }
    
    func openScanner(request: Home.Navigate.RequestScanner) {
        presenter.navigate(response: Home.NavigationDestination.scanner)
    }
    
    func openAbout(request: Home.Navigate.RequestAbout) {
        presenter.navigate(response: Home.NavigationDestination.about)
    }
    
    
}
