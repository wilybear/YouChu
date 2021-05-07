//
//  Device.swift
//  YouChu
//
//  Created by 김현식 on 2021/05/06.
//

import UIKit

// https://medium.com/fantageek/auto-layout-with-different-screen-sizes-in-ios-954c780b2884 블로그 기록
class Device {
  // Base width in point, use iPhone 6
    static let baseHeight: CGFloat = 896
    static let baseWidth: CGFloat = 414
    static var widthRatio: CGFloat {
        return UIScreen.main.bounds.width / baseWidth
    }
    static var heightRatio: CGFloat {
        return UIScreen.main.bounds.height / baseHeight
    }
}
