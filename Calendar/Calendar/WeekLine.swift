import SwiftUI

struct WeekLine: View {
    
    @StateObject var weekDataProvider: WeekDataProvider
    @State private var snappedItem = 0.0
    @State private var draggingItem = 0.0

    var body: some View {
        ZStack {
            ForEach(weekDataProvider.allWeeks) { week in
                VStack{
                    HStack(spacing: 20) {
                        ForEach(0..<7) { index in
                            VStack(spacing: 50) {
                                Text(weekDataProvider.dateToString(date: week.date[index], format: "EEE"))
                                    .font(.system(size:14))
                                    .fontWeight(.semibold)
                                    .frame(maxWidth:.infinity)
                            
                                Text(weekDataProvider.dateToString(date: week.date[index], format: "d"))
                                    .font(.system(size:14))
                                    .frame(maxWidth:.infinity)
                            }
                            .onTapGesture {
                                weekDataProvider.currentDate = week.date[index]
                            }
                        }
                    }

                    .frame(width: UIScreen.main.bounds.width)
                    .background(
                        Rectangle()
                            .fill(.white)
                    )
                }
                .offset(x: myXOffset(week.id), y: 0)
                .zIndex(1.0 - abs(distance(week.id)) * 0.1)
                .padding(.horizontal, 50)
            }
        }
        .frame(maxHeight:.infinity , alignment : .top)
        .padding(.top,50)
        .gesture(
            DragGesture()
                .onChanged { value in
                    draggingItem = snappedItem + value.translation.width / 400
                }
                .onEnded { value in
                    withAnimation {
                        if value.predictedEndTranslation.width > 0 {
                            draggingItem = snappedItem + 1
                        } else {
                            draggingItem = snappedItem - 1
                        }

                        snappedItem = draggingItem
                        weekDataProvider.update(index: Int(snappedItem))

                    }

                }

        )

    }

    

    func distance(_ item: Int) -> Double {
        return (draggingItem - Double(item)).remainder(dividingBy: Double(weekDataProvider.allWeeks.count))
    }

    

    func myXOffset(_ item: Int) -> Double {
        let angle = Double.pi * 2 / Double(weekDataProvider.allWeeks.count) * distance(item)
        return sin(angle) * 200
    }

}
