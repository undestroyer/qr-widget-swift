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
    let cellReuseId = "CELL_REUSE_ID"
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(onNewQrReceived), name: NSNotification.Name(NotificationCenterConstants.newQrScanned), object: nil)
        
        interactor.fetchQR(request: Home.FetchQr.Request())
        
        customView?.collectionView.dataSource = self
        customView?.collectionView.delegate = self
        customView?.collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseId)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(onInfoBtnTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.viewfinder"), style: .plain, target: self, action: #selector(onScanBtnTapped))
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
            customView?.collectionView.isHidden = true
        case .empty:
            customView?.collectionView.isHidden = true
            customView?.noQrsLabel.isHidden = false
        case .result:
            customView?.noQrsLabel.isHidden = true
            customView?.collectionView.isHidden = false
            customView?.collectionView.reloadData()
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
        interactor.forceQrUpdate(request: Home.ForceQrUpdate.Request())
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        state.qrViewModels().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseId, for: indexPath)
        guard let castedCell = cell as? HomeCollectionViewProtocol else {
            return cell
        }
        let data = state.qrViewModels()
        if data.indices.contains(indexPath.row) {
            castedCell.setData(HomeCollectionViewCellViewModel(
                qrPreview: data[indexPath.row].image,
                name: data[indexPath.row].name))
        }
        return castedCell
    }
}
