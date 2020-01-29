//
//  DetailViewController.swift
//  Remembrall
//
//  Created by Samar Seth on 1/20/20.
//  Copyright © 2020 Samar Seth. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var defaults = UserDefaults.standard
    var todoList: [String] = []
    var todoDescriptions: [String] = []
    var selectedIndex: Int!
    
    @IBOutlet weak var todoDescription: UILabel!
    
    override func viewDidLoad() {
        todoList = defaults.array(forKey: "toDoList") as! [String]
        selectedIndex = defaults.integer(forKey: "index")
        todoDescriptions = defaults.array(forKey: "descriptions") as! [String]
        
        self.navigationItem.title = todoList[selectedIndex!]
        self.todoDescription.text = todoDescriptions[selectedIndex]
        super.viewDidLoad()
    }
}
