//
//  ProfileViewController.swift
//  fyt
//
//  Created by Jason Lobo on 4/21/23.
//

import UIKit
import HealthKit
import Charts

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var HeartRateLabel: UILabel!
    @IBOutlet weak var StepsLabel: UILabel!
    @IBOutlet weak var ActiveLabel: UILabel!
    @IBOutlet weak var SleepLabel: UILabel!
    @IBOutlet weak var DistanceLabel: UILabel!
    @IBOutlet weak var FloorClimedLabel: UILabel!
    @IBOutlet weak var SwimmingLabel: UILabel!

    @IBOutlet weak var ChartUIView: UIView!
    
    var healthStore = HKHealthStore()
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.authorizeHealthkit()

        // Do any additional setup after loading the view.
        // Adding fyt. logo to the navbar
        let logoView = UIView(frame: CGRect(x: 0, y: 0, width: 90, height: 45))
        // Create an image view with the image you want to display
        let logoImageView = UIImageView(image: UIImage(named: "fyt_logo"))
        logoImageView.contentMode = .scaleAspectFit
        // Set the frame of the image view to fit inside the custom view
        logoImageView.frame = CGRect(x: 0, y: 0, width: logoView.frame.width, height: logoView.frame.height)
        // Add the image view to the custom view
        logoView.addSubview(logoImageView)
        // Set the custom view as the title view of the navigation bar
        navigationItem.titleView = logoView
    }
    
    func authorizeHealthkit(){
        let read = Set([HKCategoryType.quantityType(forIdentifier: .stepCount)!,HKCategoryType.quantityType(forIdentifier: .heartRate)!,HKCategoryType.quantityType(forIdentifier: .distanceWalkingRunning)!,HKCategoryType.quantityType(forIdentifier: .flightsClimbed)!,HKCategoryType.quantityType(forIdentifier: .distanceSwimming)!,HKCategoryType.quantityType(forIdentifier: .activeEnergyBurned)!,HKCategoryType.categoryType(forIdentifier: .sleepAnalysis)!])
        let share = Set([HKCategoryType.quantityType(forIdentifier: .stepCount)!,HKCategoryType.quantityType(forIdentifier: .heartRate)!,HKCategoryType.quantityType(forIdentifier: .distanceWalkingRunning)!,HKCategoryType.quantityType(forIdentifier: .flightsClimbed)!,HKCategoryType.quantityType(forIdentifier: .distanceSwimming)!,HKCategoryType.quantityType(forIdentifier: .activeEnergyBurned)!, HKCategoryType.categoryType(forIdentifier: .sleepAnalysis)!])
        healthStore.requestAuthorization(toShare: share, read: read) { chk, error in
            if(chk){
                // Calling health kit functions
                print("permisssion granted")
                    self.getTodayTotalStepCounts()
                    self.getLatestHeartRate()
                    self.getTodayDistanceTravel()
                    self.getTodayFloorClimbed()
                    self.getTodayDistanceSwimming()
                    self.getTodayActiveEnergy()
                    self.getSleepAnalysis()
            }
        }
    }
    
    func getTodayTotalStepCounts(){
        guard let sampleType = HKCategoryType.quantityType(forIdentifier: .stepCount) else{
            return
        }
        
        let startDate = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        var interval = DateComponents()
        interval.day = 1
        let query = HKStatisticsCollectionQuery(quantityType: sampleType, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startDate, intervalComponents: interval)
        query.initialResultsHandler = {
            query, result, error in
            if let myresult = result {
                myresult.enumerateStatistics(from: startDate, to: Date()) { (statistics,value) in
                    if let count = statistics.sumQuantity(){
                        let val = count.doubleValue(for: HKUnit.count())
                        print("Total step taken today is \(val) steps")
                        
                        DispatchQueue.main.async{
                            self.StepsLabel.text = "\(Int(val)) steps"
                            
                        }
                     
                        
                    }
                }
            }
            
            
        }
        healthStore.execute(query)
    }
    
    func getLatestHeartRate(){
        
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
             return
         }
         
         let startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
         let predicate = HKQuery.predicateForSamples(withStart: startDate, end: nil, options: .strictEndDate)
         
         let observerQuery = HKObserverQuery(sampleType: sampleType, predicate: predicate) { query, completionHandler, error in
             if error != nil {
                 print("Error: \(error!.localizedDescription)")
                 return
             }
             
             self.fetchLatestHeartRate { heartRate in
                 DispatchQueue.main.async {
                     self.HeartRateLabel.text = "\(Int(heartRate))"
                 }
             }
             
             completionHandler()
         }
         
         healthStore.execute(observerQuery)
            
            
        }
    
    func fetchLatestHeartRate(completion: @escaping (Double) -> Void) {
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            return
        }
        
        let startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: nil, options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: 1, sortDescriptors: [sortDescriptor]) { query, results, error in
            guard let heartRateSample = results?.first as? HKQuantitySample else {
                return
            }
            
            let heartRate = heartRateSample.quantity.doubleValue(for: HKUnit(from: "count/min"))
            completion(heartRate)
        }
        
        healthStore.execute(query)
    }
    
    func getTodayActiveEnergy() {
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
            return
        }

        let startDate = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: nil, options: .strictEndDate)

        let observerQuery = HKObserverQuery(sampleType: sampleType, predicate: predicate) { query, completionHandler, error in
            if error != nil {
                print("Error: \(error!.localizedDescription)")
                return
            }

            self.fetchLatestActiveEnergy { activeEnergy in
                DispatchQueue.main.async {
                    self.ActiveLabel.text = "\(Int(activeEnergy)) kcal"
                }
            }

            completionHandler()
        }

        healthStore.execute(observerQuery)

        fetchLatestActiveEnergy { activeEnergy in
            DispatchQueue.main.async {
                self.ActiveLabel.text = "\(Int(activeEnergy)) kcal"
            }
        }
    }

    func fetchLatestActiveEnergy(completion: @escaping (Double) -> Void) {
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
            return
        }

        let startDate = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: nil, options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: 1, sortDescriptors: [sortDescriptor]) { query, results, error in
            guard let activeEnergySample = results?.first as? HKQuantitySample else {
                return
            }

            let activeEnergy = activeEnergySample.quantity.doubleValue(for: HKUnit.kilocalorie())
            completion(activeEnergy)
        }

        healthStore.execute(query)
    }
    
    func getSleepAnalysis() {
        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        let startDate = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: nil, options: .strictEndDate)
        
        let observerQuery = HKObserverQuery(sampleType: sleepType, predicate: predicate) { query, completionHandler, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            self.fetchSleepAnalysis(startDate: startDate) { sleepAnalysis in
                DispatchQueue.main.async {
                    self.SleepLabel.text = "\(sleepAnalysis)"
                }
            }
            
            completionHandler()
        }
        
        healthStore.execute(observerQuery)
        
        let anchoredQuery = HKAnchoredObjectQuery(type: sleepType, predicate: predicate, anchor: nil, limit: HKObjectQueryNoLimit) { query, samples, deletedObjects, anchor, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            self.fetchSleepAnalysis(startDate: startDate) { sleepAnalysis in
                DispatchQueue.main.async {
                    let sleepHours = Double(sleepAnalysis) / 3600.0
                    self.SleepLabel.text = String(format: "%.1f hours", sleepHours)
                }
            }
        }
        
        anchoredQuery.updateHandler = { query, samples, deletedObjects, anchor, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            self.fetchSleepAnalysis(startDate: startDate) { sleepAnalysis in
                DispatchQueue.main.async {
                    let sleepHours = Double(sleepAnalysis) / 3600.0
                    self.SleepLabel.text = String(format: "%.1f hours", sleepHours)
                }
            }
        }
        
        healthStore.execute(anchoredQuery)
    }

    func fetchSleepAnalysis(startDate: Date, completion: @escaping (Int) -> Void) {
        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: nil, options: .strictEndDate)
        
        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { query, samples, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            var totalSleepDuration = 0
            
            samples?.forEach { sample in
                let sleepAnalysis = sample as! HKCategorySample
                let value = sleepAnalysis.value
                if value == HKCategoryValueSleepAnalysis.asleepUnspecified.rawValue {
                    totalSleepDuration += Int(sleepAnalysis.endDate.timeIntervalSince(sleepAnalysis.startDate))
                }
            }
            
            completion(totalSleepDuration)
        }
        
        healthStore.execute(query)
    }
    
    func getTodayDistanceTravel(){
        guard let sampleType = HKCategoryType.quantityType(forIdentifier: .distanceWalkingRunning) else{
            return
        }

        let startDate = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        var interval = DateComponents()
        interval.day = 1
        let query = HKStatisticsCollectionQuery(quantityType: sampleType, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startDate, intervalComponents: interval)
        query.initialResultsHandler = {
            query, result, error in
            if let myresult = result {
                myresult.enumerateStatistics(from: startDate, to: Date()) { (statistics,value) in
                    if let count = statistics.sumQuantity(){
                        let val = count.doubleValue(for: HKUnit.mile())
                        let miles = String(format:"%.2f miles",val)
                        print("Total travel distance today is \(miles)")

                        DispatchQueue.main.async{
                            self.DistanceLabel.text = "\(miles)"

                        }


                    }
                }
            }

        }
        healthStore.execute(query)
    }
    
    
    func getTodayFloorClimbed(){
        guard let sampleType = HKCategoryType.quantityType(forIdentifier: .flightsClimbed) else{
            return
        }
        
        let startDate = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        var interval = DateComponents()
        interval.day = 1
        let query = HKStatisticsCollectionQuery(quantityType: sampleType, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startDate, intervalComponents: interval)
        query.initialResultsHandler = {
            query, result, error in
            if let myresult = result {
                myresult.enumerateStatistics(from: startDate, to: Date()) { (statistics,value) in
                    if let count = statistics.sumQuantity(){
                        let val = count.doubleValue(for: HKUnit.count())
                        print("Total floor climbed is \(val) floors")
                        
                        DispatchQueue.main.async{
                            self.FloorClimedLabel.text = "\(Int(val)) floors"
                            
                        }
                     
                        
                    }
                }
            }
            
        }
        healthStore.execute(query)
    }
    func getTodayDistanceSwimming(){
        guard let sampleType = HKCategoryType.quantityType(forIdentifier: .distanceSwimming) else{
            return
        }
        
        let startDate = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        var interval = DateComponents()
        interval.day = 1
        let query = HKStatisticsCollectionQuery(quantityType: sampleType, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startDate, intervalComponents: interval)
        query.initialResultsHandler = {
            query, result, error in
            if let myresult = result {
                myresult.enumerateStatistics(from: startDate, to: Date()) { (statistics,value) in
                    if let count = statistics.sumQuantity(){
                        let val = count.doubleValue(for: HKUnit.yard())
                        let yards = String(format:"%.2f yards",val)
                        print("Total swimming distance today is \(yards)")
                        
                        DispatchQueue.main.async{
                            self.SwimmingLabel.text = "\(yards)"
                            
                        }
                     
                        
                    }
                }
            }
            
        }
        healthStore.execute(query)
    }
}
