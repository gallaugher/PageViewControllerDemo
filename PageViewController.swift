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
//Logic for handling UIPageController is in PageViewController
//Clicking the List icon in lower left will segue to the ListViewController.
//The listButton is added to the UIPageController programatically, as is the
//UIPageControl.  This should keep components independent so you can drop in your
//own detail w/logic & UI handled independent of the PageViewController and ListController.
//ListViewController is currently set up to prevent deletion and moving of the first
//item, but this can be easily modified.

//UIPageViewController adds a "Permenant" item as first item in a ListViewController,
//but this can be easily modified.

//DetailViewControllers are instantiated as needed, via the createDetailVC method.
//New elements can be added (elements to the array) via the "+" button on the
//DetailViewController.
//
//Segue happens from PageViewController to ListViewController. Detail isn't aware that
//these other ViewControllers exist. Clicking a row in the UITableView on the
//ListViewController returns to the PageViewController which sets up UIPageControl and
//the DetailViewController. Any interface updates can then be handled in DetailViewController.
//I'd welcome any suggestions, recommendations, or corrections.
//Thank you! john [dot] gallaugher [at] bc [dot] edu - Twitter: @gallaugher'


import Foundation
import UIKit

class PageViewController: UIPageViewController {
    var pageControl: UIPageControl! // the "dots" at bottom that show current page among dots for each page
    
    var listArray = ["Default Line: Can't Be Moved"] // start with a single item in the array - eventually this'll be the local weather which cannot be deleted
    // Replace by calling any list setup logic for your app right here.
    
    var currentPage: Int = 0
    let squareBarButtonSize: CGFloat = 44 // Height of items in Toolbar area - pageControl & locationsListButton
    var listButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
 
        dataSource = self
        delegate = self
        
        setViewControllers([createDetailViewController(0)], direction: .forward, animated: false, completion: nil)

        setUpListButton()
        setUpPageControl()
    }
    
    // MARK: - Set Up UI Methods
    func setUpPageControl() {
        let pageControlHeight: CGFloat = squareBarButtonSize // Standard bar height
        let pageControlWidth: CGFloat = 232 // 320 SE width - 44 x 2
        pageControl = UIPageControl(frame: CGRect(x: (view.frame.width - pageControlWidth)/2, y: view.frame.height - pageControlHeight, width: pageControlWidth, height: pageControlHeight))
        // Color set as lightGray. You'll certainly want to make it look prettier but
        // without this, indicators can't be seen on a default white background.
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.numberOfPages = listArray.count
        pageControl.currentPage = currentPage
        view.addSubview(pageControl)
    }
    
    func setUpListButton() {
        let buttonWidth = squareBarButtonSize // This will change
        let buttonHeight = squareBarButtonSize // UI Tweak, so the button is lined up with pageControl
        listButton = UIButton(frame: CGRect(x: view.frame.width - buttonWidth, y: view.frame.height - buttonHeight, width: buttonWidth, height: buttonHeight))
        listButton.setImage(UIImage(named: "listIcon"), for: .normal)
        
        let highlightImage = UIImage(named: "listIcon")!.alpha(value: 0.3)
        listButton.setBackgroundImage(highlightImage, for: .highlighted)
        listButton.addTarget(self, action: #selector(segueToListViewController), for: .touchUpInside)
        view.addSubview(listButton)
    }
    
    //MARK: - Create Page Method
    func createDetailViewController(_ inPage: Int) -> DetailViewController {
        
        // Update currentPage, which when called from 'viewControllerBefore' method below subtracts by one, or
        // when called from 'viewControllerAfter' method below, increases by one.
        let currentPage = min(max(0, inPage), listArray.count-1)
        
        // the VCs for DetailViewController aren't all created, one is simply instantiated as needed
        let detailViewController = storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailViewController.currentPage = currentPage
        detailViewController.listArray = listArray
        
        return detailViewController
    }
    
    //MARK: - Segue Methods
    
    func segueToListViewController(sender: UIButton!) {
        performSegue(withIdentifier: "ToListViewController", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToListViewController" {
            let controller = segue.destination as! ListViewController
            controller.listArray = listArray
            controller.currentPage = currentPage
        }
    }
    
    @IBAction func unwindFromListViewController(sender: UIStoryboardSegue) {
        pageControl.numberOfPages = listArray.count
        pageControl.currentPage = currentPage
        setViewControllers([createDetailViewController(currentPage)], direction: .forward, animated: false, completion: nil)
    }
}

// MARK: - UIPageViewController Datasource Methods
// Standard methods for UIPageViewController protocol. Implemented as extensions just for organization purposes
extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentViewController = viewController as? DetailViewController {
            if currentViewController.currentPage < listArray.count - 1 {
                return createDetailViewController(currentViewController.currentPage + 1) // create the page you're headed to
            }
        }
        return nil // this would happen if we were on the last page
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // get the page# of the current page we're on. page is a property of DetailViewController. It was set in func cityVCForPage
        if let currentViewController = viewController as? DetailViewController {
            if currentViewController.currentPage > 0 {
                return createDetailViewController(currentViewController.currentPage - 1) // create the page you're headed to
            }
        }
        return nil // this would happen if we were on the first page
    }
    
    
    // MARK: - Methods for handling PageControl (current page indicator)
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return listArray.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        if let currentViewController = pageViewController.viewControllers?[0] as? DetailViewController {
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
        
        if let currentViewController = pageViewController.viewControllers?[0] as? DetailViewController {
            pageControl.currentPage = currentViewController.currentPage
        }
    }
}
