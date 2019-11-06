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
        keyboardAddObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
        UIApplication.dataManager.saveText(notesID: note!.objectID, info: textView.text)
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Notification Center Methods
    private func keyboardAddObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func updateTextView(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardEndFrameScreenCoordinates = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardEndFrame = self.view.convert(keyboardEndFrameScreenCoordinates, to: view.window)
        
        let isEqual = notification.name == UIResponder.keyboardWillHideNotification
        textView.contentInset = isEqual ? UIEdgeInsets.zero : UIEdgeInsets(top: 0, left: 0, bottom: keyboardEndFrame.height, right: 0)
        if isEqual { textView.scrollIndicatorInsets = textView.contentInset }
        textView.scrollRangeToVisible(textView.selectedRange)
    }
}
