import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomBackButtonIfNeeded()
    }
    
    private func setupCustomBackButtonIfNeeded() {
        guard let nav = navigationController,
              nav.viewControllers.first !== self else {
            return
        }
        
        let button = UIButton(type: .system)
        let image = UIImage(named: "nav_logo")
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        button.contentMode = .scaleAspectFit
        
        let barButton = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = barButton
        navigationItem.hidesBackButton = true
    }
    
    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }
}
