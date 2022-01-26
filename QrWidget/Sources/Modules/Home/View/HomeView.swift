//
//  HomeView.swift
//  QrWidget
//
//  Created by Dmitriy Sazonov on 19.12.21.
//

import SnapKit
import UIKit

class HomeView: UIView {
    
    fileprivate(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 150)
        layout.scrollDirection = .vertical
        
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        return collectionView
    }()
    
    fileprivate(set) lazy var noQrsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "No QRs yet. Use add button above to scan or create QR"
        return label
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
    }
    
    func addSubviews() {
        addSubview(collectionView)
        addSubview(noQrsLabel)
    }
    
    func makeConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide.snp.edges)
        }
        noQrsLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
}
