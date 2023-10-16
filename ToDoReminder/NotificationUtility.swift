//
//  NotificationUtility.swift
//  ToDoReminder
//
//  Created by Sinchana R G on 16/10/23.
//

import Foundation
import UserNotifications

 

class NotificationUtility{

    let notificationCenter = UNUserNotificationCenter.current()

    var isAuthorised = false

    

    init(){

        askAuthorisation()

    }

    

    

    func askAuthorisation(){

        notificationCenter.getNotificationSettings { setting in

            if setting.authorizationStatus == .authorized{

                print("Already authorized")

                self.isAuthorised = true

            }

            

            else{

                print("Not Authorized")

                self.notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { allowed, _ in

                    if allowed {

                        print("Permission Granted")

                        self.isAuthorised = true

                    }

                    else{

                        

                        print("Permission not Granted")

                        self.isAuthorised = false

                        

                    }

                }

            }

        }

    }

    

    func addNotification(notTitle: String, notType: String, notDate: Date){

        

        //1 create content

        let content = UNMutableNotificationContent()

        content.title = notTitle

        content.body = notType

        content.sound = .default


      let selectedDate = notDate

//

//        let formatingDay = DateFormatter()

//        formatingDay.dateFormat = "dd"

//        let dayString = formatingDay.string(from: selectedDate)

//

//        let formatingMonth = DateFormatter()

//        formatingMonth.dateFormat = "MM"

//        let monthString = formatingMonth.string(from: selectedDate)

//

//        let formatingHour = DateFormatter()

//        formatingHour.dateFormat = "HH"

//        let hourString = formatingHour.string(from: selectedDate)

//

//        let formatingMin = DateFormatter()

//        formatingMin.dateFormat = "mm"

//        let minString = formatingMin.string(from: selectedDate)

//

//        let dayInt = Int(dayString) ?? 0

//        let monthInt = Int(monthString) ?? 0

//        let hourInt = Int(hourString) ?? 0

//        let minInt = Int(minString) ?? 0

//

//

//        print(hourString)

//

//        dcomponent.day = dayInt

//        dcomponent.month = monthInt

//        dcomponent.hour = hourInt

//        dcomponent.minute = minInt

        

        let newDate = selectedDate.addingTimeInterval(-10 * 60)

        

        var dComp = Calendar.current.dateComponents([.day,.month, .year, .hour, .minute], from: newDate)

        

//        dcomponent.day = 15

//        dcomponent.month = 10

//        dcomponent.hour = 0

//        dcomponent.minute = 5

        //2. Create Trigger

        let trigger = UNCalendarNotificationTrigger(dateMatching: dComp, repeats: false)

        

        //3. add request

        let req = UNNotificationRequest(identifier: "meeting", content: content, trigger: trigger)

        notificationCenter.add(req)

        

    }

}
