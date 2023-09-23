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
    @IBOutlet var animeTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Properties
    private var animeList: [Anime] = []
    private var searchedAnimeList: [Anime] = []
    var sortLink = ""
    var filterLink = ""
    private var currentPage = 0
    private var currentPageForSearch = 0
    var goToAnotherPage: Bool = true
    var goToAnotherPageForSearch: Bool = true
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        title = "Otaku"
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        loadNextPage()
    }
    
    // MARK: - Open sortButton
    @IBAction func sortButton(_ sender: Any) {
        let SortTableVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SortTableVC")
        self.navigationController?.pushViewController(SortTableVC, animated: true)
    }
    
    // MARK: - Open FilterButton
    @IBAction func filterButton(_ sender: Any) {
        let FilterTableVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FilterTableVC")
        self.navigationController?.pushViewController(FilterTableVC, animated: true)
    }
    
    // MARK: - Open FavouritesButton
    @IBAction func openFavourites(_ sender: Any) {
        let FavouritesVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FavouriteVC")
        self.navigationController?.pushViewController(FavouritesVC, animated: true)
    }
    
    
    // MARK: - Load Pages (Pagination)
    private func loadNextPage() {
        activityIndicator.startAnimating()
        searchedAnimeList = []
        currentPage += 1
        let nextPageURL = "https://jut.su/anime/\(filterLink)\(sortLink)/page-\(currentPage)/"
        HTMLParser.getHTML(from: nextPageURL) { [weak self] animeData in
            if !animeData.isEmpty {
                self?.animeList += animeData
                DispatchQueue.main.async {
                    self!.animeTableView.reloadData()
                }
            } else {
                self!.goToAnotherPage = false
                DispatchQueue.main.async {
                    if !self!.filterLink.isEmpty && self!.animeList.isEmpty {
                        Alerts.AccessDeniedAlertOrNoData(title: "Нет аниме", message: "По выбранным вами критериям аниме отсутствуют. Пожалуйста, укажите другие категории.", viewController: self!)
                    }
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    
    private func loadNextPageForSearch() {
        currentPageForSearch += 1
        HTMLParser.search(page: currentPageForSearch, searchText: searchBar.text!) { [weak self] searchedAnime in
            if !searchedAnime.isEmpty {
                self?.searchedAnimeList += searchedAnime
                DispatchQueue.main.async {
                    self!.animeTableView.reloadData()
                }
                
            } else {
                self!.goToAnotherPageForSearch = false
                if self!.searchedAnimeList.isEmpty {
                    DispatchQueue.main.async {
                        Alerts.AccessDeniedAlertOrNoData(title: "Нет аниме", message: "По указанным вами критериям аниме отсутствуют..", viewController: self!)
                        self?.activityIndicator.stopAnimating()
                    }
                }
            }
        }
    }
    

    // MARK: - numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !searchedAnimeList.isEmpty {
            return searchedAnimeList.count
        } else {
            return animeList.count
        }
        
    }

    // MARK: - cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = animeTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        DispatchQueue.main.async { [self] in
            if !searchedAnimeList.isEmpty {
                let anime = searchedAnimeList[indexPath.row]
                cell.configure(with: anime)
                if goToAnotherPageForSearch {
                    if indexPath.row >= searchedAnimeList.count - 1 {
                        loadNextPageForSearch()
                    }
                }
            } else {
                let anime = animeList[indexPath.row]
                cell.configure(with: anime)
                if goToAnotherPage {
                    if indexPath.row >= animeList.count - 1 {
                        loadNextPage()
                    }
                }
            }
        }
        self.activityIndicator.stopAnimating()
        return cell
    }
    
    // MARK: - didSelectRowAt (SEND data to AnimeDetailViewController and Show in UI)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var anime: Anime
        if !searchedAnimeList.isEmpty {
            anime = searchedAnimeList[indexPath.row]
        } else {
            anime = animeList[indexPath.row]
        }
        let animeInfoVC = storyboard?.instantiateViewController(withIdentifier: "AnimeDetailVС") as! AnimeInfoViewController
        animeInfoVC.series = anime.series
        animeInfoVC.title = anime.name
        animeInfoVC.link = anime.link
        animeInfoVC.posterUrl = anime.poster
        self.navigationController?.pushViewController(animeInfoVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: - Search Delegate

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchedAnimeList = []
        currentPageForSearch = 0
        if !searchBar.text!.isEmpty {
            loadNextPageForSearch()
        }
      }

      func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
          searchedAnimeList = []
          animeTableView.reloadData()
          searchBar.text = ""
      }
}
