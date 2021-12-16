//
//  UIViewController+Action.swift
//  ExameniOS
//
//  Created by Josue Hernandezon 09/11/21.
//

import UIKit
import NVActivityIndicatorView

extension UIViewController {

  func displayAlert(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
    alertController.addAction(defaultAction)
    self.present(alertController, animated: true, completion: nil)
  }

  func activityIndicator(height:Int?)-> NVActivityIndicatorView {
    let screen = UIScreen.main.bounds
    let x = screen.width / 2 - 30
    let y = screen.height / 2 - 30
    let frame = CGRect(x: x, y: y, width: 60, height: 60)
    let activityIndicator = NVActivityIndicatorView(frame: frame, type: .ballClipRotatePulse, color: #colorLiteral(red: 0.9803921569, green: 0.2705882353, blue: 0.3058823529, alpha: 1), padding: 2)
    return activityIndicator
  }
  
}
