//
//  Photo.swift
//  Photorama
//
//  Created by Hisham Abraham on 3/16/17.
//  Copyright © 2017 Hisham Abraham. All rights reserved.
//

import Foundation

class Photo{
    
    let title: String
    let remoteURL: URL
    let photoID: String
    let dateTaken: Date
    
    init(title: String, remoteURL: URL, photoID: String, dateTaken: Date) {
        self.title = title
        self.remoteURL = remoteURL
        self.photoID = photoID
        self.dateTaken = dateTaken
    }
    
    
}
extension Photo: Equatable {
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        //Two photos are the same if they have the same photoID
        return lhs.photoID == rhs.photoID
    }
}

