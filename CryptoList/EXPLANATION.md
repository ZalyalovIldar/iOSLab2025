# 📚 Полное объяснение проекта CryptoList

## 🎯 Обзор проекта

Это приложение для отображения списка криптовалют, загружаемых из открытого API CoinGecko. Проект демонстрирует работу с сетевыми запросами, async/await, декодированием JSON и архитектурой MVVM с использованием Observation.

---

## 📁 Структура проекта

```
CryptoList/
├── Models/
│   └── Crypto.swift          # Модель данных криптовалюты
├── Services/
│   └── CryptoService.swift  # Протокол и реализация сетевого сервиса
├── ViewModels/
│   └── CryptoViewModel.swift # ViewModel с бизнес-логикой
├── Views/
│   ├── ContentView.swift     # Главный экран
│   ├── CryptoRowView.swift   # Компонент строки криптовалюты
│   ├── CryptoListView.swift  # Компонент списка
│   └── TopGainersView.swift  # Компонент топ-криптовалют (Pro)
└── CryptoListApp.swift       # Точка входа приложения
```

---

## 🔍 Детальное объяснение компонентов

### 1. Модель Crypto (`Models/Crypto.swift`)

#### Что это?
Модель данных, которая представляет криптовалюту. Она соответствует структуре JSON, приходящей из API.

#### Ключевые концепции:

**Codable протокол:**
```swift
struct Crypto: Codable, Identifiable {
    // ...
}
```
- `Codable` = `Encodable` + `Decodable`
- Позволяет автоматически преобразовывать JSON ↔ Swift объекты
- Swift сам понимает, как декодировать, если имена свойств совпадают с JSON

**CodingKeys:**
```swift
enum CodingKeys: String, CodingKey {
    case id
    case name
    case symbol
    case currentPrice = "current_price"  // snake_case → camelCase
    case image
}
```
- Используется, когда имена в JSON отличаются от имен в Swift
- `current_price` (JSON) → `currentPrice` (Swift)
- В Swift принято использовать camelCase, в JSON часто snake_case

**Identifiable:**
- Протокол, требующий уникальный `id`
- Нужен для SwiftUI `List` и `ForEach` без явного указания `id:`

#### Пример JSON из API:
```json
{
  "id": "bitcoin",
  "name": "Bitcoin",
  "symbol": "btc",
  "current_price": 50000.0,
  "image": "https://assets.coingecko.com/coins/images/1/large/bitcoin.png"
}
```

---

### 2. Сетевой сервис (`Services/CryptoService.swift`)

#### Протокол CryptoService

**Зачем протокол?**
```swift
protocol CryptoService {
    func fetchCryptos() async throws -> [Crypto]
}
```
- **Тестируемость**: можно создать Mock-реализацию для тестов
- **Гибкость**: легко заменить реализацию
- **Разделение ответственности**: ViewModel не знает детали сети

#### Реализация RealCryptoService

**URLSession.shared.data(from:):**
```swift
let (data, _) = try await URLSession.shared.data(from: url)
```
- `URLSession.shared` - готовая сессия для простых запросов
- `data(from:)` - async/await метод (iOS 15+)
- Возвращает кортеж: `(Data, URLResponse)`
- `_` означает, что мы игнорируем `URLResponse`

**Декодирование:**
```swift
let decoder = JSONDecoder()
return try decoder.decode([Crypto].self, from: data)
```
- `JSONDecoder` - декодер из Foundation
- `[Crypto].self` - тип, в который декодируем (массив Crypto)
- `try` - может выбросить ошибку (неверный JSON, отсутствие поля и т.д.)

**async throws:**
- `async` - асинхронная функция (может приостановить выполнение)
- `throws` - может выбросить ошибку
- При вызове: `try await service.fetchCryptos()`

---

### 3. ViewModel (`ViewModels/CryptoViewModel.swift`)

#### Observation Framework

**@Observable макрос:**
```swift
@Observable
class CryptoViewModel {
    var items: [Crypto] = []
    var isLoading = false
    var error: String?
}
```
- Заменяет старый `ObservableObject` + `@Published`
- Автоматически отслеживает изменения свойств
- В SwiftUI используется с `@State` или `@Bindable`

**Как это работает:**
1. SwiftUI подписывается на изменения свойств
2. При изменении `items`, `isLoading`, `error` - UI обновляется автоматически
3. Не нужно вручную вызывать `objectWillChange.send()`

#### Состояния приложения

**isLoading:**
- `true` - показываем индикатор загрузки
- `false` - скрываем индикатор

**error:**
- `nil` - ошибок нет
- `String?` - текст ошибки для отображения

**items:**
- Массив загруженных криптовалют
- Пустой массив = состояние "empty"

#### Метод load()

```swift
func load() async {
    if let cached = cachedItems {
        items = cached
        return
    }
    
    isLoading = true
    error = nil
    
    do {
        var fetchedItems = try await service.fetchCryptos()
        fetchedItems.sort { $0.currentPrice > $1.currentPrice }
        items = fetchedItems
        cachedItems = fetchedItems
    } catch {
        self.error = error.localizedDescription
    }
    
    isLoading = false
}
```

**Пошаговое объяснение:**

1. **Кэширование (Plus уровень):**
   ```swift
   if let cached = cachedItems {
       items = cached
       return
   }
   ```
   - Если данные уже загружены, используем кэш
   - Не делаем лишний сетевой запрос

2. **Установка состояния загрузки:**
   ```swift
   isLoading = true
   error = nil
   ```
   - Показываем индикатор
   - Очищаем предыдущие ошибки

3. **Загрузка и обработка:**
   ```swift
   do {
       var fetchedItems = try await service.fetchCryptos()
       fetchedItems.sort { $0.currentPrice > $1.currentPrice }
       items = fetchedItems
       cachedItems = fetchedItems
   } catch {
       self.error = error.localizedDescription
   }
   ```
   - `do-catch` - обработка ошибок
   - `try await` - асинхронный вызов, который может выбросить ошибку
   - Сортировка по убыванию цены (Plus уровень)
   - Сохранение в кэш

4. **Завершение:**
   ```swift
   isLoading = false
   ```
   - Всегда сбрасываем флаг загрузки

#### Метод refresh()

```swift
func refresh() async {
    cachedItems = nil
    await load()
}
```
- Очищает кэш
- Загружает данные заново
- Используется для pull-to-refresh (Pro уровень)

#### Свойство topGainers (Pro уровень)

```swift
var topGainers: [Crypto] {
    Array(items.prefix(5))
}
```
- Вычисляемое свойство (computed property)
- Возвращает первые 5 криптовалют
- `prefix(5)` - берет первые 5 элементов
- `Array(...)` - преобразует в массив

---

### 4. UI Компоненты

#### CryptoRowView (`Views/CryptoRowView.swift`)

**Структура:**
```swift
struct CryptoRowView: View {
    let crypto: Crypto
    
    var body: some View {
        HStack {
            // Иконка
            // Название и символ
            Spacer()
            // Цена
        }
    }
}
```

**AsyncImage (Pro уровень):**
```swift
AsyncImage(url: URL(string: crypto.image)) { image in
    image
        .resizable()
        .aspectRatio(contentMode: .fit)
} placeholder: {
    ProgressView()
}
.frame(width: 50, height: 50)
```

**Объяснение:**
- `AsyncImage` - встроенный компонент SwiftUI для загрузки изображений
- Автоматически загружает изображение по URL
- `placeholder` - показывается во время загрузки
- `ProgressView()` - индикатор загрузки
- `.resizable()` - позволяет изменять размер
- `.aspectRatio(contentMode: .fit)` - сохраняет пропорции

**Форматирование цены (Plus уровень):**
```swift
private func formatPrice(_ price: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencyCode = "USD"
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    return formatter.string(from: NSNumber(value: price)) ?? "$0.00"
}
```

**NumberFormatter:**
- Форматирует числа в строки
- `.currency` - формат валюты
- `currencyCode = "USD"` - доллары США
- `minimumFractionDigits = 2` - минимум 2 знака после запятой
- `maximumFractionDigits = 2` - максимум 2 знака
- Результат: `50000.0` → `"$50,000.00"`

#### CryptoListView (`Views/CryptoListView.swift`)

```swift
struct CryptoListView: View {
    let cryptos: [Crypto]
    
    var body: some View {
        List(cryptos) { crypto in
            CryptoRowView(crypto: crypto)
        }
        .listStyle(.plain)
    }
}
```

**List:**
- Автоматически создает прокручиваемый список
- `cryptos` - массив данных
- `{ crypto in ... }` - замыкание для каждой строки
- Так как `Crypto: Identifiable`, SwiftUI автоматически использует `id`

**Разделение на компоненты:**
- `CryptoRowView` - отдельный компонент для строки
- `CryptoListView` - отдельный компонент для списка
- Это соответствует требованию "минимум 2 отдельные вьюхи"

#### TopGainersView (`Views/TopGainersView.swift`)

**Горизонтальный скролл:**
```swift
ScrollView(.horizontal, showsIndicators: false) {
    HStack(spacing: 16) {
        ForEach(cryptos) { crypto in
            // Карточка криптовалюты
        }
    }
}
```

- `ScrollView(.horizontal)` - горизонтальная прокрутка
- `showsIndicators: false` - скрываем индикатор прокрутки
- `HStack` - горизонтальное расположение
- `ForEach` - перебор элементов

---

### 5. Главный экран (`Views/ContentView.swift`)

#### Использование ViewModel

```swift
@State private var viewModel = CryptoViewModel()
```

**@State:**
- Управляет жизненным циклом объекта
- При изменении свойств `@Observable` объекта - UI обновляется
- `private` - доступен только внутри этого View

#### Обработка состояний

**1. Loading (загрузка):**
```swift
if viewModel.isLoading {
    ProgressView("Loading...")
}
```
- Показываем индикатор загрузки
- Блокируем взаимодействие с UI

**2. Error (ошибка):**
```swift
else if let error = viewModel.error {
    VStack {
        Image(systemName: "exclamationmark.triangle")
        Text("Error: \(error)")
        Button("Retry") {
            Task {
                await viewModel.load()
            }
        }
    }
}
```

**Объяснение:**
- `if let error = viewModel.error` - безопасное извлечение опционала
- Если `error != nil`, показываем ошибку
- Кнопка "Retry" - повторная попытка загрузки
- `Task { }` - создает асинхронную задачу
- `await viewModel.load()` - ждем завершения загрузки

**3. Empty (пусто):**
```swift
else if viewModel.items.isEmpty {
    VStack {
        Image(systemName: "list.bullet.rectangle")
        Text("No cryptocurrencies found")
    }
}
```
- Показываем, когда список пуст
- Пользователь понимает, что данных нет

**4. Content (контент):**
```swift
else {
    ScrollView {
        VStack {
            TopGainersView(cryptos: viewModel.topGainers)
            Divider()
            CryptoListView(cryptos: viewModel.items)
        }
    }
    .refreshable {
        await viewModel.refresh()
    }
}
```

**refreshable (Pro уровень):**
- Модификатор для pull-to-refresh
- При потягивании вниз вызывается замыкание
- `await viewModel.refresh()` - обновляем данные

#### Загрузка при появлении экрана

```swift
.task {
    await viewModel.load()
}
```

**Модификатор .task:**
- Выполняется при появлении View
- Автоматически отменяется при исчезновении View
- Идеально для загрузки данных
- Аналог `.onAppear`, но для async операций

---

## 🔄 Поток данных (Data Flow)

```
1. ContentView появляется
   ↓
2. .task { await viewModel.load() }
   ↓
3. ViewModel.isLoading = true
   ↓
4. RealCryptoService.fetchCryptos()
   ↓
5. URLSession.shared.data(from: url)
   ↓
6. JSON → [Crypto] (декодирование)
   ↓
7. Сортировка по цене
   ↓
8. ViewModel.items = [Crypto]
   ↓
9. ViewModel.isLoading = false
   ↓
10. SwiftUI автоматически обновляет UI
    ↓
11. Отображается список криптовалют
```

---

## 🎓 Ключевые концепции Swift/SwiftUI

### 1. async/await

**Что это?**
Современный способ работы с асинхронным кодом в Swift.

**Старый способ (completion handlers):**
```swift
func load(completion: @escaping ([Crypto]?, Error?) -> Void) {
    URLSession.shared.dataTask(with: url) { data, response, error in
        // обработка
        completion(cryptos, nil)
    }.resume()
}
```

**Новый способ (async/await):**
```swift
func load() async throws -> [Crypto] {
    let (data, _) = try await URLSession.shared.data(from: url)
    return try decoder.decode([Crypto].self, from: data)
}
```

**Преимущества:**
- Читаемость кода (как синхронный)
- Легче обрабатывать ошибки
- Нет "callback hell"

### 2. Codable

**Автоматическое декодирование:**
```swift
struct Crypto: Codable {
    let id: String
    let name: String
}
```

**JSON:**
```json
{
  "id": "bitcoin",
  "name": "Bitcoin"
}
```

Swift автоматически создаст объект `Crypto(id: "bitcoin", name: "Bitcoin")`.

**Когда нужны CodingKeys:**
- Имена в JSON отличаются от Swift
- Нужно преобразовать типы
- Нужно игнорировать некоторые поля

### 3. Observation Framework

**Старый способ (ObservableObject):**
```swift
class ViewModel: ObservableObject {
    @Published var items: [Crypto] = []
}

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
}
```

**Новый способ (@Observable):**
```swift
@Observable
class ViewModel {
    var items: [Crypto] = []
}

struct ContentView: View {
    @State private var viewModel = ViewModel()
}
```

**Преимущества:**
- Меньше кода
- Лучшая производительность
- Автоматическое отслеживание изменений

### 4. Опционалы (Optionals)

**String? - опциональная строка:**
- Может быть `nil` (нет значения)
- Может быть `String` (есть значение)

**Безопасное извлечение:**
```swift
if let error = viewModel.error {
    // error здесь точно не nil
    Text("Error: \(error)")
}
```

**Nil-coalescing operator:**
```swift
return formatter.string(from: NSNumber(value: price)) ?? "$0.00"
```
Если `formatter.string(...)` вернет `nil`, используем `"$0.00"`.

### 5. Замыкания (Closures)

**Пример:**
```swift
List(cryptos) { crypto in
    CryptoRowView(crypto: crypto)
}
```

**Полная форма:**
```swift
List(cryptos, rowContent: { (crypto: Crypto) -> CryptoRowView in
    return CryptoRowView(crypto: crypto)
})
```

**Сокращенная форма (trailing closure):**
```swift
List(cryptos) { crypto in
    CryptoRowView(crypto: crypto)
}
```

---

## ✅ Реализованные уровни

### Base ✅
- ✅ Загрузка и отображение данных
- ✅ Обработка ошибок
- ✅ Экран разбит на отдельные вьюхи (CryptoRowView, CryptoListView)

### Plus ✅
- ✅ Кэширование результата
- ✅ Сортировка по цене
- ✅ Форматирование цены

### Pro ✅
- ✅ AsyncImage с placeholder
- ✅ Pull-to-refresh
- ✅ Секция "Top Gainers"

---

## 🚀 Как это работает вместе

1. **Запуск приложения:**
   - `CryptoListApp` создает `ContentView`

2. **Появление ContentView:**
   - `.task` модификатор вызывает `viewModel.load()`

3. **Загрузка данных:**
   - `ViewModel` вызывает `CryptoService.fetchCryptos()`
   - `RealCryptoService` делает HTTP запрос
   - JSON декодируется в `[Crypto]`

4. **Обновление состояния:**
   - `ViewModel.items` обновляется
   - `@Observable` автоматически уведомляет SwiftUI

5. **Обновление UI:**
   - SwiftUI перерисовывает `ContentView`
   - Отображается список криптовалют

6. **Взаимодействие:**
   - Pull-to-refresh → `viewModel.refresh()`
   - Retry → `viewModel.load()`

---

## 📝 Важные моменты

1. **Всегда обрабатывайте ошибки:**
   ```swift
   do {
       // код, который может выбросить ошибку
   } catch {
       // обработка ошибки
   }
   ```

2. **Используйте async/await правильно:**
   - `async` функции вызываются с `await`
   - В синхронном контексте используйте `Task { }`

3. **Разделяйте ответственность:**
   - Model - данные
   - Service - сетевые запросы
   - ViewModel - бизнес-логика
   - View - отображение

4. **Обрабатывайте все состояния:**
   - Loading
   - Error
   - Empty
   - Content

---

## 🎯 Итог

Вы создали полнофункциональное приложение, которое:
- Загружает данные из API
- Обрабатывает ошибки
- Показывает разные состояния UI
- Использует современные технологии Swift/SwiftUI
- Следует архитектуре MVVM
- Реализует все три уровня сложности

Это отличная база для дальнейшего изучения iOS разработки! 🚀

