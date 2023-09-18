//
//  EpisodesTableViewController.swift
//  AniLab
//
//  Created by The WORLD on 12/09/23.
//

import UIKit

class EpisodesTableViewController: UITableViewController {

    var AnimeEpisodes = [Episodes]()
    var animeVideoQualities = [VideoQuality]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AnimeEpisodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EpisodeTableViewCell
        cell.title.text = AnimeEpisodes[indexPath.row].title
        cell.link.text = AnimeEpisodes[indexPath.row].link
        return cell
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episodelink = "https://jut.su\(AnimeEpisodes[indexPath.row].link)"
        HTMLParser.getVideoQuality(from: episodelink) { videoQualities in
            self.animeVideoQualities = videoQualities
            DispatchQueue.main.async {
                let VideoQualityVC = self.storyboard?.instantiateViewController(withIdentifier: "VideoQualityVC") as! VideoQualityTableViewController
                VideoQualityVC.videoQuality = self.animeVideoQualities
                self.navigationController?.pushViewController(VideoQualityVC, animated: true)
            }
        }
    }

}
