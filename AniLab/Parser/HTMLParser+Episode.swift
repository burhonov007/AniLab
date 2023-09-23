//
//  AnimeByEpisodes.swift
//  AniLab
//
//  Created by The WORLD on 11/09/23.
//

import Foundation
import Kanna


extension HTMLParser {
    
    //MARK: - GET ANIME EPISODES
    static func getEpisodes(from url: String, animeName: String, completion: @escaping ([Episodes]) -> Void) {

        var AnimeEpisodes = [Episodes]()
        var episodeTitle: String = ""
        var episodeURL: String = ""
        
        let myUrl = URL(string: url)
        guard let requestUrl = myUrl else { fatalError() }
        let request = URLRequest(url: requestUrl)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                Alerts.ErrorInURLSessionAlert()
                return
            }
           
            if let data = data, let dataString = String(data: data, encoding: .windowsCP1251) {
                if let doc = try? HTML(html: dataString, encoding: .windowsCP1251) {
                    for link in doc.xpath("//a") {
                        if let href = link["href"], let text = link.text {
                            if !href.hasPrefix("https://") && (href.contains("/episode-") || href.contains("/film-")) {
                                let title = text.replacingOccurrences(of: animeName, with: "")
                                episodeTitle = title
                                episodeURL = href
                                AnimeEpisodes.append(Episodes(title: episodeTitle, link: episodeURL))
                            }
                        }
                    }
                    completion(AnimeEpisodes)
                }
            }
        }.resume()
    }
}

