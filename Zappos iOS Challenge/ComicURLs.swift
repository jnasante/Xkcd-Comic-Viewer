//
//  ComicURLs.swift
//  Zappos iOS Challenge
//
//  Created by Joseph Asante on 9/25/15.
//  Copyright © 2015 CCEW. All rights reserved.
//

import Foundation

class ComicURLs: NSObject {
    
    static var hostUrl = "http://imgs.xkcd.com/comics/"
    
    static var images = [
        "council_of_300.png",
        "sledding_discussion.png",
        "experiment.png",
        "giraffes.png",
        "december_25th.png",
        "10_day_forecast.png",
        "picture_a_grassy_field.png",
        "email.png",
        "interview.png",
        "overqualified.png",
        "solar_system_questions.png",
        "infinite_scrolling.png",
        "the_end_is_not_for_a_while.png"
    ]
    
    static func getFullUrl(index : NSInteger) -> String {
        return hostUrl + images[(index) % images.count]
    }
    
    static func getNextURL(currentIndex : NSInteger) -> String {
        return getFullUrl((currentIndex + 1) % images.count)
    }
    
    static func getPreviousURL(currentIndex : NSInteger) -> String {
        return getFullUrl(abs(currentIndex - 1) % images.count)
    }
    
}
