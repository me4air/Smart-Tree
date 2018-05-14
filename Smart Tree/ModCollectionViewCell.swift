//
//  ModCollectionViewCell.swift
//  Smart Tree
//
//  Created by Всеволод on 14.05.2018.
//  Copyright © 2018 me4air. All rights reserved.
//

import UIKit

protocol CellButtonDelegate{
    func modButtonPresed(at index:IndexPath, modId: String, status: String)
}

class ModCollectionViewCell: UICollectionViewCell {
    var delegate:CellButtonDelegate!
    var indexPath:IndexPath!
    var mod_id: String!
    var status: String!
    @IBAction func modButtonPresed(_ sender: UIButton) {
        self.delegate?.modButtonPresed(at: indexPath, modId: mod_id, status: status)
    }
    
    @IBOutlet weak var modLabel: UILabel!
    @IBOutlet weak var modButton: UIButton!
}
