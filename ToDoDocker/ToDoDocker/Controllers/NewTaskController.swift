//
//  NewTaskController.swift
//  ToDoDocker
//
//  Created by Danillo on 07/12/2017.
//  Copyright © 2017 Danillo. All rights reserved.
//

import UIKit
import BFKit
import MBProgressHUD
import SwiftMessages
import DatePickerDialog

class NewTaskController: UIViewController {
    
    @IBOutlet weak var taskComplete: UISwitch!
    @IBOutlet weak var taskTitle: UITextField!
    @IBOutlet weak var taskDescription: UITextView!
    
    var taskResult = Result()
    var editTask = false
    //let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.taskTitle.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if editTask {
            taskTitle.text = taskResult.title
            taskDescription.text = taskResult.desc
            taskComplete.isOn = taskResult.isComplete!
        }
    }
    
    @IBAction func showDatePicker(_ sender: Any) {
        datePickerTapped()
    }
    
    func datePickerTapped() {
        var date: Date!
        if  editTask {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            date = dateFormatter.date(from: taskResult.expirationDate!)
        } else {
            date = Date()
        }
        DatePickerDialog().show(
            "Data de Expiração",
            doneButtonTitle: "Concluir",
            cancelButtonTitle: "Cancelar",
            defaultDate: date,
            datePickerMode: .date) {
                (date) -> Void in
                
                if let dt = date {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    self.taskResult.expirationDate = formatter.string(from: dt)
                }
        }
    }
    
    @IBAction func saveTask(_ sender: Any) {
        
        taskResult.title = taskTitle.text
        taskResult.desc = taskDescription.text
        taskResult.isComplete = taskComplete.isOn
        
        if validationFields() {
            editTask ? edit() : save()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func validationFields() -> Bool {
        
        var isValid = true
        
        if (taskResult.title == nil || (taskResult.title?.isEmpty)!) {
            isValid = false
            self.showAlert(title: "Alerta", body: "O campo título deve ser informado!", theme: Theme.warning)
        } else if (taskResult.desc == nil || (taskResult.desc?.isEmpty)!) {
            isValid = false
            self.showAlert(title: "Alerta", body: "O campo descrição deve ser informado!", theme: Theme.warning)
        } else if (taskResult.expirationDate == nil || (taskResult.expirationDate?.isEmpty)!) {
            isValid = false
            self.showAlert(title: "Alerta", body: "Informe uma data!", theme: Theme.warning)
        }
        
        return isValid
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
    
    func save() {
        if Reachability.isConnectedToNetwork(){
            self.showLoading()
            TasksService().saveTask(task: self.taskResult, onSuccess: { response in
                self.showAlert(title: "Sucesso", body: "Task criada com sucesso!", theme: Theme.success)
            }, onError: { error in
                self.showAlert(title: "Erro", body: "Ocorreu um erro a incluir task.", theme: Theme.error)
            }, always: {
                self.hideLoading()
            })
        } else {
            let myTask = ResultDB()
            myTask.title = taskResult.title
            myTask.desc = taskResult.desc
            myTask.expirationDate = taskResult.expirationDate
            myTask.isComplete = taskResult.isComplete!
            do {
                try Repository.bd.write {
                    Repository.bd.add(myTask)
                }
                self.showAlert(title: "Sucesso", body: "Task criada com sucesso!", theme: Theme.success)
            } catch let error as NSError {
                self.showAlert(title: "Erro", body: "Ocorreu um erro a incluir task.", theme: Theme.error)
                print(error)
            }
        }
    }
    
    func edit() {
        if Reachability.isConnectedToNetwork(){
            self.showLoading()
            TasksService().editTask(task: self.taskResult, onSuccess: { response in
                self.showAlert(title: "Sucesso", body: "Task editada com sucesso!", theme: Theme.success)
            }, onError: { error in
                self.showAlert(title: "Erro", body: "Ocorreu um erro a editar a task.", theme: Theme.error)
            }, always: {
                self.hideLoading()
            })
        } else {
            var myTask = ResultDB()
            myTask = Repository.bd.object(ofType: ResultDB.self, forPrimaryKey: self.taskResult.id)!
            do {
                try Repository.bd.write {
                    myTask.title = self.taskResult.title
                    myTask.desc = self.taskResult.desc
                    myTask.expirationDate = self.taskResult.expirationDate
                    myTask.isComplete = self.taskResult.isComplete!
                    Repository.bd.add(myTask, update: true)
                }
                self.showAlert(title: "Sucesso", body: "Task editada com sucesso!", theme: Theme.success)
            } catch let error as NSError {
                self.showAlert(title: "Erro", body: "Ocorreu um erro a editar a task.", theme: Theme.error)
                print(error)
            }
        }
    }
}
