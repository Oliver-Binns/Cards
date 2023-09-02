import CoreTransferable
import GroupActivities
import Sevens


@available(iOS 17, macOS 14, *)
extension Sevens: Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        GroupActivityTransferRepresentation { item in
            PlayTogether(game: item)
        }.visibility(.ownProcess)
    }
}
