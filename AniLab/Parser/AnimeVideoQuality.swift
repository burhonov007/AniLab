//
//  AnimeVideoQuality.swift
//  AniLab
//
//  Created by The WORLD on 12/09/23.
//

import Foundation
import Kanna

extension HTMLParser {
    static func getVideoQuality(from url: String, completion: @escaping ([VideoQuality]) -> Void) {
        var qualities = [VideoQuality]()
        let myUrl = URL(string: url)
        guard let requestUrl = myUrl else { fatalError() }
        let userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.0.0 Safari/537.36 OPR/100.0.0.0"
        var request = URLRequest(url: requestUrl)
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error \(error)")
                completion([]) // Return an empty array in case of error
                return
            }
            if let data = data, let dataString = String(data: data, encoding: .windowsCP1251) {
                if let doc = try? HTML(html: dataString, encoding: .windowsCP1251) {
                    let sources = doc.xpath("//source")
                    print(sources.count)
                    for source in sources {
                        if let src = source["src"], let title = source["label"] {
                            qualities.append(VideoQuality(title: title, link: src))
                            print(title)
                        }
                    }
                    completion(qualities) // Pass the populated array to the completion handler
                }
            }
        }.resume()
    }
}

