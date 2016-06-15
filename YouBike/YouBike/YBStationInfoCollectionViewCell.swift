//
//  YBStationInfoCollectionViewCell.swift
//  YouBike
//
//  Created by SK on 5/17/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//

import UIKit

class YBStationInfoCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var stationAvailableBikeLabel: UILabel!
    @IBOutlet weak var stationNameLabel: UILabel!
    
    
    struct Constant {
        static let identifier = "YBStationInfoCollectionViewCell"
    }
    
    
    var ybStationInfo = YBStationInfo()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initCellStyle()
        
    }
    
    func initCellStyle() {
        initStationNameLabel()
        initStationAvailableBikeLabel()
    }
    
    func initStationNameLabel() {
        stationNameLabel.textColor = UIColor.ybkBrownishColor()
        stationNameLabel.font = UIFont.ybkTextStylePingFangTCMedium(14)
        stationNameLabel.textAlignment = NSTextAlignment.Left
    }
    
    // Setup stationAvailableBikeLabel style
    func initStationAvailableBikeLabel() {
        
        stationAvailableBikeLabel.textColor = UIColor.ybkDarkSalmonColor()
        stationAvailableBikeLabel.font = UIFont.ybkTextStyleHelveticaBold(80)
        stationAvailableBikeLabel.textAlignment = NSTextAlignment.Center
        
    }
    

}
