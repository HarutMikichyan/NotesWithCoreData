//
//  DataManager.swift
//  Notes
//
//  Created by Harut Mikichyan on 11/2/19.
//  Copyright © 2019 Harut Mikichyan. All rights reserved.
//

import CoreData

final class DataManager {
    
    var persistentController: PersistentController
    
    init(persistentController: PersistentController) {
        self.persistentController = persistentController
    }
    
    //MARK: - Public Interface
    func getNote(completion: @escaping ([Note]?) -> Void) {
        completion(featchNote())
    }
    
    func searchNotes(prefixText: String, completion: @escaping ([Note]?) -> Void) {
        completion(featchSearchNote(prefixText))
    }
    
    func deleteObject(id objectID: NSManagedObjectID) {
        deleteObject(objectID)
    }
    
    func saveNote(_ name: String, _ text: String, completion: @escaping ([Note]?) -> Void) {
        saveNote(name, text)
        completion(featchNote())
    }
    
    func saveText(notesID: NSManagedObjectID, info text: String) {
        let context = persistentController.persistentContainer.viewContext
        let note = context.object(with: notesID) as! Note
        note.text = text
        
        persistentController.saveContext(context)
        persistentController.persistentContainer.viewContext.refreshAllObjects()
    }
    
    //MARK: - Private Interface
    private func featchNote() -> [Note]? {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let objects = (try? persistentController.persistentContainer.viewContext.fetch(request))
        return objects
    }
    
    private func featchSearchNote(_ text: String) -> [Note]? {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        request.predicate = NSPredicate(format: "name contains[c] '\(text)'")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let objects = (try? persistentController.persistentContainer.viewContext.fetch(request))
        return objects
    }
    
    private func saveNote(_ name: String, _ text: String) {
        let context = persistentController.persistentContainer.viewContext
        let note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context) as! Note
        note.name = name
        note.text = text
        
        persistentController.saveContext(context)
        persistentController.persistentContainer.viewContext.refreshAllObjects()
    }
    
    private func deleteObject(_ objectID: NSManagedObjectID) {
        let context = persistentController.persistentContainer.viewContext
        
        context.delete(context.object(with: objectID))
        persistentController.saveContext(context)
    }
}
