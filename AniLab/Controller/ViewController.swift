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
    var filterLink = ""
    private var currentPage = 0
    var goToAnotherPage: Bool = true
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        if let act = activityIndicator {
            act.startAnimating()
        }
        print(filterLink)
        title = "Anime List"
        loadNextPage()
    }
    
    // MARK: - Open sortButton
    @IBAction func sortButton(_ sender: Any) {
        let SortTableVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SortTableVC")
        self.navigationController?.pushViewController(SortTableVC, animated: true)
    }
    
    @IBAction func filterButton(_ sender: Any) {
        let FilterTableVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FilterTableVC")
        self.navigationController?.pushViewController(FilterTableVC, animated: true)
    }
    

    // MARK: - Load Pages (Pagination)
    private func loadNextPage() {
        currentPage += 1
        let nextPageURL = "https://jut.su/anime/\(filterLink)\(sortLink)/page-\(currentPage)/"
        HTMLParser.getHTML(from: nextPageURL) { [weak self] animeData in
            if !animeData.isEmpty {
                self?.animeList += animeData
                DispatchQueue.main.async {
                    if let act = self!.activityIndicator {
                        act.stopAnimating()
                }
                    self?.animeTableView.reloadData()
                }
            } else {
                self!.goToAnotherPage = false
                DispatchQueue.main.async {
                    if self?.filterLink.isEmpty == false && self?.animeList.isEmpty == true {
                        Alerts.AccessDeniedAlertOrNoData(title: "Нет аниме", message: "По выбранным вами критериям аниме отсутствуют. Пожалуйста, укажите другие категории.", viewController: self!)
                    }
                    self?.activityIndicator.stopAnimating()
                    self!.activityIndicator.isHidden = true
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
        if goToAnotherPage {
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
        animeInfoVC.series = anime.series
        animeInfoVC.title = anime.name
        animeInfoVC.link = anime.link
        animeInfoVC.posterUrl = anime.poster
        self.navigationController?.pushViewController(animeInfoVC, animated: true)
    }
}

