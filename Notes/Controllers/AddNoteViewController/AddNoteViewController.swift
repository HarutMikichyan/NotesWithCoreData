//
//  AddNoteViewController.swift
//  Notes
//
//  Created by Harut Mikichyan on 11/1/19.
//  Copyright © 2019 Harut Mikichyan. All rights reserved.
//

import UIKit

protocol AddNoteViewControllerDelegate: class {
    func getNewNoteData(_ title: String)
}

class AddNoteViewController: UIViewController {
    
    @IBOutlet weak var noteImageView: UIImageView!
    @IBOutlet weak var noteTitleTextField: UITextField!
    
    weak var delegate: AddNoteViewControllerDelegate?
    
    override func viewDidLoad() {
        noteTitleTextField.attributedPlaceholder = NSAttributedString(string: "Note Title", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    //MARK: - Actions
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        if noteTitleTextField.text == "" {
            noteTitleTextField.layer.borderWidth = 2
            noteTitleTextField.layer.borderColor = UIColor.red.cgColor
        } else {
            delegate?.getNewNoteData(noteTitleTextField.text!)
            dismiss(animated: true, completion: nil)
        }
    }
}
