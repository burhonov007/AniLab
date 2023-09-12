//
//  ViewController.swift
//  AniLab
//
//  Created by The WORLD on 07/09/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var animeTableView: UITableView!
    var animeList: [Anime] = []
    private var currentPage = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let act = activityIndicator {
            act.startAnimating()
        }
        title = "Anime List"
        loadNextPage()
    }
    
    private func loadNextPage() {
        currentPage += 1
        print(animeList.count)
        let nextPageURL = "https://jut.su/anime/page-\(currentPage)/"
        print(nextPageURL)
        print(animeList.count)
        HTMLParser.getHTML(from: nextPageURL) { [weak self] animeData in
            self?.animeList += animeData
            DispatchQueue.main.async {
                if let act = self!.activityIndicator {
                    act.stopAnimating()
            }
                self?.animeTableView.reloadData()
            }
        }
    }


  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animeList.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = animeTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        let anime = animeList[indexPath.row]
        cell.configure(with: anime)
        if currentPage < 32 {
            if indexPath.row >= animeList.count - 1 {
                loadNextPage()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let anime = animeList[indexPath.row]
            
        let animeInfoVC = storyboard?.instantiateViewController(withIdentifier: "AnimeDetailVС") as! AnimeInfoViewController
        animeInfoVC.name = anime.name
        animeInfoVC.title = anime.name
        animeInfoVC.link = anime.link
        animeInfoVC.posterUrl = anime.poster
        self.navigationController?.pushViewController(animeInfoVC, animated: true)
      
    }
    
    
}

