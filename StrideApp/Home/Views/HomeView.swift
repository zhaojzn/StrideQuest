//
//  HomeView.swift
//  StrideApp
//
//  Created by Jason Zhao on 2024-10-15.
//

import SwiftUI



struct HomeView: View {
    
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        ScrollView(showsIndicators: false){
            VStack(alignment: .leading){
                Text("StrideQuest")
                    .font(.largeTitle)
                    .padding()
                HStack{
                    Spacer()
                    VStack(alignment: .leading){
                        VStack(alignment: .leading, spacing: 8){
                            Text("Calories")
                                .font(.callout)
                                .bold()
                                .foregroundStyle(.red)
                            Text("\(String(format: "%.1f", viewModel.calories)) kcal")
                                .bold()
                        }
                        .padding(.bottom)
                        VStack(alignment: .leading, spacing: 8){
                            Text("Active")
                                .font(.callout)
                                .bold()
                                .foregroundStyle(.green)
                            Text("\(String(format: "%.1f", viewModel.activeMinutes)) minute(s)")
                                .bold()
                        }
                        .padding(.bottom)
                        
                        VStack(alignment: .leading, spacing: 8){
                            Text("Stand")
                                .font(.callout)
                                .bold()
                                .foregroundStyle(.blue)
                            Text("\(viewModel.standHours) hour(s)")
                                .bold()
                        }
                        
                    }
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                    Spacer()
                    
                    ZStack{
                        ProgressCircleView(progress: .constant(20), goal: 250, color: .red, width: 20)
                        ProgressCircleView(progress: .constant(70), goal: 200, color: .green, width: 20)
                            .padding(20)
                        ProgressCircleView(progress: .constant(20), goal: 200, color: .blue, width: 20)
                            .padding(40)
                    }
                    .border(Color.black)
                    .padding(.horizontal)
                    
                    Spacer()
                    
                }
                .padding()
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                
                
                
                HStack{
                    Text("Fitness Activity")
                        .font(.title2)
                    
                    Spacer()
                    
                    NavigationLink {
                        EmptyView()
                    } label: {
                        Text("Show more")
                            .padding(10)
                            .foregroundColor(.white)
                            .background(.blue)
                            .cornerRadius(20)
                            
                    }
                    .padding(.horizontal)
                }
                .padding(.horizontal)

            }
            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
            if !viewModel.activites.isEmpty {
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 2)){
                    ForEach(viewModel.activites, id: \.title) { activity in
                        ActivityBoxView(activity: activity)
                    }

                }
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                .padding()
            }
 
            HStack{
                Text("Recent Activity")
                    .font(.title2)
                
                Spacer()
                
                Button(action: {
                    print("Hello")
                }, label: {
                    Text("Show more")
                        .padding(10)
                        .foregroundColor(.white)
                        .background(.blue)
                        .cornerRadius(20)
                        
                })
                .padding(.horizontal)
            }
            .padding(.horizontal)
            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)

            LazyVStack(spacing: 50){
                ForEach(viewModel.workouts, id: \.date) {fitness in
                    FitnessView(fitness: fitness).border(Color.black)
                }
            }
            .padding()
            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
            
            
        }
    }
}

#Preview {
    HomeView()
}
