//
//  ScanBuilder.swift
//  QrWidget
//
//  Created by Dmitriy Sazonov on 26.12.21.
//

import UIKit

class ScanBuilder: ModuleBuilder {

    var initialState: Scan.ViewControllerState?

    func set(initialState: Scan.ViewControllerState) -> ScanBuilder {
        self.initialState = initialState
        return self
    }

    func build() -> UIViewController {
        let presenter = ScanPresenter()
        let interactor = ScanInteractor(presenter: presenter)
        let controller = ScanViewController(interactor: interactor)

        presenter.viewController = controller
        return controller
    }
}
