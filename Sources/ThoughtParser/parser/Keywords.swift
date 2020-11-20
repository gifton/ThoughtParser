
import CoreData

// kewords are defined index's of a Thought. they identify words that directly relate to the users thought
// Keywords will be given a relationship rating to every other keyword saved in applicatoine
// Finds individual words that appear to be the focus of the corpus, its special because it can be derived from three seperate places, allowing for the identification of its layer of abstraction for the keyword extraction, and in tern its given a unique weight to make for more robust searches
    // Thought.content: Abstraction level = 1
    // [Thought.topic.content] AL = 2
    // [Thought.topic.topic] AL = 3

func randomString(length: Int) -> String {
  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  return String((0..<length).map{ _ in letters.randomElement()! })
}

public class ConfigurableKeyword {
    
    internal init(emoji: String = "☁️", title: String, thoughts: [ConfigurableThought]? = nil) {
        self.emoji = emoji
        self.createdAt = Date()
        self.title = title
        self.thoughts = thoughts
        self.id = randomString(length: 10)
    }
    
    // MARK: Core data objects
    public var emoji: String
    public var createdAt: Date
    public var title: String
    public var id: String
    public var thoughts: [ConfigurableThought]?

}

extension Array where Element == ConfigurableKeyword {
    
    func titles() -> [String] {
        return map { return $0.title }
    }
}

public typealias Keywords = [ConfigurableKeyword]
let KeywordTypeTitle = "Keyword"
