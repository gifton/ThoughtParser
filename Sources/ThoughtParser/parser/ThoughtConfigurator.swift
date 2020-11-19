
import Foundation
import NaturalLanguage

// Thought Configurator needs information on thought to run calculations
// for seperation of concerns the viewmodel that instantiates the ThoughtConfigurator will handle all connection to core data
protocol ThoughtConfiguratorDelegate: class {
    func createNewKeyword(fromTitle title: String) -> Keyword?
    func addExistingKeyword(_ keyword: Keyword)
    var content: String { get }
}

// thought configurator will need access to core data to be able to identify keywords that are already in existance
final class ThoughtConfigurator: NSObject {
    
    /// mark: Public variables
    public weak var delegate: ThoughtConfiguratorDelegate?
    /// mark: Private variables
    private var rawPortions: [String]?
    
    private var computedKeywords: [Keyword]?
    
    /// Embedding for NLP word similarity
    let embedding = NLEmbedding.wordEmbedding(for: .english)
    
    // MARK: Singleton variables
    public static var shared = ThoughtConfigurator()
    private var existingKeywords: [Keyword]?
    
    // MARK: Generator objects
    private weak var keywordGenerator: KeywordGenerator?
    
    deinit {
        keywordGenerator = nil
        
    }
    
}

// MARK: Singleton methods
extension ThoughtConfigurator {
    // call configure on shared to set content, existing topcs and keywords will be set all up in durr there
    func configure(addKeywords keywords: [Keyword]) {
        existingKeywords = keywords
    }
    
    // on the creation of a new keyword, update the shared storage so its up to date
    func addNew(_ keyword: Keyword) {
        guard let _ = existingKeywords else { existingKeywords = [keyword]; return }
        existingKeywords?.append(keyword)
    }
    
    func update(keywordWithID id: String, toKeyword keyword: Keyword) {
        guard let kws = existingKeywords else { return }
        let index = kws.firstIndex { (k) -> Bool in
            return k.id == id
        }
        
        if let index = index {
            existingKeywords?[index] = keyword
        }
        
        
    }
    
    public func clear() {
        existingKeywords?.removeAll()
    }
    
}
// something you had to do with sets?

// MARK: Public access methods
extension ThoughtConfigurator {
    
    public func getExtsitingKeywords() -> Keywords {
        if ThoughtConfigurator.shared.existingKeywords != nil {
            return ThoughtConfigurator.shared.existingKeywords!
        } else { return [] }
    }

    
    public func generate(completion: ([Keyword]) -> ()) {
        // parse text & include corpus 
        // extract topics from rawPortions -> ThoughtPortions
        // extract keywords from ThoughtPortions
        
        // my problem is how to properly understand what keywords are most important.
        // identify whats important by looking at: (for KW's) abstraction level & highlight bool
        // weight between 0 and 1
        // some way to save the weight for each relationship, maybe in the keyword fingerprint include a second break that identifies the weight?
        
        
        // check if theres highlighted text
        // find keywords for corpus and higlights, give highglighted jeywords higher weight
        // check if keywords exist ⑃
        
        guard let del = delegate else { return }
        let existingKeywords = ThoughtConfigurator.shared.existingKeywords ?? []
        
        // request text rank algorithm
        KeywordGenerator.rawKeywords(forString: del.content) { (rawKeywords) in
            
            // check if empty
            if rawKeywords.isEmpty { return }
                
            // set computed keywords
            if self.computedKeywords == nil {
                self.computedKeywords = []
            }
                
            // check all kws for similarities then request new kw if nothing can be found
            // set max length by allowing a max of 4 keywords oer sentance (1 sentance = 20 words)
            let words = delegate?.content.split(separator: " ").count ?? 0
            
            for rawKW in rawKeywords.slice(length: words / 5) {
                
                // check if keyword directly exists
                if let keyword = existingKeywords.first(where: { (kw) -> Bool in return kw.title == rawKW.0 }) {
                    
                    delegate?.addExistingKeyword(keyword)
                    self.computedKeywords?.append(keyword)
                
                }
                else {
                    if let del = delegate {
                        
                        // check based on NLP similarity check
                        // if nothing else, create new keyword
                        guard let createdKeyword = del.createNewKeyword(fromTitle: rawKW.0) else { continue }
                        self.computedKeywords?.append(createdKeyword)
                        ThoughtConfigurator.shared.addNew(createdKeyword)

//                        delegate?.addExistingKeyword(similarKW)
                        
                    }
                }
                
            }
            
            if self.computedKeywords != nil {
                completion(self.computedKeywords!)
            }
            
        }
    }
    
    public func summarize(completion: (String) -> ()) {
        if let del = delegate,
            let summary = Summarizer(text: del.content).execute().first {
            
                completion(summary)
            
        }
        
    }
    
    private func checkForSimilar(_ keyword: String, inCorpus corpus: [Keyword]) -> Keyword? {
        
        // find nearest 5 words
        guard let embedding = embedding else { return nil }
        var wordDict = embedding.neighbors(for: keyword, maximumCount: 5)
        
        // find all strongly related words
        wordDict = wordDict.filter { return $0.1 > 0.9 }
        var relatedKeywords = [(Keyword, NLDistance)]()
        for word in wordDict {
            if let kw = corpus.first(where: { return $0.title == word.0 }) {
                relatedKeywords.append((kw, word.1))
            }
            
        }
        
        // find highest rated kw
        if relatedKeywords.count > 0 {
            relatedKeywords.sort { (d1, d2) -> Bool in
                return d1.1 > d2.1
            }
            
            return relatedKeywords.first?.0
        }
        
        return nil
    }
}
