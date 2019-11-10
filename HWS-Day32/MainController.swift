//
//  MainController.swift
//  HWS-Day32
//
//  Created by Steven Jemmott on 09/11/2019.
//  Copyright © 2019 Lagom Exp. All rights reserved.
//

import UIKit

class MainController: UITableViewController {
    
    private var items = [String]()
    private let reuseIdentifier = "cellId"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        navigationItem.rightBarButtonItems = [addButton, shareButton]
        navigationController?.navigationBar.tintColor = .systemBlue
        title = "Shopping List"
        configureTableView()
    }
    
    fileprivate func configureTableView() {
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - TableView Delegate & Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = .secondarySystemBackground
        
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            items.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    @objc private func add() {
        print("Show alert to add item")
        let ac = UIAlertController(title: "Add Item", message: "Add your item below", preferredStyle: .alert)
        var textField = UITextField()
        textField.autocapitalizationType = .words
        textField.keyboardType = .alphabet
        
        ac.addTextField { alertTextField in
            alertTextField.placeholder = "Add your item here. Eg Grapes"
            textField = alertTextField
        }
        
        let addAction = UIAlertAction(title: "Add to list", style: .default) { action in
            print("Get item name from textfield and add it to items array")
            if let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty{
                self.items.insert(text.capitalized, at: 0)
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: [.init(row: 0, section: 0)], with: .automatic)
                self.tableView.endUpdates()
            }
            self.dismiss(animated: true, completion: nil)
        }
        
        ac.addAction(addAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            self.dismiss(animated: true, completion: nil)
        }
        
        ac.addAction(cancelAction)
        self.present(ac, animated: true, completion: nil)
    }
    
    @objc private func share() {
        let list = items.joined(separator: "\n")
        let avc = UIActivityViewController(activityItems: [list], applicationActivities: nil)
        
        present(avc, animated: true, completion: nil)
    }
}

import SwiftUI

struct MainPreview: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: UIViewControllerRepresentableContext<MainPreview.ContainerView>) -> UIViewController {
            let navController = UINavigationController(rootViewController: MainController())
            return navController
        }
        
        func updateUIViewController(_ uiViewController: MainPreview.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<MainPreview.ContainerView>) {
            
        }
    }
}
