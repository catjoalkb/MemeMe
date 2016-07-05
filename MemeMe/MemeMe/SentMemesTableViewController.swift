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
        print("tableView count \(memes.count)")
        return memes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableCell")!
        let meme = memes[indexPath.row]
        cell.imageView?.image = meme.image
        cell.textLabel?.text = meme.topText + " " + meme.bottomText
        print("cellForRow: \(meme)")
        return cell
    }
    
    @IBAction func addNewMemedImage(sender: AnyObject) {
        let addNewMemedImage = self.storyboard?.instantiateViewControllerWithIdentifier("addNewMemedImage") as! ViewController
        self.navigationController?.pushViewController(addNewMemedImage, animated: true)
        
    }
}
