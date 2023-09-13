import Foundation
import Kanna

public class HTMLParser {
    
    static func getHTML(from url: String, completion: @escaping ([Anime]) -> Void) {
        var animeList: [Anime] = []
    
        guard let myURL = URL(string: url) else {
            completion([]) // Вызываем completion с пустым массивом в случае ошибки
            return
        }
        
        let request = URLRequest(url: myURL)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error \(error)")
                completion([]) // Вызываем completion с пустым массивом в случае ошибки
                return
            }
            
            // GET HTML from web site
            if let data = data, let dataString = String(data: data, encoding: .windowsCP1251) {
                if let doc = try? HTML(html: dataString, encoding: .windowsCP1251) {
                    for animeListElement in doc.css(".all_anime_global") {   
                        // Ваш код обработки данных animeListElement
                        if let animeName = animeListElement.at_css(".aaname")?.text,
                           var animeLink = animeListElement.at_css("a")?["href"],
                           var animeSeries = animeListElement.at_css(".aailines")?.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                           let imgLink = animeListElement.at_css(".all_anime_image")?["style"]?.components(separatedBy: "'")[1] {
                            
                            animeLink = animeLink.replacingOccurrences(of: "/", with: "")
                            animeLink = "https://jut.su/\(animeLink)"
                            
                            animeSeries = animeSeries.replacingOccurrences(of: "сезона", with: "сезона ")
                            animeSeries = animeSeries.replacingOccurrences(of: "сезонов", with: "сезонов ")
                            animeSeries = animeSeries.replacingOccurrences(of: "серий", with: "серий ")
                            
                            
                            let anime = Anime(name: animeName, link: animeLink, series: animeSeries, poster: imgLink)
                            animeList.append(anime)
                            
                        }
                    }
                    if animeList.count == 0 {
                        completion([]) 
                    }
                    completion(animeList) // Вызываем completion с массивом после завершения обработки данных
                }
            }
        }.resume()
    }
}
