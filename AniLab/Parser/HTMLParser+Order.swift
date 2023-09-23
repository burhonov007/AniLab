//
//  AnimeOrder.swift
//  AniLab
//
//  Created by The WORLD on 16/09/23.
//


import Foundation
import Kanna

extension HTMLParser {
    
    static func getOrder(completion: @escaping ([Order]) -> Void) {
        var orderList: [Order] = []
        let url = "https://jut.su/anime/"
        guard let myURL = URL(string: url) else {
            completion([])
            return
        }
        let request = URLRequest(url: myURL)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                Alerts.ErrorInURLSessionAlert()
                completion([])
                return
            }
            // GET HTML from web site
            if let data = data, let dataString = String(data: data, encoding: .windowsCP1251) {
                if let doc = try? HTML(html: dataString, encoding: .windowsCP1251) {
                    if let _ = doc.at_css(".anime_choose_block_order")!.innerHTML {
                        for orderElement in doc.css(".anime_choose_order") {
                            if let link = orderElement.at_css("a")?["href"] {
                                let title = orderElement.at_css("a")?.text
                                orderList.append(Order(title: title!, link: link.replacingOccurrences(of: "/anime/", with: "").replacingOccurrences(of: "/", with: "")))
                            }
                        }
                    }
                    completion(orderList)
                }
            }
        }.resume()
    }
}

