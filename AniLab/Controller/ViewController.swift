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
    var animeList: [Anime] = []
    var searchedAnimeList: [Anime] = []
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
        title = "Jut.su"
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
        currentPage += 1
        let nextPageURL = "https://jut.su/anime/\(filterLink)\(sortLink)/page-\(currentPage)/"
        HTMLParser.getHTML(from: nextPageURL) { [weak self] animeData in
            if !animeData.isEmpty {
                self?.animeList += animeData
                DispatchQueue.main.async {
                    self!.activityIndicator.stopAnimating()
                    self!.activityIndicator.isHidden = true
                    self!.animeTableView.reloadData()
                }
            } else {
                self!.goToAnotherPage = false
                DispatchQueue.main.async {
                    if !self!.filterLink.isEmpty && self!.animeList.isEmpty {
                        Alerts.AccessDeniedAlertOrNoData(title: "Нет аниме", message: "По выбранным вами критериям аниме отсутствуют. Пожалуйста, укажите другие категории.", viewController: self!)
                    }
                    self!.activityIndicator.stopAnimating()
                    self!.activityIndicator.isHidden = true
                }
            }
        }
    }
    
    
    
//    private func loadNextPageForSearch(searchText: String) {
//        currentPageForSearch += 1
//        let nextPageURLForSearch = "https://jut.su/anime/page-\(currentPageForSearch)"
//
//
//        HTMLParser.getAllAnimeForSearch(from: nextPageURLForSearch,
//                                        searchText: searchText) { animeData in
//
//                self.searchedAnimeList += animeData
//                print(animeData)
//                DispatchQueue.main.async {
//                    self.animeTableView.reloadData()
//                }
//        }
//    }
        

    // MARK: - numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !searchedAnimeList.isEmpty {
            return searchedAnimeList.count
        }else{
            return animeList.count
        }
        
    }

    // MARK: - cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = animeTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        if !searchedAnimeList.isEmpty {
            let anime = searchedAnimeList[indexPath.row]
            cell.configure(with: anime)
        } else {
            let anime = animeList[indexPath.row]
            cell.configure(with: anime)
        }
//        if goToAnotherPageForSearch {
//            if indexPath.row >= searchedAnimeList.count - 1 {
//                loadNextPageForSearch(searchText: searchBar.text!)
//            }
//        }
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
}



extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchedAnimeList = []
        activityIndicator.startAnimating()
//        if let searchText = searchBar.text {
//            loadNextPageForSearch(searchText: searchText)
//            searchBar.resignFirstResponder()
//        }

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchedAnimeList = []
        animeTableView.reloadData()
        searchBar.text = ""
    }
}
