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

    func not (b: Bool) -> Bool
    {
        return (!b)
    }
    
    func suspendprocess (t: Double)
    {
        let secs: Int = Int(abs(t))
        let nanosecs: Int = Int((abs(t) - Double(Int(abs(t)))) * 1000000000)
        var time = timespec(tv_sec: secs, tv_nsec: nanosecs)
        let result = nanosleep(&time, nil)
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
        
        
//        suspendprocess (0.02) // Wait 20 ms., enough time to do screen updates regarding to the background job, which calls this function
//        dispatch_async(dispatch_get_main_queue())
//            {
//                let myFiledialog: NSOpenPanel = NSOpenPanel()
//                let fileTypeArray: [String] = filetypelist.componentsSeparatedByString(",")
//                
//                myFiledialog.prompt = "Open"
//                myFiledialog.worksWhenModal = true
//                myFiledialog.allowsMultipleSelection = false
//                myFiledialog.canChooseDirectories = false
//                myFiledialog.resolvesAliases = true
//                myFiledialog.title = windowTitle
//                myFiledialog.message = message
//                myFiledialog.allowedFileTypes = fileTypeArray
//                
//                let void = myFiledialog.runModal()
//                
//                var chosenfile = myFiledialog.URL // Pathname of the file
//                
//                if (chosenfile != nil)
//                {
//                    self.fileName = chosenfile!.absoluteString
//                }
//                finished = true
//        }
//        
//        while not(finished)
//        {
//            suspendprocess (0.001) // Wait 1 ms., loop until main thread finished
//        }
    }

    @IBAction func processFileClick(sender: AnyObject) {
        
        var inputString: NSString?
        if let data = NSData(contentsOfURL: NSURL(string: fileName! as String)!) {
            if let content = NSString(data: data, encoding: NSUTF8StringEncoding) {
                inputString = content
//                NSLog("\(content)")
            }
        }
        
        //let inputString = "Year,Make,Model,Description,Price\r\n1997,Ford,E350,descrition,3000.00\r\n1999,Chevy,Venture,another description,4900.00\r\n"
        let csv = CSwiftV(String: inputString! as String)
        
        let headers = csv.headers // ["Year","Make","Model","Description","Price"]
        let rows = csv.rows
        NSLog("HEADERS - \(headers)")
        NSLog("ROWS - \(rows)")
        
        self.outputTextView.string = String(format: "%@", rows)
    }
}

