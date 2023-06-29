//
//  ViewController.swift
//  XFlash
//
//  Created by Felix on 06/25/2023.
//  Copyright (c) 2023 Felix. All rights reserved.
//

import UIKit
import XFlash

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "XFlash实验室"
        view.addSubview(table)
    }
    
    lazy var dataArray = [
        (title: "通用", list: []),
        (title: "UI", list: []),
        (title: "服务", list: ["PopupService"])
    ]
    
    lazy var table: UITableView = {
        let t = UITableView(frame: self.view.bounds, style: .grouped)
        t.separatorStyle = .none
        t.backgroundColor = .clear
        t.estimatedRowHeight = 100
        t.showsVerticalScrollIndicator = false
        t.showsHorizontalScrollIndicator = false
        t.sectionIndexColor = .gray
        t.delegate  = self
        t.dataSource = self
        t.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return t
    }()
}

extension ViewController: UITableViewDataSource {
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return dataArray.map { $0.title }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataArray[section].title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray[section].list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataArray[indexPath.section].list[indexPath.row]
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = dataArray[indexPath.section].list[indexPath.row]
        guard let vc = getVCByClassString(title)
        else { return }
        
        vc.title = title
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
