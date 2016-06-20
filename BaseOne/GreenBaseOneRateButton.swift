//
//  GreenBaseOneRateButton.swift
//  BaseOne
//
//  Created by Stan Zeetsen on 27/05/16.
//  Copyright © 2016 Stan Zeetsen. All rights reserved.
//

import UIKit

class GreenBaseOneRateButton: BaseOneRateButton {
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor(red: 34.0/255, green: 192.0/255, blue: 100.0/255, alpha: 1.0)
    }
    
    override var highlighted: Bool {
        didSet {
            
            if (highlighted) {
                self.backgroundColor = UIColor(red: 28.0/255, green: 141.0/255, blue: 75.0/255, alpha: 1.0)
            }
            else {
                self.backgroundColor = UIColor.clearColor()
            }
            
        }
    }
}
