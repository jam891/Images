//
//  MasterViewController.swift
//  Images
//
//  Created by Vitaliy Delidov on 10/5/15.
//  Copyright © 2015 Vitaliy Delidov. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let url = NSURL(string: "https://dl.dropboxusercontent.com/u/73337349/testtask/images.xml")!
    var images = [Image]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.hidden = true
        fetchListImages()
    }
    
    func fetchListImages() {
        let backgroundQueue = NSOperationQueue()
        backgroundQueue.addOperationWithBlock() {
            let parser = Parser()
            let success = parser.parse(self.url)
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                if success {
                    self.images = parser.images
                    self.tableView.reloadData()
                    self.tableView.hidden = false
                    self.activityIndicator.stopAnimating()
                } else {
                    self.showAlert()
                }
            }
        }
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "Connection Failed", message: "Please check your internet connection. Please retry later.", preferredStyle: .Alert)
        let retryAction = UIAlertAction(title: "Retry", style: .Default) { action in
            self.fetchListImages()
        }
        alertController.addAction(retryAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let image = images[indexPath.row]
        cell.textLabel?.text = image.title
        return cell
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showImage" {
            let image = images[tableView.indexPathForSelectedRow!.row]
            let viewController = segue.destinationViewController as? DetailViewController
            viewController?.title = image.title
            viewController?.imageURL = NSURL(string: image.link)
        }
    }


}
