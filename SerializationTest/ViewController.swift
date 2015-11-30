//
//  ViewController.swift
//  SerializationTest
//
//  Created by David Rollins on 11/27/15.
//  Copyright © 2015 David Rollins. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var books:[Book] = [Book]()
    var editIdx:Int = -1 

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtAuthor: UITextField!
    @IBOutlet weak var txtPageCount: UITextField!
    @IBOutlet weak var txtCategories: UITextField!
    @IBOutlet weak var toggleAvailable: UISwitch!
    
    @IBOutlet weak var btnAddBook: UIButton!
    @IBAction func cmdAddBook(sender: AnyObject) {
        
        if txtAuthor.text == "" || txtTitle.text == "" || txtCategories.text == "" || txtPageCount.text == "" {
            ShowAlert("All non-toggle fields are required!")
        }
        else{
            
            let myString = txtCategories.text!
            let myAuth = txtAuthor.text!
            
            print(myString)
            
            let cats:[String] = myString.characters.split{$0 == ","}.map(String.init)
            let authVals:[String] = myAuth.characters.split{$0 == " "}.map(String.init)
            
            let auth:Author = Author(fname: authVals[0], lname:authVals[1])

            let book = Book(title: txtTitle.text!, author: auth, pageCount: Int(txtPageCount.text!)!, categories: cats, available: toggleAvailable.on)
            
            books.append(book)
            
            ClearUI()
            
            tableView.reloadData()
        }
        
    }
    
    func ClearUI() {
        txtPageCount.text = ""
        txtTitle.text = ""
        txtCategories.text = ""
        txtAuthor.text = ""
        toggleAvailable.on = false
    }
    
    @IBAction func cmdSerialize(sender: AnyObject) {
        DoSerialization()
        books = [Book]()
        tableView.reloadData()
        ClearUI()
    }
    
    @IBAction func cmdDeserialize(sender: AnyObject) {
        books = DoDeSerialization()!
        tableView.reloadData()
        ClearUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LoadTestData()

        toggleAvailable.on = false
        
    }
    
    func LoadTestData() {
        
        let mybooks:[Book] = DoDeSerialization()!
        
        if mybooks.count > 0 {
            books = mybooks
        }
//        else{
//            let book1 = Book(title: "My Title1", author: "My Author2", pageCount: 300, categories: ["Drama","Crime"], available: true)
//            books.append(book1)
//
//            let book2 = Book(title: "My Title2", author: "My Author2", pageCount: 217, categories: ["Mystery","Crime"], available: false)
//            books.append(book2)
//            
//            let book3 = Book(title: "My Title3", author: "My Author3", pageCount: 298, categories: ["Love","History"], available: true)
//            books.append(book3)
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func DoSerialization() -> Void {
        NSKeyedArchiver.archiveRootObject(books, toFile: DocsFolder("mybooks"))
    }

    func DoDeSerialization() -> [Book]? {
        if let mybooks = NSKeyedUnarchiver.unarchiveObjectWithFile(DocsFolder("mybooks")) as? [Book]{
            return mybooks
        }
        else{
            return [Book]()
        }
    }
    
    func DocsFolder(name:String) ->String{
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentDirectory = paths[0] as NSString
        return documentDirectory.stringByAppendingPathComponent(name)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        
        print(indexPath.row)
        
        if let book:Book = books[indexPath.row] {
            if let lbl = cell.textLabel{
                lbl.text = book.title
            }
            if let dlbl = cell.detailTextLabel {
                dlbl.text = book.author.fullName()
            }
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let b = books[indexPath.row] as? Book{
            
            txtTitle.text = b.title
            txtAuthor.text = b.author.fullName()
            txtCategories.text = b.categories.joinWithSeparator(",")
            txtPageCount.text = String(b.pageCount)
            toggleAvailable.on = b.available
            
            editIdx = indexPath.row
            
        }
        else{
            ClearUI()
            editIdx = -1
        }
    }
    
    func ShowAlert(msg:String){
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.title = "Error"
        alert.message = msg
        self.showViewController(alert, sender: nil)
    }

}

