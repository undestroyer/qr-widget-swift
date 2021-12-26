//
//  ViewController.swift
//  QrWidget
//
//  Created by Dmitriy Sazonov on 19.12.21.
//

import UIKit

protocol HomeDisplayLogic: AnyObject {
    func displayQr(viewModel: Home.FetchQr.ViewModel)
    func forceQrUpdate(viewModel: Home.ForceQrUpdate.ViewModel)
    func openScanner()
    func openAbout()
}

class HomeViewController: UIViewController, HomeDisplayLogic {
    let interactor: HomeBusinessLogic
    var state: Home.ViewControllerState
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
    override var shouldAutorotate: Bool { false }
    var customView: HomeView? { view as? HomeView }
    
    init(interactor: HomeBusinessLogic, initialState: Home.ViewControllerState = .loading) {
        self.interactor = interactor
        self.state = initialState
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = HomeView(frame: UIScreen.main.bounds)
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView?.scanBtn.addTarget(self, action: #selector(onScanBtnTapped), for: .touchUpInside)
        customView?.infoBtn.addTarget(self, action: #selector(onInfoBtnTapped), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onNewQrReceived), name: NSNotification.Name(NotificationCenterConstants.newQrScanned), object: nil)
        
        interactor.fetchQR(request: Home.FetchQr.Request())
    }

    func displayQr(viewModel: Home.FetchQr.ViewModel) {
        state = viewModel.state
        displayState()
    }
    
    func forceQrUpdate(viewModel: Home.ForceQrUpdate.ViewModel) {
        state = viewModel.state
        displayState()
    }
    
    private func displayState() {
        switch state {
        case .loading:
            customView?.qrPreview.isHidden = true
        case let .result(vm):
            customView?.qrPreview.isHidden = false
            customView?.qrPreview.image = vm.image
            customView?.qrPreview.tintColor = vm.isPlaceholder ? UIColor.systemBlue : nil
        }
    }
    
    func openScanner() {
        let vc = ScanBuilder().build()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func openAbout() {
        let vc = AboutViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: - objc actions
    @objc func onScanBtnTapped() {
        interactor.openScanner(request: Home.Navigate.RequestScanner())
    }
    
    @objc func onInfoBtnTapped() {
        interactor.openAbout(request: Home.Navigate.RequestAbout())
    }

    @objc func onNewQrReceived() {
        
    }
    
}
