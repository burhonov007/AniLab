//
//  Alerts.swift
//  AniLab
//
//  Created by The WORLD on 13/09/23.
//

import UIKit

class Alerts {
    
    // MARK: - Alert for animes which ACCESS IS DANIED
    static func AccessDeniedAlert(title: String, message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { alertAction in
            viewController.navigationController?.popViewController(animated: true)
        }
        alert.addAction(OKAction)
        viewController.present(alert, animated: true, completion: nil)
    }
}
