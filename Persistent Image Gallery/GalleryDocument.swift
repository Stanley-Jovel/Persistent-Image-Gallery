import UIKit

class GalleryDocument: UIDocument {
  var gallery: Gallery?
  
  override func contents(forType typeName: String) throws -> Any {
    return gallery?.json ?? Data()
  }
    
  override func load(fromContents contents: Any, ofType typeName: String?) throws {
    if let json = contents as? Data {
      gallery = Gallery(json: json)
    }
  }
}
