//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by wctjerry on 16/7/4.
//  Copyright © 2016年 wctjerry. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    
    //MARK: - Reload data to update
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    //MARK: - Stored sent memed images
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    
    //MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableCell")!
        let meme = memes[indexPath.row]
        cell.imageView?.image = meme.image
        cell.textLabel?.text = meme.topText + " " + meme.bottomText
        return cell
    }
    
    //MARK: - Segue when selecting cell
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailedVC = self.storyboard?.instantiateViewControllerWithIdentifier("detailedVC") as! DetailedMemeImageViewController
        detailedVC.meme = memes[indexPath.row]
        navigationController?.pushViewController(detailedVC, animated: true)
    }
    
    //MARK: - Segue to add Meme view controller programmically
    @IBAction func addNewMemedImage(sender: AnyObject) {
        let addNewMemedImageVC = self.storyboard?.instantiateViewControllerWithIdentifier("addNewMemedImage") as! CreateMemeImageViewController
        presentViewController(addNewMemedImageVC, animated:true, completion: nil)
    }
}
