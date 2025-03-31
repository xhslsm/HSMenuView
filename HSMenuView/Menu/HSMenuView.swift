//
//  HSMenu.swift
//  HS_NPDFConvert
//
//  Created by 123 on 2025/3/20.
//

import UIKit

protocol HSMebuDelegate : AnyObject {
    ///选中下标
    func menu(_ menu: HSMenuView, didSelectItemAt index: Int)
}

protocol HSMebuDataSource : AnyObject {
    ///菜单数量
    func numberOfItems(in menu: HSMenuView) -> Int
    ///返回一个HSMenuData实例
    func menu(_ menu: HSMenuView, dataForItemAt index: Int) -> HSMenuModel
}

class HSMenuView: UIView {
    
    weak var delegate: HSMebuDelegate?
    weak var dataSource: HSMebuDataSource?
    
    var title: String = "Menu" {
        didSet {
            menuLayer.title = title
            menuLayer.setNeedsDisplay()
        }
    }
    
    //Cell高度
    var cellHeight: CGFloat = 32
    
    //当前下标
    var selectIndex : Int = 0 {
        didSet{
            guard let ds = dataSource else { return }
            title = ds.menu(self, dataForItemAt: selectIndex).title ?? ""
            tableView.reloadData()
        }
    }
    
    private let menuLayer = HSMenuLayer()
    
    private func setupLayer() {
        menuLayer.frame = bounds
        menuLayer.cornerRadius = 10
        menuLayer.masksToBounds = true
        menuLayer.isShow = isShow
        menuLayer.title = title
        layer.addSublayer(menuLayer)
    }
    
    private lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorColor = .gray
        tableView.register(HSMenuTableViewCell.self, forCellReuseIdentifier: CellIdentify)
        tableView.hs_setCornerRadius(.init(topLeft: 0, topRight: 0, bottomLeft: 10, bottomRight: 10), borderColor: .clear, borderWidth: 0, backgroundColor: self.backgroundColor)
        return tableView
    }()
    
    private let CellIdentify = "HSMenuTableViewCell"
    
    ///菜单展开状态
    private var isShow = false
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let menuTap = UITapGestureRecognizer(target: self, action: #selector(menuTapped))
        self.addGestureRecognizer(menuTap)
        
        setupLayer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        menuLayer.frame = bounds
        
        guard let ds = dataSource else { return }
        title = ds.menu(self, dataForItemAt: selectIndex).title ?? ""
        
        menuLayer.setNeedsDisplay()
    }
    
    @objc private func menuTapped(){
        guard let ds = dataSource else { return }
        
        tableView.backgroundColor = self.backgroundColor
        if isShow {
            //收起
            UIView.animate(withDuration: 0.2, animations: {
                self.tableView.frame.size.height = 0
            }, completion: { (finished) in
                self.tableView.removeFromSuperview()
            })
            
            self.hs_setCornerRadius(.init(topLeft: 10, topRight: 10, bottomLeft: 10, bottomRight: 10), borderColor: .clear, borderWidth: 0, backgroundColor: self.backgroundColor)
            
        }else{
            //展开
            tableView.reloadData()
            
            if let mySuperview = superview{
                tableView.frame = .init(x: frame.origin.x, y: CGRectGetMaxY(frame), width: CGRectGetWidth(frame), height: 0)
                
                let numberOfRow = ds.numberOfItems(in: self)
                
                let maxHeight = CGRectGetMaxY(mySuperview.frame) - CGRectGetMaxY(frame)
                let heightForTableView = CGFloat(numberOfRow) * cellHeight > maxHeight ? maxHeight :  CGFloat(numberOfRow) * cellHeight
                
                mySuperview.addSubview(tableView)
                
                UIView.animate(withDuration: 0.2) {
                    self.tableView.frame.size.height = heightForTableView
                }
            }
            
            self.hs_setCornerRadius(.init(topLeft: 10, topRight: 10, bottomLeft: 0, bottomRight: 0), borderColor: .clear, borderWidth: 0, backgroundColor: self.backgroundColor)
        }
        
        isShow.toggle()
        
        menuLayer.isShow = isShow
        menuLayer.setNeedsDisplay()
    }
    
    func hiddenMenu(){
        if isShow == false {
            return
        }
        
        isShow = false
        
        UIView.animate(withDuration: 0.2, animations: {
            self.tableView.frame.size.height = 0
        }, completion: { (finished) in
            self.tableView.removeFromSuperview()
        })
        
        self.hs_setCornerRadius(.init(topLeft: 10, topRight: 10, bottomLeft: 10, bottomRight: 10), borderColor: .clear, borderWidth: 0, backgroundColor: self.backgroundColor)
        
        
        menuLayer.isShow = isShow
        menuLayer.setNeedsDisplay()
    }
}

extension HSMenuView : UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfItems(in: self) ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentify, for: indexPath) as! HSMenuTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = self.backgroundColor
        if let data = dataSource?.menu(self, dataForItemAt: indexPath.row) {
            cell.title = data.title ?? ""
            cell.isSelected = indexPath.row == selectIndex
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let ds = dataSource else { return }
        
        selectIndex = indexPath.row
        title = ds.menu(self, dataForItemAt: indexPath.row).title ?? ""
        
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.menu(self, didSelectItemAt: indexPath.row)
        
        if indexPath.row != selectIndex {
            selectIndex = indexPath.row
            tableView.reloadData()
        }
    }
}
