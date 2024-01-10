//
//  ToastView.swift
//  XFlash_Example
//
//  Created by Felix on 2024/1/10.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import XFlash
import SnapKit

class ToastView: UIView {

    var title: String?
    var image: UIImage?
    init(title: String? = nil, image: UIImage? = nil) {
        self.title = title
        self.image = image
        super.init(frame: .zero)
        
        if let _ = image {
            addSubview(loadingImage)
            loadingImage.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(30)
                $0.size.equalTo(CGSize(width: 43, height: 29))
            }
            
            addSubview(label)
            label.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(loadingImage.snp.bottom).offset(16)
                $0.left.right.equalToSuperview().inset(16)
            }
        } else {
            addSubview(label)
            label.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var loadingImage: UIImageView = {
        let imgv = UIImageView(frame: .zero)
        imgv.image = image
        return imgv
    }()
    
    lazy var label: UILabel = {
        let l = UILabel()
        l.text = title
        l.textAlignment = .center
        l.font = UIFont.boldSystemFont(ofSize: 16)
        return l
    }()
    
}

extension ToastView: PopupProtocol {
    
    func supplyCustomPopupView() -> UIView { self }
    
    func layout(with superV: UIView) {
        snp.makeConstraints {
            $0.size.lessThanOrEqualTo(CGSize(width: 300, height: 400))
            $0.size.greaterThanOrEqualTo(CGSize(width: 80, height: 80))
            $0.center.equalToSuperview()
        }
    }
}
