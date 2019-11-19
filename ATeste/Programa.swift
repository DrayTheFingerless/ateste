import Foundation

// MARK: - Programa
class Programa: Codable {
    let id, callLetter, startDate, startTime: String?
    let programID: Int?
    let endDate, title, synopsis: String?
    let seriesID, seriesEpisodeNumber: Int?
    let participants, imageURI: String?
    let isAdultContent, isEnabled: Bool?
    let searchRank, numberOfEpisodes: Int?
    let isLiveAnytimeChannel: Bool?
    let titleID: String?
    let isBlackout: Bool?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case callLetter = "CallLetter"
        case startDate = "StartDate"
        case startTime = "StartTime"
        case programID = "ProgramId"
        case endDate = "EndDate"
        case title = "Title"
        case synopsis = "Synopsis"
        case seriesID = "SeriesId"
        case seriesEpisodeNumber = "SeriesEpisodeNumber"
        case participants = "Participants"
        case imageURI = "ImageUri"
        case isAdultContent = "IsAdultContent"
        case isEnabled = "IsEnabled"
        case searchRank = "SearchRank"
        case numberOfEpisodes = "NumberOfEpisodes"
        case isLiveAnytimeChannel = "IsLiveAnytimeChannel"
        case titleID = "TitleId"
        case isBlackout = "IsBlackout"
    }

    init(id: String, callLetter: String, startDate: String, startTime: String, programID: Int, endDate: String, title: String, synopsis: String, seriesID: Int, seriesEpisodeNumber: Int, participants: String, imageURI: String, isAdultContent: Bool, isEnabled: Bool, searchRank: Int, numberOfEpisodes: Int, isLiveAnytimeChannel: Bool, titleID: String, isBlackout: Bool) {
        self.id = id
        self.callLetter = callLetter
        self.startDate = startDate
        self.startTime = startTime
        self.programID = programID
        self.endDate = endDate
        self.title = title
        self.synopsis = synopsis
        self.seriesID = seriesID
        self.seriesEpisodeNumber = seriesEpisodeNumber
        self.participants = participants
        self.imageURI = imageURI
        self.isAdultContent = isAdultContent
        self.isEnabled = isEnabled
        self.searchRank = searchRank
        self.numberOfEpisodes = numberOfEpisodes
        self.isLiveAnytimeChannel = isLiveAnytimeChannel
        self.titleID = titleID
        self.isBlackout = isBlackout
    }
    
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
}
