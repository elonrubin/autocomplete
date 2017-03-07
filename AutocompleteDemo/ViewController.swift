//
//  ViewController.swift
//  AutocompleteDemo
//
//  Created by Elon Rubin on 2/18/17.
//  Copyright © 2017 Elon Rubin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var searchController = UISearchController()
    var birds = [Bird]()
    var searchResults: [Bird] = []
    var didFinishSearch = false
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      birds = Bird.initalizeJSON()
      initializeSearchController()
      tableView.dataSource = self
      tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // To Do - Add function to check if data has been saved in UserDefaults
    
//    func checkForFirstInitialization () {
//        if UserDefaults.standard.bool(forKey: "FirstInitializationComplete") == false {
//            Bird.extractJSON(completion: { (didFinish) in
//                if (didFinish) {
//                    
//                    self.birds = UserDefaults.standard.array(forKey: "Datasource") as! [Bird]
//                }
//            })
//        } else {
//            self.birds = UserDefaults.standard.array(forKey: "Datasource") as! [Bird]
//        }
//    }
    
    func initializeSearchController () {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.scopeButtonTitles = ["All", "Birdname", "Type"]
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Search for birds"
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        self.definesPresentationContext = false
        tableView.tableHeaderView = searchController.searchBar
        
    }
    
    //--------------------------------------
    // MARK: Tableview
    //--------------------------------------
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        if (searchController.isActive) && searchResults.count > 0 && (!didFinishSearch){
            return "Suggested Search Results"
        }

        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {

            switch searchController.isActive {
                case true:
                    if searchResults.count < 5 {
                        return searchResults.count
                    } else if (!didFinishSearch) {
                        return 5
                    } else {
                        return searchResults.count
                }
                case false:
                        return searchResults.count
            
            }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let bird = (searchController.isActive) ? searchResults[indexPath.row] : birds[indexPath.row]
        
        if (!didFinishSearch) {
            cell.textLabel?.textColor = UIColor.gray
        } else {
            cell.textLabel?.textColor = UIColor.black
        }
        cell.textLabel?.text = bird.fullname
        return cell
    }
    
    func filterControllerForSearchText(searchText: String, scope: String) {
       
        
        // To Do - Refactor This Function To Reduce Code
            switch scope {
        case "All":
                 searchResults = birds.filter({ (bird: Bird) -> Bool in
            
                let birdMatch = bird.fullname.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
               return birdMatch != nil
                })
            case "Birdname":
                searchResults = birds.filter({ (bird: Bird) -> Bool in
                    
                    let birdMatch = bird.birdname.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                    return birdMatch != nil
                })
            
        case "Type":
      
            searchResults = birds.filter({ (bird: Bird) -> Bool in
                
        
                let birdMatch = bird.type?.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                return birdMatch != nil
            })
            default:
                break
        }
    }


}

extension ViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        print("changed")
        filterControllerForSearchText(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        didFinishSearch = true
        DispatchQueue.main.async {
            print("changed")
            self.tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        didFinishSearch = false
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

extension ViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text {
            let searchBar = searchController.searchBar
            let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
            
            filterControllerForSearchText(searchText: searchText,scope: scope)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
}

