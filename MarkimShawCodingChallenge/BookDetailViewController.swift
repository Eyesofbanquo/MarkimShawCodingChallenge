//
//  BookDetailViewController.swift
//  MarkimShawCodingChallenge
//
//  Created by Markim Shaw on 8/11/16.
//  Copyright © 2016 Markim Shaw. All rights reserved.
//

import UIKit
import CoreData

class BookDetailViewController: UIViewController {
    
    var viewTitle:String!
    var selectedBook:Book!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.viewTitle
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addBookToFavorites(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Book")
        let predicate = NSPredicate(format: "title = %@", self.selectedBook.title!)
        fetchRequest.predicate = predicate
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            if results.isEmpty {
                let entity = NSEntityDescription.entityForName("Book", inManagedObjectContext: managedContext)
                let book = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
                book.setValue(self.selectedBook.title!, forKey: "title")
                book.setValue(self.selectedBook.author!, forKey: "author")
                book.setValue(self.selectedBook.imageURL!, forKey: "imageURL")
                try managedContext.save()

            } else {
                
            }
        } catch {
            print(error)
        }
    
    }

}
