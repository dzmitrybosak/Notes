//
//  ViewController.swift
//  Notes
//
//  Created by Dzmitry Bosak on 6/18/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit
import CoreData

class NotesVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    var note: Note!
    var notes: [Note]!
    
    var data = DataInStorage.shared
    var imageManager = ImageManager.sharedImageManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Get all data.
        notes = data.getAll()
        tableView.reloadData()
        
        // Print contains of Documents Directory
        print("\(imageManager.readFiles())")
    }
    
    //MARK: Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let noteCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? NoteViewCell else {
            return UITableViewCell()
        }
        
        // Fetches the appropriate notes for the data source layout.
        let capitalToDisplay = notes[indexPath.row]
        noteCell.note = capitalToDisplay
        
        return noteCell
    }
    
    //MARK: Actions
    
    // Add button pressed.
    @IBAction func addNote(_ sender: Any) {
        
        performSegue(withIdentifier: "NewNoteVC", sender: self)
    }
    
    // MARK: Actions with segues.
    
    // Passing data between View Controllers.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailVC {
            let index = tableView.indexPathForSelectedRow?.row
            if index != nil {
                
                // Print note.
                print("Selected note title: \(notes[index!].title)")
                print("Selected note details: \(notes[index!].details)")
                print("Selected note date: \(notes[index!].date)")
                
                // Note displayed on another screen.
                destination.note = notes[index!]
            }
        }
    }
    
    // Back to NotesVC.
    @IBAction func unwindtoNotesVC(segue: UIStoryboardSegue) { }

}
