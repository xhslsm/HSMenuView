//
//  UIView+Round.swift
//  HS_NPDFConvert
//
//  Created by 123 on 2025/3/19.
//

import UIKit

struct HSRadius {
    var topLeft: CGFloat
    var topRight: CGFloat
    var bottomLeft: CGFloat
    var bottomRight: CGFloat

    init(topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat) {
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomLeft = bottomLeft
        self.bottomRight = bottomRight
    }

    static let zero = HSRadius(topLeft: 0, topRight: 0, bottomLeft: 0, bottomRight: 0)
}

private var hs_operationQueue: OperationQueue = {
    let queue = OperationQueue()
    return queue
}()

private var hs_operationKey: Void?

extension UIView {

    func hs_setCornerRadius(_ radius: HSRadius,
                               borderColor: UIColor?,
                               borderWidth: CGFloat,
                            backgroundColor: UIColor?) {
        
        hs_cancelOperation()
        
        var viewSize = self.bounds.size
        
        let blockOperation = BlockOperation { [weak self] in
            if self?.hs_getOperation()?.isCancelled == true {
                return
            }
            
            if viewSize == .zero {
                DispatchQueue.main.sync {
                    viewSize = (self?.bounds.size)!
                }
            }
            
            guard viewSize != .zero else { return }
            
            // 绘制路径
            let path = UIBezierPath()
            let topLeft = CGPoint(x: 0, y: 0)
            let topRight = CGPoint(x: viewSize.width, y: 0)
            let bottomRight = CGPoint(x: viewSize.width, y: viewSize.height)
            let bottomLeft = CGPoint(x: 0, y: viewSize.height)
            
            path.move(to: CGPoint(x: topLeft.x + radius.topLeft, y: topLeft.y))
            path.addArc(withCenter: CGPoint(x: topLeft.x + radius.topLeft, y: topLeft.y + radius.topLeft),
                        radius: radius.topLeft,
                        startAngle: -.pi / 2,
                        endAngle: .pi,
                        clockwise: false)
            
            path.addLine(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y - radius.bottomLeft))
            path.addArc(withCenter: CGPoint(x: bottomLeft.x + radius.bottomLeft, y: bottomLeft.y - radius.bottomLeft),
                        radius: radius.bottomLeft,
                        startAngle: .pi,
                        endAngle: .pi / 2,
                        clockwise: false)
            
            path.addLine(to: CGPoint(x: bottomRight.x - radius.bottomRight, y: bottomRight.y))
            path.addArc(withCenter: CGPoint(x: bottomRight.x - radius.bottomRight, y: bottomRight.y - radius.bottomRight),
                        radius: radius.bottomRight,
                        startAngle: .pi / 2,
                        endAngle: 0,
                        clockwise: false)
            
            path.addLine(to: CGPoint(x: topRight.x, y: topRight.y + radius.topRight))
            path.addArc(withCenter: CGPoint(x: topRight.x - radius.topRight, y: topRight.y + radius.topRight),
                        radius: radius.topRight,
                        startAngle: 0,
                        endAngle: -.pi / 2,
                        clockwise: false)
            
            path.close()
            
            // 在主线程应用圆角
            OperationQueue.main.addOperation {
                if self?.hs_getOperation()?.isCancelled == true {
                    return
                }
                          
                let maskLayer = CAShapeLayer()
                maskLayer.path = path.cgPath
                maskLayer.zPosition = -1
                self?.layer.mask = maskLayer
                
                let borderLayer = CAShapeLayer()
                borderLayer.path = path.cgPath
                borderLayer.lineWidth = borderWidth
                borderLayer.strokeColor = borderColor?.cgColor
                borderLayer.fillColor = backgroundColor?.cgColor
                borderLayer.zPosition = -1
                self?.layer.addSublayer(borderLayer)
            }
        }
        
        self.hs_setOperation(blockOperation)
        hs_operationQueue.addOperation(blockOperation)
    }
    
    private func hs_getOperation() -> Operation? {
        return objc_getAssociatedObject(self, &hs_operationKey) as? Operation
    }
        
    // Setter method for assigning the operation
    private func hs_setOperation(_ operation: Operation?) {
        objc_setAssociatedObject(self, &hs_operationKey, operation, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    // Cancel the current operation
    private func hs_cancelOperation() {
        if let operation = hs_getOperation() {
            operation.cancel()
            hs_setOperation(nil)
        }
    }
}
