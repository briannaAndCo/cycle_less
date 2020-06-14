import Flutter
import UIKit
import UserNotifications

@available(iOS 10.0, *)
public class SwiftSchedulerPlugin: NSObject, FlutterPlugin {
    private var NOTIFICATION_ID_BASE: String = "SchedulerNotification"

    public static func register(with registrar: FlutterPluginRegistrar) {
        // Create the channel that allows flutter to call this plugin.
        let channel = FlutterMethodChannel(name: "scheduler", binaryMessenger: registrar.messenger())
        let instance = SwiftSchedulerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)

        // Set up the notification center to delegate the alerts to the plugin.
        UNUserNotificationCenter.current().delegate = instance

        // Request notification permissions.
        instance.requestNotificationAuthorization()
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [AnyObject] else {
            result("iOS could not recognize flutter arguments in method: (sendParams)")
            return
        }

        switch call.method {
        case "scheduleNotification":
            let hour = args[0] as! Int
            let minute = args[1] as! Int
            let title = args[2] as! String
            let text = args[3] as! String
            scheduleNotification(hour: hour, minute: minute, title: title, text: text)
        case "cancelNotification":
            cancelNotification()
        case "cancelNextNotification":
            cancelNextNotification()
        case "createAndroidChannel":
            break // Not valid for iOS
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    func scheduleNotification(hour: Int, minute: Int, title: String, text: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = text
        content.sound = UNNotificationSound.default

        var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        dateComponents.hour = hour
        dateComponents.minute = minute

        let times = createRepeatingAlarmTimes(date: dateComponents)

        for (index, time) in times.enumerated() {
            // Create the trigger as a repeating event.
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: time, repeats: true)
            // Create a unique identifier with a standard base
            let request = UNNotificationRequest(identifier: NOTIFICATION_ID_BASE + String(index),
                                                content: content, trigger: trigger)

            // add our notification request
            UNUserNotificationCenter.current().add(request)
        }
    }

    func cancelNotification() {
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { notifications in
            for notification in notifications {
                // Only modify notifications that have the ID as part of the identifier
                if notification.identifier.contains(self.NOTIFICATION_ID_BASE) {
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notification.identifier])
                }
            }
        })
    }

    func cancelNextNotification() {
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { notifications in

            for notification in notifications {
                // Only modify notifications that have the ID as part of the identifier
                if notification.identifier.contains(self.NOTIFICATION_ID_BASE) {
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notification.identifier])

                    let trigger: UNCalendarNotificationTrigger = notification.trigger! as! UNCalendarNotificationTrigger

                    // Calculate the same time but one day in the future and create a trigger
                    let today = Date()
                    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)
                    var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: tomorrow!)
                    // Get the same hour and minutes of the original trigger
                    dateComponents.hour = trigger.dateComponents.hour
                    dateComponents.minute = trigger.dateComponents.minute

                    // Re-create the trigger
                    let newTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

                    let request = UNNotificationRequest(identifier: notification.identifier, content: notification.content, trigger: newTrigger)

                    UNUserNotificationCenter.current().add(request)
                }
            }

        })
    }

    private func createRepeatingAlarmTimes(date: DateComponents) -> [DateComponents] {
        var times: [DateComponents] = []

        times.append(date)

         for minute in stride(from: 5, to: 30, by: 5) {
            // Copy the existing date struct as a baseline
            var nextDate = date

            let totalMinutes: Int = (date.minute ?? 0) + minute
            let nextMinute: Int = totalMinutes % 60

            nextDate.minute = nextMinute

            if totalMinutes - nextMinute > 0 {
                let nextHour = (date.hour ?? 0) + 1
                nextDate.hour = nextHour >= 24 ? 0 : nextHour
            } else {
                nextDate.hour = date.hour
            }

            times.append(nextDate)
        }
        return times
    }

    private func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound]) { success, error in
            if success {
                // TODO:
            } else if let error = error {
                // TODO:
                print(error.localizedDescription)
            }
        }
    }
}

@available(iOS 10.0, *)
extension SwiftSchedulerPlugin: UNUserNotificationCenterDelegate {
    @available(iOS 10.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
}
