//
//  BaseOneRateButton.swift
//  BaseOne
//
//  Created by Stan Zeetsen on 27/05/16.
//  Copyright © 2016 Stan Zeetsen. All rights reserved.
//

import UIKit

class BaseOneRateButton: UIButton {
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)!
        
        self.backgroundColor = UIColor(red: 223.0/255, green: 66.0/255, blue: 66.0/255, alpha: 1.0)
        
        self.tintColor = UIColor.whiteColor()
        
        self.imageEdgeInsets = UIEdgeInsetsMake(30, 80, 30, 80)
        
    }
    
    override var highlighted: Bool {
        didSet {
            
            if (highlighted) {
                self.tintColor = UIColor.whiteColor()
            }
            else {
                self.backgroundColor = UIColor.clearColor()
            }
            
        }
    }

}
