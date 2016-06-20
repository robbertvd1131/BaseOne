//
//  GreenBaseOneRateButton.swift
//  BaseOne
//
//  Created by Stan Zeetsen on 27/05/16.
//  Copyright © 2016 Stan Zeetsen. All rights reserved.
//

import UIKit

class RedBaseOneRateButton: BaseOneRateButton {
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor(red: 223.0/255, green: 66.0/255, blue: 66.0/255, alpha: 1.0)
    }
    
    override var highlighted: Bool {
        didSet {
            
            if (highlighted) {
                self.backgroundColor = UIColor(red: 158.0/255, green: 46.0/255, blue: 46.0/255, alpha: 1.0)
            }
            else {
                self.backgroundColor = UIColor.clearColor()
            }
            
        }
    }
}
