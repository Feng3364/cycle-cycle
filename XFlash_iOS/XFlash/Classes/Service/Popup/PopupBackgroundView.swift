//
//  PopupBackgroundView.swift
//  XFlash
//
//  Created by Felix on 2023/6/27.
//

import UIKit

class PopupBackgroundView: UIView {
    
    var hiddenBg: Bool
    
    override init(frame: CGRect) {
        hiddenBg = false
        
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super .hitTest(point, with: event)
        if hitView == self, hiddenBg {
            return nil
        } else {
            return hitView
        }
    }
}
