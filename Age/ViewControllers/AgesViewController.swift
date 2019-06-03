//
//  ViewController.swift
//  Age
//
//  Created by Amin on 2019-04-12.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import UIKit
import CoreData

class AgesViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.green
        DatabaseManager.shared.birthdaysFetchResultsController.delegate = self
    }

}

extension AgesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return DatabaseManager.shared.birthdaysFetchResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DatabaseManager.shared.birthdaysFetchResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "age", for: indexPath) as! AgeTableViewCell
        cell.birthday = DatabaseManager.shared.birthdaysFetchResultsController.object(at: indexPath).birthday
        return cell
    }
    
}

extension AgesViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) { }
    
}

