//
//  VideoQualityTableViewController.swift
//  AniLab
//
//  Created by The WORLD on 12/09/23.
//

import UIKit

class VideoQualityTableViewController: UITableViewController {

    var videoQuality = [VideoQuality]()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("videoQuality - \(videoQuality)")
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
}
