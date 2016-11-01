import UIKit

public extension UICollectionView {

    public func dequeueReusableCell<T:UICollectionViewCell>(type: T.Type, indexPath: IndexPath) -> T {
        let collectionCell  : T
        let cellIdentifier  = String(describing: T.self)

        if let _ = Bundle(for: T.classForCoder()).path(forResource: cellIdentifier, ofType: "nib") {
            self.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
            collectionCell = self.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath as IndexPath) as! T
        }
        else {
            collectionCell = T()
        }
        return collectionCell

    }
}
