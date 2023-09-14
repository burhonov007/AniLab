//
//  GenreTableViewController.swift
//  AniLab
//
//  Created by The WORLD on 13/09/23.
//

import UIKit

class FilterTableViewController: UITableViewController {
    var filterLink: [String] = []
    
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
    
    var FilterList: [Filter] = [
        Filter(title: "Приключения", link: "adventure", isSelected: false),
        Filter(title: "Боевик", link: "action", isSelected: false),
        Filter(title: "Комедия", link: "comedy", isSelected: false),
        Filter(title: "Повседневность", link: "everyday", isSelected: false),
        Filter(title: "Романтика", link: "romance", isSelected: false),
        Filter(title: "Драма", link: "drama", isSelected: false),
        Filter(title: "Фантастика", link: "fantastic", isSelected: false),
        Filter(title: "Фэнтези", link: "fantasy", isSelected: false),
        Filter(title: "Мистика", link: "mystic", isSelected: false),
        Filter(title: "Детектив", link: "detective", isSelected: false),
        Filter(title: "Триллер", link: "thriller", isSelected: false),
        Filter(title: "Психология", link: "psychology", isSelected: false)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FilterList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FilterTableViewCell
        cell.title.text = FilterList[indexPath.row].title
        cell.link.text = FilterList[indexPath.row].link
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        FilterList[indexPath.row].isSelected = !FilterList[indexPath.row].isSelected
        
        let cell = tableView.cellForRow(at: indexPath) as! FilterTableViewCell
        if FilterList[indexPath.row].isSelected {
            cell.isSelectedFilter.tintColor = UIColor.link
            if !filterLink.contains(FilterList[indexPath.row].link) {
                filterLink.append(FilterList[indexPath.row].link)
            }
        } else {
            cell.isSelectedFilter.tintColor = UIColor.white
            if let index = filterLink.firstIndex(of: FilterList[indexPath.row].link) {
                filterLink.remove(at: index)
            }
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    


}
