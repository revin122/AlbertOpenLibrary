//
//  DetailMainTableViewCell.swift
//  OpenLibrary
//
//  Created by Remar Supnet on 5/26/19.
//  Copyright © 2019 Remar Supnet. All rights reserved.
//

import UIKit
import Nuke

class DetailMainTableViewCell: UITableViewCell {

    //all of these values are taken from the storyboard
    //we want them easy to edit everytime this cell is going to be used
    static let identifier = "main"
    static let estimatedRowHeight : CGFloat = 225.0
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupView(docItemVM : DocItemVM) {
        //show the things we want to display
        self.titleLabel.text = docItemVM.title
        self.authorLabel.text = docItemVM.getAuthorNames()
        
        //store the index in the tag so that we can easily retrieve it
        self.tag = tag
        
        //show image using Nuke (image loading and caching system)
        //TODO do a check if image is empty
        Nuke.loadImage(with: docItemVM.getCoverImageURLString(size: .medium),
                       options: ImageLoadingOptions(placeholder: UIImage(named: "tempbooksm"),
                                                    transition: .fadeIn(duration: 0.25),
                                                    failureImage: UIImage(named: "tempbooksm")),
                       into: self.coverImageView)
    }
}
