import UIKit
import Kingfisher

private let reuseIdentifier = "Cell"

class GalleryCollectionViewController:
  UICollectionViewController,
  UICollectionViewDelegateFlowLayout
{
  var gallery: Gallery?
  var document: GalleryDocument?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.addInteraction(UIDropInteraction(delegate: self))
    collectionView.dropDelegate = self
    collectionView.dragDelegate = self
    
    let gesture = UIPinchGestureRecognizer(target: self, action: #selector(didReceivePinchGesture))
    collectionView.addGestureRecognizer(gesture)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    document?.open { success in
      if success {
        self.title = self.document?.localizedName
        let gallery = self.document?.gallery ?? Gallery("Untitled")
        self.gallery = gallery
        self.collectionView.reloadData()
      }
    }
  }
  
  @IBAction func saveButtonTapped(_ sender: UIBarButtonItem? = nil) {
    document?.gallery = self.gallery
    if document?.gallery != nil {
      document?.updateChangeCount(.done)
    }
  }
  
  @IBAction func tapCloseButton(_ sender: UIBarButtonItem) {
    saveButtonTapped()
    dismiss(animated: true) {
      self.document?.close()
    }
  }
  
  public func deleteImage(at index: Int) {
    gallery?.images.remove(at: index)
    collectionView.reloadData()
  }
  
  var scale: CGFloat = 1.0
  @objc func didReceivePinchGesture(gesture: UIPinchGestureRecognizer) {
    var scaleStart: CGFloat = 1.0
    if (gesture.state == .began)
    {
      scaleStart = self.scale;
    }
    else if (gesture.state == .changed)
    {
      let newScale = gesture.scale < 0.3 ? 0.3 : gesture.scale
      self.scale = scaleStart * newScale
      self.collectionView.collectionViewLayout.invalidateLayout()
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: scale*64, height: scale*64)
  }
  
  // MARK: UICollectionViewDataSource
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return gallery?.images.count ?? 0
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: reuseIdentifier,
      for: indexPath
      ) as! GalleryCell
    
    let url = gallery?.images[indexPath.item]
    cell.imageView.kf.setImage(with: url!.imageURL)
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    performSegue(withIdentifier: "showImage", sender: indexPath)
  }
  
  override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    let item = gallery?.images.remove(at: sourceIndexPath.item)
    gallery?.images.insert(item!, at: destinationIndexPath.item)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if (segue.identifier == "showImage") {
      let vc = segue.destination as! ZoomedImageViewController
      let indexPath = sender as! IndexPath
      
      let url = gallery?.images[indexPath.item]
      KingfisherManager.shared.retrieveImage(
        with: url!.imageURL,
        options: nil,
        progressBlock: nil,
        completionHandler: { result in
          vc.backgroundImage = result.value?.image
      }
      )
    }
  }
}
