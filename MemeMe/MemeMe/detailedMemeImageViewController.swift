//
//  detailedMemeImageViewController.swift
//  MemeMe
//
//  Created by wctjerry on 16/7/5.
//  Copyright © 2016年 wctjerry. All rights reserved.
//

import UIKit

class detailedMemeImageViewController: UIViewController {

    @IBOutlet weak var detailedMemeImageView: UIImageView!
    
    var meme: Meme!
    

    override func viewWillAppear(animated: Bool) {
        detailedMemeImageView.image = meme.memedImage
    }

}
