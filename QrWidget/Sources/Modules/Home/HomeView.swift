//
//  HomeView.swift
//  QrWidget
//
//  Created by Dmitriy Sazonov on 19.12.21.
//

import SnapKit
import UIKit

class HomeView: UIView {
    
    fileprivate(set) lazy var scanBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle(NSLocalizedString("Scan QR", comment: "Scan QR"), for: .normal)
        btn.backgroundColor = UIColor.systemGray
        return btn
    }()
    
    fileprivate(set) lazy var qrPreview: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        addSubview(qrPreview)
        addSubview(scanBtn)
    }
    
    func makeConstraints() {
        qrPreview.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(qrPreview.snp.width)
        }
        scanBtn.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(30)
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(-30)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-30)
        }
    }
}
