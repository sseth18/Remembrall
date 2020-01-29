//
//  DashboardViewController.swift
//  Remembrall
//
//  Created by Samar Seth on 1/22/20.
//  Copyright © 2020 Samar Seth. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    
    // label outlets
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var completedTasksLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    
    // trophy image outlets
    @IBOutlet weak var remembrallTrophy: UIImageView?
    @IBOutlet weak var sortingHatTrophy: UIImageView?
    @IBOutlet weak var timeTurnerTrophy: UIImageView?
    @IBOutlet weak var fawkesTrophy: UIImageView?
    
    // explainer texts for alerts
    let hagridTrophyExplainText: String = """
        Thank you for joining the Remembrall To-Do List App!
        For starting your journey to a productive life you have
        unlocked the 'Hagrid' Trophy!
    """
    
    let infoText: String = """
    This is a To-Do List/Game hybrid app.


- For every task you complete you receive points

- You increase in rank depending on the number of tasks you complete

- You earn trophies for reaching certain milestones or completing tasks in a specific way

- Completing multiple tasks in one day results in an extra 100 pts for each additional task after the first

- You need to complete a task at least once every 2 days or you will begin to lose 200 points every time you open the app without completing a task
"""
    
    // other
    var defaults = UserDefaults.standard
    var completedTasks: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // populate number of points
        if let numberOfPoints = defaults.integer(forKey: "points") as Int? {
            pointsLabel.text = "\(numberOfPoints)\nPoints"
        } else { // only runs the first time you open the app
            pointsLabel.text = "\(0)\nPoints"
            defaults.set(0, forKey: "points")
            defaults.set(false, forKey: "remembrallTrophyUnlocked")
            defaults.set(false, forKey: "sortingHatTrophyUnlocked")
            defaults.set(false, forKey: "fawkesTrophyUnlocked")
            defaults.set(false, forKey: "timeTurnerTrophyUnlocked")
            
            // hagrid image src: https://i.ytimg.com/vi/C_KSsKK49k8/maxresdefault.jpg
            let alert = UIAlertController(title: "Congratulations!", message: self.hagridTrophyExplainText, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        // populate number of completed tasks label
        if let completedTasks = defaults.integer(forKey: "numberOfCompletedTasks") as Int? {
            completedTasksLabel.text = "\(completedTasks)"
            self.completedTasks = completedTasks
        } else {
            defaults.set(0, forKey: "numberOfCompletedTasks")
            completedTasksLabel.text = String(0)
        }
        
        // populate ranking
        if completedTasks! >= 10000 {
            rankLabel.text = "Dumbledore"
        } else if completedTasks! >= 5000 {
            rankLabel.text = "Hermione"
        } else if completedTasks! >= 1000 {
            rankLabel.text = "Harry"
        } else if completedTasks! >= 500 {
            rankLabel.text = "Lupin"
        } else if completedTasks! >= 100 {
            rankLabel.text = "Ginny"
        } else if completedTasks! >= 50 {
            rankLabel.text = "Ron"
        } else if completedTasks! >= 25 {
            rankLabel.text = "Luna"
        } else if completedTasks! >= 10 {
            rankLabel.text = "Neville"
        } else {
            rankLabel.text = "Hagrid"
        }
        
        // setting images for trophies
        // src: https://stackoverflow.com/questions/45812502/how-to-set-an-image-in-imageview-swift-3
        if defaults.bool(forKey: "remembrallTrophyUnlocked") {
            // image src: https://66.media.tumblr.com/tumblr_m6ys3vYJs91r39i1to1_500.jpg
            remembrallTrophy!.image = UIImage(named: "remembrall")!
        }
        
        if defaults.bool(forKey: "sortingHatTrophyUnlocked") {
            // image src: https://i.etsystatic.com/18351663/r/il/69a8b0/1745498353/il_570xN.1745498353_2xl6.jpg
            sortingHatTrophy!.image = UIImage(named: "sorting hat")!
        }
        
        if defaults.bool(forKey: "timeTurnerTrophyUnlocked") {
            // image src: https://data.whicdn.com/images/102799244/original.jpg
            timeTurnerTrophy!.image = UIImage(named: "time turner")!
        }
        
        if defaults.bool(forKey: "fawkesTrophyUnlocked") {
            // image src: https://i.pinimg.com/474x/b1/e6/86/b1e68606d53d45015de42414ef15f242--quizz-zodiac-signs.jpg
            fawkesTrophy!.image = UIImage(named: "fawkes")!
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        pointsLabel.text = "\(defaults.integer(forKey: "points"))\nPoints"
        
        completedTasksLabel.text = "\(defaults.integer(forKey: "numberOfCompletedTasks"))"
        
        self.completedTasks = defaults.integer(forKey: "numberOfCompletedTasks")
        
        if completedTasks! >= 10000 {
            rankLabel.text = "Dumbledore"
        } else if completedTasks! >= 5000 {
            rankLabel.text = "Hermione"
        } else if completedTasks! >= 1000 {
            rankLabel.text = "Harry"
        } else if completedTasks! >= 500 {
            rankLabel.text = "Lupin"
        } else if completedTasks! >= 100 {
            rankLabel.text = "Ginny"
        } else if completedTasks! >= 50 {
            rankLabel.text = "Ron"
        } else if completedTasks! >= 25 {
            rankLabel.text = "Luna"
        } else if completedTasks! >= 10 {
            rankLabel.text = "Neville"
        } else {
            rankLabel.text = "Hagrid"
        }
        
        if defaults.bool(forKey: "remembrallTrophyUnlocked") {
            remembrallTrophy!.image = UIImage(named: "remembrall")!
        }
        
        if defaults.bool(forKey: "sortingHatTrophyUnlocked") {
            sortingHatTrophy!.image = UIImage(named: "sorting hat")!
        }
        
        if defaults.bool(forKey: "timeTurnerTrophyUnlocked") {
            timeTurnerTrophy!.image = UIImage(named: "time turner")!
        }
        
        if defaults.bool(forKey: "fawkesTrophyUnlocked") {
            fawkesTrophy!.image = UIImage(named: "fawkes")!
        }
    }
    
    // displays instructions for the app
    @IBAction func infoButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Instructions", message: self.infoText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
