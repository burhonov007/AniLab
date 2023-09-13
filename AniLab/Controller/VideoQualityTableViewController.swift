//
//  VideoQualityTableViewController.swift
//  AniLab
//
//  Created by The WORLD on 12/09/23.
//

import UIKit
import AVKit


class VideoQualityTableViewController: UITableViewController {

    var videoQuality = [VideoQuality]()
    override func viewDidLoad() {
        super.viewDidLoad()
        if videoQuality.isEmpty {
            Alerts.AccessDeniedAlert(title: "Запрещено", message: "К сожалению, в вашей стране это видео недоступно.", viewController: self)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoQuality.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! VideoQualityTableViewCell
        cell.title.text = videoQuality[indexPath.row].title
        cell.link.text = videoQuality[indexPath.row].link
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let videoURL = URL(string: videoQuality[indexPath.row].link)
       
        
        let videoURL = URL(string: "https://tengrinews.kz/userdata/news/2023/news_510042/photo_443335.mp4")
   
        
        
        
        print(videoURL)
        
        var request = URLRequest(url: videoURL!)
        
        let userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.0.0 Safari/537.36 OPR/100.0.0.0"
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
           
        let player = AVPlayer(url: request.url!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player

        present(playerViewController, animated: true) {
            player.play()
        }
    }
}

