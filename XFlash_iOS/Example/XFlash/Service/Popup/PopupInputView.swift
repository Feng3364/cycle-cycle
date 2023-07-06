//
//  PopupInputView.swift
//  XFlash_Example
//
//  Created by Felix on 2023/7/1.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import XFlash
import SnapKit

class PopupInputView: UIView {
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        addSubview(closeBtn)
        closeBtn.snp.makeConstraints {
            $0.top.right.equalToSuperview()
            $0.width.height.equalTo(16)
        }
        
        addSubview(tf)
        tf.snp.makeConstraints {
            $0.left.top.right.equalToSuperview().inset(16)
            $0.height.equalTo(52)
        }
        
        addSubview(tv)
        tv.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview().inset(16)
            $0.height.equalTo(200)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func close(_ btn: UIButton) {
        PopupManager.shared.dismiss(popup: self)
    }
    
    lazy var closeBtn: UIButton = {
        let b = UIButton(type: .custom)
        b.setTitle("X", for: .normal)
        b.setTitleColor(.gray, for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        b.addTarget(self, action: #selector(close), for: .touchUpInside)
        return b
    }()
    
    lazy var tf: UITextField = {
        let tf = UITextField(frame: .zero)
        tf.placeholder = "请输入"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    lazy var tv: UITextView = {
        let tv = UITextView(frame: .zero)
        tv.backgroundColor = .gray
        tv.text = "这是一个换行输入框"
        return tv
    }()
    
}

extension PopupInputView: PopupProtocol {
    
    func supplyCustomPopupView() -> UIView { self }
    
    func layout(with superV: UIView) {
        snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 300, height: 300))
            $0.center.equalToSuperview()
        }
    }
    
    func popupViewDidAppear() {
        print("\(self.classForCoder):\(Unmanaged.passUnretained(self).toOpaque())出现")
    }
    
    func popupViewDidDisappear() {
        print("\(self.classForCoder):\(Unmanaged.passUnretained(self).toOpaque())消失")
    }
}
