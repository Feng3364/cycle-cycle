//
//  PopupView.swift
//  XFlash_Example
//
//  Created by Felix on 2023/6/29.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import XFlash
import SnapKit

class PopupView: UIView {

    var type: PopupScene
    init(type: PopupScene) {
        self.type = type
        super.init(frame: .zero)
        
        var text = ""
        switch type {
        case .center:
            backgroundColor = .red
            text = "中心弹窗"
        case .top:
            backgroundColor = .blue
            text = "顶部Tip"
        case .bottom:
            backgroundColor = .black
            text = "底部弹窗"
        case .full:
            backgroundColor = .green
            text = "全屏广告"
        }
        label.text = "\(text)-\(PopupManager.shared.getAllPopupCount())"
        
        
        addSubview(closeBtn)
        closeBtn.snp.makeConstraints {
            $0.top.right.equalToSuperview()
            $0.width.height.equalTo(16)
        }
        
        addSubview(label)
        label.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
    
    lazy var label: UILabel = {
        let l = UILabel()
        l.text = "center"
        l.textColor = .yellow
        l.textAlignment = .center
        l.font = UIFont.boldSystemFont(ofSize: 16)
        return l
    }()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard type == .full else { return }
        
        PopupManager.shared.dismiss(popup: self)
    }
    
}

extension PopupView: PopupProtocol {
    
    func supplyCustomPopupView() -> UIView { self }
    
    func layout(with superV: UIView) {
        switch type {
        case .center:
            snp.makeConstraints {
                $0.size.equalTo(CGSize(width: 300, height: 300))
                $0.center.equalToSuperview()
            }
        case .top:
            snp.makeConstraints {
                $0.left.top.right.equalToSuperview()
                $0.height.equalTo(200)
            }
        case .bottom:
            snp.makeConstraints {
                $0.left.bottom.right.equalToSuperview()
                $0.height.equalTo(500)
            }
        case .full:
            snp.makeConstraints { $0.edges.equalToSuperview() }
        }
    }
    
    func popupViewDidAppear() {
        print("\(self.classForCoder):\(Unmanaged.passUnretained(self).toOpaque())出现")
    }
    
    func popupViewDidDisappear() {
        print("\(self.classForCoder):\(Unmanaged.passUnretained(self).toOpaque())消失")
    }
}
