//
//  AboutViewController.swift
//  QrWidget
//
//  Created by Dmitriy Sazonov on 21.12.21.
//

import UIKit

class AboutViewController: UIViewController {

    var customView: AboutView? { view as? AboutView }
    
    override func loadView() {
        let view = AboutView(frame: UIScreen.main.bounds)
        self.view = view
    }
    
    override func viewDidLoad() {
        guard let customView = customView else {
            return
        }
        customView.closeBtn.addTarget(self, action: #selector(onCloseTapped), for: .touchUpInside)
    }
    
    // - MARK: objc
    @objc func onCloseTapped() {
        dismiss(animated: true, completion: nil)
    }

}
