//
//  FavouriteTableViewController.swift
//  AniLab
//
//  Created by The WORLD on 16/09/23.
//

import UIKit

class FavouriteTableViewController: UITableViewController {

    var loadedAnime: [Anime] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadedAnime = FavouriteManager.loadData()
        if loadedAnime.isEmpty {
            Alerts.AccessDeniedAlertOrNoData(title: "Нет аниме", message: "Вы еще не добавляли аниме в избранное", viewController: self)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadedAnime = FavouriteManager.loadData()
        tableView.reloadData()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loadedAnime.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
            let anime = loadedAnime[indexPath.row]
            cell.configure(with: anime)
            return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let anime = loadedAnime[indexPath.row]
        let animeInfoVC = storyboard?.instantiateViewController(withIdentifier: "AnimeDetailVС") as! AnimeInfoViewController
        animeInfoVC.series = anime.series
        animeInfoVC.title = anime.name
        animeInfoVC.link = anime.link
        animeInfoVC.posterUrl = anime.poster
        self.navigationController?.pushViewController(animeInfoVC, animated: true)
    }
}
