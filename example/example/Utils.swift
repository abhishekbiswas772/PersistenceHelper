//
//  Utils.swift
//  DataPersistanceDemo
//
//  Created by Abhishek Biswas on 04/12/23.
//

import UIKit

class Utils {
    static func addAlert(withAlertTitle: String, withAlertMsssage: String) -> UIAlertController {
        let alert = UIAlertController(title: withAlertTitle, message: withAlertMsssage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default))
        return alert
    }
}
