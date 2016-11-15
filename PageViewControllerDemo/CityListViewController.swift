//
//  CityListViewController.swift
//  PageViewControllerDemo
//
//  Created by John Gallaugher on 11/9/16.
//  Copyright © 2016 Gallaugher. All rights reserved.
//

import UIKit

class CityListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    var citiesArray = [String]()
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addBarButton.isEnabled = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }

    // Triggered before performSegue call within function didSelectRowAt, below
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UnwindFromCitiesList" {
            let controller = segue.destination as! CityViewController
            controller.citiesArray = citiesArray
        }
    }
    
    // MARK: - tableView methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = citiesArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentPage = indexPath.row
        performSegue(withIdentifier: "UnwindFromCitiesList", sender: self)
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 {
            return false // don't edit the "Local Weather" first row
        } else {
            return true
        }
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            citiesArray.remove(at: indexPath.row) // remove from array
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Not doing an insert here.
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
    
    // Override to support rearranging the table view.
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
            // First make a copy of the values in the cell we are moving
            let itemToMove = citiesArray[fromIndexPath.row]
            
            // Delete them from the original location (pre-move)
            citiesArray.remove(at: fromIndexPath.row)
            
            // Insert them into the "to", post-move location
            citiesArray.insert(itemToMove, at: to.row)
    }
    
    
    // Override to support conditional rearranging of the table view.
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 {
            return false // don't edit the "Local Weather" first row
        } else {
            return true
        }
    }
    
    // This is a simple alert to gather user input to add another city.  If this were
    // a 'real' weather app, I'd implement GooglePlaces API, called via AlamoFire &
    // SwiftyJSON (which I'll demonstrate in a future post).
    func showAlert() {
        
        let alertController = UIAlertController(title: "City", message: "Enter a City for Weather:", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field = alertController.textFields?[0] {
                // store your data
                if let newCity = field.text {
                    self.citiesArray.append(newCity)
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
    
    // MARK: - IBActions
    
    @IBAction func editBarButtonPressed(_ sender: UIBarButtonItem) {
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
    
    // This triggers when the "+" button in lower-right-hand corner is pressed
    @IBAction func addCityButton(_ sender: UIBarButtonItem) {
        showAlert()
    }
}
