//
//  SearchItemCellTableViewCell.swift
//  OpenLibrary
//
//  Created by Remar Supnet on 5/22/19.
//  Copyright © 2019 Remar Supnet. All rights reserved.
//

import UIKit
import Nuke

class DocItemTableViewCell: UITableViewCell {

    //all of these values are taken from the storyboard
    //we want them easy to edit everytime this cell is going to be used
    static let identifier = "docItem"
    static let estimatedRowHeight : CGFloat = 75.0
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var wishListButton: UIButton!
    
    var delegate : DocItemTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupView(docItemVM : DocItemVM, tag : Int, delegate : DocItemTableViewCellDelegate) {
        //show the things we want to display
        self.delegate = delegate
        self.titleLabel.text = docItemVM.title
        self.subtitleLabel.text = docItemVM.subtitle
        
        if docItemVM.isInCoreData {
            self.wishListButton.setTitle("Remove from Wish List", for: .normal)
        } else {
            self.wishListButton.setTitle("Add to Wish List", for: .normal)
        }
        
        //store the index in the tag so that we can easily retrieve it
        self.tag = tag
        
        //show image using Nuke (image loading and caching system)
        //TODO do a check if image is empty
        Nuke.loadImage(with: docItemVM.getCoverImageURLString(size: .small),
                       options: ImageLoadingOptions(placeholder: UIImage(named: "tempbooksm"),
                                                    transition: .fadeIn(duration: 0.25),
                                                    failureImage: UIImage(named: "tempbooksm")),
                       into: self.coverImageView)
    }

    @IBAction func wishListButtonClicked(_ sender: Any) {
        delegate?.wishListButtonClicked(index: self.tag)
    }
    
}

protocol DocItemTableViewCellDelegate {
    func wishListButtonClicked(index : Int)
}
