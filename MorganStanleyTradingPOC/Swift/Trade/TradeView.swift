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
        viewModel.start()
    }

    var body: some View {
        createView()
    }
    
    @ViewBuilder
    func createView() -> some View {
        if viewModel.isLoading {
            ProgressView("Loading…")
        } else {
            List(viewModel.assetList, id: \.self) { symbol in
                AssetRow(symbol: symbol,
                         priceModel: (viewModel.getAssetPriceModel(symbol: symbol)))
            }
            //.listStyle(.plain)
        }
    }
}

struct AssetRow: View {
    let symbol: String
    let priceModel: AssetPriceModelWrapper

    var body: some View {
            HStack(spacing: 12) {
                Text(symbol)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .frame(width: 120, alignment: .leading)
                
                HStack(spacing: 10) {
                    Text(String(priceModel.assetPriceModel.askPrice.price))
                        .font(.body)
                        .foregroundColor(priceModel.assetPriceModel.askPrice.direction == .up ? .green : .red)
                        .frame(maxWidth: .infinity)

                    Text(String(priceModel.assetPriceModel.bidPrice.price))
                        .font(.body)
                        .foregroundColor(priceModel.assetPriceModel.bidPrice.direction == .up ? .green : .red)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.vertical, 6.0)
            .padding(.horizontal, 6.0)
     }
}

#if DEBUG
struct TradeView_Previews: PreviewProvider {
    static var previews: some View {
        TradeView()
    }
}
#endif

