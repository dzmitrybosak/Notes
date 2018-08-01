//
//  EditVC.swift
//  Notes
//
//  Created by Dzmitry Bosak on 7/9/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit

class EditVC: UIViewController, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    //MARK: Properties
    @IBOutlet weak var titleEdit: UITextView!
    @IBOutlet weak var detailsEdit: UITextView!
    @IBOutlet weak var collectionOfImages: UICollectionView!
    var editImagesNames: [String]?
    
    var note: Note!
    var images: Images!
    var data = DataInStorage.shared
    var attachmentHandler = AttachmentHandler.sharedAttachmentHandler
    var imageManager = ImageManager.sharedImageManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleEdit.delegate = self
        detailsEdit.delegate = self
        
        titleEdit.text = note?.title
        detailsEdit.text = note?.details
        
        collectionOfImages.delegate = self
        collectionOfImages.dataSource = self
        
        editImagesNames = note?.images
    }
    
    override func viewWillAppear(_ animated: Bool) {
        editImagesNames = (note?.images)! + imageManager.imagesNames
        collectionOfImages.reloadData()
    }

    // Hide keyboard.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            titleEdit.resignFirstResponder()
            detailsEdit.resignFirstResponder()
            return false
        }
        return true
    }
    
    // MARK: Collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return editImagesNames!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageViewCell else {
            return UICollectionViewCell()
        }
        
        // Configure Cell
        collectionCell.backgroundColor = .black // for testing
        let imageName = editImagesNames![indexPath.row]
        collectionCell.imageView.image = imageManager.loadImagesNames(imageName: imageName)
        
        return collectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Create alert controller.
        let alert = UIAlertController(title: "Delete image?", message: "This image will be deleted. This action cannot be undone.", preferredStyle: .alert)
        
        // Define actions.
        let actionYes = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            
            let imageName = self.editImagesNames![indexPath.row]
            let indexEditImagesNames = self.editImagesNames?.index(of: imageName)
            let indexImageManager = self.imageManager.imagesNames.index(of: imageName)
            
            if indexImageManager == nil {
                // Remove images.
                self.editImagesNames?.remove(at: indexEditImagesNames!)
                self.imageManager.deleteFile(imageName: imageName)
            } else {
                // Remove temp images.
                self.imageManager.imagesNames.remove(at: indexImageManager!)
                self.imageManager.imagesURL.remove(at: indexImageManager!)
                self.imageManager.imagesJPG.remove(at: indexImageManager!)
                self.editImagesNames?.remove(at: indexEditImagesNames!)
            }
            
            // Remove image from Documents Directory.
            self.imageManager.deleteFile(imageName: imageName)
            
            self.imageManager.removeAllFromArray()
            
            // Save.
            self.data.editNote(note: self.note, titleView: self.titleEdit, detailsView: self.detailsEdit, images: self.editImagesNames!)
            
            self.collectionOfImages.reloadData()
        }
        
        let actionNo = UIAlertAction(title: "Cancel", style: .cancel)
        
        // Add buttons to alert window.
        alert.addAction(actionYes)
        alert.addAction(actionNo)
        
        // Show alert window.
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Actions
    
    // Save button pressed.
    @IBAction func savePressed(_ sender: Any) {
        
        // Save edited note and close modal screen.
        data.editNote(note: note, titleView: titleEdit, detailsView: detailsEdit, images: (note?.images)! + imageManager.imagesNames)
        
        // Clean the array.
        imageManager.removeAllFromArray()
        
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
