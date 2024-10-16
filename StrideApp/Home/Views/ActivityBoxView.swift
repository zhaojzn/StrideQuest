//
//  ActivityBoxView.swift
//  StrideApp
//
//  Created by Jason Zhao on 2024-10-15.
//

import SwiftUI


struct ActivityBoxView: View {
    
    @State var activity: Activity;
    
    
    var body: some View {
        ZStack(alignment: .leading){
            Color(uiColor: .systemGray6)
                .cornerRadius(15)
            VStack{
                HStack(alignment: .top){
                    VStack(alignment: .leading, spacing: 8){
                        Text(activity.title)
                        Text(activity.subtitle)
                            .font(.caption)
                    }

                    Spacer()
                    
                    Image(systemName: activity.image)
                        .foregroundColor(activity.tintColor)
                }
                Text(activity.amount)
                    .font(.title)
                    .bold()
                    .padding()
                
            }

        }
        
        
    }
}

#Preview {
    ActivityBoxView(activity: Activity(id: 0, title: "Today steps", subtitle: "Goal 10,000", image: "figure.run", tintColor: .green, amount: "6,123"))
}
