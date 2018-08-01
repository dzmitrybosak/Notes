//
//  AttachmentHandler.swift
//  Notes
//
//  Created by Dzmitry Bosak on 7/11/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import Foundation
import UIKit
import Photos

class AttachmentHandler: NSObject {
    
    // MARK: Properties
    static let sharedAttachmentHandler = AttachmentHandler()
    
    var currentVC: UIViewController!
    
    let pickerController = UIImagePickerController()
    
    var images: Images?
    
    var image: UIImage?
    
    var imageManager = ImageManager.sharedImageManager
    
    // MARK: Show attachment action sheet.
    func showAttachmentActionSheet(vc: UIViewController) {
        
        currentVC = vc
        
        // Create alert controller.
        let actionSheet = UIAlertController(title: "Add image", message: nil, preferredStyle: .actionSheet)
        
        // Add actions.
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { action in
            self.openCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler:  { action in
            self.photoLibrary()
        }))
        
        // Add cancel button.
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Show alert sheet.
        vc.present(actionSheet, animated: true)
    }
    
    // MARK: Camera Picker.
    // This function is used to open camera
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            pickerController.delegate = self
            pickerController.sourceType = .camera
            currentVC?.present(pickerController, animated: true, completion: nil)
        }
    }
    
    // MARK: Photo Picker.
    // Photo from library
    func photoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary
            currentVC?.present(pickerController, animated: true, completion: nil)
        }
    }
}

// MARK: Image Picker delegate.
// This is responsible for image picker interface to access image and then responsible for canceling the picker.
extension AttachmentHandler: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Get picture.
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickerImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image = pickerImage
            print("That's my image.")
            imageManager.saveImageInDirectory(image: image!)
        } else{
            print("Something went wrong.")
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // Close Image Picker Controller.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Canceled.")
        currentVC?.dismiss(animated: true, completion: nil)
    }
}
