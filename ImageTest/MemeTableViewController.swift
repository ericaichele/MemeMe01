//
//  MemeTableViewController.swift
//  ImageTest
//
//  Created by Eric Aichele on 4/12/16.
//  Copyright © 2016 Eric Aichele. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    var memes: [Meme]!
//    var memes: [Meme] {
//        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
//    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.allowsMultipleSelectionDuringEditing = true
        //tableView.setEditing(true, animated: false)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableViewCell")!
        let incomingMeme = self.memes[indexPath.row]
        
        //SET THE IMAGE AND TEXT
        cell.imageView!.image = incomingMeme.memedImage
        cell.textLabel!.text = "\(incomingMeme.textTop)... \(incomingMeme.textBottom)"
        cell.imageView!.sizeToFit()
        print("Not a cell issue")
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let memeDetails = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailsViewController") as! MemeDetailsViewController
        memeDetails.incomingMeme = self.memes[indexPath.row]
        //tabBarController?.tabBar.hidden = true
        navigationController!.pushViewController(memeDetails, animated: true)
        print("Ok. \(memes.count)")
        print("Ok. \(memes)")
        
        
    }
    
    //DELETE SETUP
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // SWIPE TO DELETE
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            memes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            tableView.reloadData()
        }
    }
    
}
