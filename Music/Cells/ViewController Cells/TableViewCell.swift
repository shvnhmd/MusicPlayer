//
//  TableViewCell.swift
//  view
//
//  Created by Ikhtiar Ahmed on 1/11/21.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var aLabel: UILabel!
    
    @IBOutlet weak var aImage: UIImageView!
    
    static let idetifier = "cell"
    
    static func nib() -> UINib {
        return UINib(nibName: "TableViewCell", bundle: nil)
    

        func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
  }
//
}
