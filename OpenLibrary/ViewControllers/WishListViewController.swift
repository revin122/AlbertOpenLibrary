//
//  SecondViewController.swift
//  OpenLibrary
//
//  Created by Remar Supnet on 5/22/19.
//  Copyright © 2019 Remar Supnet. All rights reserved.
//

import UIKit

class WishListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DocItemTableViewCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var coreDataVM : CoreDataVM = CoreDataVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "DocItemTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: DocItemTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = DocItemTableViewCell.estimatedRowHeight
    }
    
    override func viewWillAppear(_ animated: Bool) {
        coreDataVM.update()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ?? "" ==  DetailViewController.segueIdentifier {
            
            if let detailViewController = segue.destination as? DetailViewController {
                detailViewController.docItemVM = coreDataVM.selectedItem
            }
        }
    }

    /*****
     TableView Delegate/Datasource
     ****/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreDataVM.docItemsVM.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let docItemTableViewCell : DocItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: DocItemTableViewCell.identifier, for: indexPath) as! DocItemTableViewCell
        
        let docItemVM = coreDataVM.docItemsVM[indexPath.row]
        
        docItemTableViewCell.setupView(docItemVM: docItemVM, tag: indexPath.row, delegate: self)
        
        return docItemTableViewCell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coreDataVM.selectedItem = coreDataVM.docItemsVM[indexPath.row]
        performSegue(withIdentifier: DetailViewController.segueIdentifier, sender: nil)
    }
    
    //End of TableView Delegate/Datasource
    
    /*****
     DocItemTableViewCell Delegate
     ****/
    
    func wishListButtonClicked(index: Int) {
        coreDataVM.removeItem(index: index)
        
        if coreDataVM.generatedMessage == "" {
            showMessage(message: "Item Removed")
        } else {
            showMessage(message: coreDataVM.generatedMessage)
        }
        
        tableView.reloadData()
    }
    
    //End of DocItemTableViewCell Delegate
}

