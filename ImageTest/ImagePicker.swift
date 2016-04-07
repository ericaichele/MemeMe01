//
//  ImagePicker.swift
//  ImageTest
//
//  Created by Eric Aichele on 4/7/16.
//  Copyright © 2016 Eric Aichele. All rights reserved.
//

import Foundation
import UIKit

class ImagePicker: UIViewController, UIImagePickerControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    func pickerSource(inputName: String) {
        if inputName == "camera" {
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        } else if inputName == "album" {
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
    }
}