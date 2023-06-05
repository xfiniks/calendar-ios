import SwiftUI

class YearDataProvider: ObservableObject {
    
    @Published var allYears: [Year] = []
    @Published var currentDate: Date = Date()
    @Published var currentIndex: Int = 0
    @Published var indexToUpdate: Int = 0
    

    @Published var currentYear: [Date] = []
    @Published var nextYear: [Date] = []
    @Published var previousYear: [Date] = []
    
    
    init() {
        fetchCurrentYear()
        fetchPreviousNextYear()
        appendAll()
    }
    
    
    
    func appendAll() {
        var newYear = Year(id: 0, date: currentYear)
        allYears.append(newYear)
        newYear = Year(id: 2, date: nextYear)
        allYears.append(newYear)
        newYear = Year(id: 1, date: previousYear)
        allYears.append(newYear)
    }
    
    func update(index : Int) {
        var value : Int = 0
        
        if index < currentIndex {
            value = 1
            if indexToUpdate ==  2 {
                indexToUpdate = 0
            } else {
                indexToUpdate = indexToUpdate + 1
            }
            
        } else {
            value = -1
            
            if indexToUpdate ==  0{
                indexToUpdate = 2
            } else {
                indexToUpdate = indexToUpdate - 1
                
            }
        }
        
        currentIndex = index
        addYear(index: indexToUpdate, value: value)
    }
    
    
    
    func addYear(index: Int, value: Int) {
        allYears[index].date.removeAll()
        var calendar = Calendar(identifier: .gregorian)
        let today = Calendar.current.date(byAdding: .day, value: 7 * value , to: self.currentDate)!
        self.currentDate = today
        
        calendar.firstWeekday = 7
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        
        (1...7).forEach{ day in
            if let weekday = calendar.date(byAdding: .day, value: day, to: startOfWeek){
                allYears[index].date.append(weekday)
            }
            
        }
        
    }
    
    
    
    func isToday(date:Date)->Bool{
        let calendar = Calendar.current
        return calendar.isDate(currentDate, inSameDayAs: date)
    }
    
    
    
    
    
    func dateToString(date: Date,format: String) -> String{
        
        let formatter = DateFormatter()
    
        formatter.dateFormat = format
        
        return formatter.string(from: date)
        
    }
    
    
    
    func fetchCurrentYear(){
        let today = currentDate
        let year = Calendar.current.component(.year, from: Date())
//        currentYear.append(year)
    }
    
    
    
    func fetchPreviousNextYear(){
        nextYear.removeAll()
        
        let nextWeekToday = Calendar.current.date(byAdding: .day, value: 7, to: currentDate )!
    
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 7

        let startOfWeekNext = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: nextWeekToday))!
        
        (1...7).forEach{ day in
            if let weekday = calendar.date(byAdding: .day, value: day, to: startOfWeekNext){
                nextYear.append(weekday)
            }
        }
        
        previousYear.removeAll()
        let previousWeekToday = Calendar.current.date(byAdding: .day, value: -7, to: currentDate)!
        let startOfWeekPrev = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: previousWeekToday))!
        
        (1...7).forEach{ day in
            if let weekday = calendar.date(byAdding: .day, value: day, to: startOfWeekPrev){
                previousYear.append(weekday)
            }
            
        }
        
    }
    
}
