//
//  ListViewController.swift
//  PageViewControllerDemo
//
//  Created by John Gallaugher on 11/9/16.
//  Copyright © 2016 Gallaugher. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    var listArray = [String]()
    var currentPage = 0
    
    //MARK: - tableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = listArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentPage = indexPath.row // set current page to row selected
        
        performSegue(withIdentifier: "ToPageViewController", sender: self)
    }
    
    //MARK: - tableView Edit Methods
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            listArray.remove(at: indexPath.row) // remove from array
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Not doing an insert here.
        }
    }
    
    // Override to support rearranging the table view.
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        // First make a copy of the values in the cell we are moving
        let itemToMove = listArray[fromIndexPath.row]
        
        // Delete them from the original location (pre-move)
        listArray.remove(at: fromIndexPath.row)
        
        // Insert them into the "to", post-move location
        listArray.insert(itemToMove, at: to.row)
    }
    
    // Override to support conditional rearranging of the table view.
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 {
            return false // don't edit the "Local Weather" first row
        } else {
            return true
        }
    }
    
    // Prevents user from dragging to first item (Index 0) which is Local Weather.
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if proposedDestinationIndexPath.row == 0 {
            return sourceIndexPath
        } else {
            return proposedDestinationIndexPath
        }
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 {
            return false // don't edit the "Local Weather" first row
        } else {
            return true
        }
    }
    
    //MARK: - Segue Methods
    
    //Triggered before performSegue call within function didSelectRowAt, below
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToPageViewController" {
            let controller = segue.destination as! PageViewController
            controller.currentPage = currentPage
            controller.listArray = listArray
        }
    }
    
    //MARK: - IBActions
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if(tableView.isEditing == true) {
            tableView.setEditing(false, animated: true)
            editBarButton.title = "Edit"
            addBarButton.isEnabled = true
        } else {
            tableView.setEditing(true, animated: false)
            editBarButton.title = "Done"
            addBarButton.isEnabled = false
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        addItemToList()
    }
    
    func addItemToList() {
        // Replace code below with whatever you'd like to use to populate your list.
        // For example, in a weather app I wrote, I've used the GooglePlaces API.
        
        let alertController = UIAlertController(title: "Item", message: "Enter a new item for the list:", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field = alertController.textFields?[0] {
                // store your data
                if let newItem = field.text {
                    self.listArray.append(newItem)
                }
            } else {
                // user did not fill field
            }
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "City"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
