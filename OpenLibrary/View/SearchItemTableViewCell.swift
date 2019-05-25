//
//  SearchItemCellTableViewCell.swift
//  OpenLibrary
//
//  Created by Remar Supnet on 5/22/19.
//  Copyright © 2019 Remar Supnet. All rights reserved.
//

import UIKit

class SearchItemTableViewCell: UITableViewCell {

    //all of these values are taken from the storyboard
    //we want them easy to edit everytime this cell is going to be used
    static let identifier = "searchItem"
    static let estimatedRowHeight : CGFloat = 75.0
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var wishListButton: UIButton!
    
    var delegate : SearchItemTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func wishListButtonClicked(_ sender: Any) {
        delegate?.wishListButtonClicked(index: self.tag)
    }
    
}

protocol SearchItemTableViewCellDelegate {
    func wishListButtonClicked(index : Int)
}
