//
//  NotificationManager.swift
//  Hodie
//
//  Created by 김현식 on 2021/02/22.
//

import Foundation
import UserNotifications

struct Noti {
    var id: String
    var title: String
}

class LocalNotificationManager {
    var notifications = [Noti]()
    func requestPermission() {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .badge, .alert]) { granted, error in
                if granted == true && error == nil {
                    self.scheduleNotifications()
                    // We have permission!
                }
        }
    }

    func addNotification(title: String) {
        notifications.append(Noti(id: "Id", title: title))
    }

    func scheduleNotifications() {
        for notification in notifications {
            let content = UNMutableNotificationContent()
            content.title = notification.title
            var date = DateComponents()
            date.hour = 15
            date.minute = 03
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
                print("Scheduling notification with id: \(notification.id)")
            }
        }
    }

    func schedule() {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
          switch settings.authorizationStatus {
          case .notDetermined:
              self.requestPermission()
          case .authorized, .provisional:
              self.scheduleNotifications()
          default:
              break
          }
      }
  }
}
