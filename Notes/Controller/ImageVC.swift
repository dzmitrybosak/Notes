//
//  ImageVC.swift
//  Notes
//
//  Created by Dzmitry Bosak on 7/31/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit

class ImageVC: UIViewController, UIScrollViewDelegate {
    
    //MARK: Properties
    var image: UIImage!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0

        imageView.image = image
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    //MARK: Actions
    @IBAction func CloseButtonPressed(_ sender: UIButton) {
        // Close VC and back to DetailsVC
        dismiss(animated: true, completion: nil)
    }
}
