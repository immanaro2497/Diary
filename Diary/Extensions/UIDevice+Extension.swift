//
//  UIDevice+Extension.swift
//  Diary
//
//  Created by Immanuel on 14/04/24.
//

import Foundation
import UIKit

extension UIDevice {
    
    static var isPad: Bool {
        current.userInterfaceIdiom == .pad
    }
    
}
