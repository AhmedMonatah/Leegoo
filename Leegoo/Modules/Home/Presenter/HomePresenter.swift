import Foundation

class HomePresenter: HomePresenterProtocol {
    
        
    private let items: [Sport] = [
        Sport(title: "Football", imageName: "football"),
        Sport(title: "Basketball", imageName: "basketball"),
        Sport(title: "Tennis", imageName: "tennis"),
        Sport(title: "Cricket", imageName: "cricket")
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
