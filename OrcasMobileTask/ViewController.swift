//
//  ViewController.swift
//  OrcasMobileTask
//
//  Created by mina wefky on 07/03/2021.
//

import UIKit
import RxSwift

class ViewController: UIViewController, UISearchBarDelegate {
    
    // MARK: - variables
    lazy var searchBar: UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 240, height: 20))
    var weatherViewModel = WeatherViewModel()
    var disoseBag = DisposeBag()
    let weatherTVCID = "DailyWeatherTableViewCell"
    let errorTVCID = "ErrorTableViewCell"
    var tableViewState: TableViewStateState? {
        didSet {
            tableView.reloadData()
        }
    }
    var weatherFeed: WeatherModel? {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }

    // MARK: - binding View Model
    func bindViewModel() {
        weatherViewModel.feedList.subscribe(onNext: { [weak self] (feeds) in
                guard let localfeeds = feeds else {return}
                self?.weatherFeed = localfeeds
                self?.tableViewState = .populated
            }).disposed(by: disoseBag)
        weatherViewModel.error.subscribe(onNext: { [weak self] (error) in
            if error == "not data" {
                self?.tableViewState = .error
            } else if error == "not accurate data" {
                self?.tableViewState = .oldData
            }
        }).disposed(by: disoseBag)
    }
    
    // MARK: - UI setup
    func setupUI() {
        // nav bar
        searchBar.placeholder = "Enter City Name"
        let leftNavBarButton = UIBarButtonItem(customView: searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        let search = UIImage(named: "SearchArrow")?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: search, style: .plain, target: self, action: #selector(searchBtnTapped))
        searchBar.delegate = self
        // table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        tableView.register(UINib(nibName: weatherTVCID, bundle: nil), forCellReuseIdentifier: weatherTVCID)
        tableView.register(UINib(nibName: errorTVCID, bundle: nil), forCellReuseIdentifier: errorTVCID)
    }
    
    // MARK: - Actions
    @objc func searchBtnTapped() {
        if searchBar.text == "" {
            print("no Values")
        } else {
            weatherViewModel.fetchRemoteFeed(with: searchBar.text ?? "")
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBtnTapped()
        searchBar.resignFirstResponder()
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableViewState {
        case .empty:
            return 0
        case .error:
            return 1
        default:
            return weatherFeed?.list.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        switch tableViewState {
        case .error:
            let cell = tableView.dequeueReusableCell(withIdentifier: errorTVCID) as! ErrorTableViewCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: weatherTVCID) as! DailyWeatherTableViewCell
            let weatherRow = weatherFeed?.list[indexPath.row]
            cell.setUpCell(weatherdate: weatherRow?.dtTxt ?? "", weatherDescription: weatherRow?.weather.first?.weatherDescription ?? "")
            return cell
        // swiftlint:enable force_cast
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch tableViewState {
        case .oldData:
            return "not accurate data"
        default:
            return ""
        }
    }
}

// MARK: - binding View Model
enum TableViewStateState {
  case oldData
  case populated
  case empty
  case error
}
