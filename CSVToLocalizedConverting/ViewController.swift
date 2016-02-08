//
//  ViewController.swift
//  CSVToLocalizedConverting
//
//  Created by Zmicier Biesau on 14.1.16.
//  Copyright © 2016 Maxvale Ind. All rights reserved.
//

import Cocoa
import CSwiftV

class ViewController: NSViewController, NSCollectionViewDataSource {

    
    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var fileNameButton: NSButton!
    @IBOutlet var outputTextView: NSTextView!
    var fileName: NSString?
    var contentOfFile: NSArray?
    var parsedCSV: CSwiftV?
    var titles = [["Banana", "Apple", "Strawberry"], ["Cherry", "Pear", "Pineapple"], ["Grape", "Melon"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        collectionView!.itemPrototype = SourceCollectionItem()
       // collectionView!.content = titles
        collectionView.dataSource = self
    
        
        //self.updateCollectionView()
        
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
        self.titles = self.parsedCSV!.rows
        //self.updateCollectionView(self.parsedCSV!.rows)
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
    
    //MARK: Setting table of strings
    
    func updateCollectionView(array:[[String]])
    {
//        for index in 0..<array.count
//        {
//            NSLog("NEW Row - %@", array[index])
//        }
       // self.collectionView.content = array
        self.titles = array
        self.updateCollectionView()
    }
    func updateCollectionView()
    {
        for index in 0..<self.titles.count {
            for index2 in 0..<self.titles[index].count
            {
                let item = self.collectionView!.itemAtIndex(index * self.titles[index].count + index2) as! SourceCollectionItem
                item.textValue = self.titles[index][index2]
                
            }
            
            
        }
    }
    
    // MARK: NSCollectionViewDataSource
    
    func collectionView(collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.titles.count * self.titles[0].count
    }
    
    func collectionView(collectionView: NSCollectionView, itemForRepresentedObjectAtIndexPath indexPath: NSIndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItemWithIdentifier("SourceCollectionItem", forIndexPath: indexPath)
        item.representedObject = LabelObject(title: self.titles[indexPath.item])
        return item
    }
    
}

