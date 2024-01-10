//
//  AliveThreadVC.swift
//  XFlash_Example
//
//  Created by Felix on 2023/7/6.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import XFlash

fileprivate extension StringKey {
    static let normal = "常规线程"
    static let alive = "常驻线程"
    
    static let start = "启动线程"
    static let print = "打印线程"
    static let operate = "操作线程"
    static let end = "结束线程"
}

class AliveThreadVC: BaseTableVC {
    
    var normal: Thread?
    var alive: AliveThread?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetData(with: [
            (title: StringKey.normal,
             list: [
                StringKey.start,
                StringKey.print,
            ]),
            (title: StringKey.alive,
             list: [
                StringKey.start,
                StringKey.print,
                StringKey.operate,
                StringKey.end,
            ]),
        ])
    }
    
}

// MARK: - UITableViewDelegate
extension AliveThreadVC {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        
        let title = dataArray[indexPath.section].title
        let row = dataArray[indexPath.section].list[indexPath.row]
        switch title {
        case StringKey.normal:
            if row == StringKey.start {
                normal = Thread(block: {
                    print("普通线程干活")
                })
                normal?.start()
            } else if row == StringKey.print {
                print(normal ?? "线程为空")
            }
        case StringKey.alive:
            if row == StringKey.start {
                alive = AliveThread()
            } else if row == StringKey.print {
                print(alive?.liveThread ?? "线程为空")
            } else if row == StringKey.operate {
                alive?.execute {
                    print("常驻线程干活")
                }
            } else if row == StringKey.end {
                alive?.stop()
            }
        default:
            break
        }
    }
}
