//
//  DetailViewController.swift
//  PageViewControllerDemo
//
//  Created by John Gallaugher on 11/9/16.
//  Copyright © 2016 Gallaugher. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var currentPage = 0
    var listArray = [String]()
    
    @IBOutlet weak var listItemLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        listItemLabel.text = listArray[currentPage]
        descriptionLabel.text = "Item below is listArray[currentPage] where currentPage = \(currentPage)"
    }
    
}
