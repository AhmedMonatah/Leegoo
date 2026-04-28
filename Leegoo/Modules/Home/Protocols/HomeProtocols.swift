import Foundation


protocol HomePresenterProtocol: AnyObject {
    func numberOfItems() -> Int
    func item(at index: Int) -> Sport
    func didSelectItem(at index: Int)
}
