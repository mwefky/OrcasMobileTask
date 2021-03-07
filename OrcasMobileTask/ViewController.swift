//
//  ViewController.swift
//  OrcasMobileTask
//
//  Created by mina wefky on 07/03/2021.
//

import UIKit

class ViewController: UIViewController {
    //MARK:- variables
    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
    var weatherViewModel = WeatherViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherViewModel.fetchRemoteFeed()
        
        initNavBar()
    }

    //MARK: Navigation Bar init
    func initNavBar(){
        searchBar.placeholder = "Enter City Name"
        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
    }

}

