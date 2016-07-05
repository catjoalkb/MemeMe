//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by wctjerry on 16/7/4.
//  Copyright © 2016年 wctjerry. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    
    //MARK: - Set collection cell size
    private func setCollectionCellSize() {
        let benchmark = view.frame.size.width
        let space: CGFloat = 3.0
        let dimension = (benchmark - (2 * space)) / 3.0
        flowLayout.minimumLineSpacing = space
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    //MARK: - Set flow layout cell size
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionCellSize()
    }
    
    
    //MARK: - Reload data to update
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView?.reloadData()
    }

    
    //MARK: - Update cell size
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        setCollectionCellSize()
    }
    
    
    //MARK: - Get stored sent memed images
    
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
        cell.imageView.image = meme.memedImage
        return cell
    }
    
    //MARK: - segue to add Meme veiw controller in storyboard
}
