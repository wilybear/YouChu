//
//  CircularImageButton.swift
//  YouChu
//
//  Created by 김현식 on 2021/04/19.
//

import UIKit

class CircularShadowButton: UIButton {

    // MARK: - Properties

    private var shadowLayer: CAShapeLayer!

    var layerBackgroundColor: UIColor = UIColor.white

    override func layoutSubviews() {
        super.layoutSubviews()

        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()

            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.size.width / 2 ).cgPath
            shadowLayer.fillColor = layerBackgroundColor.cgColor
            shadowLayer.shadowColor = UIColor.darkGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.5
            shadowLayer.shadowRadius = 4

            layer.insertSublayer(shadowLayer, at: 0)
        }
    }

//    // MARK: - Helpers
//    private func configureUI(){
//        addSubview(containerView)
//        containerView.anchor(top:topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
//        containerView.layer.cornerRadius = 15
//        containerView.clipsToBounds = true
//        containerView.backgroundColor = .white
//        setImage(#imageLiteral(resourceName: "like").withTintColor(.white), for: .normal)
//        layer.cornerRadius = frame.width / 2
//        clipsToBounds = true
//        backgroundColor = .blue
//    }

}
