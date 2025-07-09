//
//  TradeViewModel.swift
//  MorganStanleyTradingPOC
//
//  Created by Shrey Shrivastava on 07/07/25.
//


final class TradeViewModel: NSObject, ObservableObject {
    @Published var assetList: [AssetModel] = []
    @Published var livePrices: [String: String] = [:]
    
    private let socket = SocketConnectionManager()
    private let assetClient: MarketAssetClient
    private let requiredSymbols = ["AMZN", "AAPL", "MLGO", "INTC", "AMTM", "ARCA", "ANAB", "ABNB"]

    override init() {
            let manager = NetworkConnectionManager(apiKey: Constants.apiKey,
                                                   apiSecret: Constants.apiSecret)
            self.assetClient = MarketAssetClient(networkManager: manager)
            super.init()
            self.socket.connectionDelegate = self
            self.assetClient.requiredSymbol = requiredSymbols
        }

    func fetchAssets() {
        assetClient.fetchMarketAsset { [weak self] result, list, error in
            DispatchQueue.main.async {
                self?.assetList = result ?? []
                self?.socket.subscribeAssets(list ?? [])
            }
        }
    }

    func fetchLastQuotes() {
        assetClient.fetchLastQuote(forAsset: requiredSymbols) { [weak self] quotes, error in
            DispatchQueue.main.async {
                self?.socket.updateAssetLastQuote(quotes ?? [])
            }
        }
    }
}

extension TradeViewModel: SocketConnectionManagerDelegate {
    func didReceivePrice(_ priceModel: AssetPriceModel, forAsset asset: String) {
        <#code#>
    }
    
    func didReceivePrice(_ price: String, forAsset asset: String) {
        DispatchQueue.main.async {
            self.livePrices[asset] = price
        }
    }
}
