//
//  Theme.swift
//  VoxPopuli
//
//  Created by Stanislav Kasprik on 11/03/2018.
//  Copyright © 2018 Stanislav Kasprik. All rights reserved.
//

import Foundation

import UIKit

enum Theme {
    enum Colors {
        static let lightBlue = UIColor(hex: 0x0082DE).withAlphaComponent(0.1)
        static let defaultBlue = UIColor(hex: 0x007aff)
        static let lighYellow = UIColor.yellow.withAlphaComponent(0.4)
        static let lightBlack = UIColor.black.withAlphaComponent(0.6)
    }
    
    enum Images {
        static let navigationBarBackgroundImage = UIImage.image(fromColor: Theme.Colors.lightBlue)
    }
}
