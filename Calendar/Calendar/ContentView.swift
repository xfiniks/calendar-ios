import SwiftUI

struct ContentView: View {
    
    var body: some View {
        ScrollView {
            VStack {
                Text("2022")
                YearView()
                Text("2023")
                YearView()
                Text("2024")
                YearView()
            }
        }
    }
    
}
