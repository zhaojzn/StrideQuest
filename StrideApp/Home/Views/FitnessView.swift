//
//  FitnessView.swift
//  StrideApp
//
//  Created by Jason Zhao on 2024-10-15.
//

import SwiftUI




struct FitnessView: View {
    
    @State var fitness: Fitness
    
    var body: some View {
        HStack{
            Image(systemName: fitness.image)
                .resizable()
                .scaledToFit()
                .frame(width: 48, height: 48)
                .foregroundColor(fitness.tintColor)
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
            VStack(spacing: 18){
                HStack{
                    Text(fitness.title)
                        .font(.title3)
                        .bold()
                    Spacer()
                    Text(fitness.duration)
                }
                HStack{
                    Text(fitness.date)
                    Spacer()
                    Text(fitness.calories)

                }
                
            }
            .padding()
        }
    }
}

#Preview {
    FitnessView(fitness: Fitness(title: "Running", image: "figure.run", duration: "24 mins", date: "Aug 3", calories: "342 kCal", tintColor: .green))
}
