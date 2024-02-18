//
//  AlertHelper.swift
//  ImageFeed
//
//  Created by Dosh on 18.02.2024.
//

import Foundation
import UIKit

protocol AlertHelperProtocol {
    func createLogoutAlert(confirmAction: @escaping () -> Void) -> UIAlertController
}

class AlertHelper: AlertHelperProtocol {
    func createLogoutAlert(confirmAction: @escaping () -> Void) -> UIAlertController {
        let alert = UIAlertController(title: "Пока, пока!", message: "Уверены что хотите выйти?", preferredStyle: .alert)

        let logoutAction = UIAlertAction(title: "Да", style: .destructive) { _ in
            confirmAction()
        }
        alert.addAction(logoutAction)

        let cancelAction = UIAlertAction(title: "Нет", style: .cancel)
        alert.addAction(cancelAction)

        return alert
    }
}
