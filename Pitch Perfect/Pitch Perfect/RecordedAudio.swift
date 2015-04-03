//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Pieri Laura on 29/03/15.
//  Copyright (c) 2015 Pieri Laura. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl : NSURL!
    var title : String!
    
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}