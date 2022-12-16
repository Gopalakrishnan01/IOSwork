//
//  ProfileViewController.swift
//  Chat
//
//  Created by zs-mac-6 on 01/11/22.
//

import UIKit

class ProfileAndSettingsViewController: UIViewController {
    
    private let settingOptions = ProfileAndSettingsModel.options
    private let viewControllers = ProfileAndSettingsModel.viewControllers
    
    private var settingsTableView : UITableView = {
        let tableView = UITableView()
        return tableView
        
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.config()
    }
    
    private func config(){
       
        //MARK: Table View
        
        self.view.addSubview(settingsTableView)
        
        settingsTableView.translatesAutoresizingMaskIntoConstraints = false
        settingsTableView.showsVerticalScrollIndicator = false
        settingsTableView.register(UINib(nibName: "ProfileAndSettingsTableViewCell", bundle: nil), forCellReuseIdentifier: ProfileAndSettingsTableViewCell.identifier)
        settingsTableView.tableHeaderView = ProfileAndSettingsHeaderView(frame: CGRect(x: 0, y: 0, width:UIScreen.main.bounds.width , height: 100))
        
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        
        NSLayoutConstraint.activate([
            settingsTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            settingsTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            settingsTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            settingsTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        
        ])
        
        //MARK: Navigation Bar
        
        let leftLabel = UIButton()
        leftLabel.setTitle("Settings", for: .normal)
        leftLabel.titleLabel?.font=UIFont.boldSystemFont(ofSize: 20)
        leftLabel.setTitleColor(.label, for: .normal)
        leftLabel.contentHorizontalAlignment = .left
        let leftLbl = UIBarButtonItem(customView: leftLabel)
        navigationItem.leftBarButtonItem = leftLbl
        
        
    }
    
   
    

}



extension ProfileAndSettingsViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        settingOptions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settingOptions[section].count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileAndSettingsTableViewCell.identifier,for: indexPath) as? ProfileAndSettingsTableViewCell else {
            return UITableViewCell ()
        }
        let name = settingOptions[indexPath.section][indexPath.row]
        cell.settingsImage.image = UIImage(named: name)
        cell.settingsName.text = name
        
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "\n"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let nextVC = viewControllers[indexPath.section][indexPath.row]
        if ((indexPath.section == 1) && (indexPath.row == 0)){
            (nextVC as! AccountsViewController).delegate = self
        }
        nextVC.title = settingOptions[indexPath.section][indexPath.row]
        nextVC.navigationItem .largeTitleDisplayMode = .always
        navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 20 : 5
    }
    
    
}

extension ProfileAndSettingsViewController: AccountsViewControllerDelegate{
    
    func logoutFromAccount() {
        
        navigationController?.popViewController(animated: false)
        tabBarController?.selectedIndex = 1
       
        
    }
    
    
}
