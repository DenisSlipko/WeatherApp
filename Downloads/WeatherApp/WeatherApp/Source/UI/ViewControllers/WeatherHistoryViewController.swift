//
//  WeatherHistoryViewController.swift
//  WeatherApp
//
//  Created by Denis on 02.04.18.
//  Copyright © 2018 Denis. All rights reserved.
//

import UIKit
import CoreData

final class WeatherHistoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<ManagedWeather> = {
        let fetchRequest = NSFetchRequest<ManagedWeather>(entityName: "\(ManagedWeather.self)")
        let dateDescriptor = NSSortDescriptor(key: #keyPath(ManagedWeather.date), ascending: false)
        fetchRequest.sortDescriptors = [dateDescriptor]
        let frc = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: .mr_default(),
            sectionNameKeyPath: #keyPath(ManagedWeather.dateDay),
            cacheName: nil)
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        setupTableView()
    }
    
    private func setupController() {
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func setupTableView() {
        let cellIdentifier = "\(WeatherHistoryTVCell.self)"
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    @IBAction func deleteAction(_ sender: UIBarButtonItem) {
        ManagedWeather.mr_truncateAll()
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
    }
}

// MARK: - UITableViewDataSource
extension WeatherHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "\(WeatherHistoryTVCell.self)"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! WeatherHistoryTVCell
        let weather = fetchedResultsController.object(at: indexPath)
        cell.configure(with: weather)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = fetchedResultsController.sections?[section]
        return section?.numberOfObjects ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
}

// MARK: - UITableViewDelegate
extension WeatherHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = fetchedResultsController.sections?[section] else { return nil}
        let nsDate = (section.objects ?? [])
            .flatMap {$0 as? ManagedWeather}
            .flatMap {$0.date}
            .first
        let date = nsDate as Date?
        return date?.readableHistory
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94.0
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension WeatherHistoryViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                tableView.moveRow(at: indexPath, to: newIndexPath)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(.init(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(.init(integer: sectionIndex), with: .fade)
        case .update:
            tableView.reloadSections(.init(integer: sectionIndex), with: .fade)
        default:
            break
        }
    }
}
