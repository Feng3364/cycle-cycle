//
//  ConstVC.swift
//  XFlash_Example
//
//  Created by Felix on 2023/7/6.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import XFlash

private extension StringKey {
    static let screen = "屏幕尺寸"
    static let application = "应用信息"
    static let device = "设备信息"
    
    static let bounds = "屏幕坐标"
    static let screenWidth = "屏幕宽"
    static let screenHeight = "屏幕高"
    static let statusBarHeight = "状态栏高度"
    static let navBarHeight = "导航栏高度"
    static let topHeight = "顶部导航栏高度"
    static let bottomHeight = "底部安全区域高度"
    static let tabBarHeight = "tabBar高度"
    static let mainHeight = "不带tabBar且有导航栏的页面高度"
    static let mainTabBarHeight = "带tabBar且有导航栏的页面高度"
    
    static let displayName = "应用名"
    static let bundleID = "应用标识"
    static let buildNumber = "应用build"
    static let versionNumber = "应用version"
    static let iPhoneX = "是否刘海屏"
    static let applicationShared = "应用单例"
    static let keyWindow = "主窗口"
    
    static let deviceName = "设备名称"
    static let systemVersion = "系统版本"
    static let deviceOrientation = "设备方向"
    static let isLandscape = "设备是否水平"
}

class ConstVC: BaseTableVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetData(with: [
            (title: StringKey.screen,
             list: [
                StringKey.bounds,
                StringKey.screenWidth,
                StringKey.screenHeight,
                StringKey.statusBarHeight,
                StringKey.navBarHeight,
                StringKey.topHeight,
                StringKey.bottomHeight,
                StringKey.tabBarHeight,
                StringKey.mainHeight,
                StringKey.mainTabBarHeight,
            ]),
            (title: StringKey.application,
             list: [
                StringKey.displayName,
                StringKey.bundleID,
                StringKey.buildNumber,
                StringKey.versionNumber,
                StringKey.iPhoneX,
                StringKey.applicationShared,
                StringKey.keyWindow,
            ]),
            (title: StringKey.device,
             list: [
                StringKey.deviceName,
                StringKey.systemVersion,
                StringKey.deviceOrientation,
                StringKey.isLandscape,
            ]),
        ])
    }
    
}

// MARK: - UITableViewDelegate
extension ConstVC {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        
        let title = dataArray[indexPath.section].list[indexPath.row]
        var msg: Any?
        switch title {
        case StringKey.bounds:
            msg = FX.bounds
        case StringKey.screenWidth:
            msg = FX.screenWidth
        case StringKey.screenHeight:
            msg = FX.screenHeight
        case StringKey.statusBarHeight:
            msg = FX.statusBarHeight
        case StringKey.navBarHeight:
            msg = FX.navBarHeight
        case StringKey.topHeight:
            msg = FX.topHeight
        case StringKey.bottomHeight:
            msg = FX.bottomHeight
        case StringKey.tabBarHeight:
            msg = FX.tabBarHeight
        case StringKey.mainHeight:
            msg = FX.mainHeight
        case StringKey.mainTabBarHeight:
            msg = FX.mainTabBarHeight
        case StringKey.displayName:
            msg = FX.displayName
        case StringKey.bundleID:
            msg = FX.bundleID
        case StringKey.buildNumber:
            msg = FX.buildNumber
        case StringKey.versionNumber:
            msg = FX.versionNumber
        case StringKey.iPhoneX:
            msg = FX.iPhoneX
        case StringKey.applicationShared:
            msg = FX.application
        case StringKey.keyWindow:
            msg = FX.keyWindow
        case StringKey.deviceName:
            msg = FX.deviceName
        case StringKey.systemVersion:
            msg = FX.systemVersion
        case StringKey.deviceOrientation:
            msg = FX.deviceOrientation
        case StringKey.isLandscape:
            msg = FX.isLandscape
        default:
            break
        }
        print("\(title):\(msg ?? "nil")")
    }
}
