//
//  ContactRequestCell.swift
//  Empower
//
//  Created by Aaron Zhong on 25/06/18.
//  Copyright © 2018 Aaron Zhong. All rights reserved.
//

import UIKit

class ContactRequestCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func declineButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func acceptButtonPressed(_ sender: UIButton) {
    }
    
}
