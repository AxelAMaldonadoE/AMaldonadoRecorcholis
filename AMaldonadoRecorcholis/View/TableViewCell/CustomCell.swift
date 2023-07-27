//
//  CustomCell.swift
//  AMaldonadoRecorcholis
//
//  Created by MacBookMBA15 on 26/07/23.
//

import UIKit
import SwipeCellKit

class CustomCell: SwipeTableViewCell{

    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
