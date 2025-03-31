//
//  HSMenuLayer.swift
//  HS_NPDFConvert
//
//  Created by 123 on 2025/3/21.
//

import UIKit

class HSMenuLayer: CALayer {
    
    var title: String = ""
    var isShow: Bool = false
    var triangleWidth: CGFloat = 14
    var triangleHeight: CGFloat = 14
    var space: CGFloat = 8
    var fontSize: CGFloat = 12
    
    private var textLayer : CATextLayer = CATextLayer()
    private var shapeLayer : CAShapeLayer = CAShapeLayer()
    

    // 创建标题文本层
    private func createTitleLayer(text: String, position: CGPoint, textColor: UIColor) -> CATextLayer {
        // 计算文本尺寸
        let maxWidth = bounds.size.width - space - triangleWidth
        let textSize = calculateStringSize(text, font: UIFont(name: "PingFangSC-Semibold", size: fontSize)!, maxWidth: maxWidth)
        let textLayerWidth = (textSize.width < maxWidth) ? textSize.width : maxWidth
        
        // 创建文本层
        let textLayer = CATextLayer()
        textLayer.bounds = CGRect(x: 0, y: 0, width: textLayerWidth, height: textSize.height)
        textLayer.fontSize = fontSize
        textLayer.string = text
        if let font = UIFont(name: "PingFangSC-Semibold", size: fontSize) {
            textLayer.font = font
        }
        textLayer.alignmentMode = .center
        textLayer.truncationMode = .end
        textLayer.foregroundColor = textColor.cgColor
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.position = position
        return textLayer
    }
    
    // 创建指示器图层（三角形）
    private func createIndicatorLayer(position: CGPoint, isShow: Bool) -> CAShapeLayer {
        // 三角形路径
        var image = UIImage()
        
        if isShow {
            image = .init(named: "menu_show")!
        }else {
            image = .init(named: "menu_hidden")!
        }
        
        // 创建CAShapeLayer
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = .init(x: 0, y: 0, width: triangleWidth, height: triangleWidth)
        shapeLayer.position = position
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.contents = image.cgImage
        return shapeLayer
    }
    
    override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        
        // 确保背景是透明的
        ctx.clear(bounds)  // 清除原有内容
        
        // 添加标题文本层
        textLayer.removeFromSuperlayer()
        
        let textPoint = CGPoint(x: (bounds.size.width - space - triangleWidth) / 2.0, y:  bounds.midY)
        textLayer = createTitleLayer(text: title, position: textPoint, textColor: .black)
        addSublayer(textLayer)
        
        // 添加指示器图层（三角形）
        shapeLayer.removeFromSuperlayer()
        let shapePoint = CGPoint.init(x: CGRectGetMaxX(textLayer.frame) + space + triangleWidth / 2, y: bounds.midY)
        shapeLayer = createIndicatorLayer(position: shapePoint, isShow: isShow)
        addSublayer(shapeLayer)
    }
    
    private func calculateStringSize(_ string: String, font: UIFont, maxWidth: CGFloat) -> CGSize {
        let label = UILabel()
        label.font = font
        label.text = string
        var size = label.sizeThatFits(.init(width: maxWidth, height: CGFLOAT_MAX))
        size.width += 4
        return size
    }
}
