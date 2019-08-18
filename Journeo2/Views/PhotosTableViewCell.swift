//
//  PhotosTableViewCell.swift
//  Journeo2
//
//  Created by Colin Smith on 8/17/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import UIKit

class PhotosTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
