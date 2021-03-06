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
        btn.backgroundColor = UIColor(named: "Primary")
        return btn
    }()
    
    fileprivate(set) lazy var qrPreview: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    fileprivate(set) lazy var infoBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle(NSLocalizedString("How it works?", comment: "How it works?"), for: .normal)
        btn.setTitleColor(UIColor(named: "Primary"), for: .normal)
        return btn
    }()
    
    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
        backgroundColor = UIColor.systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scanBtn.layer.cornerRadius = scanBtn.frame.height / 2
    }
    
    func addSubviews() {
        addSubview(qrPreview)
        addSubview(scanBtn)
        addSubview(infoBtn)
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
            make.top.equalTo(self.qrPreview.snp.bottom).offset(44)
            make.height.equalTo(54)
        }
        infoBtn.snp.makeConstraints { make in
            make.top.equalTo(scanBtn.snp.bottom).offset(30)
            make.centerX.equalTo(scanBtn.snp.centerX)
        }
    }
}
