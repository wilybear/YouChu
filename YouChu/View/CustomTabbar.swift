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
    var cnt = 0

    private var newBounds: CGRect {
        bounds.inset(by: UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset))
    }
    var hasBottomSafeAreaInsets: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            // with home indicator: 34.0 on iPhone X, XS, XS Max, XR.
            // with home indicator: 20.0 on iPad Pro 12.9" 3rd generation.
            return UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0 > 0
        }
        return false
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
        shapeLayer.shadowOffset = CGSize(width: 0, height: -3)
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
//    override func layoutSubviews() {
//        super.layoutSubviews()
//      //  if cnt < 5 {
//            self.isTranslucent = true
//            var tabFrame = self.frame
//         //   let additionalInset: CGFloat = UIDevice.current.hasNotch ? 0 : 10
//            tabFrame.size.height = 75.adjusted(by: .vertical) + (UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.safeAreaInsets.bottom ?? CGFloat.zero)
//            tabFrame.origin.y = self.frame.origin.y +   ( self.frame.height - 65.adjusted(by: .vertical) - (UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.safeAreaInsets.bottom ?? CGFloat.zero))
//            self.layer.cornerRadius = 20
//            self.frame = tabFrame
//            self.items?.forEach({ $0.titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: -18) })
//    //        cnt += 1
//        print(self.frame)
//    //    }
//
//    }

}
