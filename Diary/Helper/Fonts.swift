//
//  Fonts.swift
//  Diary
//
//  Created by Immanuel on 18/04/24.
//

import SwiftUI

struct Fonts {
    
    private static func title1FontMetrics(_ size: CGFloat) -> CGFloat {
        UIFontMetrics(forTextStyle: .title1).scaledValue(for: size)
    }
    
    static let scaledFont40: Font = {
        return Font.system(size: title1FontMetrics(40), weight: .heavy, design: .rounded)
    }()
    
    static let scaledFont20: Font = {
        return Font.system(size: title1FontMetrics(20), weight: .heavy, design: .rounded)
    }()
    
    static let scaledFont17Bold: Font = {
        return Font.system(size: title1FontMetrics(17), weight: .bold)
    }()
    
    static let scaledFont15Bold: Font = {
        return Font.system(size: title1FontMetrics(15), weight: .bold)
    }()
    
}
