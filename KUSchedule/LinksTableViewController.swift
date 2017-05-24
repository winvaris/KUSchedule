//
//  LinksTableViewController.swift
//  KUSchedule
//
//  Created by Varis Kritpolchai on 5/24/2560 BE.
//  Copyright © 2560 Varis Kritpolchai. All rights reserved.
//

import UIKit
import FirebaseDatabase

class LinksTableViewController: UITableViewController {
    
    var ref: DatabaseReference?
    var links: NSArray?
    var loaded: Bool?

    @IBAction func refreshButton(_ sender: Any) {
        self.loaded = false
        self.tableView.reloadData()
        ref!.child("users").child(UIDevice.current.identifierForVendor!.uuidString).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            self.links = snapshot.value as? NSArray
            self.loaded = true
            self.tableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loaded = false
        tableView.dataSource = self
        tableView.delegate = self
        ref = Database.database().reference()
        /*
        for i in 0 ..< links!.count {
            ref!.child("users").child(UIDevice.current.identifierForVendor!.uuidString).child(String(describing: i)).setValue(links![i])
        }
        */
        ref!.child("users").child(UIDevice.current.identifierForVendor!.uuidString).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            self.links = snapshot.value as? NSArray
            self.loaded = true
            self.tableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loaded = false
        self.tableView.reloadData()
        ref!.child("users").child(UIDevice.current.identifierForVendor!.uuidString).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            self.links = snapshot.value as? NSArray
            self.loaded = true
            self.tableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loaded == true {
            return links!.count
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LinksTableViewCell", for: indexPath) as? LinksTableViewCell
            else {
                fatalError("The dequeued cell is not an instance of LinksTableViewCell.")
        }
        if loaded == true {
            if self.links!.count > 0 {
                let temp: String = self.links![indexPath.row] as! String
                cell.linkLabel.text = temp
            }
            else {
                cell.linkLabel.text = "No link has been saved..."
            }
        }
        else {
            cell.linkLabel.text = "Please wait..."
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if links!.count > 0 && loaded == true {
            super.prepare(for: segue, sender: sender)
            
            switch(segue.identifier ?? "") {
                
            case "ShowDetail":
                guard let webViewController = segue.destination as? WebViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                
                guard let selectedCell = sender as? LinksTableViewCell else {
                    fatalError("Unexpected sender: \(String(describing: sender))")
                }
                
                guard let indexPath = tableView.indexPath(for: selectedCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
                
                let selectedURL = self.links![indexPath.row]
                webViewController.url = selectedURL as! String
            
            case "AddLink":
                print("Add link")
                
            default:
                fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
