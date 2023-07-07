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

        resetData(with: [
            (title: "设备尺寸", list: [
                "屏幕宽",
                "屏幕高",
                "",
                "",
                "App名称",
                "AppID",
                "Build",
                "Version",
                "设备名",
                "设备方向",
                ""
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
