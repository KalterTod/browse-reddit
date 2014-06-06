//
//  ViewController.swift
//  BrowseReddit
//
//  Created by Andrew Kennedy on 6/3/14.
//  Copyright (c) 2014 Andrew Kennedy. All rights reserved.
//
 
import UIKit
 
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    
    @IBOutlet var appsTableView : UITableView
    var data: NSMutableData = NSMutableData()
    var tableData: NSArray = NSArray()
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        getSubredditTop("all/top");
    }
    
    func getSubredditTop(subreddit: String) {
        let escapedSearchTerm = subreddit.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        let urlPath = "http://www.reddit.com/r/\(escapedSearchTerm).json"
        var url: NSURL = NSURL(string: urlPath)
        var request: NSURLRequest = NSURLRequest(URL: url)
        var connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: false)
        
        println("Getting top 5 r/\(subreddit) posts at \(url)")
        
        connection.start()
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        
        var row: NSDictionary = self.tableData[indexPath.row] as NSDictionary
        var rowData: NSDictionary = row["data"] as NSDictionary
        
        println(rowData)
        
        cell.text = rowData["title"] as String
        
        var urlString: NSString = rowData["thumbnail"] as NSString
        var imgURL: NSURL = NSURL(string: urlString)

        var imgData: NSData = NSData(contentsOfURL: imgURL)
        cell.image = UIImage(data: imgData)

        var subreddit: String = rowData["subreddit"] as String
 
        cell.detailTextLabel.text = "r/" + subreddit
        
        return cell
    }
    
    
    func connection(connection: NSURLConnection!, didFailWithError error: NSError!) {
        println("Connection failed.\(error.localizedDescription)")
    }
    
    func connection(connection: NSURLConnection, didRecieveResponse response: NSURLResponse)  {
        println("Recieved response")
    }
    
 
    
    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        self.data = NSMutableData()
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        self.data.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        var err: NSError
        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        
        var result:NSDictionary = jsonResult["data"] as NSDictionary
        
        if result["children"].count > 0 {
            self.tableData = result["children"] as NSArray
            self.appsTableView.reloadData()
        }
        
    }
    
}