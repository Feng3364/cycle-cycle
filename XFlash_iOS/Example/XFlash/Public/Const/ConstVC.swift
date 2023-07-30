//
//  ConstVC.swift
//  XFlash_Example
//
//  Created by Felix on 2023/7/6.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import XFlash

class ConstVC: BaseTableVC {

    override func viewDidLoad() {
        super.viewDidLoad()
//
//        NSLog(@"********************设备信息********************");
//        NSLog(@"设备名称:%@", XFlash.deviceName);
//        NSLog(@"系统版本:%@", XFlash.systemVersion);
//        NSLog(@"设备方向:%ld", (long)XFlash.deviceOrientation);
//        NSLog(@"设备是否水平:%d", XFlash.isLandscape);
        resetData(with: [
            (title: "屏幕尺寸", list: [
                "屏幕坐标",
                "屏幕宽",
                "屏幕高",
                "状态栏高度",
                "导航栏高度",
                "顶部导航栏高度",
                "底部安全区域高度",
                "tabBar高度",
                "不带tabBar且有导航栏的页面高度",
                "带tabBar且有导航栏的页面高度",
            ]),
            //
            //        NSLog(@"****************************************");
            //        NSLog(@":%@", XFlash.displayName);
            //        NSLog(@"应用标识:%@", XFlash.bundleID);
            //        NSLog(@"应用build:%@", XFlash.buildNumber);
            //        NSLog(@"应用version:%@", XFlash.versionNumber);
            //        NSLog(@"是否刘海屏:%d", XFlash.iPhoneX);
            //        NSLog(@"应用单例:%@", XFlash.application);
            //        NSLog(@"主窗口:%@", XFlash.keyWindow);
            (title: "应用信息", list: [
                "应用名",
                "应用标识",
                "屏幕高",
                "状态栏高度",
                "导航栏高度",
                "顶部导航栏高度",
                "底部安全区域高度",
                "tabBar高度",
                "不带tabBar且有导航栏的页面高度",
                "带tabBar且有导航栏的页面高度",
            ]),
        ])
    }
    
}

// MARK: - UITableViewDelegate
extension ConstVC {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        
        navigationController?.pushViewController(OCConstVC(), animated: true)
    }
    
}
