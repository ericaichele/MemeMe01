//
//  ViewController.swift
//  ImageTest
//
//  Created by Eric Aichele on 4/6/16.
//  Copyright © 2016 Eric Aichele. All rights reserved.
//

import UIKit

class MakeMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolBarTop: UIToolbar!
    @IBOutlet weak var toolBarBottom: UIToolbar!
    @IBOutlet weak var introText: UILabel!
    
    
    var memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "Impact", size: 40)!,
        NSStrokeWidthAttributeName : -5.0,
    ]
    
    func formattingBlock(textBlock: UITextField, fieldName: String) {
        textBlock.defaultTextAttributes = memeTextAttributes
        textBlock.textAlignment = NSTextAlignment.Center
        textBlock.text = "\(fieldName)"
    }
    
    var meme: Meme! //???? Maybe?
    //var originalImage: UIImage!
    //var memedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // DELEGATES
        self.topText.delegate = self
        self.bottomText.delegate = self
        
        // PROPERTIES
        view.backgroundColor = UIColor.grayColor()
        formattingBlock(topText, fieldName: "TOP")
        formattingBlock(bottomText, fieldName: "BOTTOM")
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
    
    override func prefersStatusBarHidden() -> Bool {
        return true     // status bar should be hidden
    }
    
    // IMAGE PICKER SOURCE
    func pickingImages(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // PLACING THE IMAGE INTO UIIMAGE
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        shareButton.enabled = true
        introText.hidden = true
    }
    
    // IMAGE PICKING ACTIONS
    @IBAction func pickAnImage(sender: AnyObject) {
        pickingImages(.PhotoLibrary)
    }
    
    @IBAction func pickImageFromCamera(sender: AnyObject) {
        pickingImages(.Camera)
        
    }
    
    // MOVE UI TO FIT KEYBOARD
    func keyboardWillShow(notification: NSNotification) {
        if bottomText.isFirstResponder() {
            self.view.frame.origin.y = getKeyboardHeight(notification) * -1
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomText.isFirstResponder() {
            self.view.frame.origin.y = 0
        }
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MakeMemeViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MakeMemeViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
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
        let meme = Meme(textTop: topText.text!, textBottom: bottomText.text!, originalImage: imageView.image!, memedImage: memedImage)
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        // TO DO: Hide Toolbar and Navbar
        UIApplication.sharedApplication().statusBarHidden = true
        toolBarTop.hidden = true
        toolBarBottom.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // TO DO: Show Toolbar and Navbar
        UIApplication.sharedApplication().statusBarHidden = false
        toolBarTop.hidden = false
        toolBarBottom.hidden = false
        
        return memedImage
    }
    
    // SHARE BUTTON SETUP
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
    
    @IBAction func closeMakeMeme(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // ACTION SHEET / FONT SETUP
    @IBAction func changeFonts(sender: AnyObject) {
        // SETUP ACTION SHEET
        let optionMenu = UIAlertController(title: nil, message: "Choose a New Fonts", preferredStyle: .ActionSheet)
        let changeHelvetica = UIAlertAction(title: "Helvetica Bold", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.memeTextAttributes[NSFontAttributeName] = UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)
            self.formattingBlock(self.topText, fieldName: "TOP")
            self.formattingBlock(self.bottomText, fieldName: "BOTTOM")
            print("\(self.memeTextAttributes[NSFontAttributeName])")

        })
        let changeOptima = UIAlertAction(title: "Optima", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.memeTextAttributes[NSFontAttributeName] = UIFont(name: "Optima-Regular", size: 40)
            self.formattingBlock(self.topText, fieldName: "TOP")
            self.formattingBlock(self.bottomText, fieldName: "BOTTOM")
            print("\(self.memeTextAttributes[NSFontAttributeName])")
        })
        let changeImpact = UIAlertAction(title: "Impact", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.memeTextAttributes[NSFontAttributeName] = UIFont(name: "Impact", size: 40)
            self.formattingBlock(self.topText, fieldName: "TOP")
            self.formattingBlock(self.bottomText, fieldName: "BOTTOM")
            print("\(self.memeTextAttributes[NSFontAttributeName])")
        })
        
        // POPULATE ACTION SHEET
        optionMenu.addAction(changeHelvetica)
        optionMenu.addAction(changeOptima)
        optionMenu.addAction(changeImpact)
        
        presentViewController(optionMenu, animated: true, completion: nil)
    }
}

