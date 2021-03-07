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
    var tableViewState: State = .empty
    var weatherFeed: WeatherModel? {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
        
    }

    //MARK:- binding View Model
    func bindViewModel(){
        weatherViewModel.feedList.subscribe(onNext: { [weak self] (feeds) in
                guard let localfeeds = feeds else {return}
                self?.weatherFeed = localfeeds
                self?.tableViewState = .populated
            }).disposed(by: disoseBag)
        weatherViewModel.error.subscribe(onNext: { [weak self] (error) in
            if error == "not data" {
                self?.tableViewState = .oldData
            }else if error == "not accurate data" {
                self?.tableViewState = .error
            }
        }).disposed(by: disoseBag)
    }
    
    //MARK:- UI setup
    func setupUI(){
        searchBar.placeholder = "Enter City Name"
        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        
        let search = UIImage(named: "SearchArrow")?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: search, style:.plain, target: self, action: #selector(searchBtnTapped))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DailyWeatherTableViewCell.self, forCellReuseIdentifier: "DailyWeatherTableViewCell")
        tableView.register(UINib(nibName: "DailyWeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "DailyWeatherTableViewCell")
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

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherFeed?.list.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyWeatherTableViewCell") as! DailyWeatherTableViewCell
        let weatherRow = weatherFeed?.list[indexPath.row]
        cell.setUpCell(weatherdate: weatherRow?.dtTxt ?? "", weatherDescription: weatherRow?.weather.first?.weatherDescription ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 
    }
    
}



//Mark:- tableView state
enum State {
  case oldData
  case populated
  case empty
  case error
}
