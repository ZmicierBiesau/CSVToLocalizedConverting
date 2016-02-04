//
//  ViewController.swift
//  CSVToLocalizedConverting
//
//  Created by Zmicier Biesau on 14.1.16.
//  Copyright © 2016 Maxvale Ind. All rights reserved.
//

import Cocoa
import CSwiftV

class ViewController: NSViewController, NSCollectionViewDataSource, NSCollectionViewDelegate {

    
    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var fileNameButton: NSButton!
    @IBOutlet var outputTextView: NSTextView!
    var fileName: NSString?
    var contentOfFile: NSArray?
    var parsedCSV: CSwiftV?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
       // self.collectionView.itemPrototype = self.storyboard!.instantiateControllerWithIdentifier("SourceCollectionItem") as! SourceCollectionItem
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
            self.processFile()
        }
        
}

    @IBAction func saveFileClick(sender: AnyObject) {
        let savePanel: NSSavePanel = NSSavePanel()
        
        savePanel.prompt = "Save"
        savePanel.worksWhenModal = true
        savePanel.title = title
        savePanel.canCreateDirectories = true
        savePanel.showsHiddenFiles = false
        savePanel.allowsOtherFileTypes = true
        savePanel.nameFieldStringValue = "English.localized"
        
        
        savePanel.beginWithCompletionHandler { (result: Int) -> Void in
            if result == NSFileHandlingPanelOKButton {
                let exportedFileURL = savePanel.URL
                self.saveFile(exportedFileURL!)
            }
        } // End block
     


    }
    
    
    @IBAction func processFileClick(sender: AnyObject)
    {
        self.processFile()
    }
    
    private func processFile()
    {
        var inputString: NSString?
        if let data = NSData(contentsOfURL: NSURL(string: fileName! as String)!) {
            if let content = NSString(data: data, encoding: NSUTF8StringEncoding) {
                inputString = content
                //                NSLog("\(content)")
            }
        }
        
        self.parsedCSV = CSwiftV(String: inputString! as String)
        
        let rows = self.parsedCSV!.rows
        self.outputTextView.string = ""
        for (_, item) in rows.enumerate() {
            //print("Found \(item) at position \(index)")
            var text = item[0] + "\" = \"" + item[1] + "\";\n"
            text = "\"" + text
            let attrString = NSAttributedString(string: text)
            self.outputTextView.textStorage!.appendAttributedString(attrString)
        }
        
        self.collectionView.needsDisplay = true
    }
    
    private func saveFile(exportedUrl: NSURL)
    {
        NSLog("EXPORTED URL - \(exportedUrl)")
        let text = outputTextView.string
        do {
            try text!.writeToURL(exportedUrl, atomically: true, encoding: NSUTF8StringEncoding)
        }
        catch {
            self.showAlert(message: "Error while saving your file")
        }
    }
    
    //MARK:Error controller
    func showAlert(message message: String)
    {
        let alert: NSAlert = NSAlert()
        alert.messageText = message
//        alert.informativeText = message + "1"
        alert.alertStyle = NSAlertStyle.WarningAlertStyle
        alert.addButtonWithTitle("OK")
        alert.runModal()
 
    }
    
    //MARK: NSCollectionViewDataSource
    func collectionView(collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int
    {
        NSLog("NUMBER OF ROWS")
        return 30// self.parsedCSV!.rows.count * self.parsedCSV!.headers.count
    }
    func collectionView(collectionView: NSCollectionView, itemForRepresentedObjectAtIndexPath indexPath: NSIndexPath) -> NSCollectionViewItem
    {
        let cell = SourceCollectionItem()//collectionView.makeItemWithIdentifier("SourceCollectionItem", forIndexPath: indexPath) as! SourceCollectionItem
        cell.textField?.stringValue = "1"
        cell.textLabelField.stringValue = "2"
        let label = NSTextField(frame: CGRectMake(0, 0, 100, 30))
        label.bezeled = false
        label.drawsBackground = false
        label.editable = false
        label.selectable = false
        label.stringValue = "3"
        label.textColor = NSColor.blackColor()
        cell.view.addSubview(label)
            
        
        return cell
    }
}

