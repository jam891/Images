//
//  DetailViewController.swift
//  Images
//
//  Created by Vitaliy Delidov on 10/5/15.
//  Copyright © 2015 Vitaliy Delidov. All rights reserved.
//

import UIKit

enum ErrorType {
    case ConnectionFailed
    case InvalidData
    case None
}

class DetailViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var error = ErrorType.None
    
    var imageURL: NSURL? {
        didSet {
            startDownloadingImage()
        }
    }
    var imageView = UIImageView()
    var image : UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            activityIndicator.stopAnimating()
        }
    }
    
    func startDownloadingImage() {
        DownloadManager.sharedInstance.downloadImageFromURL(imageURL!) { data, error in
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                if error != nil {
                    print("error -> \(error?.localizedDescription)")
                    self.showAlert(.ConnectionFailed)
                    return
                }
                guard let image = UIImage(data: data!) else {
                    self.showAlert(.InvalidData)
                    return
                }
                self.image = image
                self.updateZoom()
            }
        }
    }

    func showAlert(error: ErrorType) {
        var alertController: UIAlertController!
        
        switch error {
        case .ConnectionFailed:
            alertController = UIAlertController(title: "Connection Failed", message: "Please check your internet connection. Please retry later.", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { action in
                self.activityIndicator.stopAnimating()
            }
            let retryAction = UIAlertAction(title: "Retry", style: .Default) { action in
                self.startDownloadingImage()
            }
            alertController.addAction(cancelAction)
            alertController.addAction(retryAction)
        case .InvalidData:
            alertController = UIAlertController(title: "Error!", message: "Image not available.", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default) { action in
                self.activityIndicator.stopAnimating()
            }
            alertController.addAction(defaultAction)
        default:
            break
        }
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
    }

    // MARK: - UIScrollViewDelegate
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        centerScrollViewContents()
    }
    
    // MARK: - Сalculation
    
    func updateZoom() {
        scrollView.contentSize = imageView.image!.size
        
        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        let minScale = min(scaleWidth, scaleHeight)
        
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 2.0
        scrollView.zoomScale = minScale
    }
    
    func centerScrollViewContents() {
        let boundsSize = scrollView.bounds.size
        var contentsFrame = imageView.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        imageView.frame = contentsFrame
    }
    
    // MARK: - InterfaceOrientation
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        updateZoom()
    }
    
}




