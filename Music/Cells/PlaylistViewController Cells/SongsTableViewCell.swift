//
//  SongsTableViewCell.swift
//  view
//
//  Created by Ikhtiar Ahmed on 1/25/21.
//

import UIKit

class SongsTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var artImage: UIImageView!

    @IBOutlet weak var artTitle: UILabel!
    
    @IBOutlet weak var artName: UILabel!
    
    static let idetifier = "SongsTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "SongsTableViewCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//        func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
}
