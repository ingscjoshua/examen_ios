//
//  NameCell.swift
//  ExameniOS
//
//  Created by Josue Hernandezon 09/11/21.
//

import UIKit

protocol NameCellDelegate: class {
  func getName(name: String)
}

class NameCell: UITableViewCell {
  @IBOutlet weak var textField: UITextField!
  weak var delegate: NameCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    textField.delegate = self
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func bindWithName(){
    
  }
  
}

extension NameCell: UITextFieldDelegate {
  func textFieldDidEndEditing(_ textField: UITextField) {
    guard let text = textField.text else {return}
    delegate?.getName(name: text)
  }
  
  func getText(text: String?) -> String{
    guard let value = text else {return ""}
    return value
  }
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    delegate?.getName(name: getText(text: textField.text))
    textField.resignFirstResponder()
    return true
  }
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    do {
      let regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
      if regex.firstMatch(in: string, options: [], range: NSMakeRange(0, string.count)) != nil {
        return false
      }
    }
    catch {
      print("Regex error")
    }
    return true
  }

}
