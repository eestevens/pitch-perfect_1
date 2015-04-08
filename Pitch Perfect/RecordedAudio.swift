//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Erik Stevens on 3/22/15.
//  Copyright (c) 2015 Erik Stevens. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl : NSURL, title : String) {
        self.filePathUrl = filePathUrl
        self.title = title
        
    }
}