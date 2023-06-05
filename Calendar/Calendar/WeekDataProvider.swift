import SwiftUI

class WeekDataProvider: ObservableObject {
    
    @Published var allWeeks : [Week] = []
    @Published var currentDate : Date = Date()
    @Published var currentIndex : Int = 0
    @Published var indexToUpdate : Int = 0
    @Published var allWeeksOfTheYearByDate: [[Date]] = []
    @Published var allWeeksOfTheYear: [Week] = []
    
    @Published var currentWeek: [Date] = []
    @Published var nextWeek : [Date] = []
    @Published var previousWeek : [Date] = []
    var numOfTheWeek: Int
    
    
    init(numOfTheWeek: Int) {
        self.numOfTheWeek = numOfTheWeek
        fetchCurrentWeek()
        fetchPreviousNextWeek()
        appendAll()
        fetchWeekOfTheYear(year: 1)
        (1..<allWeeksOfTheYearByDate.count).forEach { day in
            allWeeksOfTheYear.append(Week(id: day, date: allWeeksOfTheYearByDate[day]))
        }
        self.allWeeks = []
        self.allWeeks.append(allWeeksOfTheYear[numOfTheWeek])
    }
    
    
    
    func appendAll() {
        var newWeek = Week(id: 0, date: currentWeek)
        allWeeks.append(newWeek)
        newWeek = Week(id: 2, date: nextWeek)
        allWeeks.append(newWeek)
        newWeek = Week(id: 1, date: previousWeek)
        allWeeks.append(newWeek)
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
        addWeek(index: indexToUpdate, value: value)
    }
    
    
    
    func addWeek(index: Int, value: Int) {
        allWeeks[0].date.removeAll()
        var calendar = Calendar(identifier: .gregorian)
        let today = Calendar.current.date(byAdding: .day, value: 7 * value , to: self.currentDate)!
        self.currentDate = today
        
        calendar.firstWeekday = 7
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        
        (1...7).forEach{ day in
            if let weekday = calendar.date(byAdding: .day, value: day, to: startOfWeek){
                allWeeks[0].date.append(weekday)
            }
            
        }
        
    }
    
    
    
    func isToday(date:Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(currentDate, inSameDayAs: date)
    }
    
    
    
    
    
    func dateToString(date: Date,format: String)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    
    
    func fetchCurrentWeek(){
        let today = currentDate
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 7
        
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        
        (1...7).forEach{ day in
            if let weekday = calendar.date(byAdding: .day, value: day, to: startOfWeek){
                currentWeek.append(weekday)
            }
        }
    }
    
    func fetchWeekOfTheYear(year: Int) {
        let cal = Calendar.current
        (1...51).forEach{ week in
            var curWeek = [Date]()
            let firstDay = DateComponents(calendar: cal, year: year, month: week*7 / 30, day: 1)
            let startOfWeek = cal.date(from: cal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: cal.date(from: firstDay)!))!
            (1...7).forEach{ day in
                if let weekday = cal.date(byAdding: .day, value: day, to: startOfWeek){
                    curWeek.append(weekday)
                }
            }
            allWeeksOfTheYearByDate.append(curWeek)
        }
    }
    
    
    
    func fetchPreviousNextWeek(){
        nextWeek.removeAll()
        let nextWeekToday = Calendar.current.date(byAdding: .day, value: 7, to: currentDate )!
    
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 7
        let startOfWeekNext = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: nextWeekToday))!
        
        (1...7).forEach{ day in
            if let weekday = calendar.date(byAdding: .day, value: day, to: startOfWeekNext){
                nextWeek.append(weekday)
            }
        }
        
        previousWeek.removeAll()
        let previousWeekToday = Calendar.current.date(byAdding: .day, value: -7, to: currentDate)!
        let startOfWeekPrev = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: previousWeekToday))!
        
        (1...7).forEach{ day in
            if let weekday = calendar.date(byAdding: .day, value: day, to: startOfWeekPrev){
                previousWeek.append(weekday)
            }
            
        }
        
    }
    
}
