//
//  CityViewController.swift
//  PageViewControllerDemo
//
//  Created by John Gallaugher on 11/9/16.
//  Copyright © 2016 Gallaugher. All rights reserved.
//

import UIKit

class CityViewController: UIViewController {
    @IBOutlet fileprivate weak var cityNumberLabel: UILabel!

    var citiesArray = [String]()
    var currentPage = 0
    
    // Triggers each time a page is instantiated - created when swiping right or left.
    // So below is where you'd eventually place methods to read in weather for that city, or repopulate the
    // data in a more complex user interface with temperatures, forecasts, etc. for the city.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cityNumberLabel.text = citiesArray[currentPage]
    }

    // This happens before loading the UITableViewController named CityListViewController, it 
    // happens when the user clicks the "Cities" button in the lower-right-hand corner of this page.
    // "ToCityList" segue named on the Storyboard (attributes inspector for the 'present modally' segue on the
    // CityViewController scene.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToCityList" {
            let controller = segue.destination as! CityListViewController
            controller.citiesArray = citiesArray
        }
    }
    
    // This unwind is called when a user clicks a row on UITableView in CityListViewController.
    // It simply and immediately triggers another segue heading back to theUIPageViewController named PageViewController
    @IBAction func unwindToViewController(sender: UIStoryboardSegue) {
        let controller = sender.source as! CityListViewController
        citiesArray = controller.citiesArray
        currentPage = controller.currentPage
        self.performSegue(withIdentifier: "UnwindToPageViewController", sender: self)
    }
}


