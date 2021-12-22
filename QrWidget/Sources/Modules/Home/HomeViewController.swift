//
//  ViewController.swift
//  QrWidget
//
//  Created by Dmitriy Sazonov on 19.12.21.
//

import UIKit
import WidgetKit

class HomeViewController: UIViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    var customView: HomeView? { view as? HomeView }
    
    override var modalPresentationStyle: UIModalPresentationStyle {
        get { .fullScreen }
        set { }
    }
    
    override func loadView() {
        let view = HomeView(frame: UIScreen.main.bounds)
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView?.qrPreview.image = QrGenerator().generateQRCode()
        customView?.scanBtn.addTarget(self, action: #selector(onScanBtnTapped), for: .touchUpInside)
        customView?.infoBtn.addTarget(self, action: #selector(onInfoBtnTapped), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onNewQrReceived), name: NSNotification.Name(NotificationCenterConstants.newQrScanned), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.customView?.qrPreview.image = QrGenerator().generateQRCode()
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
    override var shouldAutorotate: Bool { false }

    // MARK: - objc actions
    @objc func onScanBtnTapped() {
        let vc = ScanViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @objc func onInfoBtnTapped() {
        let vc = AboutViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }

    @objc func onNewQrReceived() {
        self.customView?.qrPreview.image = QrGenerator().generateQRCode()
        WidgetCenter.shared.reloadAllTimelines()
    }
    
}
