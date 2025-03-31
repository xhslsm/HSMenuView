//
//  ViewController.swift
//  HSMenuView
//
//  Created by 123 on 2025/3/31.
//

import UIKit

class ViewController: UIViewController, HSMebuDelegate, HSMebuDataSource {
    func numberOfItems(in menu: HSMenuView) -> Int {
        return menuDataSource.count
    }
    
    func menu(_ menu: HSMenuView, dataForItemAt index: Int) -> HSMenuModel {
        return menuDataSource[index]
    }
    
    func menu(_ menu: HSMenuView, didSelectItemAt index: Int) {
        print("当前选中下标：" + "\(index)")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .darkGray
         
        view.addSubview(menuView)
        menuView.frame = .init(x: 50, y: 90, width: 100, height: 28)
    }
    
    //MARK --Lazy
    private lazy var menuDataSource : [HSMenuModel] = {
        let arr = [HSMenuModel.init(title: "全部"), HSMenuModel.init(title: "类型1"),
                   HSMenuModel.init(title: "类型2"), HSMenuModel.init(title: "类型3"),
                   HSMenuModel.init(title: "类型4"), HSMenuModel.init(title: "类型5")
                   ]
        return arr
    }()

    private lazy var menuView : HSMenuView = {
        let menu = HSMenuView()
        menu.backgroundColor = .white
        menu.layer.cornerRadius = 10
        menu.delegate = self
        menu.dataSource = self
        return menu
    }()
}

