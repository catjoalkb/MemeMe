//
//  CreateMemeImageViewController.swift
//  MemeMe
//
//  Created by wctjerry on 16/6/14.
//  Copyright © 2016年 wctjerry. All rights reserved.
//

import UIKit

class CreateMemeImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var BottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    
    // MARK:- Setup outlook
    override func viewDidLoad() {
        super.viewDidLoad()
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3.0
        ]
        
        setupTextField(topTextField, text: "TOP", defaultTextAttributes: memeTextAttributes, textAlignment: .Center)
        setupTextField(BottomTextField, text: "BOTTOM", defaultTextAttributes: memeTextAttributes, textAlignment: .Center)
        
        shareButton.enabled = false
    }
    
    // Setup textField
    func setupTextField(textField: UITextField, text: String, defaultTextAttributes: [String: AnyObject], textAlignment: NSTextAlignment) {
        textField.text = text
        textField.defaultTextAttributes = defaultTextAttributes
        textField.textAlignment = textAlignment
        textField.delegate = self
    }
    
    // Hide the status bar programatically
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    // MARK:- Subscribe and unsubscribe notifications
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) // disable camera if unavailable
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreateMemeImageViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreateMemeImageViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    // MARK:- Present view when click album or camera
    @IBAction func chooseAnImageFromAlbum(sender: UIBarButtonItem) {
        chooseAnImage(.SavedPhotosAlbum)
    }
    
    @IBAction func chooseAnImageFromCamera(sender: UIBarButtonItem) {
        chooseAnImage(.Camera)
    }
    
    func chooseAnImage(sourceType: UIImagePickerControllerSourceType) {
        let chooseController = UIImagePickerController()
        chooseController.delegate = self
        chooseController.sourceType = sourceType
        presentViewController(chooseController, animated: true, completion: nil)
    }
    
    // MARK:- Show image in UIImage
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            dismissViewControllerAnimated(true, completion: nil)
            
            // enable share button
            shareButton.enabled = true
        }
    }
    
    
    // MARK:- Edit text
    @IBAction func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Move view upward when keyboard appears
    func keyboardWillShow(notification: NSNotification) {
        if BottomTextField.editing {
            view.frame.origin.y = -getKeyboardHeight(notification) // assign negative height value here instead of compound operator like -=, mainly to avoid bugs. See: https://discussions.udacity.com/t/mememe-v1-bottom-text/168178/2
        }
    }
    
    // Move view downward when keyboard disappears
    func keyboardWillHide(notification: NSNotification) {
        if BottomTextField.isFirstResponder() { // another way to shift on the bottom view
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    
    // MARK:- Save image

    
    func save() {
        //Create the meme
        
        let meme = Meme(topText: self.topTextField.text!, bottomText: self.BottomTextField.text!, image:
            imagePickerView.image!, memedImage: generateMemedImage())
        
        // Add it to meme Arrays
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)

    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        navBar.hidden = true
        toolBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
                                     afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        navBar.hidden = false
        toolBar.hidden = false
        
        return memedImage
    }
    
    
    // MARK:- Share image
    @IBAction func shareImage(sender: AnyObject) {
        let meme = generateMemedImage()
        let shareActivityViewController = UIActivityViewController(activityItems: [meme], applicationActivities: nil)
        
        shareActivityViewController.completionWithItemsHandler = {(activity, completed, items, error) in
            print("Activity: \(activity)\nCompleted: \(completed)\nItems: \(items)\nError: \(error)")
            if (completed) {
                self.save()
            }
        }
        
        presentViewController(shareActivityViewController, animated: true, completion: nil)
    }

    @IBAction func dismissVC(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

