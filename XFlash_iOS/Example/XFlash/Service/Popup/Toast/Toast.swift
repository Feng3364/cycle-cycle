//
//  Toast.swift
//  XFlash_Example
//
//  Created by Felix on 2024/1/10.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

// MARK: - Toast

public func showToast(_ message: String?,
                      image: UIImage? = nil) {
    let toast = ToastView(title: message, image: image)
    
    var config = PopupConfigure()
    config.isClickDismiss = false
    config.cornerRadius = 8
    config.dismissDuration = 1.5
    
    PopupManager.shared.add(popup: toast, options: config)
}

// MARK: - Loading

public func showLoading() {
    let toast = ToastView(image: nil)
    
    var config = PopupConfigure()
    config.isClickDismiss = false
    config.cornerRadius = 8
    
    PopupManager.shared.add(popup: toast, options: config)
}

public func hideLoading() {
    PopupManager.shared.removeAllPopup()
}
