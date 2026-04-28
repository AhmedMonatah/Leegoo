import UIKit

class HomeViewController: UIViewController {
    
    var presenter: HomePresenterProtocol = HomePresenter()
    
    @IBOutlet weak var sportsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sportsCollectionView.delegate = self
        sportsCollectionView.dataSource = self
    }
       
    
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HomeCell.identifier,
            for: indexPath
        ) as? HomeCell else {
            return UICollectionViewCell()
        }
        
        let item = presenter.item(at: indexPath.item)
        cell.configure(with: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectItem(at: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding: CGFloat = 12
        let spacing: CGFloat = 12
               
        let isLandscape = collectionView.frame.width > collectionView.frame.height
        let itemsPerRow: CGFloat = isLandscape ? 4 : 2
               
        let totalSpacing = (padding * 2) + ((itemsPerRow - 1) * spacing)
        let width = (collectionView.frame.width - totalSpacing) / itemsPerRow
                              
        return CGSize(width: width, height: 230)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}
