import Foundation
import UIKit
import Kingfisher

extension GalleryCollectionViewController: UIDropInteractionDelegate {
  func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
    return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
  }
  
  func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
    return UIDropProposal(operation: .copy)
  }
}

extension GalleryCollectionViewController: UICollectionViewDropDelegate {
  func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
    let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: gallery?.images.count ?? 0, section: 0)
    for item in coordinator.items {
      let placeholderContext = coordinator.drop(
        item.dragItem,
        to: UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: "DropPlaceholderCell"))
      
      item.dragItem.itemProvider.loadObject(ofClass: NSURL.self, completionHandler: { (provider, error) in
        if let url = provider as? URL {
          DispatchQueue.main.async {
            KingfisherManager.shared.retrieveImage(
              with: url.imageURL,
              options: nil,
              progressBlock: nil,
              completionHandler: { result in
                placeholderContext.commitInsertion(dataSourceUpdates: { insersionIndexPath in
                  self.gallery?.images.insert(url, at: insersionIndexPath.item)
                  self.collectionView.reloadData()
                })
            }
            )
          }
        } else {
          placeholderContext.deletePlaceholder()
        }
      })
    }
  }
}


extension GalleryCollectionViewController: UICollectionViewDragDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    itemsForBeginning session: UIDragSession,
    at indexPath: IndexPath
  ) -> [UIDragItem] {
    let itemProvider = NSItemProvider(object: String(indexPath.item) as NSString)
    let dragItem = UIDragItem(itemProvider: itemProvider)
    dragItem.localObject = indexPath
    session.localContext = self
    return [dragItem]
  }
}
