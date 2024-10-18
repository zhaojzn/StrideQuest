//
//  HomeViewModel.swift
//  StrideApp
//
//  Created by Jason Zhao on 2024-10-16.
//

import Foundation
@MainActor
class HomeViewModel: ObservableObject {
    
    let healthManager = HealthManager.shared
    
    
    @Published var activites = [Activity]()
    @Published var  workouts = [
        Fitness(title: "Running", image: "figure.run", duration: "24 mins", date: "Aug 3", calories: "342 kCal", tintColor: .green),
        Fitness(title: "Walking", image: "figure.walk", duration: "25 mins", date: "Aug 4", calories: "342 kCal", tintColor: .blue),
        Fitness(title: "Running", image: "figure.run", duration: "26 mins", date: "Aug 5", calories: "342 kCal", tintColor: .purple)
    ]
    
    var mockActivites = [
        Activity(title: "Today steps", subtitle: "Goal 10,000", image: "figure.run", tintColor: .green, amount: "6,123"),
        Activity(title: "Today steps", subtitle: "Goal 10,000", image: "figure.run", tintColor: .blue, amount: "6,123"),
        Activity(title: "Today steps", subtitle: "Goal 10,000", image: "figure.run", tintColor: .red, amount: "6,123"),
        Activity(title: "Today steps", subtitle: "Goal 10,000", image: "figure.run", tintColor: .purple, amount: "6,123")
    ]
        var mockRecent = [
            Fitness(title: "Running", image: "figure.run", duration: "24 mins", date: "Aug 3", calories: "342 kCal", tintColor: .green),
            Fitness(title: "Walking", image: "figure.walk", duration: "25 mins", date: "Aug 4", calories: "342 kCal", tintColor: .blue),
            Fitness(title: "Running", image: "figure.run", duration: "26 mins", date: "Aug 5", calories: "342 kCal", tintColor: .purple)
        ]
    
    @Published var calories: Double = 0
    @Published var activeMinutes: Double = 0
    @Published var standHours: Int = 0

    init(){
        Task{
            do{
                try await healthManager.requestHealthKitAccess()
                fetchTodayCalories()
                fetchExerciseTime()
                fetchStandHours()
                fetchTodaysSteps()
                fetchCurrentWeekActivites()
            }catch{
                print(error.localizedDescription)
            }
        }

        
    }
    


    
    func fetchTodayCalories(){
        healthManager.fetchTodayCaloriesBurned { result in
            switch result{
                case .success(let calories):
                    DispatchQueue.main.async{
                        self.calories = calories
                        let activity = Activity(title: "Calories burned", subtitle: "today", image: "flame", tintColor: .green, amount: calories.formattedNumberString())
                        self.activites.append(activity)
                    }

            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    func fetchExerciseTime(){
        healthManager.fetchExerciseTime { result in
            switch result{
            case .success(let exercise):
                DispatchQueue.main.async {
                    self.activeMinutes = exercise
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }    }
    func fetchStandHours(){
        healthManager.fetchStandHours { result in
            switch result{
            case .success(let hours):
                DispatchQueue.main.async {
                    self.standHours = hours
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    
    // MARK: Fitness Activity
    func fetchTodaysSteps(){
        healthManager.fetchTodaySteps { result in
            switch result {
            case.success(let activity):
                DispatchQueue.main.async {
                    self.activites.append(activity)
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func fetchCurrentWeekActivites(){
        healthManager.fetchCurrentWeekWorkoutStats { result in
            switch result {
            case.success(let activites):
                DispatchQueue.main.async {
                    self.activites.append(contentsOf: activites)
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func fetchRecentWorkouts(){
        healthManager.fetchWorkoutsForMonth(month: Date()) { result in
            switch result {
            case.success(let fitness):
                DispatchQueue.main.async {
                    self.workouts = fitness
                }
            case .failure(let failure):
                print(failure.localizedDescription )
            }
        }
    }
}
    
