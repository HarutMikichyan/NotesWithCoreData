//
//  NotesViewController.swift
//  Notes
//
//  Created by Harut Mikichyan on 10/31/19.
//  Copyright © 2019 Harut Mikichyan. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController {
    
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var footerViewBottomConstraint: NSLayoutConstraint!
    
    private var notes = [Note]()
    private var originalFooterViewBottonConstraint: CGFloat = 0.0
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let notesTableView: UITableView = {
        var tv = UITableView(frame: .zero, style: .plain)
            tv.register(UINib(nibName: NotesTableViewCell.id, bundle: nil), forCellReuseIdentifier: NotesTableViewCell.id)
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notes"
        setupSearchController()
        setupNotesTableView()
        fetchData()
        keyboardAddObserver()
    }
    
    //MARK: - Actions
    @IBAction func editNotesButtonTapped(_ sender: UIButton) {
        notesTableView.isEditing = !notesTableView.isEditing
    }
    
    
    @IBAction func addNoteButtonTapped(_ sender: UIButton) {
        let vc = AddNoteViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            footerViewBottomConstraint.constant = -keyboardSize.cgRectValue.height + view.safeAreaInsets.bottom
            UIView.animate(withDuration: 1.0) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        footerViewBottomConstraint.constant = originalFooterViewBottonConstraint
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: - Setup Methods
    private func setupSearchController() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    private func setupNotesTableView() {
        view.addSubview(notesTableView)
        notesTableView.delegate = self
        notesTableView.dataSource = self
        notesTableView.separatorStyle = .none
        notesTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, topPad: 0, bottom: footerView.topAnchor, bottomPad: 0,
                              left: view.leftAnchor, leftPad: 0, right: view.rightAnchor, rightPad: 0,
                              height: 0, width: 0)
    }
    
    private func fetchData() {
        UIApplication.dataManager.getNote { [weak self] (notes) in
            guard let self = self, let notes = notes else { return }
            self.notes = notes
            self.notesTableView.reloadData()
        }
    }
    
    private func keyboardAddObserver() {
        originalFooterViewBottonConstraint = footerViewBottomConstraint.constant
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension NotesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            UIApplication.dataManager.deleteObject(id: notes[indexPath.row].objectID)
            notes.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = TextViewController()
        vc.note = notes[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotesTableViewCell.id, for: indexPath) as! NotesTableViewCell
        cell.noteTitle.text = notes[indexPath.row].name
        return cell
    }
}

extension NotesViewController: AddNoteViewControllerDelegate {
    func getNewNoteData(_ title: String) {
        UIApplication.dataManager.saveNote(title, "") { [weak self] (notes) in
            guard let self = self, let notes = notes else { return }
            self.notes = notes
            self.notesTableView.reloadData()
        }
    }
}

extension NotesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            UIApplication.dataManager.searchNotes(prefixText: searchText) { [weak self] (notes) in
                guard let self = self, let notes = notes else { return }
                self.notes = notes
                self.notesTableView.reloadData()
            }
        } else {
            fetchData()
        }
    }
}
