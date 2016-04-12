//
//  MemeCollectionViewController.swift
//  ImageTest
//
//  Created by Eric Aichele on 4/12/16.
//  Copyright © 2016 Eric Aichele. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true     // status bar should be hidden
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
        collectionView!.reloadData()
    }
    
    override func collectionView(connectionView: UICollectionView, numberOfItemsInSection sections: Int) -> Int {
        return self.memes.count
    }
    
   override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[indexPath.row]
        
        //SET THE IMAGE AND TEXT
        cell.memeImageView.image = meme.memedImage
    
        return cell
        
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let editMeme = self.storyboard!.instantiateViewControllerWithIdentifier("MakeMemeViewController") as! MakeMemeViewController
        editMeme.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(editMeme, animated: true)
    }
}