//
//  SortTableViewController.swift
//  AniLab
//
//  Created by The WORLD on 13/09/23.
//

import UIKit

class SortTableViewController: UITableViewController {
    
    var sortElement:[Sort] = [
        Sort(title: "По рейтингу", link: ""),
        Sort(title: "По алфавиту", link: "/order-by-name"),
        Sort(title: "По количеству серий", link: "/order-by-count"),
        Sort(title: "По году выхода", link: "/order-by-date"),
        Sort(title: "По дате добавления", link: "/order-by-add")
    ]
    


    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sortElement.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SortTableViewCell
        cell.title.text = sortElement[indexPath.row].title
        cell.link.text = sortElement[indexPath.row].link
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let link = sortElement[indexPath.row].link
        let mainVC = storyboard?.instantiateViewController(withIdentifier: "MainVC") as! ViewController
        mainVC.sortLink = link
        self.navigationController?.pushViewController(mainVC, animated: true)
    }
    

}
