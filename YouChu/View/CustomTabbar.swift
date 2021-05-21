//
//  CustomTabbar.swift
//  YouChu
//
//  Created by 김현식 on 2021/05/21.
//
import UIKit

class CustomTabbar: UITabBar {
    var color: UIColor? = .white
    var radii: CGFloat = 20.0
    var inset: CGFloat = 30

    private var newBounds: CGRect {
        bounds.inset(by: UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset))
    }

    private var shapeLayer: CALayer?

    override func draw(_ rect: CGRect) {
        addShape()
    }

    private func addShape() {
        let shapeLayer = CAShapeLayer()

        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.gray.withAlphaComponent(0.1).cgColor
        shapeLayer.fillColor = color?.cgColor ?? UIColor.white.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.shadowColor = UIColor.black.cgColor
        shapeLayer.shadowOffset = CGSize(width: 0   , height: -3);
        shapeLayer.shadowOpacity = 0.2
        shapeLayer.shadowPath =  UIBezierPath(roundedRect: newBounds, cornerRadius: radii).cgPath


        if let oldShapeLayer = self.shapeLayer {
            layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            layer.insertSublayer(shapeLayer, at: 0)
        }

        self.shapeLayer = shapeLayer
    }

    private func createPath() -> CGPath {

        let path = UIBezierPath(
            roundedRect: newBounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: radii, height: 0.0))

        return path.cgPath
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.isTranslucent = true
        var tabFrame = self.frame
        tabFrame.size.height = 75 + (UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.safeAreaInsets.bottom ?? CGFloat.zero)
        tabFrame.origin.y = self.frame.origin.y +   ( self.frame.height - 65 - (UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.safeAreaInsets.bottom ?? CGFloat.zero))
        self.layer.cornerRadius = 20
        self.frame = tabFrame
        self.items?.forEach({$0.imageInsets = UIEdgeInsets(top: -15, left: 0, bottom: 0, right: 0)})
        self.items?.forEach({ $0.titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: -20.0) })
        self.itemWidth = UIScreen.main.bounds.width / 8
    }


}
