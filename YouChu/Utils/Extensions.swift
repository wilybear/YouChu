//
//  Extensions.swift
//  InstagramFirestoreTutorial
//
//  Created by Stephen Dowless on 6/19/20.
//  Copyright © 2020 Stephan Dowless. All rights reserved.
//

import UIKit
import JGProgressHUD

extension UIViewController {
    static let hud = JGProgressHUD(style: .dark)

    func configureGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemPurple.cgColor, UIColor.systemBlue.cgColor]
        gradient.locations = [0, 1]
        view.layer.addSublayer(gradient)
        gradient.frame = view.frame
    }
    func showLoader(_ show: Bool) {
        view.endEditing(true)

        if show {
            UIViewController.hud.show(in: view)
        } else {
            UIViewController.hud.dismiss()
        }
    }

    func showMessage(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension UIButton {
    func attributedTitle(firstPart: String, secondPart: String) {
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(white: 1, alpha: 0.87), .font: UIFont.systemFont(ofSize: 16)]
        let attributedTitle = NSMutableAttributedString(string: "\(firstPart) ", attributes: atts)

        let boldAtts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(white: 1, alpha: 0.87), .font: UIFont.boldSystemFont(ofSize: 16)]
        attributedTitle.append(NSAttributedString(string: secondPart, attributes: boldAtts))

        setAttributedTitle(attributedTitle, for: .normal)
    }
}

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {

        translatesAutoresizingMaskIntoConstraints = false

        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop.adjusted(by: .vertical)).isActive = true
        }

        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft.adjusted(by: .horizontal)).isActive = true
        }

        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom.adjusted(by: .vertical)).isActive = true
        }

        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight.adjusted(by: .horizontal)).isActive = true
        }

        if let width = width {
            widthAnchor.constraint(equalToConstant: width.adjusted(by: .horizontal)).isActive = true
        }

        if let height = height {
            heightAnchor.constraint(equalToConstant: height.adjusted(by: .vertical)).isActive = true
        }
    }

    func center(inView view: UIView, yConstant: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yConstant!).isActive = true
    }

    func centerX(inView view: UIView, topAnchor: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        if let topAnchor = topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: paddingTop!).isActive = true
        }
    }

    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil,
                 paddingLeft: CGFloat = 0, constant: CGFloat = 0) {

        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true

        if let left = leftAnchor {
            anchor(left: left, paddingLeft: paddingLeft)
        }
    }

    func setDimensions(height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }

    func setDimensions(height: CGFloat, width: CGFloat, by dir: Direction) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height.adjusted(by: dir)).isActive = true
        widthAnchor.constraint(equalToConstant: width.adjusted(by: dir)).isActive = true
    }

    func setHeight(_ height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height.adjusted(by: .vertical)).isActive = true
    }

    func setWidth(_ width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width.adjusted(by: .horizontal)).isActive = true
    }

    func fillSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        guard let view = superview else { return }
        anchor(top: view.topAnchor, left: view.leftAnchor,
               bottom: view.bottomAnchor, right: view.rightAnchor)
    }
}

extension UIView {
    func setupShadow(){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 5
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }

    func dropShadow(shadowColor: UIColor = UIColor.black,
                    fillColor: UIColor = UIColor.white,
                    opacity: Float = 0.2,
                    offset: CGSize = CGSize(width: 0.0, height: 1.0),
                    radius: CGFloat = 10) -> CAShapeLayer {

        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: radius).cgPath
        shadowLayer.fillColor = fillColor.cgColor
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = offset
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius = radius
        layer.insertSublayer(shadowLayer, at: 0)
        return shadowLayer
    }


    // https://www.youtube.com/watch?v=S4iygtaoYCs 블로그 기록
    public enum Animation {
        case left
        case right
        case top
        case none
    }

    func slideIn(from edge: Animation = .none, x: CGFloat = 0, y: CGFloat = 0, duration: TimeInterval = 1, delay: TimeInterval = 0, completion: ((Bool) -> Void)? = nil) -> UIView {
        let offset = offsetFor(edge: edge)
        self.alpha = 0.1
        isHidden = false
        transform = CGAffineTransform(translationX: offset.x + x, y: offset.y + y)
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 1, initialSpringVelocity: 2, options: .curveEaseIn, animations: {
            self.transform = .identity
            self.alpha = 1
        }, completion: completion)

        return self
    }

    func slideOut(from edge: Animation = .none, x: CGFloat = 0, y: CGFloat = 0, duration: TimeInterval = 0.5, delay: TimeInterval = 0, completion: ((Bool) -> Void)? = nil) -> UIView {

        let offset = offsetFor(edge: edge)
        print(offset)
        isHidden = false
        let endtransform = CGAffineTransform(translationX: offset.x + x, y: offset.y + y)
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 1, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
            self.transform = endtransform
            self.alpha = 0.1
        }, completion: completion)

        return self
    }

    private func offsetFor(edge:Animation) -> CGPoint {
        if let size = self.superview?.frame.size {
            switch edge {
            case .none:
                return CGPoint.zero
            case .left:
                return CGPoint(x: -(frame.width + 50.adjusted(by: .horizontal)), y:0)
            case .right:
                return CGPoint(x: (frame.width + 50.adjusted(by: .horizontal)), y:0)
            case .top:
                return CGPoint(x: 0,y: -frame.maxY)
            }
        }
        return .zero
    }
    var globalPoint :CGPoint? {
        return self.superview?.convert(self.frame.origin, to: nil)
    }


}

extension CGFloat {

    func adjusted(by dir: Direction) -> (CGFloat) {
        switch dir {
        case .horizontal:
            return self * Device.widthRatio
        case .vertical:
            return self * Device.heightRatio
        }
    }
}
extension Int {

    func adjusted(by dir: Direction) -> (CGFloat) {
        switch dir {
        case .horizontal:
            return CGFloat(self) * Device.widthRatio
        case .vertical:
            return CGFloat(self) * Device.heightRatio
        }
    }
}


enum Direction {
    case vertical
    case horizontal
}

