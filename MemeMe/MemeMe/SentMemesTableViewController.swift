//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by wctjerry on 16/7/4.
//  Copyright © 2016年 wctjerry. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    
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
        cell.textLabel?.text = meme.topText + meme.bottomText
        return cell
    }
    
    @IBAction func addNewMemedImage(sender: AnyObject) {
        let addNewMemedImage = self.storyboard?.instantiateViewControllerWithIdentifier("addNewMemedImage") as! ViewController
        
        self.navigationController?.pushViewController(addNewMemedImage, animated: true)
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
