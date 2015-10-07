//
//  DownloadManager.swift
//  Images
//
//  Created by Vitaliy Delidov on 10/6/15.
//  Copyright © 2015 Vitaliy Delidov. All rights reserved.
//

import Foundation

class DownloadManager: NSObject {
    
    let cache = NSCache()
    
    static let sharedInstance = DownloadManager()
    
    func downloadImageFromURL(url: NSURL, completion:(data: NSData?, error: NSError?) -> ()) {
        let data = cache.objectForKey(url) as? NSData
        if data != nil {
            completion(data: data!, error: nil)
            return
        }
        let request = NSURLRequest(URL: url)
        let configuration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        let session = NSURLSession(configuration: configuration)
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completion(data: nil, error: error)
                return
            }
            self.cache.setObject(data!, forKey: url)
            completion(data: data!, error: nil)
        }
        task.resume()
    }
}




