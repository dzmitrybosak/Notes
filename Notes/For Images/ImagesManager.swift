//
//  ImagesManager.swift
//  Notes
//
//  Created by Dzmitry Bosak on 7/17/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import Foundation
import UIKit

class ImageManager {
    
    static let sharedImageManager = ImageManager()
    
    var note: Note!
    var images: Images?
    
    var imagesURL: [URL] = []
    var imagesJPG: [UIImage] = []
    var imagesNames: [String] = []
    
    let fileManager = FileManager.default
    
    // Image name is current date.
    func dateName() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'_'HH_mm_ss"
        let imageName = "\(dateFormatter.string(from: date)).jpg"
        return imageName
    }
    
    // Save image in Documents Directory and append to new array.
    func saveImageInDirectory(image: UIImage) {
        
        let path = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let imageName = dateName()
        let newPath = path.appendingPathComponent(imageName)
        let jpgImageData = UIImageJPEGRepresentation(image, 1.0)
        
        do {
            try jpgImageData!.write(to: newPath)
            print("Image saved in path: \(newPath)")
            imagesURL.append(newPath)
            print("Counts of images URLs in array imagesURL: \(imagesURL.count)")
        } catch {
            print(error)
        }
        
        // Add image to array of JPGs
        imagesJPG.append(image)
        print("Counts of images in array imagesJPG: \(imagesJPG.count)")
        
        // Add image name to array of names
        imagesNames.append("\(imageName)")
        print("Images names -- imagesNames: \(imagesNames)")
    }
    
    // Load images from Documents Directory by names.
    func loadImagesNames(imageName: String) -> UIImage? {
        if let fileURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(imageName) {
            var imageData: Data?
            do {
                imageData = try Data(contentsOf: fileURL)
            } catch {
                print(error)
                return nil
            }
            guard let dataOfImage = imageData else { return nil }
            guard let image = UIImage(data: dataOfImage) else { return nil }
            return image
        }
        return nil
    }
    
    // Remove images names from array.
    func removeAllFromArray() {
        imagesNames.removeAll()
    }
    
    // Delete one file from Documents Directory.
    func deleteFile(imageName: String) {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        guard let dirPath = path.first else {
            return
        }
        let filePath = "\(dirPath)/\(imageName)"
        do {
            try fileManager.removeItem(atPath: filePath)
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    // Delete array of images from Documents Directory.
    func deleteImages(imagesNames: [String]) {
        for image in imagesNames {
            do {
                try fileManager.removeItem(atPath: image)
            } catch {
                print(error)
            }
        }
    }
    
    // Show all files from Documents Directory.
    func readFiles() -> [String] {
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].path
        return try! fileManager.contentsOfDirectory(atPath: documentsURL)
    }
}
