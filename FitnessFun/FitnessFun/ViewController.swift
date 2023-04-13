//
//  ViewController.swift
//  FitnessFun
//
//  Created by zhaos on 4/11/23.
//

import UIKit
import HealthKit

class ViewController: UIViewController {
    
    @IBOutlet weak var Steps: UILabel!
    
    
    let healthScore = HKHealthStore()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        authorizeHealthkit()
        // Do any additional setup after loading the view.
        
    }
    
    func authorizeHealthkit(){
        let read = Set([HKCategoryType.quantityType(forIdentifier: .stepCount)!,HKCategoryType.quantityType(forIdentifier: .heartRate)!])
        let share = Set([HKCategoryType.quantityType(forIdentifier: .stepCount)!,HKCategoryType.quantityType(forIdentifier: .heartRate)!])
        healthScore.requestAuthorization(toShare: share, read: read) { chk, error in
            if(chk){
                print("permisssion granted")
                self.getTodayTotalStepCounts()
                
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
                            self.Steps.text = "Total steps \(Int(val))"
                            
                        }
                     
                        
                    }
                }
            }
            
        }
        healthScore.execute(query)
    }


}

