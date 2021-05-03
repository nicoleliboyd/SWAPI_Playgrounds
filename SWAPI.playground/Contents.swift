import UIKit

//Person final URL: https://swapi.dev/api/people/1/
struct Person: Decodable {
    let name: String
    let films: [URL]
    let height: String
    let birth_year: String
    let gender: String
    let homeworld: URL
    let mass: String
    let hair_color: String
    let skin_color: String
    let eye_color: String
}

struct Film: Decodable {
    let title: String
    let opening_crawl: String
    let release_date: String
}

class SwapiService {
    
    static private let baseURL = URL(string: "https://swapi.dev/api/")
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        //1. PerpareURL
        guard let baseURL = baseURL else {return completion(nil)}
        let peopleURL = baseURL.appendingPathComponent("people")
        print("peopleURL: \(peopleURL)")
        
        let finalURL = peopleURL.appendingPathComponent("\(id)")
        print("FinalURL: \(finalURL)")
        
        //2. Contact server
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            //3. Handle errors
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
            //4. Check on data
            guard let data = data else {return completion(nil)}
            
            //5. Decode person from JSON
            do{
                let decoder = JSONDecoder()
                let person = try decoder.decode(Person.self, from: data)
                return completion(person)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
        }.resume()
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        
        //1. Contact server
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            //2. handel errors
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
            //3. check on data
            guard let data = data else {return completion(nil)}
            
            //4. decode film from JSON
            do{
                let decoder = JSONDecoder()
                let film = try decoder.decode(Film.self, from: data)
                return completion(film)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
        }.resume()
    }
    
}//End of class


SwapiService.fetchPerson(id: 10) { person in
    if let person = person {
        print("Name: \(person.name)\nHeight: \(person.height)\nMass: \(person.mass)\nHair color: \(person.hair_color)\nSkin color: \(person.skin_color)\nEye Color: \(person.eye_color)\nBirth Year: \(person.birth_year)\nGender: \(person.gender)\nHomeworld: \(person.homeworld)\n \nAppears in: ")
        
        for film in person.films {
            fetchFilm(url: film)
//                print(film)
        }
    }
}

func fetchFilm(url: URL) {
  SwapiService.fetchFilm(url: url) { film in
      if let film = film {
        print(film.title)
      }
  }
}
