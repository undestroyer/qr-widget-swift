//
//  AboutViewController.swift
//  QrWidget
//
//  Created by Dmitriy Sazonov on 21.12.21.
//

import UIKit

class AboutViewController: UIViewController {

    override func loadView() {
        let view = AboutView(frame: UIScreen.main.bounds)
        self.view = view
    }

}
