//
//  Alerts.swift
//  AniLab
//
//  Created by The WORLD on 13/09/23.
//

import UIKit

class Alerts {
    
    // MARK: - Alert for animes which ACCESS IS DANIED
    static func AccessDeniedAlertOrNoData(title: String, message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { alertAction in
            viewController.navigationController?.popViewController(animated: true)
        }
        alert.addAction(OKAction)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Alert for animes when Internet not ON
    static func ErrorInURLSessionAlert() {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Ошибка", message: "Произошла ошибка при загрузке данных включите интернет или перезагрузите приложение", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
}
