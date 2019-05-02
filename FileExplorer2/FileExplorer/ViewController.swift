//
//  ViewController.swift
//  FileExplorer
//
//  Created by Otboss on 2019/4/28.
//

import UIKit;
import Foundation;

class ViewController: UIViewController {

    @IBOutlet var fileListing: UITableView!;
    var homeDirectory:String = "";
    var currentDirectory:String = "";
    let alert = UIAlertController(title: "Server IP", message: "Please enter the full server ip address", preferredStyle: UIAlertController.Style.alert);
    let myUrl = NSURL(string: "");
    var directoryListing = DirectoryListing();
    
    
    func sendDirectoryRequest(path:String){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil));
        var request = URLRequest(url: URL(string: "http://127.0.0.1:8000")!);
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type");
        let session = URLSession.shared;
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response);
            }
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder();
                    let results = try jsonDecoder.decode(ServerResponse.self, from: data);
                    self.directoryListing.directoryFiles = results.files;
                    self.directoryListing.directoryFolders = results.files;
                    print("THE RESPONSE FROM THE QUERY IS: ");
                    print(results);
                    
                    self.fileListing.beginUpdates();
                    //INSERT ROWS HERE
                    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
                        
                    }
                    self.fileListing.endUpdates();
                } catch {
                    print(error)
                }
            }
        }.resume();
        
        self.present(alert, animated: true, completion: nil);
        /*fileListing.insertRows(at: [IndexPath.init()], with: UITableView.RowAnimation.fade);*/
        fileListing.beginUpdates();
        let folderContents:Array<String> = ["hello world", "hello world2"];
        fileListing.insertRows(at: [IndexPath(row: folderContents.count-1, section: 0)], with: .automatic);
        fileListing.endUpdates();
        
    }
    


    
    
    
    
}

class DirectoryListing {
    var currentPath:String = "./";
    var directoryFiles:Array<String> = [];
    var directoryFolders:Array<String> = [];
    func DirectoryListing(){
        
    }
};

struct ServerResponse: Codable {
    var folders:Array<String> = [];
    var files:Array<String> = [];
    var current:String = "./";
    var parent:String = "./";
}
