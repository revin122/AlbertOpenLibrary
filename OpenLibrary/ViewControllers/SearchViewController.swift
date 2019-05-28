//
//  FirstViewController.swift
//  OpenLibrary
//
//  Created by Remar Supnet on 5/22/19.
//  Copyright © 2019 Remar Supnet. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, DoneKeyboardDelegate, PickerTextFieldDelegate, SearchResultVMDelegate, UITableViewDataSource, UITableViewDelegate, DocItemTableViewCellDelegate {
    
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
        
        typeTextField.options = searchResultVM.typeOptions
        typeTextField.pickerDelegate = self
        
        searchResultVM.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
    
        tableView.register(UINib(nibName: "DocItemTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: DocItemTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = DocItemTableViewCell.estimatedRowHeight
    }

    func startSearch(showError : Bool) {
        
        //only accept text query that has a length > Minimum CHAR Count
        if searchTextField.text?.count ?? 0 > MIN_CHAR_COUNT {
            searchResultVM.doASearch(text: searchTextField.text ?? "", type: typeTextField.text)
        } else if showError {
            self.showMessage(message: "Please make your query longer to make start searching")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ?? "" ==  DetailViewController.segueIdentifier {
            
            if let detailViewController = segue.destination as? DetailViewController {
                detailViewController.docItemVM = searchResultVM.selectedItem
            }
        }
    }
    
    /*****
     TableView Delegate/Datasource
     ****/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultVM.totalItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let docItemTableViewCell : DocItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: DocItemTableViewCell.identifier, for: indexPath) as! DocItemTableViewCell
        
        let docItemVM = searchResultVM.getItem(index: indexPath.row)
        
        docItemTableViewCell.setupView(docItemVM: docItemVM, tag: indexPath.row, delegate: self)
        
        return docItemTableViewCell
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchResultVM.selectedItem = searchResultVM.getItem(index: indexPath.row)
        performSegue(withIdentifier: DetailViewController.segueIdentifier, sender: nil)
    }
    
    
    //End of TableView Delegate/Datasource
    
    /*****
     DocItemTableViewCell Delegate
     ****/
    
    func wishListButtonClicked(index: Int) {
        searchResultVM.processToCoreData(docIndex: index)
    }
    
    //End of DocItemTableViewCell Delegate
    
    /*****
     SearchResultVM Delegate
     ****/
    
    func searchingDone() {
        tableView.reloadData()
    }
    
    func generatedMessage() {
        self.showMessage(message: searchResultVM.showMessage ?? "")
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

