//
//  ViewController.swift
//  Movies
//
//  Created by Sheroz Nazhmudinov on 2/10/18.
//  Copyright © 2018 Sheroz Nazhmudinov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var categoriesTableView: UITableView!
    
    let categories = ["Popular", "Now playing", "Top rated", "Upcoming"]

    var selectedCategory: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let categoryCell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryViewCell
        let category = categories[indexPath.row]
        
        categoryCell.setCategory(category: category)
        return categoryCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.row]
        
        if let destinationViewController = storyboard?.instantiateViewController(withIdentifier: "movieList") as? MovieListViewController {
            destinationViewController.selectedCategory = selectedCategory
            navigationController?.show(destinationViewController, sender: self)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

