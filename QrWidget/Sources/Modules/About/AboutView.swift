//
//  HomeView.swift
//  QrWidget
//
//  Created by Dmitriy Sazonov on 21.12.21.
//

import Foundation
import UIKit
import SnapKit
import SwiftUI

class AboutView: UIView {
    
    fileprivate(set) lazy var scroll: UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()
    
    fileprivate(set) lazy var labelsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    fileprivate(set) lazy var titleLabel: UILabel = {
        buildLabelForItem(LabelsStackItem(content: NSLocalizedString("About", comment: "About"), level: .title))
    }()
    
    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        backgroundColor = UIColor.secondarySystemBackground
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(scroll)
        addSubview(titleLabel)
        scroll.addSubview(labelsStack)
        addLabelsToStack()
    }
    
    private func makeConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(8)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-8)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(30)
        }
        scroll.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.bottom.equalToSuperview()
        }
        scroll.frameLayoutGuide.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing)
        }
        labelsStack.snp.makeConstraints { make in
            make.top.equalTo(scroll.contentLayoutGuide.snp.top)
            make.bottom.equalTo(scroll.contentLayoutGuide.snp.bottom).offset(0)
            make.leading.equalTo(scroll.contentLayoutGuide.snp.leading).offset(8)
            make.trailing.equalTo(scroll.contentLayoutGuide.snp.trailing).offset(-8)
            make.width.equalTo(scroll.frameLayoutGuide.snp.width).offset(-16)
        }
    }
    
    private func addLabelsToStack() {
        let contentItems: [LabelsStackItem] = [
            LabelsStackItem(content: NSLocalizedString("This application allows you to add a QR code widget to your home screen (desktop).", comment: "This application allows you to add a QR code widget to your home screen (desktop)."), spacingAfter: .large),
            LabelsStackItem(content: NSLocalizedString("For everything to work as expected, you need to do the following:", comment: "For everything to work as expected, you need to do the following:"), spacingAfter: .large),
            LabelsStackItem(content: NSLocalizedString("1) Scan QR by clicking on the \"Scan QR\" button on the main screen of the application", comment: "1) Scan QR by clicking on the \"Scan QR\" button on the main screen of the application"), spacingAfter: .small),
            LabelsStackItem(content: NSLocalizedString("2) (optional) Allow access to the camera (without permission, the application will not be able to scan the code)", comment: "2) (optional) Allow access to the camera (without permission, the application will not be able to scan the code)"),  spacingAfter: .small),
            LabelsStackItem(content: NSLocalizedString("3) Point the camera at your QR", comment: "3) Point the camera at your QR"),  spacingAfter: .small),
            LabelsStackItem(content: NSLocalizedString("4) Once the app recognizes the QR, the app will return to the home screen and show your QR.", comment: "4) Once the app recognizes the QR, the app will return to the home screen and show your QR."),  spacingAfter: .small),
            LabelsStackItem(content: NSLocalizedString("5) Now it's time to add the widget to your home screen. Minimize the application and pinch the free space on the screen with your finger", comment: "5) Now it's time to add the widget to your home screen. Minimize the application and pinch the free space on the screen with your finger"),  spacingAfter: .small),
            LabelsStackItem(content: NSLocalizedString("6) Click on the button with \"+\" in the upper right corner", comment: "6) Click on the button with \"+\" in the upper right corner"),  spacingAfter: .small),
            LabelsStackItem(content: NSLocalizedString("7) Find this application in the list, click on it and select the appropriate widget form.", comment: "7) Find this application in the list, click on it and select the appropriate widget form.")),
            LabelsStackItem(content: NSLocalizedString("That's all, now you have it on your home screen. To replace QR - scan another QR in the application and the widget will immediately update.", comment: "That's all, now you have it on your home screen. To replace QR - scan another QR in the application and the widget will immediately update."), spacingAfter: .large),
            LabelsStackItem(content: NSLocalizedString("The QR in the widget may look slightly different from the one you scanned. This is normal, no changes were made to your QR, it was just created with slightly different parameters.", comment: "The QR in the widget may look slightly different from the one you scanned. This is normal, no changes were made to your QR, it was just created with slightly different parameters."),  spacingAfter: .extraLarge),
            LabelsStackItem(content: NSLocalizedString("How the app works:", comment: "How the app works:"), level: .subtitle, spacingAfter: .large),
            LabelsStackItem(content: NSLocalizedString("- You scan the QR in the app", comment: "- You scan the QR in the app"), spacingAfter: .small),
            LabelsStackItem(content: NSLocalizedString("- The app recognizes QR and receives data from the code", comment: "- The app recognizes QR and receives data from the code"), spacingAfter: .small),
            LabelsStackItem(content: NSLocalizedString("- The application creates a new QR with the specified data", comment: "- The application creates a new QR with the specified data"), spacingAfter: .extraLarge),
            LabelsStackItem(content: NSLocalizedString("Questions and answers:", comment: "Questions and answers:"), level: .subtitle, spacingAfter: .large),
            LabelsStackItem(content: NSLocalizedString("Question: Can the app work with multiple QR codes?", comment: "Question: Can the app work with multiple QR codes?"), spacingAfter: .small),
            LabelsStackItem(content: NSLocalizedString("Answer: No, the current version of the app only supports 1 QR.", comment: "Answer: No, the current version of the app only supports 1 QR."), spacingAfter: .normal),
            LabelsStackItem(content: NSLocalizedString("Q: Can the app recognize QR from the gallery photo?", comment: "Q: Can the app recognize QR from the gallery photo?"), spacingAfter: .small),
            LabelsStackItem(content: NSLocalizedString("A: No, the current version of the app only recognizes QR from the camera.", comment: "A: No, the current version of the app only recognizes QR from the camera."), spacingAfter: .normal),
            LabelsStackItem(content: NSLocalizedString("Q: The app does not recognize QR. What to do?", comment: "Q: The app does not recognize QR. What to do?"), spacingAfter: .small),
            LabelsStackItem(content: NSLocalizedString("A: There may be a lack of lighting or contrast. If you scan QR from another monitor, glare may be interfering.", comment: "A: There may be a lack of lighting or contrast. If you scan QR from another monitor, glare may be interfering."), spacingAfter: .normal),
            LabelsStackItem(content: NSLocalizedString("Q: QR is not displayed in the widget. What to do?", comment: "Q: QR is not displayed in the widget. What to do?"), spacingAfter: .small),
            LabelsStackItem(content: NSLocalizedString("A: Try to re-scan your QR or remove and re-add the widget.", comment: "A: Try to re-scan your QR or remove and re-add the widget."), spacingAfter: .normal),
            LabelsStackItem(content: NSLocalizedString("Q: QR in the widget cannot be scanned. What to do?", comment: "Q: QR in the widget cannot be scanned. What to do?"), spacingAfter: .small),
            LabelsStackItem(content: NSLocalizedString("A: Try to increase the brightness of your screen, perhaps the current brightness is not enough and the scanning device cannot detect QR.", comment: "A: Try to increase the brightness of your screen, perhaps the current brightness is not enough and the scanning device cannot detect QR."))
        ]
        
        for item in contentItems {
            let label = buildLabelForItem(item)
            labelsStack.addArrangedSubview(label)
            var spacingAfter: CGFloat = 10
            switch item.spacingAfter {
            case .extraLarge:
                spacingAfter = 30
            case .large:
                spacingAfter = 20
            case .small:
                spacingAfter = 5
            default:
                spacingAfter = 10
            }
            labelsStack.setCustomSpacing(spacingAfter, after: label)
        }
    }
    
    private func buildLabelForItem(_ item: LabelsStackItem) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = item.content
        
        switch item.level {
        case .subtitle:
            label.font = UIFont.preferredFont(forTextStyle: .title2)
        case .title:
            label.font = UIFont.preferredFont(forTextStyle: .title1)
        default:
            label.font = UIFont.preferredFont(forTextStyle: .body)
        }
        
        return label
    }
    
    struct LabelsStackItem {
        var content: String
        var level: Level = .basic
        var spacingAfter: Spacing = .normal
        
        enum Level {
            case basic
            case title
            case subtitle
        }
        
        enum Spacing {
            case small
            case normal
            case large
            case extraLarge
        }
    }
}
