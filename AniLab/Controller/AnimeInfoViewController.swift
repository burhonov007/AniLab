//
//  AnimeInfoViewController.swift
//  AniLab
//
//  Created by The WORLD on 11/09/23.
//

import UIKit

class AnimeInfoViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var originalTitle: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var yearOfIssue: UILabel!
    @IBOutlet weak var ageRating: UILabel!
    @IBOutlet weak var addToFavouritesButton: UIButton!
    
    // MARK: - Properties
    var series: String = ""
    var posterUrl: String = ""
    var link: String = ""
    var isAnimeAddedToFavourites = false
    var animeInfo: [AnimeInfo] = []
    var animeEpisodes: [Episodes] = []
    var animeToFavourites: [Anime] = []
    
    
    // MARK: - Load ANIME from User Defaults
    var loadedAnimeList = FavouriteManager.loadData()

    // MARK: - VIEWDIDLOAD()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HTMLParser.getAnimeInfo(from: link) { animeInfoArr in
            self.animeInfo = animeInfoArr
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
        
        isAnimeAddedToFavourites = loadedAnimeList.contains { anime in
            return anime.name == self.title
        }
        
        if isAnimeAddedToFavourites {
            animeAdded()
        } else {
            animeNotAdded()
        }
    }

    @IBAction func addToFavorites() {
        if !isAnimeAddedToFavourites {
            loadedAnimeList.append(Anime(name: self.title!, link: link, series: series, poster: posterUrl))
            FavouriteManager.saveData(animeList: loadedAnimeList)
            animeAdded()
            isAnimeAddedToFavourites = true
        } else {
            loadedAnimeList.removeAll { anime in
                return anime.name == self.title
            }
            FavouriteManager.saveData(animeList: loadedAnimeList)
            animeNotAdded()
            isAnimeAddedToFavourites = false
        }
    }
    
    
    func animeAdded() {
        addToFavouritesButton.setTitle("В избранном", for: .normal)
        addToFavouritesButton.backgroundColor = UIColor.yellow
    }
    
    func animeNotAdded() {
        addToFavouritesButton.setTitle("В избранное", for: .normal)
        addToFavouritesButton.backgroundColor = UIColor.white
        addToFavouritesButton.layer.borderWidth = 2.0
        addToFavouritesButton.layer.borderColor = UIColor.yellow.cgColor
    }

    
    @IBAction func watchEpisodes() {
        let watchEpisodesVC = storyboard?.instantiateViewController(withIdentifier: "EpisodesVC") as! EpisodesTableViewController
        HTMLParser.getEpisodes(from: link, animeName: self.title!) { animeData in
            self.animeEpisodes = animeData
            DispatchQueue.main.async {
                watchEpisodesVC.AnimeEpisodes = self.animeEpisodes
                self.navigationController?.pushViewController(watchEpisodesVC, animated: true)
            }
        }
    }

    func updateUI() {
        if let firstAnime = animeInfo.first {
            originalTitle.text = "Оригинальное название: \(firstAnime.originalTitle)"
            rating.text = "Рейтинг: \(firstAnime.rating)"
            genre.text = firstAnime.genre
            yearOfIssue.text = "Год выпуска: \(firstAnime.yearOfIssue)"
            ageRating.text = "Возрастной рейтинг: \(firstAnime.ageRating)"
            
            if let imageUrl = URL(string: posterUrl) {
                URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                    if let _ = error {
                        self.poster.image = UIImage(named: "noimage")
                        return
                    }
                    
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.poster.image = image
                        }
                    }
                }.resume()
            }
        }
    }
    
    
}
