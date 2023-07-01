//
//  CenterView.swift
//  XFlash_Example
//
//  Created by Felix on 2023/6/29.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import XFlash

class CenterView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var label: UILabel = {
        let l = UILabel(frame: self.bounds)
        l.text = "center"
        l.textColor = .yellow
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 14)
        return l
    }()
    
}

extension CenterView: PopupProtocol {
    
    func supplyCustomPopupView() -> UIView { self }
}
