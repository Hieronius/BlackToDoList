import UIKit

extension UIViewController {
    
    /// Показывает настраиваемый alert с текстом
    ///
    /// По умолчанию всегда доступна одна кнопка "Ок"
    ///
    /// - Parameters:
    ///   - title: заголовок
    ///   - message: сообщение
    ///   - isCancelButton: нужна ли кнопка "отмена" или только "ок"
    ///   - isOkDestructive: кнопка "Ок" красного цвета
    ///   - okButtonName: название кнопки "Ок"
    ///   - customButtons: добавить свой массив кнопок
    ///   - preferredStyle: стиль отображения
    ///   - sourceView: передать кнопку для отображения алерта около нее (для iPad)
    ///   - completion: замыкание для кнопки "Ок"
    func showAlert(title: String,
                   message: String,
                   isCancelButton: Bool? = nil,
                   isOkDestructive: Bool? = nil,
                   okButtonName: String? = nil,
                   
                   customButtons: [UIAlertAction] = [UIAlertAction](),
                   preferredStyle: UIAlertController.Style = .alert,
                   sourceView: UIView? = nil,
                   completion: (() -> Void)? = nil) {
        
        let okDefaultName = "Ок"
        let cancelDefaultName = "Отмена"
        
        func addActionSheetForiPad(actionSheet: UIAlertController) {
            if let popoverPresentationController = actionSheet.popoverPresentationController, let sourceView = sourceView {
                popoverPresentationController.sourceView = sourceView
                popoverPresentationController.sourceRect = sourceView.bounds
                popoverPresentationController.permittedArrowDirections = [.down, .up]
            }
        }
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: preferredStyle)
        
        var allButtons = [UIAlertAction]()
        
        if let okButtonName = okButtonName { //}, !okButtonName!.isEmpty {  //}, isOkDestructive != nil, isOkDestructive! {
            let name = okButtonName.isEmpty ? okDefaultName : okButtonName
            let style: UIAlertAction.Style = isOkDestructive == true ? .destructive : .default
            
            allButtons.append(UIAlertAction(title: name, style: style) { (_) in
                completion?()
            })
        }
        
        
        if !customButtons.isEmpty {
            allButtons += customButtons
        }
        
        if isCancelButton == true {
            // Когда preferredStyle == .cancel, то две дефолыне кнопки Ок и Отмена меняются местами
            let style: UIAlertAction.Style = preferredStyle == .alert ? .default : .cancel
            
            allButtons.append(UIAlertAction(title: cancelDefaultName, style: style))
        }
        
        for button in allButtons {
            alert.addAction(button)
        }
        
        if allButtons.isEmpty {
            alert.addAction(UIAlertAction(title: okDefaultName, style: .cancel) { (_) in
                completion?()
            })
        }
        
        addActionSheetForiPad(actionSheet: alert)
        
        present(alert, animated: true)
    }
}
 

