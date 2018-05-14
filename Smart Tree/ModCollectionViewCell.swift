//
//  ModCollectionViewCell.swift
//  Smart Tree
//
//  Created by Всеволод on 14.05.2018.
//  Copyright © 2018 me4air. All rights reserved.
//

import UIKit

class ModCollectionViewCell: UICollectionViewCell {

    @IBAction func modButtonPresed(_ sender: UIButton) {
        modActivity.startAnimating()
    }
    
    @IBOutlet weak var modLabel: UILabel!
    @IBOutlet weak var modButton: UIButton!
    @IBOutlet weak var modActivity: UIActivityIndicatorView!
}
