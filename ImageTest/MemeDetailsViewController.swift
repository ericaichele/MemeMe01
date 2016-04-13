//
//  MemeDetailsViewController.swift
//  ImageTest
//
//  Created by Eric Aichele on 4/12/16.
//  Copyright © 2016 Eric Aichele. All rights reserved.
//

import UIKit

class MemeDetailsViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var incomingMeme: Meme!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = incomingMeme.memedImage
//        if let memedImage = incomingMeme.memedImage {
//            imageView!.image = memedImage
//        }
    }

}