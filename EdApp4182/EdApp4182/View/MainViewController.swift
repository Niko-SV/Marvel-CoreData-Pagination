//
//  ViewController.swift
//  EdApp4182
//
//  Created by NikoS on 05.07.2022.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    
    @IBOutlet weak var charactersView: UICollectionView!
    @IBOutlet weak var comicsView: UITableView!
    
    var charactersPagination = CharactersPagination()
    var comicsViewModel = ComicsPagination()
    var context = CoreDataStack.shared.mainContext
    var messageLabel = MessageLabel()
    var selectedCharacter: CharacterCoreDataModel?
    var serverIsAvailable = true
    
    let imageDownloader = ImageProvider()
    let service = NetworkService()
    
    lazy var charactersController: NSFetchedResultsController<CharacterCoreDataModel> = {
        //Initialize Fetch Request
        var request = CharacterCoreDataModel.fetchRequest()
        //Add Sort Descriptors
        request.sortDescriptors = [.init(key: "name", ascending: true)]
        //Initialize Fetched Results Controller
        //Configure Fetched Results Controller
        return .init(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }()
    var comicsController: NSFetchedResultsController<ComicCoreDataModel>?
    
    func createComicsController() -> NSFetchedResultsController<ComicCoreDataModel>? {
        guard let id = selectedCharacter else { return nil }
        let request = ComicCoreDataModel.fetchRequest(character: id)
        request.sortDescriptors = [.init(key: "title", ascending: true)]
        let resultController = NSFetchedResultsController<ComicCoreDataModel>(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try resultController.performFetch()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
        resultController.delegate = self
        return resultController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        charactersController.delegate = self
        do {
            try charactersController.performFetch()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
        service.makeTestFetch() { [weak self] in
            guard let self = self else { return }
            self.serverIsAvailable = $0
            if self.serverIsAvailable == false {
                DispatchQueue.main.async {
                    Alert().showFirstOfflineLoadAlert(view: self, title: AppConstants.serverUnavailableTitle, message: AppConstants.backendErrorDataMessage)
                }
            }
        }
        
        if isFirstCharacterNotLoaded() {
            if Reachability.isConnectedToNetwork() {
                fetchCharacters()
            } else {
                Alert().showFirstOfflineLoadAlert(view: self, title: AppConstants.noInternetConnectionTitle, message: AppConstants.noDataMessage)
            }
        } else {
            selectCharacterAtIndex(index: IndexPath(item: 0, section: 0))
        }
        comicsView.backgroundView = messageLabel
    }
    
    func isFirstCharacterNotLoaded() -> Bool {
        let request = CharacterCoreDataModel.fetchRequest()
        let result = try? context.fetch(request)
        return (result ?? []).isEmpty
    }
    
    func fetchCharacters() {
        //Fetching characters into CollectionView
        charactersPagination.fetchCharactersData { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    func fetchComics() {
        //Fetch comicsData into TableView
        //Selecting a character
        guard let id = selectedCharacter?.id else { return }
        //Fetching data for this character
        comicsViewModel.fetchComicsData(characterId: Int(id)) { [weak self] error, _ in
            //Error handling
            if let _ = error {
                DispatchQueue.main.async {
                    //Show label instead of tableView
                    self?.messageLabel.isHidden = false
                }
            } else {
                //Reload data
                self?.comicsView.reloadOnMain()
            }
        }
    }
}
