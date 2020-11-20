
import CoreData

// Thought is the basic building block of user created content
// thoughts have a singular piece of important data: the content, which is inputted by the user.
// All other components and variables are generated, and can be edited (and also created) by the user

// -------- Thought generated components -------- //

    // Keywords
        /// Using a keywords extractor from MLKit, we can identifier key words that the user has inputted
        /// Users can input their own keywords to help solidify connections with other thoughts that may not be based specifically on words inputted. (e.g: Dog -> Best Friend)
    // Topics
        /// Topics are generated by the system identifying what the user is talking about.  Topics are similar to Keywords but instead of being restricted to a single word, Topics can be sentances
        /// Topics can describe a portion of the text or encumpass the Thought entitrely


// Internally thoughts are broken into 3 seperate entities for digestion of the NLP algorthims
    /// Corpus: Identifies the entire body fo text, and allows us to have a high level definition of what the user is typing
    /// Chunks: Breaks corpus into smaller portions of text (no length aprameter) to be analayzed and designated with a topic identifier
    /// Singular: Finds individual words that appear to be the focus of the corpus, its special because it can be derived from three seperate palces, allowing for the identification of its layer of abstraction for the keyword extraction, and in tern its given a unique weight to make for more robust searches
        /// Thought.content
        /// [Thought.topic.content]
        /// [Thought.topic.topic]

            
// We save entries as a single block of text with string identifiers for break identification
// when we do our searches within the coredata framework, we can use these strings to much more quickly identify relationships
    /// --- break identifier ---
        /// !THOUGHTID%DATETIME-TOSTRING //


public class ConfigurableThought {
    internal init(content: String, keywords: [Keyword]? = nil) {
        self.content = content
        self.createdAt = Date()
        self.lastUpdated = Date()
        self.keywords = keywords
        self.id = randomString(length: 10)
    }
    
    
    // MARK: Core Data properties
    public var content: String
    public var createdAt: Date
    public var lastUpdated: Date
    public var id: String

    // MARK: relationship
    public var keywords: [Keyword]?
    
}
let ThoughtTypeTitle = "Thought"
