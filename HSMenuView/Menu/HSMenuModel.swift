//
//  HSMenuData.swift
//  HS_NPDFConvert
//
//  Created by 123 on 2025/3/21.
//

import UIKit

class HSMenuModel: NSObject {
    var title: String?
    
    init(title: String) {
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
