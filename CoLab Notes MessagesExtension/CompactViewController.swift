//
//  CompactViewController.swift
//  CoLab Notes MessagesExtension
//
//  Created by Power186 on 2/6/20.
//  Copyright © 2020 none. All rights reserved.
//

import UIKit

protocol CompactDelegate {
    func newNote()
}

class CompactViewController: UIViewController {
    var delegate:CompactDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func createNewNote(_ sender: Any) {
        delegate?.newNote()
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
