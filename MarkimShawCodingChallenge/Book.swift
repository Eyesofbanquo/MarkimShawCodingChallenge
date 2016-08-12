//
//  Book.swift
//  MarkimShawCodingChallenge
//
//  Created by Markim Shaw on 8/11/16.
//  Copyright © 2016 Markim Shaw. All rights reserved.
//

import Foundation


class Book {
    var title:String?
    var author:String?
    var imageURL:String?
    
    init(title:String, author:String, imageURL:String){
        self.title = title
        self.author = author
        self.imageURL = imageURL
    }
}