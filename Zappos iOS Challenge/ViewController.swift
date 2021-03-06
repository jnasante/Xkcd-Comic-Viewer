//
//  ViewController.swift
//  Zappos iOS Challenge
//
//  Created by Joseph Asante on 9/25/15.
//  Copyright © 2015 CCEW. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var comicTitle: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    
    let hostUrl = "http://xkcd.com/"
    let jsonParameter = "/info.0.json"
    var currentComicURL = "http://xkcd.com/info.0.json"
    var comicURL : String = "http://xkcd.com/1/info.0.json"
    
    var currentComicNumber = 0
    var comicNumber : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Show first comic
        //getNextComic()
        
        getComic(comicNumber)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Action Methods
    @IBAction func showNextComic(sender: AnyObject) {
        NSLog("Next")
        getNextComic()
    }
    
    @IBAction func showPreviousComic(sender: AnyObject) {
        NSLog("Previous")
        getPreviousComic()
    }
    
    // MARK: Networking
    func getComic(currentComic : Int) {
        
        comicURL = "\(hostUrl)\(comicNumber)\(jsonParameter)"
        let url = currentComic == 0 ? currentComicURL : comicURL
        
        if let comicURL = NSURL(string: url) {
            // Get data from the URL
            getDataFromUrl(comicURL, completion: { (data) -> Void in
                
                if let json: NSDictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                    
                    // Get the number of the latest comic
                    if currentComic == 0 {
                        if let maximumComicNumber = json["num"] as? Int {
                            self.currentComicNumber = maximumComicNumber
                            self.comicNumber = maximumComicNumber
                        }
                    }
                    
                    // Set comic title
                   if let title = json["safe_title"] as? String {
                        self.setComicTitleTextView(title)
                    }
                    
                    // Set image (retrieved from image URL)
                   if let imageURL = json["img"] as? String {
                        NSLog("%@", imageURL)
                        self.downloadImage(NSURL(string: imageURL)!)
                    }
                }
            })
        }
            
        
    }
    
    func getNextComic() {
        comicNumber = (comicNumber+1) % currentComicNumber
        getComic(comicNumber)
    }
    
    func getPreviousComic() {
        comicNumber = abs(comicNumber - 1) % currentComicNumber
        getComic(comicNumber)
    }
    
    func getDataFromUrl(urL:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: data)
            }.resume()
    }
    
    func setComicTitleTextView(string : String) {
        dispatch_async(dispatch_get_main_queue()) {
            self.comicTitle.text = string
        }
    }
    
    func downloadImage(url:NSURL) {
        getDataFromUrl(url) { data in
            dispatch_async(dispatch_get_main_queue()) {
                self.mainImageView.image = UIImage(data: data!)
            }
        }
    }

}

