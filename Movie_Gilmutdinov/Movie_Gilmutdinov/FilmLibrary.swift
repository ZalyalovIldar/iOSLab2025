import Foundation
import Observation

@Observable
class FilmLibrary {
    
    var films: [Film]
    init(films: [Film] = Film.demo) {
        self.films = films
    }

    func add(_ film: Film) {
        films.append(film)
    }
    
    func remove(at indexes: IndexSet) {
        for index in indexes.sorted(by: >) {
            films.remove(at: index)
        }
    }
}
