//
//  HomeCollectionViewCell.swift
//  QrWidget
//
//  Created by Dmitriy Sazonov on 25.01.22.
//

import UIKit

protocol HomeCollectionViewProtocol: UICollectionViewCell {
    func setData(_ data: HomeCollectionViewCellViewModel)
}


struct HomeCollectionViewCellViewModel {
    var qrPreview: UIImage
    var name: String
}

class HomeCollectionViewCell: UICollectionViewCell {
    
    fileprivate(set) var qrPreview: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    fileprivate(set) var nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: NSCoder) is not implemented")
    }
    
    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
        self.backgroundColor = UIColor.secondarySystemBackground
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 4
    }
    
    private func addSubviews() {
        addSubview(qrPreview)
        addSubview(nameLabel)
    }
    
    private func makeConstraints() {
        qrPreview.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.lessThanOrEqualTo(qrPreview.snp.width)
            make.height.greaterThanOrEqualTo(50).priority(.required)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(qrPreview.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
}

extension HomeCollectionViewCell: HomeCollectionViewProtocol {
    func setData(_ data: HomeCollectionViewCellViewModel) {
        qrPreview.image = data.qrPreview
        nameLabel.text = data.name
    }
}
