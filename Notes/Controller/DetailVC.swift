//
//  NoteVC.swift
//  Notes
//
//  Created by Dzmitry Bosak on 6/18/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit
import CoreData

class DetailVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var titleDetail: UITextView!
    @IBOutlet weak var dateDetail: UILabel!
    @IBOutlet weak var detailsDetail: UITextView!
    @IBOutlet weak var collectionOfImages: UICollectionView!
    var detailsImagesNames: [String]?
    
    var notes: [Note]!
    var note: Note!
    var images: Images!
    var data = DataInStorage.shared
    var attachmentHandler = AttachmentHandler.sharedAttachmentHandler
    var imageManager = ImageManager.sharedImageManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCurrentNote()
        
        collectionOfImages.delegate = self
        collectionOfImages.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCurrentNote()
        collectionOfImages.reloadData()
    }
    
    // Get note.
    func getCurrentNote() {
        titleDetail.text = note?.title
        detailsDetail.text = note?.details
        dateDetail.text = data.dateFormat(date: note.date!)
        detailsImagesNames = note?.images
    }
    
    // Hide keyboard.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: Collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailsImagesNames!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageViewCell else {
            return UICollectionViewCell()
        }
        
        // Configure Cell
        collectionCell.backgroundColor = .black // for testing
        let imageName = detailsImagesNames![indexPath.row]
        collectionCell.imageView.image = imageManager.loadImagesNames(imageName: imageName)
        
        return collectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let collectionCell = collectionOfImages.cellForItem(at: indexPath) as! ImageViewCell
        self.imageTapped(image: collectionCell.imageView.image!)
    }
    
    //MARK: Actions
    
    // Edit button pressed.
    @IBAction func editPressed(_ sender: Any) {
        
        // Go to Edit screen.
        performSegue(withIdentifier: "EditVC", sender: self)
    }
    
    // Delete button pressed.
    @IBAction func deletePressed(_ sender: Any) {
        
        // Create alert controller.
        let alert = UIAlertController(title: "Delete note?", message: "This note will be deleted. This action cannot be undone.", preferredStyle: .alert)
        
        // Define actions.
        let actionYes = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            // Delete note.
            self.data.deleteNote(note: self.note)
            
            // Delete images from Documents Directory
            self.imageManager.deleteImages(imagesNames: self.detailsImagesNames!)
            
            // Switching to NotesVC.
            self.performSegue(withIdentifier: "unwindSegueToNotesVC", sender: self)
            }
        
        let actionNo = UIAlertAction(title: "Cancel", style: .cancel)
        
        // Add buttons to alert window.
        alert.addAction(actionYes)
        alert.addAction(actionNo)
        
        // Show alert window.
        self.present(alert, animated: true, completion: nil)
    }
    
    // Tap on image.
    func imageTapped(image: UIImage) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyBoard.instantiateViewController(withIdentifier: "ImageVC") as! ImageVC
        
        newVC.image = image
        
        self.present(newVC, animated: true, completion: nil)
        
        /*if let imageVC = UIViewController() as? ImageVC {
            imageVC.image = image
            present(imageVC, animated: true, completion: nil)
            //navigationController?.pushViewController(imageVC, animated: true)
        }*/
    }
    
    /*
    func imageTapped(image: UIImage) {
        let newImageView = UIImageView(frame: UIScreen.main.bounds)
        newImageView.image = image
        newImageView.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.9)
        newImageView.contentMode = .scaleToFill
        newImageView.isUserInteractionEnabled = true
        view.addSubview(newImageView)
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        let aSelector: Selector = #selector(dismissFullScreenImage(_:))
        let tap = UITapGestureRecognizer(target: self, action: aSelector)
        tap.delegate = self
        
        newImageView.addGestureRecognizer(tap)
    }
    
    @objc func dismissFullScreenImage(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
        navigationController?.setNavigationBarHidden(false, animated: true)
        print("Fullscreen image dismissed")
    }*/
    
    // Passing data between View Controllers.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EditVC {
            
            // Note displayed on EditVC.
            destination.note = note
        }
    }
}
