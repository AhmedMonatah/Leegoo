import UIKit

class HomeViewController: UIViewController ,HomeViewProtocol {
    
    var presenter: HomePresenterProtocol!
    
    @IBOutlet weak var sportsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = HomePresenter(view: self)
        sportsCollectionView.delegate = self
        sportsCollectionView.dataSource = self
    }
    
    func navigateToLeagues(with sport: Sport) {
        let storyboard = UIStoryboard(name: "Home_Storyboard", bundle: nil)
           
        guard let leaguesVC = storyboard.instantiateViewController(withIdentifier: "LeaguesVC") as? LeaguesViewController else {
            return
        }
           
        let presenter = LeaguesPresenter(view: leaguesVC, title: sport.title, selectedSport: sport)
        leaguesVC.presenter = presenter
    
        navigationController?.pushViewController(leaguesVC, animated: true)
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding: CGFloat = 12
        let spacing: CGFloat = 12

        let isLandscape = collectionView.bounds.width > collectionView.bounds.height
        let itemsPerRow: CGFloat = isLandscape ? 4 : 2

        let totalSpacing = (padding * 2) + ((itemsPerRow - 1) * spacing)
        let width = (collectionView.bounds.width - totalSpacing) / itemsPerRow
        let height = width * 1.5
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }
    
}
