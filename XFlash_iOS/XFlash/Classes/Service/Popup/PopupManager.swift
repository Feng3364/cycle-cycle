//
//  PopupManager.swift
//  XFlash
//
//  Created by Felix on 2023/6/26.
//

public struct PopupManager {
    
    // MARK: - 单例
    public static let shared = PopupManager()
    
    private init() {
        print("初始化单例")
    }
}
