import Hearts
import Sevens

public enum Game: Codable {
    case sevens(Sevens)
    case hearts(Hearts)
}
