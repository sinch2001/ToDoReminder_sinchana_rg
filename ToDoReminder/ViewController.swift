//
//  ViewController.swift
//  ToDoReminder
//
//  Created by Sinchana R G on 15/10/23.
//

import UserNotifications
import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    
    //var models = [MyReminder]()
    var reminderList : [ReminderTable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(NSHomeDirectory())
        table.delegate = self
        table.dataSource = self
      
        do {

                    reminderList = try RUtility.instance.getRemindersList()

                    if (reminderList.count == 0)

                    {

                        table.isHidden = true
                     }

                    self.table.reloadData()

                  print(reminderList.count)

                }catch{

                    print("error")

                }
    }
    
    @IBAction func didTapAdd(_ sender: Any) {
        //show add vc
        
        guard let vc = storyboard?.instantiateViewController(identifier: "add") as? AddVC else{
            return
        }
        
        vc.title = "New Reminder"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { title, body , date in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
                let new = ReminderTable()
                self.reminderList.append(new)
                self.table.reloadData()
                

           }
            
        }
    navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        do {

                    reminderList = try RUtility.instance.getRemindersList()

                    if (reminderList.count == 0)

                    {

                        table.isHidden = true
                     }

                    self.table.reloadData()

                  print(reminderList.count)

                }catch{

                    print("error")

                }
    }
        
    
    
    

    
    
    @IBAction func didTapNotify(_ sender: Any) {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {success ,error in
            if success{
                self.scheduleNotify()
            }
            else if error != nil {
                print("error occured")
            }
        })
    }
    
    func scheduleNotify(){

        let content = UNMutableNotificationContent()
        content.title = "Hello Reminder"
        content.sound = .default
        content.body = "This is Reminder that your task should be viewed"

        let targetDate = Date().addingTimeInterval(10)

        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate),
        repeats: false)

        let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            
            
            if error != nil {
                print("something went wrong")
            }
        })
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") { _, _, _ in
            
                
            let rem = self.reminderList[indexPath.row]
            
            self.reminderList.remove(at: indexPath.row)
            self.table.deleteRows(at: [indexPath], with: .automatic)
            do
            {
                try RUtility.instance.deleteReminder(remToDelete: rem)
            }catch{
                print("error")
            }
            
            
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        

        //cell.textLabel?.text = models[indexPath.row].title
        
        let reminder = reminderList[indexPath.row]
        
        cell.textLabel?.text = reminder.title
//        cell.detailTextLabel?.text = reminder.body
       // cell.detailTextLabel?.text = "type: \(reminder.type ?? "")"
        
        
        
        
       let selDate = reminder.date!
        
        

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM, dd , YYYY at hh:mm a"
        let dateString = formatter.string(from: selDate)
        
        cell.detailTextLabel?.text = dateString
        
        
            return cell
    }
}
    


struct MyReminder {
    let title : String
    let date : Date
    let identifier : String
}
