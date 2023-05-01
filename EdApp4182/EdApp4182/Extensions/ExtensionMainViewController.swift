//
//  ExtensionMainViewController.swift
//  EdApp4182
//
//  Created by NikoS on 06.07.2022.
//

import UIKit
import CoreData

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return charactersController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CharacterCollectionViewCell
        cell.setupCell(with: CharacterViewCellViewModel(with: charactersController, indexPath: indexPath))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectCharacterAtIndex(index: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 5 {
            fetchCharacters()
        }
    }
    
    func selectCharacterAtIndex (index: IndexPath) {
        let character = charactersController.object(at: index)
        guard selectedCharacter != character  else { return }
        charactersView.selectItem(at: index, animated: true, scrollPosition: .centeredHorizontally)
        selectedCharacter = character
        comicsController = createComicsController()
        comicsView.reloadOnMain()
        if comicsController?.fetchedObjects?.isEmpty ?? true {
            fetchComics()
        }
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowsCount = comicsController?.sections?[section].numberOfObjects ?? 0
        guard let allLoaded = selectedCharacter?.loadingState?.isAllLoaded else { return rowsCount }
        let isEmpty = rowsCount == 0
        messageLabel.isHidden = !isEmpty
        if !Reachability.isConnectedToNetwork() {
            if isEmpty {
                messageLabel.text = "Please try later with Internet connection."
            }
        }
        if isEmpty && allLoaded {
            messageLabel.text = "No comics for \(selectedCharacter?.name ?? "this character")."
        }
        return rowsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! ComicTableViewCell
        guard let controller = comicsController else { return UITableViewCell() }
        cell.setupCell(with: ComicViewCellViewModel(with: controller, indexPath: indexPath))
        cell.isUserInteractionEnabled = false
        return cell
    }
}

extension MainViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard Reachability.isConnectedToNetwork() else { return }
        guard serverIsAvailable else { return }
        guard let id = selectedCharacter?.id else { return }
        let position = scrollView.contentOffset.y
        if position > (comicsView.contentSize.height - 200 - scrollView.frame.size.height) {
            comicsViewModel.fetchComicsData(characterId: Int(id)) { error, hasChanges  in
                if let error = error {
                    print(error)
                    return
                } else if hasChanges {
                    self.comicsView.reloadOnMain()
                }
            }
        }
    }
}

extension MainViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard controller == charactersController else { return }
        switch type {
        case .insert, .delete:
            charactersView.reloadData()
            charactersView.performBatchUpdates {} completion: { _ in
                if self.selectedCharacter == nil && !(controller.fetchedObjects ?? []).isEmpty {
                    self.selectCharacterAtIndex(index: IndexPath(item: 0, section: 0))
                }
            }
            
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == comicsController {
            comicsView.reloadOnMain()
        }
    }
}
