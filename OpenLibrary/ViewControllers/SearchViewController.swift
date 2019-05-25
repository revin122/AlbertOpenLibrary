//
//  FirstViewController.swift
//  OpenLibrary
//
//  Created by Remar Supnet on 5/22/19.
//  Copyright © 2019 Remar Supnet. All rights reserved.
//

import UIKit
import Nuke

class SearchViewController: UIViewController, DoneKeyboardDelegate, PickerTextFieldDelegate, SearchResultVMDelegate, UITableViewDataSource, UITableViewDelegate, SearchItemTableViewCellDelegate {
    
    private let MIN_CHAR_COUNT = 3
    
    @IBOutlet weak var searchTextField: DoneKeyboardTextField!
    @IBOutlet weak var typeTextField: PickerTextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchResultsLabel: UILabel!
    @IBOutlet weak var tabeViewTopConstraint: NSLayoutConstraint!
    
    let searchResultVM : SearchResultVM = SearchResultVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        searchTextField.doneKeyboardDelegate = self
        typeTextField.pickerDelegate = self
        searchResultVM.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
    
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = SearchItemTableViewCell.estimatedRowHeight
    }

    func startSearch(showError : Bool) {
        
        //only accept text query that has a length > Minimum CHAR Count
        if searchTextField.text?.count ?? 0 > MIN_CHAR_COUNT {
            searchResultVM.doASearch(text: searchTextField.text ?? "", type: typeTextField.text)
        } else if showError {
            self.showMessage(message: "Please make your query longer to make start searching")
        }
        
    }
    
    /*****
     TableView Delegate/Datasource
     ****/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultVM.totalItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchItemTableViewCell : SearchItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: SearchItemTableViewCell.identifier, for: indexPath) as! SearchItemTableViewCell
        
        let searchItemVM = searchResultVM.getItem(index: indexPath.row)
        
        //show the things we want to display
        searchItemTableViewCell.delegate = self
        searchItemTableViewCell.titleLabel.text = searchItemVM.title
        searchItemTableViewCell.subtitleLabel.text = searchItemVM.subtitle
        
        //store the index in the tag so that we can easily retrieve it
        searchItemTableViewCell.tag = indexPath.row
        
        //show image using Nuke (image loading and caching system)
        //TODO do a check if image is empty
        Nuke.loadImage(with: searchItemVM.getCoverImageURLString(size: .small),
                       options: ImageLoadingOptions(placeholder: UIImage(named: "tempbooksm"),
                                                    transition: .fadeIn(duration: 0.25),
                                                    failureImage: UIImage(named: "tempbooksm")),
                       into: searchItemTableViewCell.coverImageView)
        
        return searchItemTableViewCell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //let's do the next page
        if indexPath.row > searchResultVM.getMaxPageItemIndex() {
            searchResultVM.goToNextPage()
        }
    }
    
    //End of TableView Delegate/Datasource
    
    /*****
     SearchItemTableViewCellDelegate Delegate
     ****/
    
    func wishListButtonClicked(index: Int) {
        
    }
    
    //End of SearchItemTableViewCell Delegate
    
    /*****
     SearchResultVM Delegate
     ****/
    
    func searchingDone() {
        tableView.reloadData()
    }
    
    func errorFound() {
        self.showMessage(message: searchResultVM.errorMessage ?? "")
    }
    
    //End of SearchResultVM Delegate
    
    /*****
     PickerTextField Delegate
     ****/
    
    func pickerTextFieldItemSelected(row: Int, view: PickerTextField) {
        //once they select one we do a search however dont show an error
        startSearch(showError: false)
    }
    
    //End of PickerTextField Delegate
    
    /*****
     DoneKeyboardTextField Delegate
     ****/
    
    func donePressed(text: String) {
        startSearch(showError: true)
    }
    
    //End of DoneKeyboardTextField Delegate
}

