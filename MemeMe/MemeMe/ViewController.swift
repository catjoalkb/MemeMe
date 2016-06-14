//
//  ViewController.swift
//  MemeMe
//
//  Created by wctjerry on 16/6/14.
//  Copyright © 2016年 wctjerry. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        }
    }
    
//    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
//        <#code#>
//    }

}

