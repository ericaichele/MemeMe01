//
//  MemeTableViewController.swift
//  ImageTest
//
//  Created by Eric Aichele on 4/12/16.
//  Copyright © 2016 Eric Aichele. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView!.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.allowsMultipleSelectionDuringEditing = true
        //tableView.setEditing(true, animated: false)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true     // status bar should be hidden
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableViewCell")!
        let meme = self.memes[indexPath.row]
        
        //SET THE IMAGE AND TEXT
        cell.imageView!.image = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.row].memedImage
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let editMeme = self.storyboard!.instantiateViewControllerWithIdentifier("MakeMemeViewController") as! MakeMemeViewController
        editMeme.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(editMeme, animated: true)
    }
    
    //DELETE SETUP
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // SWIPE TO DELETE
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            tableView.reloadData()
        }
    }
    
}
