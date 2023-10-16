//
//  RUtility.swift
//  ToDoReminder
//
//  Created by Sinchana R G on 16/10/23.
//

import Foundation
import UIKit

struct RUtility{
    
    private init()
    {
        
    }
    static var instance = RUtility()
    
    
    var dbConText = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func addReminder(title : String , type : String , date : Date , body : String) throws

        {

            let rem = ReminderTable(context: dbConText)
            
            rem.title = title

            rem.body = body

            rem.date = date

            rem.type = type

            

            try dbConText.save()

           
            

        }
    func getRemindersList() throws -> [ReminderTable]

        {

        let fRequest = ReminderTable.fetchRequest()

        let result = try dbConText.fetch(fRequest)

                

                return result

            

        }
    func deleteReminder(remToDelete : ReminderTable) throws

        {

            dbConText.delete(remToDelete)

            try dbConText.save()

        }
    
}
