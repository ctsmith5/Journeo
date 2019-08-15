//
//  ArchiveTableViewCell.swift
//  Journeo2
//
//  Created by Colin Smith on 8/14/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import UIKit

class ArchiveTableViewCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var localeLabel: UILabel!
    
    
    var entry: Entry?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard let entry = entry else {return}
        titleLabel.text = entry.title
       // dateLabel.text = entry.date.asStringDateOnly()
       // localeLabel.text = entry.location.stringDescription()
        
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
