//
//  AddVC.swift
//  ToDoReminder
//
//  Created by Sinchana R G on 16/10/23.
//

import UIKit

class AddVC: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    
    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var bodyField: UITextView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var typeSC: UISegmentedControl!
    
    let notifyUtility = NotificationUtility()
    
    public var completion: ((String, String, Date) ->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.delegate = self
        bodyField.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButton))

}
    
    @objc func saveButton(_ sender: Any) {
        

        let titleText = titleField.text ?? ""
        let bodyText = bodyField.text ?? ""
        let targetDate = datePicker.date
        let typeField = typeSC.titleForSegment(at: typeSC.selectedSegmentIndex) ?? ""
        
        do{
            try RUtility.instance.addReminder(title: titleText, type: typeField, date: targetDate, body: bodyText)
            
            //try RUtility.instance.getRemindersList()
        }catch{
            print("error")
        }
        
        notifyUtility.addNotification(notTitle: titleText, notType: bodyText, notDate: targetDate)
        
        navigationController?.popViewController(animated: true)
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
