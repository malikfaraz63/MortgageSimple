//
//  MortgageDetailView.swift
//  MortgageSimple
//
//  Created by Faraz Malik on 30/06/2023.
//

import SwiftUI
import Charts

struct MortgageDetailView: View {
    let mortgageData: MortgageModel
    let interestPaid: Int
    
    init(mortgageData: MortgageModel) {
        self.mortgageData = mortgageData
        self.interestPaid = MortgageManager.getTotalInterest(forModel: mortgageData)
    }
    
    var body: some View {
        ScrollView {
            Text(mortgageData.mortgageDescription)
                .font(.title)
                .fontWeight(.bold)
            Text(String(format: "%.2f%%       ", mortgageData.rate * 100) + mortgageData.lender)
                .padding(.top)
                .fontWeight(.bold)
            
            
            Text("Amortisation")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top)
            // MARK: Loan cost view
            ZStack {
                Color(uiColor: .systemGray6)
                VStack {
                    Label("Cost of Loan", systemImage: "hourglass")
                        .font(.callout)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.blue)
                    Text("Based on a £\(Utility.getFormattedNumber(Float(mortgageData.loan), decimalPoints: 0)) loan excluding fees, paid in \(mortgageData.term * 12) monthly repayments over a \(mortgageData.term) year term.")
                        .font(.callout)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fontWeight(.bold)
                    HStack {
                        VStack {
                            Label("Total", systemImage: "circle.fill")
                                .font(.caption)
                                .fontWeight(.bold)
                                .imageScale(.small)
                            Text("£\(interestPaid + mortgageData.loan)")
                                .font(.callout)
                                .fontWeight(.bold)
                                .imageScale(.small)
                        }
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        VStack {
                            Label("Interest", systemImage: "circle.fill")
                                .font(.caption)
                                .fontWeight(.bold)
                            Text("£\(interestPaid)")
                                .font(.callout)
                                .fontWeight(.bold)
                        }
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }.padding(.top)
                    Chart {
                        LineMark(
                            x: .value("Year", 0),
                            y: .value("£", 0),
                            series: .value("Type", "Total")
                        )
                        .foregroundStyle(.blue)
                        .interpolationMethod(.linear)
                        LineMark(
                            x: .value("Year", mortgageData.term),
                            y: .value("£", mortgageData.term),
                            series: .value("Type", "Total")
                        )
                        .foregroundStyle(.blue)
                        .interpolationMethod(.linear)
                        PointMark(
                            x: .value("Year", mortgageData.term),
                            y: .value("Total", mortgageData.term)
                        ).foregroundStyle(.blue)
                        
                        LineMark(
                            x: .value("Year", 0),
                            y: .value("£", 0),
                            series: .value("Type", "Interest")
                        )
                        .foregroundStyle(.gray)
                        .interpolationMethod(.catmullRom)
                        LineMark(
                            x: .value("Year", mortgageData.term),
                            y: .value("£", mortgageData.term / 2),
                            series: .value("Type", "Interest")
                        )
                        .foregroundStyle(.gray)
                        .interpolationMethod(.catmullRom)
                        PointMark(
                            x: .value("Year", mortgageData.term),
                            y: .value("Interest", mortgageData.term / 2)
                        ).foregroundStyle(.gray)
                    }
                    .chartYAxis(.hidden)
                    .chartXAxis {
                        AxisMarks(
                            preset: .aligned,
                            position: .bottom,
                            values: .stride(by: 4),
                            stroke: StrokeStyle(
                                lineWidth: 0,
                                lineCap: .round,
                                lineJoin: .bevel,
                                miterLimit: 0,
                                dash: [],
                                dashPhase: 0
                            )
                        )
                    }
                    .chartXScale(domain: 0...mortgageData.term)
                    .frame(height: 100)
                    .padding(.horizontal)
                }.padding(.all)
                
            }
                .cornerRadius(10)
            
            // MARK: Overall cost view
            ZStack {
                Color(uiColor: .systemGray6)
                
                VStack {
                    Label("Overall Cost", systemImage: "creditcard.fill")
                        .font(.callout)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.blue)
                    let text = "£\(Utility.getFormattedNumber(Float(interestPaid + mortgageData.loan), decimalPoints: 0)) to repay overall. This means you'll pay back £\(Utility.getFormattedNumber(Float(interestPaid + mortgageData.loan) / Float(mortgageData.loan))) for every £1 borrowed."
                    Text(text)
                        .font(.callout)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fontWeight(.bold)

                    let interestFraction = Float(interestPaid) / Float(mortgageData.loan + interestPaid)
                    VStack {
                        Text("£\(interestPaid)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(Int(interestFraction * 100))%")
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        GeometryReader { proxy in
                            ZStack {
                                Color.blue
                            }
                            .cornerRadius(5)
                            .padding(.init(top: 0, leading: 0, bottom: 0, trailing: proxy.size.width - proxy.size.width * CGFloat(interestFraction)))
                        }
                    }.padding(.top)
                    VStack {
                        Text("£\(mortgageData.loan)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(Int(100 - interestFraction * 100))%")
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        GeometryReader { proxy in
                            ZStack {
                                Color.gray
                            }
                            .cornerRadius(5)
                            .padding(.init(top: 0, leading: 0, bottom: 0, trailing: proxy.size.width - proxy.size.width * CGFloat(1 - interestFraction)))
                        }
                    }.padding(.top)
                    
                }.padding(.all)
            }
                .cornerRadius(10)
            
            // MARK: Information
            Text("Information")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top)
            
            VStack {
                HStack {
                    Text("Interest Rate")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(String(format: "%.2f%%", mortgageData.rate * 100))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                HStack {
                    Text("Term Remaining")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("24 years & 10 months")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                HStack {
                    Text("Start Date")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("June 2023")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                HStack {
                    Text("End Date")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("June 2048")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                HStack {
                    Text("Lender")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(mortgageData.lender)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }.padding(.vertical)
            
        }.padding(.horizontal)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MortgageDetailView(mortgageData: MortgageModel(address: "60 Parham Drive", lender: "HSBC", loan: 400000, mortgageDescription: "Main home", rate: 0.04, rent: 1000, start: Date(timeIntervalSinceNow: -86400 * 365 * 10), term: 25))
    }
}

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
