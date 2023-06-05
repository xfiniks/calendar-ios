import SwiftUI

struct YearView: View {
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(0..<50) { week in
                    WeekLine(weekDataProvider: WeekDataProvider(numOfTheWeek: week))
                }
            }
        }
    }
    
}
