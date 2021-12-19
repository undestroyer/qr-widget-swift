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
    
    override func loadView() {
        let view = HomeView(frame: UIScreen.main.bounds)
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView?.qrPreview.image = QrGenerator().generateQRCode()
        customView?.scanBtn.addTarget(self, action: #selector(onScanBtnTapped), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
    override var shouldAutorotate: Bool { false }

    // MARK: - objc actions
    @objc func onScanBtnTapped() {
        present(ScanViewController(), animated: true, completion: nil)
    }

}

