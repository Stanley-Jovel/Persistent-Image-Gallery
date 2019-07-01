import UIKit

class DeleteImageVIew: UIView, UIDropInteractionDelegate {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    self.addInteraction(UIDropInteraction(delegate: self))
  }
  
  func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
    return session.canLoadObjects(ofClass: NSString.self)
  }
  
  func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
    return UIDropProposal(operation: .move)
  }
  
  func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
    let droppedImageIndexPath = session.localDragSession?.items[0].localObject as! IndexPath
    let vc = session.localDragSession?.localContext as! GalleryCollectionViewController
    vc.deleteImage(at: droppedImageIndexPath.item)
  }
}
