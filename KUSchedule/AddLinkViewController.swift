//
//  AddLinkViewController.swift
//  KUSchedule
//
//  Created by Varis Kritpolchai on 5/24/2560 BE.
//  Copyright © 2560 Varis Kritpolchai. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddLinkViewController: UIViewController {
    
    var ref: DatabaseReference?
    var links: NSArray?
    var loaded: Bool?
    var linksStr: [String]?

    @IBOutlet weak var urlLabel: UITextField!
    @IBAction func saveButton(_ sender: Any) {
        if loaded == true {
            for i in 0 ..< links!.count {
                linksStr!.append(links![i] as! String)
            }
            if urlLabel.text != "" {
                if urlLabel.text?[0..<4] == "http" && urlLabel.text?[4] != "s" {
                    linksStr!.append(urlLabel.text!)
                }
                else {
                    linksStr!.append("http://" + urlLabel.text!)
                }
                for i in 0 ..< linksStr!.count {
                    ref!.child("users").child(UIDevice.current.identifierForVendor!.uuidString).child(String(describing: i)).setValue(linksStr![i])
                }
                _ = navigationController?.popViewController(animated: true)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print ("ADDLINKPAGE")
        loaded = false
        linksStr = []
        
        ref = Database.database().reference()
        ref!.child("users").child(UIDevice.current.identifierForVendor!.uuidString).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            self.links = snapshot.value as? NSArray
            self.loaded = true;
            print("TEST")
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
