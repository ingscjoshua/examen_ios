//
//  ButtonCell.swift
//  ExameniOS
//
//  Created by Josue Hernandezon 09/11/21.
//

import UIKit

protocol ButtonCellDelegate: class {
  func send()
}

class ButtonCell: UITableViewCell {
  weak var delegate: ButtonCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
  @IBAction func sendAction(_ sender: UIButton) {
    delegate?.send()
  }
}
