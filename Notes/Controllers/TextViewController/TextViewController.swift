//
//  TextViewController.swift
//  Notes
//
//  Created by Harut Mikichyan on 11/1/19.
//  Copyright © 2019 Harut Mikichyan. All rights reserved.
//

import UIKit

class TextViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    weak var note: Note?
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        title = note!.name
        textView.text = note!.text
        textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.dataManager.saveText(notesID: note!.objectID, info: textView.text)
    }
}
