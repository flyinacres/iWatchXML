//
//  InterfaceController.swift
//  iWatchXML WatchKit Extension
//
//  Created by Ronald Fischer on 10/8/15.
//  Copyright (c) 2015 qpiapps. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController, NSXMLParserDelegate {
    
    var titles = [String]()
    
    @IBOutlet weak var table: WKInterfaceTable!
    


    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        
        let url = NSURL(string: "http://images.apple.com/main/rss/hotnews/hotnews.rss")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            if error == nil {
                var urlContent = NSString(data: data, encoding: NSUTF8StringEncoding)
                //println(urlContent)
                
                var xmlParser = NSXMLParser(data: data)
                xmlParser.delegate = self
                xmlParser.parse()
                
                self.table.setNumberOfRows(self.titles.count, withRowType: "tableRowController")
                for (index, title) in enumerate(self.titles) {
                    let row = self.table.rowControllerAtIndex(index) as! tableRowController
                    row.rowLabel.setText(title)
                }
                
            } else {
                println(error)
            }
            
        })
        
        task.resume()
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    var foundTitle = false
    var foundItem = false
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
        //print(elementName)
        foundTitle = false
        if elementName == "title" {
            foundTitle = true
        }
        if elementName == "item" {
            foundItem = true
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String?) {
        //print(" ")
        if string != nil && foundTitle == true && foundItem {
            println(string!)
            if string != "\n" {
                titles.append(string!)
            }
            
        }
        
    }
}
