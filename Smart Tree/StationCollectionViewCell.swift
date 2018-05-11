//
//  StationCollectionViewCell.swift
//  Smart Tree
//
//  Created by Всеволод on 11.05.2018.
//  Copyright © 2018 me4air. All rights reserved.
//

import UIKit

class StationCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var stationImage: UIImageView!
    
    @IBOutlet weak var stationLabel: UILabel!
    
    @IBOutlet weak var stationTemperature: UILabel!
    
    @IBOutlet weak var stationHum: UILabel!
    @IBOutlet weak var stationLight: UILabel!
    @IBOutlet weak var stationWater: UILabel!
}
