//
//  ScanView.swift
//  QrWidget
//
//  Created by Dmitriy Sazonov on 19.12.21.
//

import UIKit
import SnapKit


class ScanView: UIView {
    
    fileprivate(set) lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "xmark"), for: .normal)
        return btn
    }()
    
    fileprivate(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.text = NSLocalizedString("Scan QR", comment: "Scan QR")
        return label
    }()
    
    fileprivate(set) lazy var scannerContainer: UIView = {
        let view = UIView()
        return view
    }()

    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
        self.backgroundColor = UIColor.secondarySystemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(closeBtn)
        addSubview(scannerContainer)
    }
    
    private func makeConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(10)
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(-10)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(30)
        }
        closeBtn.snp.makeConstraints { make in
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-8)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.width.height.equalTo(48)
        }
        scannerContainer.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.width.equalTo(scannerContainer.snp.height).priority(.required)
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(30)
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(-30)
        }
    }
}
