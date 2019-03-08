//
//  ViewController.swift
//  Project7
//
//  Created by Dan on 3/5/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var petitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(runCredits))

        
        let urlString: String
            
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
           // "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit = 100"
            
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) { //data instance...
                   //we're Ok to Parse
                parse(json: data)
                return
            }
        }
        showError()
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again", preferredStyle: .alert )
        ac.addAction(UIAlertAction(title: "OK", style: .default)) //add a button to that. no handler
        present (ac, animated: true)
    }
    
    @objc func runCredits(_ sender: Any) {
        
        let ac = UIAlertController(title: "Brought to you By: \n 'We The People' \n API of the Whitehouse ", message: nil, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Continue", style: .default))
        
        present(ac, animated: true)

    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
    
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        
        return cell
        }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row] // whichever one they tap in the table...
        navigationController?.pushViewController(vc, animated: true) // bring that thing onto the screen
    }

}
