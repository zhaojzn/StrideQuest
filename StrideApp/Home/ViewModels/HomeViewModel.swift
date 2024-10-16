//
//  HomeViewModel.swift
//  StrideApp
//
//  Created by Jason Zhao on 2024-10-16.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    let healthManager = HealthManager.shared
    
    var mockActivites = [
        Activity(id: 0, title: "Today steps", subtitle: "Goal 0,000", image: "figure.run", tintColor: .green, amount: "6,123"),
        Activity(id: 1, title: "Today steps", subtitle: "Goal 10,000", image: "figure.run", tintColor: .blue, amount: "6,123"),
        Activity(id: 2, title: "Today steps", subtitle: "Goal 10,000", image: "figure.run", tintColor: .red, amount: "6,123"),
        Activity(id: 3, title: "Today steps", subtitle: "Goal 10,000", image: "figure.run", tintColor: .purple, amount: "6,123")
    ]
    var mockRecent = [
        Fitness(id: 0, title: "Running", image: "figure.run", duration: "24 mins", date: "Aug 3", calories: "342 kCal", tintColor: .green),
        Fitness(id: 1, title: "Walking", image: "figure.walk", duration: "25 mins", date: "Aug 4", calories: "342 kCal", tintColor: .blue),
        Fitness(id: 2, title: "Running", image: "figure.run", duration: "26 mins", date: "Aug 5", calories: "342 kCal", tintColor: .purple)
    ]
    
    init(){
        Task{
            do{
                try await healthManager.requestHealthKitAccess()
                healthManager.fetchTodayCaloriesBurned { result in
                    switch result{
                        case .success(let success):
                            print(success)
                    case .failure(let failure):
                        print(failure.localizedDescription)
                    }
                }
                healthManager.fetchStandHours { result in
                    switch result{
                        case .success(let success):
                            print(success)
                    case .failure(let failure):
                        print(failure.localizedDescription)
                    }
                }
            }catch{
                print(error.localizedDescription)
            }
        }

        
    }
}
