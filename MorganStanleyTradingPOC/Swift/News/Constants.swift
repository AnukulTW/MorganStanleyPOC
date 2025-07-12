
import Foundation

let baseURL = "https://data.alpaca.markets/"
let newsEndPoint = "v1beta1/news"
let marketAsset = "v2/assets"

let apiKey = "PKYGLGZYI3VPE4B05HX0"
let secret = "dCmEKpi6va3jXaG6zgNcugJasgB0SAeH3Gge5swF"


@objcMembers
public class Constants: NSObject {
    public static let alpacaBaseURL = "https://data.alpaca.markets/"
    public static let primeAPIBaseURL = "https://api.primeapi.io/"
    
    public static let paperApiBaseURL = "https://paper-api.alpaca.markets/"
    public static let apiKey = "PKYGLGZYI3VPE4B05HX0"
    public static let apiSecret = "dCmEKpi6va3jXaG6zgNcugJasgB0SAeH3Gge5swF"
    public static let newsEndPoint = "v1beta1/news"
    public static let marketAsset = "v2/assets"
    private static let latestQuotes_Alpaca = "v2/stocks/quotes/latest"
    private static let latestQuotes_Prime = "fx/quote"
    public static let marketMoversEndPoint = "v1beta1/screener/stocks/movers"
    public static let marketMostActiveStocksEndPoint = "v1beta1/screener/stocks/most-actives"
    public static let isEnablePrimeAPI = true
    public static var latestQuotes: String {
        isEnablePrimeAPI ? latestQuotes_Prime : latestQuotes_Alpaca
    }
    
    public static var baseURL: String {
        isEnablePrimeAPI ? primeAPIBaseURL : alpacaBaseURL
    }
    
    public static var assetList: [String] {
         isEnablePrimeAPI ? ["EURUSD", "AUDUSD", "USDJPY", "USDCAD", "GBPUSD", "EURGBP", "AUDCAD", "USDHKD"] : ["AMZN", "AAPL", "MLGO", "INTC", "AMTM", "ANAB", "ABNB"]
     }
}
