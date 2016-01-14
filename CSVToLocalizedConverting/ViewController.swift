//
//  ViewController.swift
//  CSVToLocalizedConverting
//
//  Created by Zmicier Biesau on 14.1.16.
//  Copyright © 2016 Maxvale Ind. All rights reserved.
//

import Cocoa
import CSwiftV

class ViewController: NSViewController {

    @IBOutlet weak var fileNameButton: NSButton!
    @IBOutlet var outputTextView: NSTextView!
    var fileName: NSString?
    var contentOfFile: NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func selectFileClick(sender: AnyObject) {

        let fileTypeArray: [String] = "csv".componentsSeparatedByString(",")

        let message = "Open message"
        
        let myFiledialog: NSOpenPanel = NSOpenPanel()
        
        myFiledialog.prompt = "Open"
        myFiledialog.worksWhenModal = true
        myFiledialog.allowsMultipleSelection = false
        myFiledialog.canChooseDirectories = false
        myFiledialog.resolvesAliases = true
        myFiledialog.title = title
        myFiledialog.allowedFileTypes = fileTypeArray
        myFiledialog.message = message
        myFiledialog.runModal()
        let chosenfile = myFiledialog.URL
        if (chosenfile != nil)
        {
            fileName = chosenfile!.absoluteString
            self.fileNameButton.title = fileName! as String
            
        }
        
}

    @IBAction func processFileClick(sender: AnyObject) {
        
        var inputString: NSString?
        if let data = NSData(contentsOfURL: NSURL(string: fileName! as String)!) {
            if let content = NSString(data: data, encoding: NSUTF8StringEncoding) {
                inputString = content
//                NSLog("\(content)")
            }
        }
        
        let csv = CSwiftV(String: inputString! as String)
        
        let rows = csv.rows
        self.outputTextView.string = ""
        for (index, item) in rows.enumerate() {
            //print("Found \(item) at position \(index)")
            var text = item[0] + "\" = \"" + item[1] + "\";\n"
            text = "\"" + text
            let attrString = NSAttributedString(string: text)
            self.outputTextView.textStorage!.appendAttributedString(attrString)
        }
    }
}

