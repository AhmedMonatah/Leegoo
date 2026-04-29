import Foundation

class HomePresenter: HomePresenterProtocol {
    
        
    private let items: [Sport] = [
        Sport(title: "FOOTBALL", imageName: "football"),
        Sport(title: "BASKETBALL", imageName: "basketball"),
        Sport(title: "TENNIS", imageName: "tennis"),
        Sport(title: "CRICKET", imageName: "cricket")
    ]
    
        
    func numberOfItems() -> Int {
        items.count
    }
        
    func item(at index: Int) -> Sport {
        items[index]
    }
        
    func didSelectItem(at index: Int) {
        let item = items[index]
        print(item.title)
    }
}
