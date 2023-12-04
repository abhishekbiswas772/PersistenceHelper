//
//  UserAllTableViewCell.swift
//  DataPersistanceDemo
//
//  Created by Abhishek Biswas on 04/12/23.
//

import UIKit

class UserAllTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    static let cellId = "UserAllTableViewCell"
    static func nib() -> UINib{
        return UINib(nibName: "UserAllTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
