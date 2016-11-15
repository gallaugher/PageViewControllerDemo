//
//  PageViewController.swift
//  PageViewControllerDemo
//
//  Created by John Gallaugher on 11/9/16.
//  Copyright © 2016 Gallaugher. All rights reserved.
//
//The enclosed code implements a UIPageViewController to mimic the style used in the
//Apple iOS Weather app.  Weather and additional UI are not shown - focus is just on
//implementing UIPageViewController.
//
//UIPageViewController adds a "Local" item as first item in a CitiesArray. ViewControllers
//for Cities are instantiated as needed with CityViewController as the template, and via
//the cityVCForPage method below.
//New cities can be added (elements to the array) via the Cities button on the
//CityPageViewController.  Segue to UITableViewController CityListViewController is
//presented modally.
//
//Clicking a row in CityListViewController will segue/unwind to CityViewController, then
//segue/unwind to UIPageViewController (PageViewController), which handles the instantiation of
//a page for the item clicked on, handles pageControl (the dots), and contains the
//"before" and "after" methods that handle paging to the right & left.
//
//I'm still learning UIPageViewController & am certain there are better ways to implement
//this. I'd welcome any suggestions, recommendations, or corrections.
//Thank you! john [dot] gallaugher [at] bc [dot] edu - Twitter: @gallaugher'


import Foundation
import UIKit

class PageViewController: UIPageViewController {
    var pageControl: UIPageControl! // the "dots" at bottom that show current page among dots for each page
    var citiesArray = ["Local City Weather"] // start with a single item in the array - eventually this'll be the local weather which cannot be deleted
    var currentPage: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
 
        dataSource = self
        delegate = self
        
        // Apple's setViewControllers method takes an array of view controllers, with two passed if you are
        // presenting two pages "book-style".  The Weather-app-like UI implemented here only takes one view controller
        // at a time, but an array of just one element needs to be passed.
        // .forward below doesn't really matter since it's the first page & there's no aninmation.
        setViewControllers([cityVCForPage(0)], direction: .forward, animated: false, completion: nil)

        // Set up UIPageControl e.g. "the dots" showing current page & # of pages
        // I couldn't get this to work through the interface builder, so I did it programatically
        // Don't make width the entire width of the screen if you plan other UI elements (like the Cities button in
        // this example) to sit to the right or left of the PageControl 'dots', otherwise these buttons or other UI
        // elements won't fire when clicked.
        let pageControlHeight: CGFloat = 50
        let pageControlWidth: CGFloat = 170
        pageControl = UIPageControl(frame: CGRect(x: (view.frame.width - pageControlWidth)/2, y: view.frame.height - pageControlHeight, width: pageControlWidth, height: pageControlHeight))
        // Color set as lightGray. You'll certainly want to make it look prettier but
        // without this, indicators can't be seen on a default white background.
        pageControl.backgroundColor = UIColor.lightGray
        pageControl.numberOfPages = citiesArray.count
        pageControl.currentPage = currentPage
        view.addSubview(pageControl)
        
        // Question: Should I break this out as a separate class for cleaner MVC? A singleton class for the pageControl?
    }
    

    // When the user clicks a row in the CitiesArray shown in CityListViewController, this unwinds to CityViewController
    // then directly unwinds to this UIPageViewController.
    // Question: Is this a sound approach? I couldn't seem to unwind directly from CityListViewController, likely
    // because the segue to this UITableView was triggered from a button on CityViewController.
    @IBAction func unwindFromCityViewController(sender: UIStoryboardSegue) {
        
        // Identify the CityViewController we're unwinding from, set this VC to the constant 'controller',
        // and use this to pass variables within the CityViewController to this UIPageViewController
        let controller = sender.source as! CityViewController
        currentPage = controller.currentPage
        citiesArray = controller.citiesArray
        
        // Set page control variables (so dots show properly for any changes made/Cities added/removed using
        // CityListViewController).
        pageControl.numberOfPages = citiesArray.count
        pageControl.currentPage = currentPage
        
        setViewControllers([cityVCForPage(currentPage)], direction: .forward, animated: false, completion: nil)
    }
    
    fileprivate func cityVCForPage(_ inPage: Int) -> CityViewController {
        
        // Update currentPage, which when called from 'viewControllerBefore' method below subtracts by one, or
        // when called from 'viewControllerAfter' method below, increases by one.
        let currentPage = min(max(0, inPage), citiesArray.count-1)
        
        // the VCs for CityViewController aren't all created, one is simply instantiated as needed
        let cityViewController = storyboard!.instantiateViewController(withIdentifier: "CityViewController") as! CityViewController
        cityViewController.currentPage = currentPage
        cityViewController.citiesArray = citiesArray
        
        // cityViewController.view.backgroundColor = UIColor.gray
        
        return cityViewController
    }
}

// MARK: - UIPageViewController Datasource Methods
// Standard methods for UIPageViewController protocol. Implemented as extensions just for organization purposes
extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentViewController = viewController as? CityViewController {
            if currentViewController.currentPage < citiesArray.count - 1 {
                return cityVCForPage(currentViewController.currentPage + 1) // create the page you're headed to
            }
        }
        return nil // this would happen if we were on the last page
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // get the page# of the current page we're on. page is a property of CityViewController. It was set in func cityVCForPage
        if let currentViewController = viewController as? CityViewController {
            if currentViewController.currentPage > 0 {
                return cityVCForPage(currentViewController.currentPage - 1) // create the page you're headed to
            }
        }
        return nil // this would happen if we were on the first page
    }
    
    
    // MARK: - Methods for handling PageControl (current page indicator)
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return citiesArray.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        if let currentViewController = pageViewController.viewControllers?[0] as? CityViewController {
            return currentViewController.currentPage
        }
        return 0
    }
}

// MARK: - UIPageViewController delegate method (standard)
extension PageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        
        if let currentViewController = pageViewController.viewControllers?[0] as? CityViewController {
            pageControl.currentPage = currentViewController.currentPage
        }
    }
}
