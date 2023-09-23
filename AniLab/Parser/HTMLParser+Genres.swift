//
//  AnimeGenres.swift
//  AniLab
//
//  Created by The WORLD on 16/09/23.
//

import Foundation
import Kanna

extension HTMLParser {
    
    static func getGenres(completion: @escaping ([Genre]) -> Void) {
        var genreList: [Genre] = []
        let url = "https://jut.su/anime/"
        guard let myURL = URL(string: url) else {
            completion([])
            return
        }
        let request = URLRequest(url: myURL)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                Alerts.ErrorInURLSessionAlert()
                return
            }
            // GET HTML from web site
            if let data = data, let dataString = String(data: data, encoding: .windowsCP1251) {
                if let doc = try? HTML(html: dataString, encoding: .windowsCP1251) {
                    if let _ = doc.at_css(".anime_choose_block_ganres")?.innerHTML {
                        for genreElement in doc.css(".anime_choose_ganre") {
                            if let link = genreElement.at_css("a")?["href"] {
                                let title = genreElement.at_css("a")?.text
                                genreList.append(Genre(title: title!,
                                                       link: link.replacingOccurrences(of: "/anime/", with: "").replacingOccurrences(of: "/", with: ""),
                                                       isSelected: false))
                                }
                            }
                       }
                    completion(genreList)
                }
            }
        }.resume()
    }
}

