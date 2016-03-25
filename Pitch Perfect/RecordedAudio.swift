//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Eric Sailers on 3/23/16.
//  Copyright © 2016 Expressive Solutions. All rights reserved.
//

import UIKit

class RecordedAudio {

    // MARK: - Properties
    
    var filePathURL: NSURL
    var title: String
    
    // MARK: - Initializer
    
    init(filePathURL: NSURL, title: String) {
        self.filePathURL = filePathURL
        self.title = title
    }
}
