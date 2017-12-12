//
//  TasksTableViewController.swift
//  ToDoDocker
//
//  Created by Danillo on 07/12/2017.
//  Copyright © 2017 Danillo. All rights reserved.
//

import UIKit
import SwiftMessages

class TasksTableViewController: UITableViewController, UISearchBarDelegate {
    
    var tasks = Tasks()
    var taskSelected = Result()
    lazy var originalList: [Result] = []
    var isSearch = false
    
    @IBOutlet weak var btnSearch: UIBarButtonItem!
    @IBOutlet weak var btnAdd: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "taskCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.isSearch ? isSearch = false : getTasks()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.results?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TasksCell
        
        let content = tasks.results![indexPath.row]
        cell.lblTitle.text = content.title
        cell.lblDetail.text = content.desc
        cell.lblDate.text = content.expirationDate
        cell.imgComplete.isHidden = !content.isComplete!
        
        return cell
    }
    
    @IBAction func search(_ sender: Any) {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        searchBar.tintColor = UIColor.white
        searchBar.becomeFirstResponder()
        self.btnSearch.tintColor = UIColor.clear
        self.btnSearch.isEnabled = false
        self.btnAdd.tintColor = UIColor.clear
        self.btnAdd.isEnabled = false
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.taskSelected = tasks.results![indexPath.row]
        self.tableView.deselectRow(at: indexPath, animated: false)
        self.performSegue(withIdentifier: "editTask", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? NewTaskController {
            if segue.identifier == "editTask" {
                dest.editTask = true
                dest.taskResult = self.taskSelected
            }
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Search"
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = false
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.navigationItem.titleView = nil
        self.btnSearch.tintColor = UIColor.white
        self.btnSearch.isEnabled = true
        self.btnAdd.tintColor = UIColor.white
        self.btnAdd.isEnabled = true
        self.isSearch = false
        getTasks()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.isSearch = true
        if searchText.isEmpty {
            tasks.results = originalList
            self.tableView.reloadData()
            return
        }
        tasks.results = []
        for (result) in originalList {
            if (result.title?.uppercased().range(of: searchText.uppercased()) != nil) {
                tasks.results?.append(result)
            }
        }
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let result = self.tasks.results![indexPath.row]
            delete(result: result)
            self.tasks.results?.remove(result)
            self.originalList.remove(result)
            tableView.reloadData()
        }
    }
    
    func showAlert(title: String, body: String, theme: Theme) {
        SwiftMessages.show {
            let view = MessageView.viewFromNib(layout: MessageView.Layout.cardView)
            view.configureContent(title: title, body: body)
            view.button?.isHidden = true
            view.configureTheme(theme)
            view.configureDropShadow()
            return view
        }
    }
    
    func getTasks() {
        if Reachability.isConnectedToNetwork() {
            self.showLoading()
            TasksService().getTasks(
                onSuccess: {response in
                    if response?.httpStatusCode == 200{
                        self.tasks = (response?.body)!
                        self.originalList = self.tasks.results!
                        self.tableView.reloadData()
                    }
            },
                onError: { error in
                    self.showAlert(title: "Erro", body: "Não foi possível recuperar as Tasks!", theme: Theme.error)
            },
                always: {
                    self.hideLoading()
            })
        } else {
            self.tasks.results = []
            do {
                try Repository.bd.write {
                    Repository.bd.objects(ResultDB.self).forEach {
                        let result = Result()
                        result.title = $0.title
                        result.desc = $0.desc
                        result.expirationDate = $0.expirationDate
                        result.isComplete = $0.isComplete
                        result.id = $0.id
                        self.tasks.results?.append(result)
                    }
                }
            } catch let error as NSError {
                self.showAlert(title: "Erro", body: "Não foi possível recuperar as Tasks!", theme: Theme.error)
                print(error)
            }
            
            self.tableView.reloadData()
        }
    }
    
    func delete(result: Result) {
        if Reachability.isConnectedToNetwork() {
            self.showLoading()
            TasksService().delete(task: result,
                                  onSuccess: {response in
                                    self.showAlert(title: "Sucesso", body: "Task excluída com sucesso", theme: Theme.success)},
                                  onError: { error in
                                    self.showAlert(title: "Erro", body: "Não foi possível excluir a Task!", theme: Theme.error)}, always: {
                                        self.hideLoading()
            })
        } else {
            var resultDB = ResultDB()
            do {
                try Repository.bd.write {
                    resultDB = Repository.bd.object(ofType: ResultDB.self, forPrimaryKey: result.id)!
                }
            } catch let error as NSError {
                self.showAlert(title: "Erro", body: "Não foi possível recuperar a Task!", theme: Theme.error)
                print(error)
            }
            
            do {
                try Repository.bd.write {
                    Repository.bd.delete(resultDB)
                    self.showAlert(title: "Sucesso", body: "Task excluída com sucesso", theme: Theme.success)
                }
            } catch let error as NSError {
                self.showAlert(title: "Erro", body: "Não foi possível excluir a Task!", theme: Theme.error)
                print(error)
            }
        }
    }
    
}
