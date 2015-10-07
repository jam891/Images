//
//  Parser.swift
//  Images
//
//  Created by Vitaliy Delidov on 10/5/15.
//  Copyright © 2015 Vitaliy Delidov. All rights reserved.
//

import Foundation

class Parser: NSObject, NSXMLParserDelegate {
    
    var imageTitle = String()
    var imageLink = String()
    var images = [Image]()
    
    func parse(fileURL: NSURL) -> Bool {
        let parser = NSXMLParser(contentsOfURL: fileURL)!
        parser.delegate = self
        return parser.parse()
    }

    // MARK: – NSXMLParserDelegate methods
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == "image" {
            imageTitle = attributeDict["title"]!
            imageLink = attributeDict["src"]!
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "image" {
            let image = Image()
            image.title = imageTitle
            image.link = imageLink
            images.append(image)
        }
    }

}

