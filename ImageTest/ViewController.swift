//
//  ViewController.swift
//  ImageTest
//
//  Created by Eric Aichele on 4/6/16.
//  Copyright © 2016 Eric Aichele. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolBarTop: UIToolbar!
    @IBOutlet weak var toolBarBottom: UIToolbar!
    
    
    var memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "Impact", size: 40)!,
        NSStrokeWidthAttributeName : -5.0,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // DELEGATES
        self.topText.delegate = self
        self.bottomText.delegate = self
        
        // PROPERTIES
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        topText.text = "TOP"
        topText.textAlignment = NSTextAlignment.Center
        bottomText.text = "BOTTOM"
        bottomText.textAlignment = NSTextAlignment.Center        
        shareButton.enabled = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    // PLACING THE IMAGE INTO UIIMAGE
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        shareButton.enabled = true
    }

    // IMAGE PICKING ACTIONS
    @IBAction func pickAnImage(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickImageFromCamera(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    // MOVE UI TO FIT KEYBOARD
    func keyboardWillShow(notification: NSNotification) {
        if bottomText.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomText.isFirstResponder() {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    // RETURN BUTTON CLOSES KEYBOARD AND DEACTIVATES TEXT FIELD
    func textFieldShouldReturn(textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    // CLICKING TEXT FIELD CLEARS TEXT
    func textFieldDidBeginEditing(textField: UITextField) {
        let textTest = textField.text
        if textTest == "TOP" || textTest == "BOTTOM" {
            textField.text = ""
        }
    }
    
    // MEME CREATION
    func save(memedImage: UIImage) {
        //Create the Meme
        _ = Meme( textTop: topText.text!, textBottom: bottomText.text!, originalImage: imageView.image!, memedImage: memedImage)
    }
    
    func generateMemedImage() -> UIImage {
        // TO DO: Hide Toolbar and Navbar
        UIApplication.sharedApplication().statusBarHidden = true
        self.toolBarTop.hidden = true
        self.toolBarBottom.hidden = true
        
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // TO DO: Show Toolbar and Navbar
        UIApplication.sharedApplication().statusBarHidden = false
        self.toolBarTop.hidden = false
        self.toolBarBottom.hidden = false
        
        return memedImage
    }
    
    @IBAction func shareButtonPressed(sender: AnyObject) {
        let memedImage = self.generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: nil)
        
        activityViewController.completionWithItemsHandler = {
            (activity: String?, completed: Bool, items: [AnyObject]?, error: NSError?) -> Void in
            if completed {
                self.save(memedImage)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    
    @IBAction func changeFonts(sender: AnyObject) {
        // SETUP ACTION SHEET
        let optionMenu = UIAlertController(title: nil, message: "Choose a New Fonts", preferredStyle: .ActionSheet)
        let changeHelvetica = UIAlertAction(title: "Helvetica Bold", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.memeTextAttributes[NSFontAttributeName] = UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)
            print("CHANGE TO HELVETICA!")
            self.topText.defaultTextAttributes = self.memeTextAttributes
            self.bottomText.defaultTextAttributes = self.memeTextAttributes
            self.topText.textAlignment = NSTextAlignment.Center
            self.bottomText.textAlignment = NSTextAlignment.Center

        })
        let changeOptima = UIAlertAction(title: "Optima", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.memeTextAttributes[NSFontAttributeName] = UIFont(name: "OptimaRegular", size: 40)
            print("CHANGE TO OPTIMA!")
            self.topText.defaultTextAttributes = self.memeTextAttributes
            self.bottomText.defaultTextAttributes = self.memeTextAttributes
            self.topText.textAlignment = NSTextAlignment.Center
            self.bottomText.textAlignment = NSTextAlignment.Center
        })
        let changeImpact = UIAlertAction(title: "Impact", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.memeTextAttributes[NSFontAttributeName] = UIFont(name: "Impact", size: 40)
            print("CHANGE TO IMPACT!")
            self.topText.defaultTextAttributes = self.memeTextAttributes
            self.bottomText.defaultTextAttributes = self.memeTextAttributes
            self.topText.textAlignment = NSTextAlignment.Center
            self.bottomText.textAlignment = NSTextAlignment.Center
        })
        
        // POPULATE ACTION SHEET
        optionMenu.addAction(changeHelvetica)
        optionMenu.addAction(changeOptima)
        optionMenu.addAction(changeImpact)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    
}

