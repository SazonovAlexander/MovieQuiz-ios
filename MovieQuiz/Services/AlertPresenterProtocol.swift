import Foundation


protocol AlertPresenterProtocol {
    var delegate: AlertPresenterDelegate? {get set}
    func showAlert(model: AlertModel)
}
