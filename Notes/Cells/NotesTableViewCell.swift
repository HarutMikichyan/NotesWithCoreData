//
//  NotesTableViewCell.swift
//  Notes
//
//  Created by Harut Mikichyan on 11/1/19.
//  Copyright © 2019 Harut Mikichyan. All rights reserved.
//

import UIKit

class NotesTableViewCell: UITableViewCell {
    static let id = "NotesTableViewCell"
    
    @IBOutlet weak var noteImageView: UIImageView!
    @IBOutlet weak var noteTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
