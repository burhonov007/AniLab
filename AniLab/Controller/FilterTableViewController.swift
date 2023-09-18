//
//  GenreTableViewController.swift
//  AniLab
//
//  Created by The WORLD on 13/09/23.
//

import UIKit

class FilterTableViewController: UITableViewController {
    var filterLink: [String] = []
    var filterList: [Genre] = []
    
    @IBAction func refreshFilters(_ sender: Any) {
        let MainTableVC = storyboard?.instantiateViewController(withIdentifier: "MainVC") as! ViewController
        MainTableVC.filterLink = ""
        self.navigationController?.pushViewController(MainTableVC, animated: true)
    }
    
    @IBAction func doneSelectFilters(_ sender: Any) {
        let MainTableVC = storyboard?.instantiateViewController(withIdentifier: "MainVC") as! ViewController
        MainTableVC.filterLink = filterLink.joined(separator: "-")
        self.navigationController?.pushViewController(MainTableVC, animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        HTMLParser.getGenres { genreData in
            self.filterList += genreData
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FilterTableViewCell
        cell.title.text = filterList[indexPath.row].title
        cell.link.text = filterList[indexPath.row].link
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        filterList[indexPath.row].isSelected = !filterList[indexPath.row].isSelected
        
        let cell = tableView.cellForRow(at: indexPath) as! FilterTableViewCell
        if filterList[indexPath.row].isSelected {
            cell.isSelectedFilter.tintColor = UIColor.link
            if !filterLink.contains(filterList[indexPath.row].link) {
                filterLink.append(filterList[indexPath.row].link)
            }
        } else {
            cell.isSelectedFilter.tintColor = UIColor.white
            if let index = filterLink.firstIndex(of: filterList[indexPath.row].link) {
                filterLink.remove(at: index)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
