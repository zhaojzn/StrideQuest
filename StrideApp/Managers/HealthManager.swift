//
//  HealthManager.swift
//  StrideApp
//
//  Created by Jason Zhao on 2024-10-16.
//

import Foundation
import HealthKit


extension Date{
    static var startOfDay: Date {
        let calender = Calendar.current
        return calender.startOfDay(for: Date())
    }
    static var startOfWeek: Date {
        let calender = Calendar.current
        var components = calender.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        components.weekday = 2
        return calender.date(from: components) ?? Date()
    }
    
    func fetchMonthStartAndEndDate() -> (Date, Date){
        let calender = Calendar.current
        let startDateComponent = calender.dateComponents([.year,.month], from: calender.startOfDay(for: self))
        
        let startDate = calender.date(from: startDateComponent) ?? self
        let endDate = calender.date(byAdding: DateComponents(month: 1, day: -1), to: startDate) ?? self
        return (startDate, endDate)
    }
    func formatWorkoutDate() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "MM d"
        return formatter.string(from: self)
    }
}


extension Double{
    func formattedNumberString() -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: self)) ?? "0"
    }
}

class HealthManager {
    
    static let shared = HealthManager()
    
    let healthStore = HKHealthStore()
    
    private init () {
        
        Task{
            do{
                try await requestHealthKitAccess()
            }catch{
                print(error.localizedDescription)
            }
        }
        
    }
    
    func requestHealthKitAccess() async throws{
        print("requesting")
        let calories = HKQuantityType(.activeEnergyBurned)
        let exercise = HKQuantityType(.appleExerciseTime)
        let stand = HKCategoryType(.appleStandHour)
        let steps =  HKQuantityType(.stepCount)
        let workouts = HKSampleType.workoutType()
        let healthTypes: Set = [calories,exercise,stand, steps, workouts]
        
        try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
        
    }
    
    func fetchTodayCaloriesBurned(completion: @escaping(Result<Double, Error>) -> Void){
        let calories = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: calories, quantitySamplePredicate: predicate){ _, results, error in
            guard let quantity = results?.sumQuantity(), error == nil else {
                completion(.failure(NSError()))
                return
            }
            let calorieCount = quantity.doubleValue(for: .kilocalorie())
            print(calorieCount)
            completion(.success(round(calorieCount * 10) / 10))
            
            
        }
        healthStore.execute(query)
        
    }
    
    func fetchExerciseTime(completion: @escaping(Result<Double, Error>) -> Void){
        let exercise = HKQuantityType(.appleExerciseTime)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: exercise, quantitySamplePredicate: predicate){ _, results, error in
            guard let quantity = results?.sumQuantity(), error == nil else {
                completion(.failure(NSError()))
                return
            }
            let exerciseTime = quantity.doubleValue(for: .minute())
            completion(.success(exerciseTime))
            
            
        }
        healthStore.execute(query)
        
    }
    
    func fetchStandHours(completion: @escaping(Result<Int, Error>) -> Void){
        let stand = HKCategoryType(.appleStandHour)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKSampleQuery(sampleType: stand, predicate: predicate, limit: HKObjectQueryNoLimit,
                                  sortDescriptors: nil) {_, results, error in
            guard let samples = results as? [HKCategorySample], error == nil else {
                completion(.failure(NSError()))
                return
                
            }
            
            
            let standCount = samples.filter({ $0.value == 0 }).count
            completion(.success(standCount))
            
        }
        healthStore.execute(query)
        
    }
    
    // MARK: Fitness Activity
    func fetchTodaySteps(completion: @escaping(Result<Activity, Error>) -> Void){
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate){ _, results, error in
            guard let quantity = results?.sumQuantity(), error == nil else {
                completion(.failure(NSError()))
                return
            }
            let steps = quantity.doubleValue(for:  .count())
            let activity = Activity(title: "Today steps", subtitle: "Goal : 800", image: "figure.walk", tintColor: .green, amount: steps.formattedNumberString())
            completion(.success(activity))
            
            
        }
        healthStore.execute(query)
    }
    
    func fetchCurrentWeekWorkoutStats(completion: @escaping(Result<[Activity], Error>) -> Void){
        
        let workout = HKSampleType.workoutType()
        let predicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())
        let query = HKSampleQuery(sampleType: workout, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { [weak self] _, results, error in
            guard let workouts = results as? [HKWorkout], let self = self, error == nil else {
                completion(.failure(URLError(.badURL)))
                return
                
                
            }
            
            var runningCount: Int = 0
            var strengthCount: Int = 0
            var soccerCount: Int = 0
            var basketballCount: Int = 0
            var stairsCount: Int = 0
            var kickboxingCount: Int = 0

            for workout in workouts {
                let duration = Int(workout.duration)/60
                if workout.workoutActivityType == .running {
                    runningCount += duration
                }
                if workout.workoutActivityType == .traditionalStrengthTraining {
                    strengthCount += duration
                }
                if workout.workoutActivityType == .soccer {
                    soccerCount += duration
                }
                if workout.workoutActivityType == .basketball {
                    basketballCount += duration
                }
                if workout.workoutActivityType == .stairClimbing {
                    stairsCount += duration
                }
                if workout.workoutActivityType == .kickboxing {
                    kickboxingCount += duration
                }
            }
            completion(.success(generateActivitiesFromDurations(running: runningCount, strength: strengthCount, soccer: soccerCount, basketball: basketballCount, stairs: stairsCount, kickboxing: kickboxingCount)))
            
        }
        
        healthStore.execute(query)
    }
    
    func generateActivitiesFromDurations(running: Int, strength: Int, soccer: Int, basketball: Int, stairs: Int, kickboxing: Int) -> [Activity] {
        return [Activity(title: "Running", subtitle: "This week", image: "figure.run", tintColor: .green, amount: "\(running) mins"),
        Activity(title: "Strength Training", subtitle: "This week", image: "dumbbell", tintColor: .green, amount: "\(strength) mins"),
        Activity(title: "Soccer", subtitle: "This week", image: "figure.soccer", tintColor: .green, amount: "\(soccer) mins"),
        Activity(title: "Basketball", subtitle: "This week", image: "figure.basketball", tintColor: .green, amount: "\(basketball) mins"),
        Activity(title: "Stairs", subtitle: "This week", image: "figure.stairs", tintColor: .green, amount: "\(stairs) mins"),
        Activity(title: "Kickboxing", subtitle: "This week", image: "figure.run", tintColor: .green, amount: "\(kickboxing) mins")]
        
    }
    
    // MARK: Recent Workouts
    func fetchWorkoutsForMonth(month: Date, completion: @escaping(Result<[Fitness], Error>) -> Void){
        let workout = HKSampleType.workoutType()
        let (startDate, endDate) = month.fetchMonthStartAndEndDate()
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: workout, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) {_, results, error in
            guard let workouts = results as? [HKWorkout], error == nil else {
                completion(.failure(URLError(.badURL)))
                return

            }
    
            
            let fitnessArray = workouts.map({Fitness(title: $0.workoutActivityType.name, image: $0.workoutActivityType.image, duration: "\(Int($0.duration)/60)", date: $0.startDate.formatWorkoutDate(), calories: $0.totalEnergyBurned?.doubleValue(for: .kilocalorie()).formattedNumberString() ?? "-", tintColor: $0.workoutActivityType.color)})
            completion(.success(fitnessArray))
        }
        healthStore.execute(query)
    }
    
    
    
}
