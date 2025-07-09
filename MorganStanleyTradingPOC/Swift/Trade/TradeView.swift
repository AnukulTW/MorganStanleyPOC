//
//  TradeView.swift
//  MorganStanleyTradingPOC
//
//  Created by Shrey Shrivastava on 07/07/25.
//


import SwiftUI
import Combine

@MainActor
struct TradeView: View {
    @ObservedObject private var viewModel: TradeViewModel
    
    init(viewModel: TradeViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading…")
                } else {
                    List(viewModel.assetList, id: \.self) { symbol in
                        AssetRow(symbol: symbol,
                                 priceModel: (viewModel.livePrices[symbol]!))
                    }
                }
            }
            .navigationTitle("Market Watch")
            .onAppear {
                viewModel.start()
            }
        }
    }
}

struct AssetRow: View {
    let symbol: String
    let priceModel: AssetPriceModel

    var body: some View {
        HStack(spacing: 12) {
            Text(symbol)
                .font(.headline)
                .foregroundColor(.primary)
            Spacer()
            HStack(spacing: 40){
                Text(String(priceModel.askPrice.price))
                    .font(.body)
                    .foregroundColor(priceModel.askPrice.direction == .up ? .green : .red)
                    .padding(.leading)
                Text(String(priceModel.bidPrice.price))
                    .font(.body)
                    .foregroundColor(priceModel.bidPrice.direction == .up ? .green : .red)
            }
            
        }
        .padding(.vertical, 8)
    }
}

#if DEBUG
struct TradeView_Previews: PreviewProvider {
    static var previews: some View {
        TradeView()
    }
}
#endif

