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
    var currentIndex : NSInteger = 0
    let hostUrl = "http://xkcd.com/"
    let jsonParameter = "/info.0.json"
    var currentComicURL = "http://xkcd.com/info.0.json"
    var comicURL : String = "http://xkcd.com/1/info.0.json"
    
    var currentComicNumber = 0
    var comicNumber : NSInteger = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Show first comic
        //getNextComic()
        
        getJSONFromUrl(comicNumber)

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
    func getJSONFromUrl(currentComic : NSInteger) {
        
        comicURL = "\(hostUrl)\(comicNumber)\(jsonParameter)"
        let url = currentComic == 0 ? currentComicURL : comicURL
        if let comicURL = NSURL(string: url) {
            getJSONFromUrl(comicURL, completion: { (data) -> Void in
                
                if let json: NSDictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                    if currentComic == 0 {
                        if let maximumComicNumber = json["num"] as? NSInteger {
                            self.currentComicNumber = maximumComicNumber
                            self.comicNumber = maximumComicNumber
                        }
                    }
                    
                    if let title = json["safe_title"] as? String {
                        self.setComicTitleTextView(title)
                    }
                    
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
        getJSONFromUrl(comicNumber)
    }
    
    func getPreviousComic() {
        comicNumber = abs(comicNumber - 1) % currentComicNumber
        getJSONFromUrl(comicNumber)
    }
    
    func getJSONFromUrl(urL:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: data)
            }.resume()
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

