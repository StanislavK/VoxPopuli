//
//  Button.swift
//  
//
//  Created by Stanislav Kasprik on 12/03/2018.
//

import UIKit

class Button: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.borderWidth = 1
        layer.borderColor =  Theme.Colors.defaultBlue.cgColor
        contentEdgeInsets = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
    }
}
