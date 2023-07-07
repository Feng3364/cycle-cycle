//
//  ViewController.swift
//  XFlash
//
//  Created by Felix on 06/25/2023.
//  Copyright (c) 2023 Felix. All rights reserved.
//

import UIKit

class ViewController: BaseTableVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "XFlash实验室"
        resetData(with: [
            (title: "通用", list: ["Const"]),
            (title: "UI", list: []),
            (title: "服务", list: ["PopupService"])
        ])
    }
}

extension ViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        
        let title = dataArray[indexPath.section].list[indexPath.row]
        guard let vc = getVCByClassString(title)
        else { return }
        
        vc.title = title
        vc.view.backgroundColor = .white
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func getVCByClassString(_ title: String) -> UIViewController? {
        guard let clsName = Bundle.main.infoDictionary!["CFBundleExecutable"] else {
            print("命名空间不存在")
            return nil
        }
        
        let name = (clsName as! String) + "." + title + "VC"
        let cls: AnyClass? = NSClassFromString(name)
        guard let clsType = cls as? UIViewController.Type else {
            print("无法转换成UIViewController")
            return nil
        }
         
         let childController = clsType.init()
         return childController
    }
}
