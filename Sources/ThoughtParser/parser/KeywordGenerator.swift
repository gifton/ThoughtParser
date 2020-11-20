
import CoreData
import NaturalLanguage

// user types in thought title and hits continue
// findKeywords(:String) -> [Keywords]
// once there are more than 25 thoughts, we can use a RAKE style algorithm to cross reference those keywords found and give even more acurate reccomendations
public class KeywordGenerator {

    public static func rawKeywords(forString text: String, completion: ([(String, Float)]) -> ()) {
        completion(TRKeyword(text: text).execute())
    }
    
}

extension KeywordGenerator {
    
    
    private func setKeyword(fromTitle title: String) -> Keyword {
        let keyword = Keyword(title: title)
        keyword.title = title
        keyword.createdAt = Date()
        keyword.emoji = KeywordGenerator.reccomendEmoji(forKeyword: title)
        return keyword
    }
    
    
    static func reccomendEmoji(forKeyword keyword: String) -> String {
        
        
        return "☁️"
    }
    
    func tokenizeText(for text: String) {
        let tokenizer = NLTokenizer(unit: .sentence)
        tokenizer.string = text

        tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { tokenRange, _ in
            return true
        }
    }
    
    func identifyNouns(for text: String) {
        let tagger = NLTagger(tagSchemes: [.lexicalClass, .lemma])
        tagger.string = text
        let options: NLTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
        tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .lexicalClass, options: options) { tag, tokenRange in
            if let tag = tag {
                print("\(text[tokenRange]): \(tag.rawValue)")
            }
            return true
        }
    }
    
}
