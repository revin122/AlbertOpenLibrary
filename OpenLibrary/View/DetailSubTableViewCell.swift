//
//  DetailSubTableViewCell.swift
//  OpenLibrary
//
//  Created by Remar Supnet on 5/26/19.
//  Copyright © 2019 Remar Supnet. All rights reserved.
//

import UIKit

class DetailSubTableViewCell: UITableViewCell {

    //all of these values are taken from the storyboard
    //we want them easy to edit everytime this cell is going to be used
    static let identifier = "sub"
    static let estimatedRowHeight : CGFloat = 39.5
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupView(detailItemVM : DetailsItemVM) {
        titleLabel.text = detailItemVM.title
        textView.text = detailItemVM.details
        
        //determine the height
        heightConstraint.constant = getNewHeight(desc: detailItemVM.details)
    }
    
    func getNewHeight(desc : String) -> CGFloat {
        
        //create temp label
        let label : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: textView.frame.width, height: textView.frame.height))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont(name: "Helvetica", size: 17)
        label.text = desc
        label.sizeToFit()
        
        return label.frame.height > DetailSubTableViewCell.estimatedRowHeight ? label.frame.height + 4 : DetailSubTableViewCell.estimatedRowHeight
    }
}
