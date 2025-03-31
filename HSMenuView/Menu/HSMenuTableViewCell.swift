//
//  HSMenuTableViewCell.swift
//  HS_NPDFConvert
//
//  Created by 123 on 2025/3/21.
//

import UIKit

class HSMenuTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override var isSelected: Bool {
        didSet{
            rightImageView.isHidden = !isSelected
            titleLabel.textColor = isSelected ? UIColor(red: 0.31, green: 0.49, blue: 1, alpha: 1) : UIColor(red: 0.22, green: 0.2, blue: 0.2, alpha: 1)
        }
    }

    private lazy var containerView : UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        return containerView
    }()
    
    private lazy var titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "PingFangSC-Semibold", size: 12)
        titleLabel.textColor = UIColor(red: 0.22, green: 0.2, blue: 0.2, alpha: 1)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    private lazy var rightImageView : UIImageView = {
        let rightImageView = UIImageView()
        rightImageView.image = .init(named: "menu_tick")
        rightImageView.isHidden = true
        return rightImageView
    }()
    
    func initUI(){
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(rightImageView)
    }
    
    func updateLayout(){
        guard let superview = containerView.superview else { return }
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            rightImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        ])

        // rightImageView 约束
        NSLayoutConstraint.activate([
            rightImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            rightImageView.widthAnchor.constraint(equalToConstant: 16),
            rightImageView.heightAnchor.constraint(equalToConstant: 16),
            rightImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])

        // titleLabel 约束
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: rightImageView.leadingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initUI()
        updateLayout()
    }
    
    required init?(coder: NSCoder) {
         // 通过 Interface Builder 加载时调用
         super.init(coder: coder)
        
        initUI()
        updateLayout()
     }
    
    //MARK: --Public
    var title : String = "" {
        didSet{
            titleLabel.text = title
        }
    }
    
}
