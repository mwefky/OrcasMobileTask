//
//  ViewController.swift
//  OrcasMobileTask
//
//  Created by mina wefky on 07/03/2021.
//

import UIKit
import RxSwift
class ViewController: UIViewController {
    //MARK:- variables
    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 240, height: 20))
    var weatherViewModel = WeatherViewModel()
    var disoseBag = DisposeBag()
    var weatherFeed: WeatherModel? {
        didSet {
//            print(weatherFeed)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavBar()
        bindViewModel()
    }

    //MARK:- binding View Model
    func bindViewModel(){
        weatherViewModel.feedList.subscribe(onNext: { (feeds) in
            DispatchQueue.main.async { [weak self] in
                guard let localfeeds = feeds else {return}
                self?.weatherFeed = localfeeds
            }
            }).disposed(by: disoseBag)
    }
    
    //MARK: Navigation Bar init
    func initNavBar(){
        searchBar.placeholder = "Enter City Name"
        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        
        let search = UIImage(named: "SearchArrow")?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: search, style:.plain, target: self, action: #selector(searchBtnTapped))
    }
    
    
    //MARK:- Actions
    @objc func searchBtnTapped(){
        if searchBar.text == "" {
            print("no Values")
        }else {
            weatherViewModel.fetchRemoteFeed(with: searchBar.text ?? "")
        }
    }

}

