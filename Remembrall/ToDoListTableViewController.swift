//
//  ToDoListTableViewController.swift
//  Remembrall
//
//  Created by Samar Seth on 1/17/20.
//  Copyright © 2020 Samar Seth. All rights reserved.
//

import UIKit

class ToDoListTableViewController: UITableViewController {
    let defaults = UserDefaults.standard
    var toDoList: [String] = []
    var toDoDescriptions: [String] = []
    var points: Int?
    var completedTasks: Int?
    var selectedIndex: Int = 0
    var completedIndex: Int = 0
    var lastCompletedTaskDate: DateComponents?
    
    let userCalendar = Calendar.current
    let requestedComponents: Set<Calendar.Component> = [.year, .month,.day,.hour, .minute]
    
    // trophy explainers
    let remembrallExplainText: String = """
    You have unlocked the Remembrall Trophy for completing 10000
    tasks!
"""
    let sortingHatExplainText: String = """
    You have unlocked the Sorting Hat Trophy for getting 2500
    points!
"""
    let fawkesExplainText: String = """
    You have unlocked the Fawkes Phoenix Trophy for completing a
    task between 5:00 and 7:00 in the morning!
"""
    let timeTurnerExplainText: String = """
    You have unlocked the Time Turner Trophy for completing a
    task less than 1 minute before the day ends!
"""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let checklist = defaults.array(forKey: "toDoList") as? [String] {
            // successfully found the saved data
            toDoList = checklist
        } else {
            // No data saved, only runs the first time you start the app
            defaults.set([String](), forKey: "toDoList")
        }
        
        if let descriptions = defaults.array(forKey: "descriptions") as? [String] {
            // successfully found the saved data
            toDoDescriptions = descriptions
        } else {
            // No data saved, only runs the first time you start the app
            defaults.set([String](), forKey: "descriptions")
        }
        
        completedTasks = defaults.integer(forKey: "numberOfCompletedTasks")
        
        points = defaults.integer(forKey: "points")
        if let date = defaults.object(forKey: "lastCompletedTaskDate") as! Date? {
            lastCompletedTaskDate = userCalendar.dateComponents(requestedComponents, from: date)
        }
        
        navigationItem.leftBarButtonItem = editButtonItem
        }
        
        override func viewWillAppear(_ animated: Bool) {
            if let checklist = defaults.array(forKey: "toDoList") as? [String] {
                toDoList = checklist
            } else {
                defaults.set([String](), forKey: "toDoList")
            }
            
            if let descriptions = defaults.array(forKey: "descriptions") as? [String] {
                toDoDescriptions = descriptions
            } else {
                defaults.set([String](), forKey: "descriptions")
            }
            
            points = defaults.integer(forKey: "points")
            
            // setting and retreiving dates from UserDefaults
            // src: https://stackoverflow.com/questions/45946328/saving-time-in-userdefaults
            if let date = defaults.object(forKey: "lastCompletedTaskDate") as! Date? {
                lastCompletedTaskDate = userCalendar.dateComponents(requestedComponents, from: date)
            }
            
            tableView.reloadData()
        }

        override func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if section == 0 {
                return toDoList.count
            } else {
                return 0
            }
        }

        // populate tableViewController cells
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = tableView.dequeueReusableCell(withIdentifier:
            "checkList", for: indexPath) as! InitialTableViewCell
            
            let toDoItem = toDoList[indexPath.row]
            
            cell.name!.text = "\(toDoItem)"
            
            cell.showsReorderControl = true
            cell.accessoryType = .disclosureIndicator;
            
            completedIndex = indexPath.row
            
            return cell
        }
        
        // deals with the actions when a cell is selected
        override func tableView(_ tableView: UITableView, didSelectRowAt
        indexPath: IndexPath) {
            let toDoItem = toDoList[indexPath.row]
            print("\(toDoItem) \(indexPath)")
            
            selectedIndex = indexPath.row
            defaults.set(selectedIndex, forKey: "index")
            
            // src: https://stackoverflow.com/questions/22759167/how-to-make-a-push-segue-when-a-uitableviewcell-is-selected
            // used to transition to the detail view for each cell
            self.performSegue(withIdentifier: "giveDetail", sender: self)
        }
        
        // transition to edit mode
        @IBAction func editButtonTapped(_ sender: Any) {
            let tableViewEditingMode = tableView.isEditing
            tableView.setEditing(!tableViewEditingMode, animated: true)
        }
        
        // deals with data adjustments for cells that are moved around
        override func tableView(_ tableView: UITableView, moveRowAt
        fromIndexPath: IndexPath, to: IndexPath) {
            let movedItem = toDoList.remove(at: fromIndexPath.row)
            toDoList.insert(movedItem, at: to.row)
            defaults.set(toDoList, forKey: "toDoList")
            
            let movedDescription = toDoDescriptions.remove(at: fromIndexPath.row)
            toDoDescriptions.insert(movedDescription, at: to.row)
            defaults.set(toDoDescriptions, forKey: "descriptions")

            tableView.reloadData()
        }
        
        // deals with the completion of the task
        @IBAction func deleteButtonPressed(_ sender: Any) {
            toDoList.remove(at: selectedIndex)
            print(selectedIndex)
            toDoDescriptions.remove(at: selectedIndex)
            defaults.set(toDoList, forKey: "toDoList")
            defaults.set(toDoDescriptions, forKey: "descriptions")
            
            // Finding time src: https://stackoverflow.com/questions/24070450/how-to-get-the-current-time-as-datetime
            let currentDateTime = Date()
            
            let dateTimeComponents = userCalendar.dateComponents(requestedComponents, from: currentDateTime)
            
            // adjust number of completed tasks
            completedTasks! += 1
            defaults.set(completedTasks, forKey: "numberOfCompletedTasks")
            
            // update last completed task date and apply point bonus if necessary
            if completedTasks == 1 {
                lastCompletedTaskDate = dateTimeComponents
                // fix this
                defaults.set(currentDateTime, forKey: "lastCompletedTaskDate")
            } else {
                // runs if you complete multiple tasks on the same day
                if lastCompletedTaskDate!.year == dateTimeComponents.year && lastCompletedTaskDate!.month == dateTimeComponents.month && lastCompletedTaskDate!.day == dateTimeComponents.day {
                    points! += 100
                }
                
                lastCompletedTaskDate = dateTimeComponents
                // fix this
                defaults.set(currentDateTime, forKey: "lastCompletedTaskDate")
            }
            
            // adjust points w/ bonuses for number of completed tasks and time that it was completed
            if completedTasks! % 10000 == 0 {
                points! += 10000
            } else if completedTasks! % 1000 == 0 {
                points! += 1000
            } else if completedTasks! % 500 == 0 {
                points! += 500
            } else if completedTasks! % 100 == 0 {
                points! += 150
            } else if completedTasks! % 25 == 0 {
                points! += 100
            } else if completedTasks! % 10 == 0 {
                points! += 50
            }
            
            points! += 100
    
            defaults.set(points, forKey: "points")
            
            // unlock trophies
            if completedTasks == 10000 {
                defaults.set(true, forKey: "remembrallTrophyUnlocked")
                
                let alert = UIAlertController(title: "Congratulations!", message: self.remembrallExplainText, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            if points! >= 2500 && !defaults.bool(forKey: "sortingHatTrophyUnlocked") {
                defaults.set(true, forKey: "sortingHatTrophyUnlocked")
                
                let alert = UIAlertController(title: "Congratulations!", message: self.sortingHatExplainText, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            if dateTimeComponents.hour == 23 && dateTimeComponents.minute == 59 {
                defaults.set(true, forKey: "timeTurnerTrophyUnlocked")
                
                let alert = UIAlertController(title: "Congratulations!", message: self.timeTurnerExplainText, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else if dateTimeComponents.hour! <= 7 && dateTimeComponents.hour! >= 5 {
                defaults.set(true, forKey: "fawkesTrophyUnlocked")
                
                let alert = UIAlertController(title: "Congratulations!", message: self.fawkesExplainText, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            tableView.reloadData()
        }
        
        // modified code from: https://medium.com/@ronm333/delete-and-reorder-tableview-rows-ba5900379662
        // used to implement the delete functionality of the edit button
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                toDoList.remove(at: indexPath.row)
                toDoDescriptions.remove(at: indexPath.row)
                
                defaults.set(toDoList, forKey: "toDoList")
                defaults.set(toDoDescriptions, forKey: "descriptions")
                
                tableView.reloadData()
            }
        }
}
