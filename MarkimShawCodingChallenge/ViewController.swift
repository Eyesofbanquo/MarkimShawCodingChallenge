//
//  ViewController.swift
//  MarkimShawCodingChallenge
//
//  Created by Markim Shaw on 8/11/16.
//  Copyright © 2016 Markim Shaw. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var _booksTableView: UITableView!
    
    //
    var bookResults:[Book] = [Book]()
    var cache:NSCache!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.cache = NSCache()
        self.loadBooks()
    }
    
    func loadBooks(){
        let url:NSURL = NSURL(string: "http://de-coding-test.s3.amazonaws.com/books.json")!
        let urlRequest:NSURLRequest = NSURLRequest(URL: url)
        let queue:NSOperationQueue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: queue, completionHandler: {
            response, data, error in
            if error == nil && data != nil {
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! Array<Dictionary<NSObject,AnyObject>>
                    for (_,book) in json.enumerate(){
                        var title:String
                        var author:String
                        var imageURL:String
                        if book["title"] as? String != nil {
                            title = book["title"] as! String
                        } else { title = "title unavailable" }
                        
                        if book["author"] as? String != nil {
                            author = book["author"] as! String
                        } else { author = "author information unavailable" }
                        
                        if book["imageURL"] as? String != nil {
                            imageURL = book["imageURL"] as! String
                        } else { imageURL = "image unavailable" }
                        
                        let newBook = Book(title: title, author: author, imageURL: imageURL)
                        self.bookResults += [newBook]
                        dispatch_async(dispatch_get_main_queue(), {
                            self._booksTableView.reloadData()
                        })
                        
                    }
                } catch {
                    print(error)
                }
               
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "to_BookDetailViewController" {
            let destination = segue.destinationViewController as! BookDetailViewController
            
            let cell = sender as? UITableViewCell
            if let indexPath = self._booksTableView.indexPathForCell(cell!) {
                destination.selectedBook = self.bookResults[indexPath.row]
            }
        }
    }
}

//TableView extension
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bookResults.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("book_cell", forIndexPath: indexPath)
        //View tag key:
        // 1 - UIImageView - book image
        // 2 - UILabel - title
        // 3 - UILabel - author
        let book_image = cell.viewWithTag(1) as! UIImageView
        let title = cell.viewWithTag(2) as! UILabel
        let author = cell.viewWithTag(3) as! UILabel
        
        if self.bookResults[indexPath.row].imageURL!.containsString("unavailable") {
            book_image.image = nil
        } else {
            if self.cache.objectForKey(indexPath.row) != nil {
                book_image.image = self.cache.objectForKey(indexPath.row) as? UIImage
            } else {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    let url:NSURL! = NSURL(string: self.bookResults[indexPath.row].imageURL!)
                    let data:NSData = NSData(contentsOfURL: url)!
                    dispatch_async(dispatch_get_main_queue(), {
                        if let updatedCell = tableView.cellForRowAtIndexPath(indexPath){
                            let image = UIImage(data: data)
                            (updatedCell.viewWithTag(1) as! UIImageView).image = image
                            self.cache.setObject(image!, forKey: indexPath.row)
                            self._booksTableView.reloadData()
                        }
                    })
                })
            }
        }
        title.text = self.bookResults[indexPath.row].title!
        author.text = self.bookResults[indexPath.row].author!
        return cell
    }
}

