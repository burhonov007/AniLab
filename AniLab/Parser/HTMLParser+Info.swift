//
//  AnimeInfoParser.swift
//  AniLab
//
//  Created by The WORLD on 11/09/23.
//

import Foundation
import Kanna

extension HTMLParser {
    
    //MARK: - GET ANIME INFO
    static func getAnimeInfo(from url: String, completion: @escaping ([AnimeInfo]) -> Void) {
            var animeInfoArr = [AnimeInfo]()
            guard let myUrl = URL(string: url) else { fatalError() }
            let request = URLRequest(url: myUrl)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let _ = error {
                    Alerts.ErrorInURLSessionAlert()
                    return
                }
                
                if let data = data, let dataString = String(data: data, encoding: .windowsCP1251) {
                    if let doc = try? HTML(html: dataString, encoding: .windowsCP1251) {
                        
                        animeInfoArr.append(AnimeInfo(
                            originalTitle: extractOriginalTitle(from: doc),
                            yearOfIssue: extractYearOfIssue(from: doc),
                            genre: extractGenre(from: doc),
                            rating: extractRating(from: doc),
                            ageRating: extractAgeRating(from: doc)))
                        print(animeInfoArr)
                        completion(animeInfoArr)
                    }
                }
            }.resume()
        }
    }

//MARK: - GET Age Rating
func extractAgeRating(from doc: HTMLDocument) -> String {
    if let aniAgeRating = doc.at_css("span.age_rating_all") {
        return aniAgeRating.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
    return ""
}

//MARK: - GET Rating
func extractRating(from doc: HTMLDocument) -> String {
    if let ratingValue = doc.at_xpath("//span[@class='rating_meta']/span/span[2]") {
        return ratingValue.text ?? ""
    }
    return ""
}

//MARK: - GET Original Title
func extractOriginalTitle(from doc: HTMLDocument) -> String {
    if let ratingValue = doc.at_xpath("//span[@class='rating_meta']/span/span[1]") {
        if let text = ratingValue.innerHTML?.trimmingCharacters(in: .whitespacesAndNewlines) {
            if let startIndex = text.range(of: "alternateName\" content=\"")?.upperBound,
               let endIndex = text[startIndex...].range(of: "\"")?.lowerBound {
                let extractedText = text[startIndex..<endIndex]
                return String(extractedText)
            }
        }
    }
    return ""
}

//MARK: - GET Year Of Issue
func extractYearOfIssue(from doc: HTMLDocument) -> String {
    if let desc = doc.at_css("div.under_video_additional")?.content {
        let searchString = "Год выпуска: Аниме"
        if desc.contains(searchString) {
            if let startIndex = desc.range(of: searchString)?.upperBound,
               let endIndex = desc[startIndex...].range(of: ".")?.lowerBound {
                let extractedText = desc[startIndex..<endIndex].replacingOccurrences(of: " ", with: "")
                return extractedText
            }
        } else {
            if let startIndex = desc.range(of: "Годы выпуска: Аниме")?.upperBound,
               let endIndex = desc[startIndex...].range(of: ".")?.lowerBound {
                let extractedText = desc[startIndex..<endIndex].replacingOccurrences(of: " Аниме ", with: " ").trimmingCharacters(in: .whitespacesAndNewlines)
                return extractedText
            }
        }
    }
    return ""
}

//MARK: - GET Genres
func extractGenre(from doc: HTMLDocument) -> String {
    if let desc = doc.at_css("div.under_video_additional")?.content,
       let range = desc.range(of: ".") {
        let textBeforeDot = desc[..<range.lowerBound]
        var formattedText = textBeforeDot.replacingOccurrences(of: "Аниме", with: "").trimmingCharacters(in: .whitespaces)
        formattedText = formattedText.replacingOccurrences(of: "  ", with: " ")
        return formattedText.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    return ""
}

