//
//  Color.swift
//  AppStoreDemo
//
//  Created by FlyKite on 2019/9/30.
//  Copyright © 2019 Doge Studio. All rights reserved.
//

import UIKit

enum ColorType {
    case background
    case separator
    
    case textColor
    case detailTextColor
    case placeholderColor
}

protocol ColorResource {
    func color(for type: ColorType) -> UIColor
}

extension UITraitEnvironment {
    var colorResource: ColorResource {
        if #available(iOS 12, *) {
            switch traitCollection.userInterfaceStyle {
            case .unspecified, .light: return LightColor()
            case .dark: return DarkColor()
            @unknown default: return LightColor()
            }
        } else {
            return LightColor()
        }
    }
}

private struct LightColor: ColorResource {
    func color(for type: ColorType) -> UIColor {
        switch type {
        case .background: return .white
        case .separator: return 0xE0E0E0.rgbColor
        case .textColor: return 0x212121.rgbColor
        case .detailTextColor: return 0x9E9E9E.rgbColor
        case .placeholderColor: return 0x9E9E9E.rgbColor
        }
    }
}

private struct DarkColor: ColorResource {
    func color(for type: ColorType) -> UIColor {
        switch type {
        case .background: return 0x212121.rgbColor
        case .separator: return 0x626262.rgbColor
        case .textColor: return 0xBDBDBD.rgbColor
        case .detailTextColor: return 0x757575.rgbColor
        case .placeholderColor: return 0x9E9E9E.rgbColor
        }
    }
}

extension Int {
    var rgbColor: UIColor {
        return self.rgbColor(alpha: 1)
    }
    
    func rgbColor(alpha: CGFloat) -> UIColor {
        let red = CGFloat(self >> 16) / 255.0
        let green = CGFloat((self >> 8) & 0xFF) / 255.0
        let blue = CGFloat(self & 0xFF) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
