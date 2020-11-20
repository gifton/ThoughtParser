
import Foundation

public struct Sentence {

    let text: String
    let words: [String]

    init(text: String) {
        self.text = text
        self.words = Stemmer.stemmingWordsInText(text)
            .filter { !Search.binary(stopwords, target: $0) }
    }

    init(text: String, stopwords: [String] = stopwords) {
        self.text = text
        self.words = Stemmer.stemmingWordsInText(text)
            .filter { !Search.binary(stopwords, target: $0) }
    }
}

extension Sentence: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(text)
    }

    public static func == (lhs: Sentence, rhs: Sentence) -> Bool {
        return lhs.text == rhs.text
    }
}

internal extension String {

    var sentences: [String] {

        var sentences = [String]()
        let range = self.range(of: self)

        self.enumerateSubstrings(in: range!, options: .bySentences) { (substring, _, _, _) in
            sentences.append(substring!)
        }
        return sentences
    }
}
