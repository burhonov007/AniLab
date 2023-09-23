//
//  Search.swift
//  AniLab
//
//  Created by The WORLD on 20/09/23.
//

import Foundation
import Kanna

extension HTMLParser {
    
    // MARK: - GET Anime NAME, LINK, SERIES COUNT, IMAGELINK
    static func search(page: Int, searchText: String , completion: @escaping ([Anime]) -> Void) {
        var animeList: [Anime] = []
        let url = "https://jut.su/anime/"
        guard let myURL = URL(string: url) else { return }
        var request = URLRequest(url: myURL)
        request.httpMethod = "POST"
        
        let requestHeaders: [String: String] = ["User-Agent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:109.0) Gecko/20100101 Firefox/117.0",
                                                "Content-Type" : "application/x-www-form-urlencoded; charset=UTF-8",
                                                "XMLHttpRequest" : "X-Requested-With"
        ]
        
        let parameterString = "ajax_load=yes&start_from_page=\(page)&show_search=\(searchText)"
        
        request.httpBody = parameterString.data(using: .utf8)
        
        request.allHTTPHeaderFields = requestHeaders
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                Alerts.ErrorInURLSessionAlert()
                completion([])
                return
            }
            // GET HTML from web site
            if let data = data, let dataString = String(data: data, encoding: .windowsCP1251) {
                if let doc = try? HTML(html: dataString, encoding: .windowsCP1251) {
                    
                    for animeListElement in doc.css(".all_anime_global") {
                        if let animeName = animeListElement.at_css(".aaname")?.text,
                           var animeLink = animeListElement.at_css("a")?["href"],
                           var animeSeries = animeListElement.at_css(".aailines")?.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                           let imgLink = animeListElement.at_css(".all_anime_image")?["style"]?.components(separatedBy: "'")[1] {
                            
                            
                            // MARK: - EDIT Variables
                            animeLink = animeLink.replacingOccurrences(of: "/", with: "")
                            animeLink = "https://jut.su/\(animeLink)"
                            
                            animeSeries = animeSeries.replacingOccurrences(of: "сезона", with: "сезона ")
                            animeSeries = animeSeries.replacingOccurrences(of: "сезонов", with: "сезонов ")
                            animeSeries = animeSeries.replacingOccurrences(of: "серий", with: "серий ")
                            
                            // MARK: - APPEND ANIME To Array
                            let anime = Anime(name: animeName, link: animeLink, series: animeSeries, poster: imgLink)
                            animeList.append(anime)
                        }
                    }
                    if animeList.count == 0 {
                        completion([])
                    }
                    completion(animeList)
                }
            }
        }.resume()
        
    }
}

