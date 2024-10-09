//
//  FirebaseIntroApp.swift
//  FirebaseIntro
//
//  Created by Nicholas Nieminen Jönsson on 2024-09-30.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct FirebaseIntroApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var dbConnection = DbConnection()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(dbConnection)
        }
    }
}

/*
 -StateObject använder vi när vi instansierar en instans som vi vill att swiftUI ska lyssna på.
 -När vi passerar den runtom bland våra komponeneter så hänvisar vi till den med anotationen @ObservedObject.
 -För att en instans av ett objekt ska kunna funka med @StateObject måste instansen konforma till @ObservableObject.
 */
