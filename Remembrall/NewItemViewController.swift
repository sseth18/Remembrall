//
//  NewItemViewController.swift
//  Remembrall
//
//  Created by Samar Seth on 1/20/20.
//  Copyright © 2020 Samar Seth. All rights reserved.
//

import UIKit

class NewItemViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var newItemName: UITextField!
    @IBOutlet weak var newItemDescription: UITextField!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        newItemName.delegate = self
        newItemDescription.delegate = self
        
        registerForKeyboardNotifications()
        
        super.viewDidLoad()
    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        if newItemName.text == "" {
            // Navigate back to the 'TableViewController' after hitting 'Done'
            // Src: https://stackoverflow.com/questions/28760541/programmatically-go-back-to-previous-viewcontroller-in-swift/40107165
            navigationController?.popViewController(animated: true)
        } else {  // if you populate the fields: updates the list of tasks and their descriptions, adding it to the table view controller
            var currentList: [String] = defaults.array(forKey: "toDoList") as! [String]
            currentList.append(newItemName.text!)

            defaults.set(currentList, forKey: "toDoList")
            
            var currentDescriptionList: [String] = defaults.array(forKey: "descriptions") as! [String]
        
            currentDescriptionList.append(newItemDescription.text!)
            
            defaults.set(currentDescriptionList, forKey: "descriptions")
        
            navigationController?.popViewController(animated: true)
        }
    }
    
    // methods below handle how the keyboard is dealt with
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWasShown(_:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillBeHidden(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWasShown(_:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }
    
    @objc func keyboardWasShown(_ notificiation: NSNotification) {
        guard let info = notificiation.userInfo,
            let keyboardFrameValue =
            info[UIResponder.keyboardFrameBeginUserInfoKey]
                as? NSValue
            else { return }
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardSize = keyboardFrame.size
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0,
                                         bottom: keyboardSize.height, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        self.view.layoutIfNeeded()
    }
}
