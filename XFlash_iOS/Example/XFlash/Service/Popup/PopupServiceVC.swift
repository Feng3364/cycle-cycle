//
//  PopupServiceVC.swift
//  XFlash_Example
//
//  Created by Felix on 2023/6/29.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import XFlash

class PopupServiceVC: BaseTableVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        resetData(with: [
            (title: "单一", list: ["top", "center", "bottom", "full"]),
            (title: "同组", list: []),
            (title: "混合", list: ["PopupService"])
        ])
    }
    
}

extension PopupServiceVC {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        let title = dataArray[indexPath.section].title
        let titleForRow = dataArray[indexPath.section].list[indexPath.row]
        switch title {
        case "单一":
            handleSingleCondition(titleForRow)
        case "同组":
            handleGroupCondition(titleForRow)
        case "混合":
            handleMultiCondition(titleForRow)
        default:
            break
        }
    }
    
    func handleSingleCondition(_ title: String) {
        switch title {
        case "top":
            break
        case "center":
            var config = PopupConfigure()
            config.sceneStyle = .center
            config.isClickDismiss = true
            config.cornerRadius = 8
            config.popStyle = .scale
            config.priority = 80
            
            let centerV = CenterView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
            PopupManager.shared.add(popup: centerV, options: config)
        case "bottom":
            break
        case "full":
            break
        default:
            break
        }
    }
    
    func handleGroupCondition(_ title: String) {
        
    }
    
    func handleMultiCondition(_ title: String) {
        
    }
}
