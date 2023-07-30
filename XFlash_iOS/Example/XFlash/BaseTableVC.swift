//
//  BaseTableVC.swift
//  XFlash_Example
//
//  Created by Felix on 2023/6/29.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

struct StringKey {}

class BaseTableVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(table)
    }
    
    var dataArray: [(title: String, list: [String])] = []
    
    func resetData(with list: [(title: String, list: [String])]) {
        dataArray = list
    }
    
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

extension BaseTableVC: UITableViewDataSource {
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

extension BaseTableVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
