//
//  CustomTableViewCell.swift
//  AniApp
//
//  Created by The WORLD on 06/09/23.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    //MARK: - OUTLETS
    @IBOutlet weak var animeNameLabel: UILabel!
    @IBOutlet weak var animeLink: UILabel!
    @IBOutlet weak var animeSeriesLabel: UILabel!
    @IBOutlet weak var animeImageView: UIImageView!
    
    
    func configure(with anime: Anime) {
        animeNameLabel.text = anime.name
        animeSeriesLabel.text = anime.series
        animeLink.text = anime.link
        animeImageView.image = UIImage(named: "noimage")
        
        let url = URL(string: anime.poster)!
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.animeImageView.image = image
                    self?.animeImageView.layer.cornerRadius = self!.animeImageView.frame.height / 2
                    self?.animeImageView.clipsToBounds = true
                }
            }
        }.resume()
    }
}
