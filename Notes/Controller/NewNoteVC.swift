//
//  NewNoteVC.swift
//  Notes
//
//  Created by Dzmitry Bosak on 7/10/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit

class NewNoteVC: UIViewController, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: Properties
    
    @IBOutlet weak var newNoteTitle: UITextView!
    @IBOutlet weak var newNoteDetails: UITextView!
    @IBOutlet weak var collectionOfImages: UICollectionView!
    var newNoteImagesNames: [String] = []
    
    var note: Note!
    var images: Images!
    var data = DataInStorage.shared
    var attachmentHandler = AttachmentHandler.sharedAttachmentHandler
    var imageManager = ImageManager.sharedImageManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newNoteTitle.delegate = self
        newNoteDetails.delegate = self
        
        newNoteTitle.text = note?.title
        newNoteDetails.text = note?.details
        
        collectionOfImages.delegate = self
        collectionOfImages.dataSource = self
        
        newNoteImagesNames = imageManager.imagesNames
    }
    
    override func viewWillAppear(_ animated: Bool) {
        newNoteImagesNames = imageManager.imagesNames
        collectionOfImages.reloadData()
    }
    
    // Hide keyboard.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            newNoteTitle.resignFirstResponder()
            newNoteDetails.resignFirstResponder()
            return false
        }
        return true
    }
    
    // MARK: Collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newNoteImagesNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageViewCell else {
            return UICollectionViewCell()
        }
        
        // Configure Cell
        let newNoteImageName = newNoteImagesNames[indexPath.row]
        collectionCell.imageView.image = imageManager.loadImagesNames(imageName: newNoteImageName)
        
        return collectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let collectionCell = collectionOfImages.cellForItem(at: indexPath) as! ImageViewCell
        
        // Remove image from Documents Directory.
        let imageName = newNoteImagesNames[indexPath.row]
        imageManager.deleteFile(imageName: imageName)
        
        // Remove cell.
        let index = newNoteImagesNames.index(of: imageName)
        newNoteImagesNames.remove(at: index!)
        // Remove temp images.
        imageManager.imagesNames.remove(at: index!)
        imageManager.imagesURL.remove(at: index!)
        imageManager.imagesJPG.remove(at: index!)
        
        collectionOfImages.reloadData()
    }
    
    // MARK: Actions
    
    // Save button pressed.
    @IBAction func savePressed(_ sender: Any) {
        
        // Save new note.
        data.saveNote(title: newNoteTitle.text, details: newNoteDetails.text, date: Date(), images: imageManager.imagesNames)
        
        // Print note.
        print("Saved note title: \(newNoteTitle.text)")
        print("Saved note details: \(newNoteDetails.text)")
        print("Saved note images count: \(imageManager.imagesURL.count)")
        
        // Clean the array.
        imageManager.removeAllFromArray()
        
        // Close modal screen.
        dismiss(animated: true, completion: nil)
    }
    
    // Cancel button pressed.
    @IBAction func cancelPressed(_ sender: Any) {
        
        // Clean the array.
        imageManager.removeAllFromArray()
        
        // Close modal screen.
        dismiss(animated: true, completion: nil)
    }
    
    // Attach button pressed.
    @IBAction func attachPressed(_ sender: Any) {
        
        // Alert sheet.
        attachmentHandler.showAttachmentActionSheet(vc: self)
    }
}
