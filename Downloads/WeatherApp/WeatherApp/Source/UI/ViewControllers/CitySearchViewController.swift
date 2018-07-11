//
//  CitySearchViewController.swift
//  WeatherApp
//
//  Created by Denis on 16.07.17.
//  Copyright © 2017 Denis. All rights reserved.
//

import UIKit


protocol CityDelegate: class {
    func setCoorinates(city: [String: Any]?)
}


class CitySearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {

    private var pendingRequestWorkItem: DispatchWorkItem?
    
    weak var delegate: CityDelegate? = nil
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var tableView: UITableView!
    
    var citiesList: [Any] = []
    var filteredCites = [Any]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.defaultIdentifier)
        citiesList = CitiesList.sharedInstance.citiesList
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.barTintColor = self.tableView.backgroundColor
        tableView.tableHeaderView = searchController.searchBar
    }
    

// MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        pendingRequestWorkItem?.cancel()
        let requestWorkItem = DispatchWorkItem { [weak self] in
            self?.filterContentForSearchText(searchText: searchController.searchBar.text!)
        }
        pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500) , execute: requestWorkItem)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            self.filteredCites = self.citiesList.filter { city in
                let string = (city as? [String: Any])?["name"] as? String
                return (string?.lowercased().hasPrefix(searchText.lowercased()))!
            }
            
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
    }
    
// MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredCites.count
        }
        return self.citiesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.defaultIdentifier, for: indexPath)
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.white
        
        let city: [String: Any]?
        if searchController.isActive && searchController.searchBar.text != "" {
            city = filteredCites[indexPath.row] as? [String: Any]
        } else {
            city = self.citiesList[indexPath.row] as? [String: Any]
        }
        let country = (city?["country"] as? String)?.countryNameFromCountryCode()
        cell.textLabel?.text = (city?["name"] as? String)! + ", " + country!
        
        return cell
    }
    
// MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city: [String: Any]?
        if searchController.isActive && searchController.searchBar.text != "" {
            city = filteredCites[indexPath.row] as? [String: Any]
        } else {
            city = self.citiesList[indexPath.row] as? [String: Any]
        }
        delegate?.setCoorinates(city: city)
        self.navigationController?.popViewController(animated: true)
    }
}
