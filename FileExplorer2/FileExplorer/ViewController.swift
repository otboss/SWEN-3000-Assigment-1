//
//  ViewController.swift
//  FileExplorer
//
//  Created by Otboss on 2019/4/28.
//

import UIKit;
import Foundation;

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var fileListing: UITableView!;
    var directoryListing = DirectoryListing();
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("THIS FUNCTION RAN!");
        directoryListing.directoryFolders.sort();
        directoryListing.directoryFiles.sort();
        directoryListing.directoryFolders.insert("..", at: 0);
        var allFolderContents = directoryListing.directoryFolders + directoryListing.directoryFiles;
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell");
        cell.textLabel?.text = allFolderContents[indexPath.row] as String;
        return cell;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("ANSWER: ");
        print(directoryListing.directoryFolders.count + directoryListing.directoryFiles.count + 1);
        return directoryListing.directoryFolders.count + directoryListing.directoryFiles.count + 1;
    }
    
    func getUrl(url: String){
        directoryListing.currentPath += url;
        var request = URLRequest(url: URL(string: directoryListing.currentPath)!);
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
                    self.directoryListing.directoryFolders = results.folders;
                    print("THE RESPONSE FROM THE QUERY IS: ");
                    print(results);
                    print("THE DIRECTORY FILES ARE: ");
                    print(self.directoryListing.directoryFiles);
                } catch {
                    print(error)
                }
            }
            OperationQueue.main.addOperation ({
                self.fileListing.reloadData();
            });
        }.resume();

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUrl(url: "");
    }
        
}


class DirectoryListing {
    var currentPath:String = "http://127.0.0.1:8000/?folder=./";
    var directoryFiles:Array<String> = [];
    var directoryFolders:Array<String> = [];
    func DirectoryListing(){
        
    }
};

struct ServerResponse: Codable {
    var folders:Array<String> = [];
    var files:Array<String> = [];
    var current:String = "./";
    var parent:String = "";
}
