//
//  HomeCollectionViewCell.swift
//  File Manager V1
//
//  Created by Ikhtiar Ahmed on 11/25/20.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    //MARK: IBOutlet
    
    @IBOutlet weak var folderImageView: UIImageView!
    @IBOutlet weak var folderLabel: UILabel!
    
    
    //MARK: Registration collection view
    
    static let idetifier = "CollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "CollectionViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
