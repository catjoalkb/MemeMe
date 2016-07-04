//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by wctjerry on 16/7/4.
//  Copyright © 2016年 wctjerry. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController {
    
    //MARK: - Stored sent memed images
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    //MARK: - Collection data source
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionCell", forIndexPath: indexPath) as! CollectionCell
        let meme = memes[indexPath.row]
        cell.image = meme.memedImage
        return cell
    }
    
    
    

}
