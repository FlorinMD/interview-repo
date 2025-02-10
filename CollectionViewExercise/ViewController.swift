import UIKit

class ViewController: UIViewController {

    @IBAction func buttonTapped(_ sender: Any) {
        let vc = MountainsViewController()
        vc.delegate = self
//
//        if #available(iOS 15.0, *) {
//            if let presentationController = vc.presentationController as? UISheetPresentationController {
//                presentationController.detents = [.medium(), .large()]
//                present(vc, animated: true)
//            }
//        } else {
//            present(vc, animated: true)
//        }

        present(vc, animated: true)
    }
}

extension ViewController: MountainsDelegate {
    func didSelect() {
        print("did select")
    }
}
