//
//  YBInfoTableViewCell.swift
//  YouBike
//
//  Created by SK on 4/25/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//

import UIKit

protocol YBStationInfoTableViewCellDelegate: class {
    func tapViewMap(cell: YBStationInfoTableViewCell, viewMap sender: AnyObject?)
}

class YBStationInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var stationNameCnLabel: UILabel!
    @IBOutlet weak var stationAddressCnLabel: UILabel!
    @IBOutlet weak var stationAvailableBikeLabel: UILabel!
    
    @IBOutlet weak var availableBikeDescriptionPrefixLabel: UILabel!
    @IBOutlet weak var availableBikeDescriptionSuffixLabel: UILabel!

    @IBOutlet weak var viewMapButton: UIButton!
    
    
    struct Constant {
        static let identifier = "YBStationInfoTableViewCell"
    }
    
    
    weak var delegate: YBStationInfoTableViewCellDelegate?
    
    var ybStationInfo = YBStationInfo()
    
    // Setup all labels and buttons in the cell view
    func initCellStyle() {
        initStationNameCnLabel()
        initStationAddressCnLabel()
        initStationAvailableBikeLabel()
        initViewMapButton()
    }

    // Setup stationNameCnLabel style
    func initStationNameCnLabel() {
        stationNameCnLabel.textColor = UIColor.ybkBrownishColor()
        stationNameCnLabel.font = UIFont.ybkTextStylePingFangTCMedium(20)
        stationNameCnLabel.textAlignment = NSTextAlignment.Left
    }
    
    // Setup stationAddressCnLabel style
    func initStationAddressCnLabel() {
        stationAddressCnLabel.textColor = UIColor.ybkSandBrownColor()
        stationAddressCnLabel.font = UIFont.ybkTextStylePingFangTCRegular(14)
        stationAddressCnLabel.textAlignment = NSTextAlignment.Left
    }

    // Setup stationAvailableBikeLabel style
    func initStationAvailableBikeLabel() {
        
        availableBikeDescriptionPrefixLabel.text = "Available Bikes Prefix".localized
        availableBikeDescriptionPrefixLabel.textColor = UIColor.ybkSandBrownColor()
        availableBikeDescriptionPrefixLabel.font = UIFont.ybkTextStylePingFangTCMedium(20)
        availableBikeDescriptionPrefixLabel.sizeToFit()
        
        availableBikeDescriptionSuffixLabel.text = "Available Bikes Suffix".localized
        availableBikeDescriptionSuffixLabel.textColor = UIColor.ybkSandBrownColor()
        availableBikeDescriptionSuffixLabel.font = UIFont.ybkTextStylePingFangTCMedium(20)
        availableBikeDescriptionSuffixLabel.sizeToFit()
        
        
        stationAvailableBikeLabel.textColor = UIColor.ybkDarkSalmonColor()
        stationAvailableBikeLabel.font = UIFont.ybkTextStyleHelveticaBold(80)
        stationAvailableBikeLabel.textAlignment = NSTextAlignment.Center

    }
    
    // Setup viewMapButton style
    func initViewMapButton() {
        viewMapButton.setTitle("View Map".localized, forState: UIControlState.Normal)
        viewMapButton.setTitleColor(UIColor.ybkDarkSalmonColor(), forState: .Normal)
        viewMapButton.titleLabel!.font = UIFont.ybkTextStylePingFangTCRegular(16)
        viewMapButton.layer.cornerRadius = 4
        viewMapButton.layer.borderWidth = 1
        viewMapButton.layer.borderColor = UIColor.ybkDarkSalmonColor().CGColor
        
        // Add Target-Action to viewMapButton
        viewMapButton.addTarget(self, action: #selector(tapViewMap(_:viewMap:)), forControlEvents: UIControlEvents.TouchUpInside)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initCellStyle()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func tapViewMap(cell: YBStationInfoTableViewCell, viewMap sender: AnyObject?) {
        self.delegate?.tapViewMap(self, viewMap: viewMapButton)
    }
    
}
