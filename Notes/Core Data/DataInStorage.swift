//
//  Date.swift
//  Notes
//
//  Created by Dzmitry Bosak on 6/21/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class DataInStorage {
    
    // Singleton
    static let shared = DataInStorage()
    
    //MARK: Properties
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var notes: [Note]!
    
    // Save note.
    func saveNote(title: String, details: String, date: Date, images: [String]) {
        
        let entity = NSEntityDescription.entity(forEntityName: "Note", in: managedContext)!
        let note = NSManagedObject(entity: entity, insertInto: managedContext)
        
        // Set values for keys in data model.
        note.setValue(title, forKey: "title")
        note.setValue(details, forKey: "details")
        note.setValue(Date(), forKey: "date")
        note.setValue(images, forKey: "images")
        
        // Save new note.
        do {
            try managedContext.save()
            notes.append(note as! Note)
        } catch let error as NSError {
            print("Could not save note. \(error), \(error.userInfo)")
        }
        print("New Note Saved : \(title) -- \(date) -- \(details) -- \(images.count)")
    }
    
    // Get all notes.
    func getAll() -> [Note] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Note")
        
        // Sort by date.
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Fetch notes.
        do {
            notes = try managedContext.fetch(fetchRequest) as! [Note]
            print("The list of notes in storage: \(notes)")
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return notes
    }
    
    // Convert date.
    func dateFormat(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy hh:mm"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    // Delete note.
    func deleteNote(note: Note) {
        
        // Delete selected note.
        managedContext.delete(note)
        
        do {
            try managedContext.save()
            print("Saved.")
        } catch let error as NSError {
            print("Could not save note. \(error), \(error.userInfo)")
        }
        
    }
    
    // Save edited note.
    func editNote(note: Note, titleView: UITextView, detailsView: UITextView, images: [String]) {
        
        // Update selected note.
        note.title = titleView.text
        note.details = detailsView.text
        note.date = Date()
        note.images = images
        
        do {
            try managedContext.save()
            print("Saved.")
        } catch let error as NSError {
            print("Could not save note. \(error), \(error.userInfo)")
        }
    }
    
}
