//
//  AnimeInfoViewController.swift
//  AniLab
//
//  Created by The WORLD on 11/09/23.
//

import UIKit

class AnimeInfoViewController: UIViewController {

    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var originalTitle: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var yearOfIssue: UILabel!
    @IBOutlet weak var ageRating: UILabel!
    
    var series: String = ""
    var posterUrl: String = ""
    var link: String = ""
    var animeInfo: [AnimeInfo] = []
    var animeEpisodes: [Episodes] = []
    var animeToFavourites: [Anime] = []
    
  
    
    @IBAction func addToFavorites() {
        animeToFavourites.append(Anime(name: self.title!, link: link, series: series, poster: posterUrl))
        print(animeToFavourites)
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

        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            
            HTMLParser.getAnimeInfo(from: link) { [weak self] animeInfoArr in
                self?.animeInfo = animeInfoArr
                
                // Обновите интерфейс после получения данных
                DispatchQueue.main.async {
                    self?.updateUI()
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
                        if let error = error {
                            print("Error loading image: \(error)")
                            return
                        }
                        
                        if let data = data, let image = UIImage(data: data) {
                            // Обновите UI на главном потоке
                            DispatchQueue.main.async {
                                self.poster.image = image
                            }
                        }
                    }.resume()
                }
            }
        }
    
    
}
