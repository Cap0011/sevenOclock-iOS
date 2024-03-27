//
//  Font.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/03/27.
//

import SwiftUI

extension Font {
    enum SUITE {
        case light
        case regular
        case medium
        case semibold
        case bold
        
        var value: String {
            switch self {
            case .light:
                return "SUITE-Light"
            case .regular:
                return "SUITE-Regular"
            case .medium:
                return "SUITE-Medium"
            case .semibold:
                return "SUITE-SemiBold"
            case .bold:
                return "SUITE-Bold"
            }
        }
    }

    static func suite(_ type: SUITE, size: CGFloat) -> Font {
        return .custom(type.value, size: size)
    }
}
