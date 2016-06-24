//
//  ViewController.swift
//  MemeMe
//
//  Created by wctjerry on 16/6/14.
//  Copyright © 2016年 wctjerry. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var BottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : 2.4
        ]
        
        topTextField.text = "TOP"
        BottomTextField.text = "BOTTOM"
        topTextField.textAlignment = .Center
        BottomTextField.textAlignment = .Center
        topTextField.defaultTextAttributes = memeTextAttributes
        BottomTextField.defaultTextAttributes = memeTextAttributes
        self.BottomTextField.delegate = self
        self.topTextField.delegate = self
        
        shareButton.enabled = false
    }
    
    // Hide the status bar programatically
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        self.view.frame.origin.y = 0
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }

    @IBAction func chooseAnImageFromAlbum(sender: UIBarButtonItem) {
        let chooseController = UIImagePickerController()
        chooseController.delegate = self
        chooseController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(chooseController, animated: true, completion: nil)
    }
    
    @IBAction func chooseAnImageFromCamera(sender: UIBarButtonItem) {
        let chooseController = UIImagePickerController()
        chooseController.delegate = self
        chooseController.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(chooseController, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            dismissViewControllerAnimated(true, completion: nil)
            
            // enable share button
            shareButton.enabled = true
        }
    }
    
    @IBAction func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // Move view upward when keyboard appears
    func keyboardWillShow(notification: NSNotification) {
        if self.BottomTextField.editing {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    // Move view downward when keyboard disappears
    func keyboardWillHide(notification: NSNotification) {
        if self.BottomTextField.isFirstResponder() { // another way to shift on the bottom view
            self.view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    struct Meme {
        let topText: String
        let bottomText: String
        let image: UIImage
        let memedImage: UIImage
    }
    
    func save() {
        //Create the meme
        
        let meme = Meme(topText: self.topTextField.text!, bottomText: self.BottomTextField.text!, image:
            imagePickerView.image!, memedImage: generateMemedImage())

    }
    
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
        navBar.hidden = true
        toolBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
                                     afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // TODO:  Show toolbar and navbar       
        navBar.hidden = false
        toolBar.hidden = false
        
        return memedImage
    }
    @IBAction func shareImage(sender: AnyObject) {
        let meme = generateMemedImage()
        let shareActivityViewController = UIActivityViewController(activityItems: [meme], applicationActivities: nil)
        
        self.presentViewController(shareActivityViewController, animated: true, completion: nil)
        
        shareActivityViewController.completionWithItemsHandler = {(activity, completed, items, error) in
            print("Activity: \(activity)\nCompleted: \(completed)\nItems: \(items)\nError: \(error)")
            if (completed) {
                self.save()
            }

        }
    }
}

