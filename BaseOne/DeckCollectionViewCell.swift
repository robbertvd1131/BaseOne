//
//  DeckCollectionViewCell.swift
//  BaseOne
//
//  Created by Stan Zeetsen on 02/06/16.
//  Copyright © 2016 Stan Zeetsen. All rights reserved.
//

import UIKit

class DeckCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imvBackgroundImage: UIImageView!
    @IBOutlet weak var imvCheckedOverlay: UIImageView!
    
    var selectedToggle = false
    
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)!

    }
    
    

}
