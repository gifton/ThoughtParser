

import Foundation

// TextRank Keywords
public final class TRKeyword {

    private let ngram: Int = 3
    private var words: [String]

    private let ranking = TextRank<String>()

    init(text: String) {
        self.words = TRKeyword.preprocess(text)
    }

    func execute() -> [(String, Float)] {
        filterWords()
        buildGraph()
        return ranking.execute()
            .sorted { $0.1 > $1.1 }
            .map { $0 }
    }

    func filterWords() {
        self.words = self.words
            .filter(removeShortWords)
            .filter(removeStopWords)
        
    }

    func buildGraph() {
        for (index, node) in words.enumerated() {
            var (min, max) = (index-ngram, index+ngram)
            if min < 0 { min = words.startIndex }
            if max > words.count { max = words.endIndex }
            words[min..<max].forEach { word in
                ranking.add(edge: node, to: word)
            }
        }
    }
}

private extension TRKeyword {

    static func preprocess(_ text: String) -> [String] {
        return text.lowercased()
            .components(separatedBy: CharacterSet.letters.inverted)
    }

    func removeShortWords(_ word: String) -> Bool {
        return word.count > 2
    }

    func removeStopWords(_ word: String) -> Bool {
        return !stopwords.contains(word)
    }
}
