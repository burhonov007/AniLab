//
//  ViewController.swift
//  AniLab
//
//  Created by The WORLD on 07/09/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //  MARK: - Loader
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - TableView
    @IBOutlet var animeTableView: UITableView!
    var animeList: [Anime] = []
    var sortLink = ""
    private var currentPage = 0
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        if let act = activityIndicator {
            act.startAnimating()
        }
        title = "Anime List"
        loadNextPage()
    }
    
    // MARK: - Open sortButton
    @IBAction func sortButton(_ sender: Any) {
        let SortTableVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SortTableVC")
        self.navigationController?.pushViewController(SortTableVC, animated: true)
    }

    // MARK: - Load Pages (Pagination)
    private func loadNextPage() {
        currentPage += 1
        let nextPageURL = "https://jut.su/anime\(sortLink)/page-\(currentPage)/"
        HTMLParser.getHTML(from: nextPageURL) { [weak self] animeData in
            if !animeData.isEmpty {
                self?.animeList += animeData
                DispatchQueue.main.async {
                    if let act = self!.activityIndicator {
                        act.stopAnimating()
                }
                    self?.animeTableView.reloadData()
                }
            }
        }
    }


    // MARK: - numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animeList.count
    }

    // MARK: - cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = animeTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        let anime = animeList[indexPath.row]
        cell.configure(with: anime)
        if currentPage < 34 {
            if indexPath.row >= animeList.count - 1 {
                loadNextPage()
            }
        }
        return cell
    }
    
    // MARK: - didSelectRowAt (SEND data to AnimeDetailViewController and Show in UI)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let anime = animeList[indexPath.row]
        let animeInfoVC = storyboard?.instantiateViewController(withIdentifier: "AnimeDetailVС") as! AnimeInfoViewController
        animeInfoVC.name = anime.name
        animeInfoVC.title = anime.name
        animeInfoVC.link = anime.link
        animeInfoVC.posterUrl = anime.poster
//        animeInfoVC.anime.append(anime)
        self.navigationController?.pushViewController(animeInfoVC, animated: true)
    }
}

