import Foundation

// MARK: - Canal
class Canal: Codable {
    let id: Int
    let title: String?
    let isAdult, inPromotion: Bool?
    let promotionDescription, productKey, parentalRating, catalogPrice: String?
    let availableOnChannels, thematic, canalDescription: String?
    let catalogOrderNumber: Int?
    let deviceSubscription: Bool?
    let presentationKey: String?
    let isSpecialPromotion: Bool?
    let commercialKey, imageQuality, promotionPrice, promotionTagLine: String?
    let retentionDescription: String?
    let exclusiveContent, restartTV, hasL2Vs, interactive: Bool?
    let region, callLetter: String?
    let channelPosition: Int?
    let language: String?
    let subtitled: Bool?
    let minimumSubscriptionDays: Int?
    let isLiveAnyTime: Bool?
    let friendlyURLName: String?

    var currentProgram : Programa?
    var nextProgram : Programa?
    var programaImage : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case title = "Title"
        case isAdult = "IsAdult"
        case inPromotion = "InPromotion"
        case promotionDescription = "PromotionDescription"
        case productKey = "ProductKey"
        case parentalRating = "ParentalRating"
        case catalogPrice = "CatalogPrice"
        case availableOnChannels = "AvailableOnChannels"
        case thematic = "Thematic"
        case canalDescription = "Description"
        case catalogOrderNumber = "CatalogOrderNumber"
        case deviceSubscription = "DeviceSubscription"
        case presentationKey = "PresentationKey"
        case isSpecialPromotion = "IsSpecialPromotion"
        case commercialKey = "CommercialKey"
        case imageQuality = "ImageQuality"
        case promotionPrice = "PromotionPrice"
        case promotionTagLine = "PromotionTagLine"
        case retentionDescription = "RetentionDescription"
        case exclusiveContent = "ExclusiveContent"
        case restartTV = "RestartTV"
        case hasL2Vs = "HasL2Vs"
        case interactive = "Interactive"
        case region = "Region"
        case callLetter = "CallLetter"
        case channelPosition = "ChannelPosition"
        case language = "Language"
        case subtitled = "Subtitled"
        case minimumSubscriptionDays = "MinimumSubscriptionDays"
        case isLiveAnyTime = "IsLiveAnyTime"
        case friendlyURLName = "FriendlyUrlName"
        case currentProgram = "currentProgram"
        case nextProgram = "nextProgram"
        case programaImage = "programaImage"
    }

    init(id: Int, title: String, isAdult: Bool, inPromotion: Bool, promotionDescription: String, productKey: String, parentalRating: String, catalogPrice: String, availableOnChannels: String, thematic: String, canalDescription: String, catalogOrderNumber: Int, deviceSubscription: Bool, presentationKey: String, isSpecialPromotion: Bool, commercialKey: String, imageQuality: String, promotionPrice: String, promotionTagLine: String, retentionDescription: String, exclusiveContent: Bool, restartTV: Bool, hasL2Vs: Bool, interactive: Bool, region: String, callLetter: String, channelPosition: Int, language: String, subtitled: Bool, minimumSubscriptionDays: Int, isLiveAnyTime: Bool, friendlyURLName: String) {
        self.id = id
        self.title = title
        self.isAdult = isAdult
        self.inPromotion = inPromotion
        self.promotionDescription = promotionDescription
        self.productKey = productKey
        self.parentalRating = parentalRating
        self.catalogPrice = catalogPrice
        self.availableOnChannels = availableOnChannels
        self.thematic = thematic
        self.canalDescription = canalDescription
        self.catalogOrderNumber = catalogOrderNumber
        self.deviceSubscription = deviceSubscription
        self.presentationKey = presentationKey
        self.isSpecialPromotion = isSpecialPromotion
        self.commercialKey = commercialKey
        self.imageQuality = imageQuality
        self.promotionPrice = promotionPrice
        self.promotionTagLine = promotionTagLine
        self.retentionDescription = retentionDescription
        self.exclusiveContent = exclusiveContent
        self.restartTV = restartTV
        self.hasL2Vs = hasL2Vs
        self.interactive = interactive
        self.region = region
        self.callLetter = callLetter
        self.channelPosition = channelPosition
        self.language = language
        self.subtitled = subtitled
        self.minimumSubscriptionDays = minimumSubscriptionDays
        self.isLiveAnyTime = isLiveAnyTime
        self.friendlyURLName = friendlyURLName
        self.currentProgram = nil
        self.nextProgram = nil
        self.programaImage = nil
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

// MARK: - URLSession response handlers

extension URLSession {
    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? newJSONDecoder().decode(T.self, from: data), response, nil)
        }
    }

    func canalTask(with url: URL, completionHandler: @escaping (Canal?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}
