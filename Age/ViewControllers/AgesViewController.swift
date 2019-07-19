//
//  ViewController.swift
//  Age
//
//  Created by Amin on 2019-04-12.
//  Copyright © 2019 Amin Heidari. All rights reserved.
//

import UIKit
import CoreData
import AgeData

class AgesViewController: BaseViewController {
    
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Constants/Types
    
    // MARK: - Static
    
    // MARK: - API
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DatabaseManager.shared.birthdaysFetchResultsController.delegate = self
        
        StoreObserver.shared.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Section 1 will be done through the fetch results controller.
        tableView.reloadSections([0], with: .automatic)
        
        timer = Timer.scheduledTimer(
            withTimeInterval: Constants.AgeCalculation.refreshInterval,
            repeats: true,
            block: { [weak self] (timer) in
                guard let _ = self else {
                    timer.invalidate()
                    return
                }
                
                self?.refreshAllAges()
        })
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        timer?.invalidate()
        timer = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? NewAgeViewController {
            destination.scenario = sender as? NewAgeViewController.Scenario
        }
    }
    
    deinit {
        DatabaseManager.shared.birthdaysFetchResultsController.delegate = nil
    }
    
    // MARK: - Properties
    
    private var timer: Timer?
    
    // MARK: - Outlets
    
    // MARK: - Methods
    
    private func refreshAllAges() {
        tableView.visibleCells.forEach { (cell) in
            (cell as? AgeTableViewCell)?.refreshAge()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func addBirthdayButtonTapped(_ sender: Any) {
        switch StoreObserver.shared.productStatus(forProductId: Constants.Store.multipleAgeProductId) {
        case .pending:
            return
        case .purhcased, .restored:
            performSegue(withIdentifier: "add-age", sender: NewAgeViewController.Scenario.newEntity)
        case .unknown:
            performSegue(withIdentifier: "multiples-promo", sender: nil)
        }
    }

}

// MARK: - UITableViewDataSource

extension AgesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Section 0: Default age.
        // Section 1: Entity ages.
        return 1 + (DatabaseManager.shared.birthdaysFetchResultsController.sections?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return DatabaseManager.shared.birthdaysFetchResultsController.fetchedObjects?.count ?? 0
        default:
            fatalError("Not supported!")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Age", for: indexPath) as! AgeTableViewCell
        
        switch indexPath.section {
        case 0:
            cell.item = (SuiteDefaultsUtil.defaultBirthday!, true)
        case 1:
            cell.item = (DatabaseManager.shared.birthdaysFetchResultsController.fetchedObjects![indexPath.row].birthday!, false)
        default:
            fatalError("Not supported!")
        }
        
        cell.refreshAge()
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension AgesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        switch indexPath.section {
        case 0:
            performSegue(withIdentifier: "add-age", sender: NewAgeViewController.Scenario.editDefault)
        case 1:
            if let birthdayEntity = DatabaseManager.shared.birthdaysFetchResultsController.fetchedObjects?[indexPath.row] {
                performSegue(withIdentifier: "add-age", sender: NewAgeViewController.Scenario.editEntity(birthdayEntity: birthdayEntity))
            }
        default:
            fatalError("Not supported!")
        }
    }
    
}

// MARK: - NSFetchedResultsControllerDelegate

extension AgesViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        // TODO: See if you can animate things here.
        // https://developer.apple.com/documentation/coredata/nsfetchedresultscontrollerdelegate
    }
    
}

// MARK: - StoreObserverDelegate

extension AgesViewController: StoreObserverDelegate {
    
    func storeObserverRestoreDidSucceed() { }
    
    func storeObserverDidReceiveMessage(_ message: String) { }
    
    func storeObserverTransactionsStateUpdated() {
        // Probably quite a bit of state tracking here, but totally worth it!
        // Adjust the add-age button (perhaps a loading when )
    }
    
}

