//
//  ExpandedViewController.swift
//  CoLab Notes MessagesExtension
//
//  Created by Power186 on 2/6/20.
//  Copyright © 2020 none. All rights reserved.
//

import UIKit

protocol ExpandedDelegate {
    func sendMessage(title:String,note:String)
}

class ExpandedViewController: UIViewController {
    @IBOutlet weak var txtTitle: UITextField!
    
    @IBOutlet weak var txtNote: UITextView!
    
    var delegate:ExpandedDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // dispose of any resources that can be recreated.
    }
    
    func clearText() {
        txtNote.text = "Note"
        txtTitle.text = ""
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        delegate?.sendMessage(title: txtTitle.text!, note: txtNote.text)
    }
    
    func didOpen(from url:URL) {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        for item in components.queryItems! {
            if item.name == "title" {
                txtTitle.text = item.value
            }
            else if item.name == "note" {
                txtNote.text = item.value
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
