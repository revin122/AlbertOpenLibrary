//
//  DetailViewController.swift
//  OpenLibrary
//
//  Created by Remar Supnet on 5/26/19.
//  Copyright © 2019 Remar Supnet. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITextViewDelegate {
    
    static let segueIdentifier = "details"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var wishListButton: UIButton!
    
    var docItemVM = DocItemVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        docItemVM.generateSubParameters()
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = DetailMainTableViewCell.estimatedRowHeight
        
        setupButton()
    }
    
    private func setupButton() {
        if docItemVM.isInCoreData {
            self.wishListButton.setTitle("Remove from Wish List", for: .normal)
        } else {
            self.wishListButton.setTitle("Add to Wish List", for: .normal)
        }
    }
    
    @IBAction func dismissClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func wishListButton(_ sender: Any) {
        docItemVM.processToCoreData()
        showMessage(message: docItemVM.message)
        setupButton()
    }
    
    /*****
     TableView Datasource
     ****/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return docItemVM.details.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let detailMainTableViewCell : DetailMainTableViewCell = tableView.dequeueReusableCell(withIdentifier: DetailMainTableViewCell.identifier, for: indexPath) as! DetailMainTableViewCell
            
            detailMainTableViewCell.setupView(docItemVM: docItemVM)
            
            return detailMainTableViewCell
        } else {
            let detailSubTableViewCell : DetailSubTableViewCell = tableView.dequeueReusableCell(withIdentifier: DetailSubTableViewCell.identifier, for: indexPath) as! DetailSubTableViewCell
            
            detailSubTableViewCell.textView.delegate = self
            detailSubTableViewCell.setupView(detailItemVM: docItemVM.details[indexPath.row - 1])
            
            self.tableView.reloadRows(at: [indexPath], with: .none)
            
            return detailSubTableViewCell
        }
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //End of TableView Datasource

    /*****
     UITextView Delegate
     ****/
    
    func textViewDidChange(_ textView: UITextView) {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    //End of UITextView Delegate
}
