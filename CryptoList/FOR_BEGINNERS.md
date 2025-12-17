# 📖 Полное объяснение для начинающих программистов

## 🎯 Введение

Этот документ создан специально для тех, кто только начинает изучать программирование. Здесь каждый шаг объяснен максимально просто, как будто вы никогда не программировали.

**Что мы делаем?**
Создаем приложение для iPhone, которое показывает список криптовалют (Bitcoin, Ethereum и т.д.) с их ценами.

---

## 📚 Часть 1: Что такое программирование в контексте этого проекта

### Что такое приложение?
Приложение - это программа, которая работает на вашем телефоне. Когда вы открываете Instagram или WhatsApp - это приложения.

### Что такое код?
Код - это инструкции для компьютера на специальном языке. Мы пишем на языке Swift - это язык программирования от Apple для создания приложений на iPhone.

### Что делает наше приложение?
1. Подключается к интернету
2. Запрашивает список криптовалют с их ценами
3. Показывает этот список на экране телефона

---

## 🏗️ Часть 2: Структура проекта (как организован код)

Представьте, что вы строите дом. У вас есть:
- **Фундамент** (модели данных) - что такое криптовалюта
- **Коммуникации** (сервисы) - как получить данные из интернета
- **Логика** (ViewModel) - что делать с данными
- **Интерфейс** (Views) - как это выглядит на экране

### Файлы в нашем проекте:

```
CryptoList/
├── Models/
│   └── Crypto.swift          ← Что такое криптовалюта (данные)
├── Services/
│   └── CryptoService.swift   ← Как получить данные из интернета
├── ViewModels/
│   └── CryptoViewModel.swift ← Логика приложения
└── Views/
    ├── ContentView.swift      ← Главный экран
    ├── CryptoRowView.swift    ← Одна строка с криптовалютой
    ├── CryptoListView.swift   ← Список криптовалют
    └── TopGainersView.swift   ← Топ-5 криптовалют
```

---

## 📦 Часть 3: Модель данных (Crypto.swift)

### Что такое модель данных?

Модель - это описание того, как выглядит наша информация. Например, если мы описываем человека, мы говорим:
- Имя: строка текста
- Возраст: число
- Рост: число

Для криптовалюты мы описываем:
- id: уникальный идентификатор (строка)
- name: название (строка)
- symbol: символ (строка, например "BTC")
- currentPrice: текущая цена (число)
- image: ссылка на картинку (строка)

### Разбор кода построчно:

```swift
import Foundation
```
**Что это?**
- `import` - это как сказать "дай мне доступ к..."
- `Foundation` - это набор готовых инструментов от Apple
- Нужно для работы с данными

```swift
struct Crypto: Codable, Identifiable {
```
**Что это?**
- `struct` - это способ создать новый тип данных (как создать новый ящик для хранения информации)
- `Crypto` - название нашего типа (можно было назвать "Валюта" или "Монета")
- `Codable` - означает "я могу превращаться в JSON и обратно"
- `Identifiable` - означает "у меня есть уникальный номер (id)"

**Что такое JSON?**
JSON - это формат данных, который используется в интернете. Выглядит так:
```json
{
  "id": "bitcoin",
  "name": "Bitcoin",
  "current_price": 50000
}
```

```swift
let id: String
```
**Что это?**
- `let` - означает "это значение нельзя изменить" (константа)
- `id` - название свойства
- `String` - тип данных "строка текста"
- Пример: `id = "bitcoin"`

```swift
let name: String
```
- Название криптовалюты
- Пример: `name = "Bitcoin"`

```swift
let symbol: String
```
- Символ криптовалюты
- Пример: `symbol = "btc"`

```swift
let currentPrice: Double
```
- `Double` - это тип для чисел с десятичной точкой (50.5, 100.25)
- Пример: `currentPrice = 50000.0`

```swift
let image: String
```
- Ссылка на картинку в интернете
- Пример: `image = "https://assets.coingecko.com/coins/images/1/large/bitcoin.png"`

```swift
enum CodingKeys: String, CodingKey {
    case id
    case name
    case symbol
    case currentPrice = "current_price"
    case image
}
```

**Что это?**
- `enum` - это список вариантов
- `CodingKeys` - название (ключи для декодирования)
- `currentPrice = "current_price"` - это переводчик
  - В Swift мы пишем `currentPrice` (camelCase)
  - В JSON приходит `current_price` (snake_case)
  - Это говорит Swift: "когда видишь `current_price` в JSON, положи это в `currentPrice`"

**Зачем это нужно?**
В интернете данные приходят как `current_price`, а в Swift принято писать `currentPrice`. Это как переводчик между двумя языками.

---

## 🌐 Часть 4: Сетевой сервис (CryptoService.swift)

### Что такое сервис?

Сервис - это часть кода, которая отвечает за общение с интернетом. Представьте почтальона, который ходит за письмами.

### Протокол (интерфейс)

```swift
protocol CryptoService {
    func fetchCryptos() async throws -> [Crypto]
}
```

**Что такое протокол?**
Протокол - это как договор. Он говорит: "Кто бы ни реализовал этот протокол, должен уметь делать `fetchCryptos()`"

**Зачем это нужно?**
- Можно легко заменить реализацию (например, для тестов)
- Код становится более гибким

**Разбор функции:**
- `func` - функция (действие, которое можно выполнить)
- `fetchCryptos` - название функции (получить криптовалюты)
- `async` - асинхронная (может занять время, не блокирует приложение)
- `throws` - может выбросить ошибку
- `-> [Crypto]` - возвращает массив криптовалют

### Реализация сервиса

```swift
class RealCryptoService: CryptoService {
```
- `class` - класс (способ создать объект)
- `RealCryptoService` - название класса
- `: CryptoService` - означает "я выполняю договор CryptoService"

```swift
private let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd")!
```
**Что это?**
- `private` - видно только внутри этого класса
- `let` - константа (нельзя изменить)
- `url` - адрес в интернете
- `URL(string: "...")` - создает объект URL из строки
- `!` - означает "я уверен, что это не nil" (принудительное извлечение)

**Что такое URL?**
URL - это адрес в интернете. Например:
- `https://google.com` - адрес Google
- `https://api.coingecko.com/...` - адрес API для получения криптовалют

```swift
func fetchCryptos() async throws -> [Crypto] {
```
- Это реализация функции из протокола
- Должна делать то же самое, что описано в протоколе

```swift
let (data, _) = try await URLSession.shared.data(from: url)
```

**Разбор по частям:**

1. `URLSession.shared` - это готовый инструмент для работы с интернетом
   - `shared` - означает "общий экземпляр" (один на все приложение)

2. `.data(from: url)` - метод, который загружает данные по адресу
   - `from: url` - откуда загружать

3. `try await` - два ключевых слова:
   - `try` - может произойти ошибка (нет интернета, неправильный адрес)
   - `await` - подожди, пока загрузка не закончится

4. `let (data, _)` - получаем два значения:
   - `data` - сами данные (байты)
   - `_` - второе значение (ответ сервера), но мы его игнорируем

**Что происходит?**
1. Приложение отправляет запрос на сервер
2. Ждет ответа (может занять секунду или две)
3. Получает данные в формате JSON

```swift
let decoder = JSONDecoder()
return try decoder.decode([Crypto].self, from: data)
```

**Что это?**
1. `JSONDecoder()` - создаем декодер (переводчик из JSON в Swift)
2. `decoder.decode([Crypto].self, from: data)` - переводим JSON в массив Crypto
   - `[Crypto].self` - тип, в который переводим (массив Crypto)
   - `from: data` - откуда берем данные
3. `return` - возвращаем результат

**Весь процесс:**
```
Интернет (JSON) → URLSession → Data → JSONDecoder → [Crypto]
```

---

## 🧠 Часть 5: ViewModel (CryptoViewModel.swift)

### Что такое ViewModel?

ViewModel - это мозг приложения. Он:
- Хранит данные (список криптовалют)
- Управляет состоянием (загружается ли, есть ли ошибка)
- Выполняет действия (загрузить данные, обновить)

### @Observable

```swift
@Observable
class CryptoViewModel {
```

**Что такое @Observable?**
- Это специальная метка (макрос)
- Означает "SwiftUI, следи за изменениями в этом классе"
- Когда что-то меняется в ViewModel, SwiftUI автоматически обновляет экран

**Как это работает?**
1. Вы меняете `items` в ViewModel
2. SwiftUI видит изменение
3. SwiftUI автоматически перерисовывает экран

### Свойства (переменные)

```swift
var items: [Crypto] = []
```
- `var` - переменная (можно менять)
- `items` - название (список элементов)
- `[Crypto]` - тип: массив криптовалют
- `= []` - начальное значение: пустой массив

```swift
var isLoading = false
```
- `isLoading` - "загружается ли сейчас?"
- `false` - по умолчанию не загружается

```swift
var error: String?
```
- `error` - ошибка
- `String?` - опциональная строка (может быть nil или текст)
- `?` означает "может быть пустым"

**Что такое опционал (String?)?**
Опционал - это как коробка, которая может быть пустой или содержать что-то.
- `nil` - коробка пустая (ошибки нет)
- `"Ошибка сети"` - в коробке есть текст (есть ошибка)

```swift
private let service: CryptoService
```
- `private` - видно только внутри класса
- `service` - сервис для загрузки данных
- Храним ссылку на сервис

```swift
private var cachedItems: [Crypto]?
```
- `cachedItems` - закэшированные (сохраненные) данные
- `[Crypto]?` - опциональный массив (может быть nil)
- Используется для кэширования (Plus уровень)

### Инициализатор (конструктор)

```swift
init(service: CryptoService = RealCryptoService()) {
    self.service = service
}
```

**Что это?**
- `init` - функция, которая вызывается при создании объекта
- `service: CryptoService = RealCryptoService()` - параметр с значением по умолчанию
  - Если не передали сервис, используем `RealCryptoService()`
- `self.service = service` - сохраняем переданный сервис

**Зачем параметр по умолчанию?**
- В основном коде: `CryptoViewModel()` - использует реальный сервис
- В тестах: `CryptoViewModel(service: MockService())` - используем фейковый сервис

### Метод load() - загрузка данных

```swift
func load() async {
```

**Что делает эта функция?**
Загружает список криптовалют из интернета.

```swift
if let cached = cachedItems {
    items = cached
    return
}
```

**Кэширование (Plus уровень):**
- `if let cached = cachedItems` - "если есть закэшированные данные"
- `items = cached` - используем их
- `return` - выходим из функции (не делаем запрос в интернет)

**Зачем кэширование?**
- Экономит интернет-трафик
- Приложение работает быстрее
- Не нагружает сервер лишними запросами

```swift
isLoading = true
error = nil
```

**Установка состояния:**
1. `isLoading = true` - говорим "началась загрузка"
2. `error = nil` - очищаем предыдущие ошибки

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

**Разбор по частям:**

1. **do-catch блок:**
   ```swift
   do {
       // код, который может выбросить ошибку
   } catch {
       // что делать, если ошибка
   }
   ```
   - `do` - попробуй выполнить
   - `catch` - если ошибка, поймай ее

2. **Загрузка данных:**
   ```swift
   var fetchedItems = try await service.fetchCryptos()
   ```
   - `try await` - может быть ошибка, ждем завершения
   - `fetchCryptos()` - вызываем метод сервиса
   - Результат сохраняем в `fetchedItems`

3. **Сортировка (Plus уровень):**
   ```swift
   applySort()
   ```
   - Вызываем метод для применения выбранной сортировки
   - Смотрит на `sortOption` (какой способ сортировки выбран)
   - Применяет соответствующую сортировку к массиву `items`
   - Пользователь может выбрать способ сортировки в интерфейсе через Picker
   
   **Почему вызываем после загрузки?**
   - Данные приходят из интернета в случайном порядке
   - Нужно отсортировать их согласно выбору пользователя
   - Если пользователь еще не выбирал, используется значение по умолчанию (`.priceDescending`)

4. **Сохранение результатов:**
   ```swift
   items = fetchedItems
   cachedItems = fetchedItems
   ```
   - Сохраняем в `items` (для отображения)
   - Сохраняем в `cachedItems` (для кэша)

5. **Обработка ошибки:**
   ```swift
   catch {
       self.error = error.localizedDescription
   }
   ```
   - Если произошла ошибка (нет интернета, неправильный ответ)
   - Сохраняем текст ошибки в `error`
   - `localizedDescription` - понятное описание ошибки

```swift
isLoading = false
```

**Завершение:**
- Всегда сбрасываем флаг загрузки
- Даже если была ошибка, загрузка закончилась

### Метод refresh() - обновление

```swift
func refresh() async {
    cachedItems = nil
    await load()
}
```

**Что делает?**
1. Очищает кэш (`cachedItems = nil`)
2. Загружает данные заново (`await load()`)

**Когда используется?**
- При pull-to-refresh (потянуть вниз для обновления)
- Пользователь хочет получить свежие данные

### Enum SortOption - варианты сортировки (Plus уровень)

```swift
enum SortOption: String, CaseIterable {
    case priceDescending = "Price: High to Low"
    case priceAscending = "Price: Low to High"
    case nameAscending = "Name: A to Z"
    case nameDescending = "Name: Z to A"
}
```

**Что такое enum?**
- Enum (перечисление) - это список вариантов, из которых можно выбрать только один
- Представьте меню в ресторане: вы можете выбрать только одно блюдо из списка
- В нашем случае: пользователь может выбрать только один способ сортировки

**Зачем нужен enum?**
- Вместо того чтобы использовать строки ("priceDescending", "priceAscending"), мы используем enum
- Это безопаснее: нельзя случайно написать неправильное значение
- Компилятор проверяет, что мы используем только существующие варианты

**Разбор по частям:**

1. **`enum SortOption`** - создаем новый тип данных с названием SortOption
   - Это как создать новый ящик, в котором могут быть только определенные значения

2. **`: String`** - означает, что каждый вариант имеет строковое представление
   - `priceDescending.rawValue` вернет `"Price: High to Low"`
   - Это нужно для отображения в интерфейсе

3. **`CaseIterable`** - протокол, который позволяет перебрать все варианты
   - `SortOption.allCases` вернет массив всех вариантов: `[.priceDescending, .priceAscending, .nameAscending, .nameDescending]`
   - Нужно для `ForEach` в Picker

4. **`case priceDescending = "Price: High to Low"`** - один вариант enum
   - `priceDescending` - внутреннее название (используется в коде)
   - `"Price: High to Low"` - текст, который видит пользователь (rawValue)

**Варианты сортировки:**

1. **`priceDescending`** - "Price: High to Low"
   - Сортировка по цене от большой к маленькой
   - Bitcoin ($50,000) → Ethereum ($3,000) → Litecoin ($100)

2. **`priceAscending`** - "Price: Low to High"
   - Сортировка по цене от маленькой к большой
   - Litecoin ($100) → Ethereum ($3,000) → Bitcoin ($50,000)

3. **`nameAscending`** - "Name: A to Z"
   - Сортировка по названию по алфавиту от A до Z
   - Bitcoin → Ethereum → Litecoin

4. **`nameDescending`** - "Name: Z to A"
   - Сортировка по названию по алфавиту от Z до A
   - Litecoin → Ethereum → Bitcoin

**Пример использования:**
```swift
let option: SortOption = .priceDescending  // выбираем вариант
print(option.rawValue)  // выведет: "Price: High to Low"
```

### Свойство sortOption

```swift
var sortOption: SortOption = .priceDescending
```

**Что это?**
- Переменная, которая хранит текущий выбранный способ сортировки
- Тип: `SortOption` (может быть только один из 4 вариантов)
- Начальное значение: `.priceDescending` (по цене от большой к маленькой)

**Зачем это нужно?**
- Когда пользователь выбирает способ сортировки в интерфейсе, это значение меняется
- Метод `applySort()` смотрит на это значение и применяет соответствующую сортировку

**Как это работает:**
1. Пользователь открывает приложение → `sortOption = .priceDescending` (по умолчанию)
2. Пользователь выбирает "Price: Low to High" в Picker → `sortOption = .priceAscending`
3. `applySort()` видит новое значение и пересортировывает список

### Метод applySort() - применение сортировки

```swift
func applySort() {
    switch sortOption {
    case .priceDescending:
        items.sort { $0.currentPrice > $1.currentPrice }
    case .priceAscending:
        items.sort { $0.currentPrice < $1.currentPrice }
    case .nameAscending:
        items.sort { $0.name < $1.name }
    case .nameDescending:
        items.sort { $0.name > $1.name }
    }
}
```

**Что делает эта функция?**
- Применяет выбранную пользователем сортировку к списку `items`
- Вызывается автоматически при загрузке данных и при изменении выбора сортировки

**Что такое switch?**
- `switch` - это конструкция для выбора одного варианта из многих
- Альтернатива множественным `if-else`, но более читаемая и безопасная
- Компилятор проверяет, что все варианты обработаны

**Как работает switch:**

1. **Смотрим на значение:**
   ```swift
   switch sortOption {
   ```
   - Смотрим, какое значение у `sortOption`
   - Например, если `sortOption = .priceDescending`

2. **Находим соответствующий case:**
   ```swift
   case .priceDescending:
       items.sort { $0.currentPrice > $1.currentPrice }
   ```
   - Находим `case .priceDescending:`
   - Выполняем код внутри этого case

3. **Выполняем сортировку:**
   - `items.sort { ... }` - сортирует массив `items`
   - Изменяет порядок элементов в массиве

**Разбор каждого варианта сортировки:**

1. **`case .priceDescending:`** - по цене от большой к маленькой
   ```swift
   items.sort { $0.currentPrice > $1.currentPrice }
   ```
   - `$0` - первый элемент для сравнения (например, Bitcoin с ценой $50,000)
   - `$1` - второй элемент для сравнения (например, Ethereum с ценой $3,000)
   - `$0.currentPrice > $1.currentPrice` - если цена первого больше цены второго
   - Результат: Bitcoin ($50,000) идет перед Ethereum ($3,000)

2. **`case .priceAscending:`** - по цене от маленькой к большой
   ```swift
   items.sort { $0.currentPrice < $1.currentPrice }
   ```
   - `$0.currentPrice < $1.currentPrice` - если цена первого меньше цены второго
   - Результат: Ethereum ($3,000) идет перед Bitcoin ($50,000)

3. **`case .nameAscending:`** - по названию от A до Z
   ```swift
   items.sort { $0.name < $1.name }
   ```
   - `$0.name < $1.name` - сравнение строк по алфавиту
   - "Bitcoin" < "Ethereum" (B идет перед E)
   - Результат: Bitcoin идет перед Ethereum

4. **`case .nameDescending:`** - по названию от Z до A
   ```swift
   items.sort { $0.name > $1.name }
   ```
   - `$0.name > $1.name` - обратное сравнение
   - Результат: Ethereum идет перед Bitcoin

**Что такое $0 и $1?**
- Это сокращенные имена параметров в замыкании (closure)
- `$0` - первый параметр (первый элемент массива для сравнения)
- `$1` - второй параметр (второй элемент массива для сравнения)
- Swift автоматически передает элементы массива при сортировке

**Полный пример работы:**

Допустим, у нас есть массив:
```swift
items = [
    Crypto(name: "Ethereum", currentPrice: 3000),
    Crypto(name: "Bitcoin", currentPrice: 50000),
    Crypto(name: "Litecoin", currentPrice: 100)
]
```

Если `sortOption = .priceDescending`:
1. `applySort()` вызывается
2. `switch` находит `case .priceDescending:`
3. Выполняется `items.sort { $0.currentPrice > $1.currentPrice }`
4. Массив пересортировывается:
```swift
items = [
    Crypto(name: "Bitcoin", currentPrice: 50000),    // самая дорогая
    Crypto(name: "Ethereum", currentPrice: 3000),
    Crypto(name: "Litecoin", currentPrice: 100)    // самая дешевая
]
```

**Когда вызывается applySort()?**
1. После загрузки данных из интернета (в методе `load()`)
2. При использовании кэша (в методе `load()`)
3. Когда пользователь меняет выбор сортировки (через `onChange` в Picker)

### Свойство topGainers (Pro уровень)

```swift
var topGainers: [Crypto] {
    Array(items.prefix(5))
}
```

**Что это?**
- Вычисляемое свойство (computed property)
- Не хранит значение, а вычисляет его каждый раз при обращении

**Как работает:**
1. `items.prefix(5)` - берет первые 5 элементов из массива
2. `Array(...)` - превращает в массив
3. Возвращает топ-5 криптовалют

**Зачем?**
- Для секции "Top Gainers" (Pro уровень)
- Показываем только первые 5 самых дорогих

---

## 🎨 Часть 6: Views (Интерфейс)

### Что такое View?

View - это то, что видит пользователь на экране. Это как картинка, которая рисуется на основе данных.

### CryptoRowView - одна строка

```swift
struct CryptoRowView: View {
    let crypto: Crypto
    
    var body: some View {
```

**Разбор:**
- `struct` - структура (тип данных)
- `CryptoRowView` - название
- `: View` - означает "это View" (может отображаться на экране)
- `let crypto: Crypto` - параметр (какую криптовалюту показывать)
- `var body: some View` - что показывать на экране

**Что такое body?**
`body` - это обязательное свойство для всех View. Оно возвращает то, что нужно нарисовать.

```swift
HStack {
```

**HStack - горизонтальный стек:**
- Располагает элементы горизонтально (слева направо)
- Как слова в строке текста

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

**AsyncImage - асинхронная загрузка изображения:**

1. `AsyncImage(url: ...)` - загружает картинку по адресу
2. `{ image in ... }` - что делать, когда картинка загрузилась
   - `image` - загруженная картинка
   - `.resizable()` - можно изменять размер
   - `.aspectRatio(contentMode: .fit)` - сохранять пропорции
3. `placeholder: { ProgressView() }` - что показывать во время загрузки
   - `ProgressView()` - крутящийся индикатор
4. `.frame(width: 50, height: 50)` - размер: 50x50 точек

**Что происходит?**
1. Показываем индикатор загрузки
2. Загружаем картинку из интернета
3. Когда загрузилась - показываем картинку

```swift
VStack(alignment: .leading, spacing: 4) {
    Text(crypto.name)
        .font(.headline)
    Text(crypto.symbol.uppercased())
        .font(.caption)
        .foregroundColor(.secondary)
}
```

**VStack - вертикальный стек:**
- `alignment: .leading` - выравнивание по левому краю
- `spacing: 4` - расстояние между элементами (4 точки)

**Элементы:**
1. `Text(crypto.name)` - название криптовалюты
   - `.font(.headline)` - крупный шрифт
2. `Text(crypto.symbol.uppercased())` - символ (BTC, ETH)
   - `.uppercased()` - делает заглавными буквами
   - `.font(.caption)` - маленький шрифт
   - `.foregroundColor(.secondary)` - серый цвет

```swift
Spacer()
```

**Spacer - заполнитель:**
- Занимает все свободное пространство
- Толкает элементы к краям
- Здесь: название слева, цена справа

```swift
Text(formatPrice(crypto.currentPrice))
    .font(.headline)
```

**Цена:**
- `formatPrice(...)` - форматирует цену (50000 → "$50,000.00")
- `.font(.headline)` - крупный шрифт

### Функция formatPrice()

```swift
private func formatPrice(_ price: Double) -> String {
```

**Разбор:**
- `private` - видно только внутри этого View
- `func` - функция
- `formatPrice` - название
- `(_ price: Double)` - параметр (цена как число)
  - `_` - означает "без названия параметра при вызове"
  - `price` - название внутри функции
  - `Double` - тип (число с десятичной точкой)
- `-> String` - возвращает строку

```swift
let formatter = NumberFormatter()
formatter.numberStyle = .currency
formatter.currencyCode = "USD"
formatter.minimumFractionDigits = 2
formatter.maximumFractionDigits = 2
return formatter.string(from: NSNumber(value: price)) ?? "$0.00"
```

**NumberFormatter - форматирование чисел:**

1. `NumberFormatter()` - создаем форматтер
2. `.numberStyle = .currency` - формат валюты
3. `.currencyCode = "USD"` - доллары США
4. `.minimumFractionDigits = 2` - минимум 2 знака после запятой
5. `.maximumFractionDigits = 2` - максимум 2 знака
6. `formatter.string(from: NSNumber(value: price))` - форматируем
   - `NSNumber(value: price)` - превращаем Double в NSNumber
   - `.string(from:)` - превращаем в строку
7. `?? "$0.00"` - если форматирование не удалось, используем "$0.00"

**Результат:**
- `50000.0` → `"$50,000.00"`
- `1234.5` → `"$1,234.50"`

### CryptoListView - список

```swift
struct CryptoListView: View {
    let cryptos: [Crypto]
    
    var body: some View {
        ForEach(cryptos) { crypto in
            CryptoRowView(crypto: crypto)
        }
    }
}
```

**ForEach - цикл:**
- `ForEach(cryptos)` - для каждой криптовалюты в массиве
- `{ crypto in ... }` - что делать с каждой
- `CryptoRowView(crypto: crypto)` - создаем строку для этой криптовалюты

**Что происходит?**
Если в массиве 10 криптовалют, создается 10 строк.

### TopGainersView - топ криптовалюты

```swift
struct TopGainersView: View {
    let cryptos: [Crypto]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Top Gainers")
                .font(.title2)
                .fontWeight(.bold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(cryptos) { crypto in
                        // карточка криптовалюты
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
}
```

**Разбор:**

1. **Заголовок:**
   ```swift
   Text("Top Gainers")
       .font(.title2)
       .fontWeight(.bold)
   ```
   - Большой жирный текст

2. **Горизонтальный скролл:**
   ```swift
   ScrollView(.horizontal, showsIndicators: false) {
   ```
   - `.horizontal` - горизонтальная прокрутка (влево-вправо)
   - `showsIndicators: false` - скрыть полосу прокрутки

3. **Карточки:**
   ```swift
   ForEach(cryptos) { crypto in
       VStack(spacing: 8) {
           AsyncImage(...)
           Text(crypto.symbol.uppercased())
           Text(formatPrice(crypto.currentPrice))
       }
       .padding()
       .background(Color(.systemGray6))
       .cornerRadius(12)
   }
   ```
   - Каждая криптовалюта - карточка
   - Картинка, символ, цена
   - Серый фон, скругленные углы

### ContentView - главный экран

```swift
struct ContentView: View {
    @State private var viewModel = CryptoViewModel()
```

**@State:**
- Специальная метка для SwiftUI
- Означает "это состояние View"
- Когда `viewModel` меняется, SwiftUI обновляет экран

```swift
var body: some View {
    NavigationStack {
```

**NavigationStack:**
- Современная навигация (заменила NavigationView)
- Добавляет заголовок и навигацию

```swift
ZStack {
```

**ZStack:**
- Накладывает элементы друг на друга (как слои)
- Показываем только один слой в зависимости от состояния

```swift
if viewModel.isLoading {
    ProgressView("Loading...")
```

**Состояние загрузки:**
- Если `isLoading = true`
- Показываем индикатор загрузки

```swift
else if let error = viewModel.error {
    VStack(spacing: 16) {
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

**Состояние ошибки:**
- `if let error = viewModel.error` - если есть ошибка
- Показываем иконку, текст ошибки, кнопку "Retry"
- `Button("Retry")` - кнопка
- `Task { await viewModel.load() }` - при нажатии загружаем заново
  - `Task { }` - создает асинхронную задачу
  - `await viewModel.load()` - ждем загрузки

```swift
else if viewModel.items.isEmpty {
    VStack {
        Image(systemName: "list.bullet.rectangle")
        Text("No cryptocurrencies found")
    }
}
```

**Состояние пустого списка:**
- Если `items` пустой
- Показываем сообщение "нет данных"

```swift
else {
    List {
        Section {
            TopGainersView(cryptos: viewModel.topGainers)
        }
        
        Section {
            Picker("Sort", selection: $viewModel.sortOption) {
                ForEach(SortOption.allCases, id: \.self) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(.menu)
            .onChange(of: viewModel.sortOption) {
                viewModel.applySort()
            }
        }
        
        Section {
            ForEach(viewModel.items) { crypto in
                CryptoRowView(crypto: crypto)
            }
        }
    }
    .listStyle(.insetGrouped)
    .refreshable {
        await viewModel.refresh()
    }
}
```

**Состояние контента:**
- `List` - список (прокручиваемый)
- `Section` - секция списка
- Первая секция: Top Gainers
- Вторая секция: выбор сортировки (Plus уровень)
- Третья секция: весь список
- `.refreshable` - pull-to-refresh (потянуть вниз для обновления)

**Picker - выбор сортировки (Plus уровень):**

```swift
Picker("Sort", selection: $viewModel.sortOption) {
    ForEach(SortOption.allCases, id: \.self) { option in
        Text(option.rawValue).tag(option)
    }
}
.pickerStyle(.menu)
.onChange(of: viewModel.sortOption) {
    viewModel.applySort()
}
```

**Что такое Picker?**
- Picker - это выпадающее меню для выбора одного варианта из списка
- В нашем случае: пользователь выбирает способ сортировки

**Пошаговый разбор:**

1. **`Picker("Sort", selection: $viewModel.sortOption)`**
   - `"Sort"` - название (необязательно, можно оставить пустым)
   - `selection: $viewModel.sortOption` - что выбрано сейчас
   - `$` - означает "двусторонняя связь" (binding)
     - Можно читать значение: `viewModel.sortOption`
     - Можно менять значение: когда пользователь выбирает, значение автоматически обновляется

2. **`ForEach(SortOption.allCases, id: \.self) { option in`**
   - `SortOption.allCases` - все варианты enum: `[.priceDescending, .priceAscending, .nameAscending, .nameDescending]`
   - `id: \.self` - каждый вариант является своим уникальным идентификатором
   - `{ option in ... }` - для каждого варианта выполняем код

3. **`Text(option.rawValue).tag(option)`**
   - `Text(option.rawValue)` - показываем текст варианта пользователю
     - `.priceDescending.rawValue` = `"Price: High to Low"`
     - `.priceAscending.rawValue` = `"Price: Low to High"`
   - `.tag(option)` - связываем текст с вариантом enum
     - Когда пользователь выбирает текст, выбирается соответствующий вариант

4. **`.pickerStyle(.menu)`**
   - Стиль меню - выпадающий список
   - Пользователь нажимает на строку, появляется меню с вариантами

5. **`.onChange(of: viewModel.sortOption) { ... }`**
   - Срабатывает, когда меняется значение `viewModel.sortOption`
   - Когда пользователь выбирает новый вариант, это замыкание выполняется

6. **`viewModel.applySort()`**
   - Вызываем метод для применения новой сортировки
   - Список пересортировывается согласно новому выбору

**Что видит пользователь:**

1. **В списке видит строку:**
   ```
   Sort: Price: High to Low  ▼
   ```
   (▼ означает, что можно нажать)

2. **Нажимает на строку, видит меню:**
   ```
   ✓ Price: High to Low
     Price: Low to High
     Name: A to Z
     Name: Z to A
   ```
   (✓ показывает текущий выбор)

3. **Выбирает, например, "Price: Low to High"**

4. **Список автоматически пересортировывается:**
   - Самые дешевые криптовалюты вверху
   - Самые дорогие внизу

**Полный поток работы:**

```
Пользователь нажимает Picker
    ↓
Видит меню с вариантами
    ↓
Выбирает "Price: Low to High"
    ↓
viewModel.sortOption = .priceAscending (автоматически)
    ↓
onChange срабатывает
    ↓
viewModel.applySort() вызывается
    ↓
switch находит case .priceAscending:
    ↓
items.sort { $0.currentPrice < $1.currentPrice }
    ↓
Массив пересортировывается
    ↓
@Observable видит изменение items
    ↓
SwiftUI автоматически обновляет экран
    ↓
Пользователь видит пересортированный список
```

**Важные моменты:**

- `$viewModel.sortOption` - двусторонняя связь
  - Когда пользователь выбирает, значение меняется автоматически
  - Не нужно вручную обновлять `viewModel.sortOption`

- `SortOption.allCases` - автоматически получает все варианты
  - Если добавите новый вариант в enum, он автоматически появится в меню

- `option.rawValue` - текст для пользователя
  - Пользователь видит понятный текст, а не технические названия

```swift
.navigationTitle("Crypto List")
```

**Заголовок:**
- Название экрана в навигации

```swift
.task {
    await viewModel.load()
}
```

**Загрузка при появлении:**
- `.task` - выполняется при появлении View
- Автоматически загружает данные
- Отменяется при исчезновении View

---

## 🔄 Часть 7: Как все работает вместе

### Полный поток работы приложения:

1. **Запуск приложения:**
   ```
   CryptoListApp запускается
   ↓
   Создает ContentView
   ```

2. **Появление ContentView:**
   ```
   ContentView появляется на экране
   ↓
   .task модификатор срабатывает
   ↓
   Вызывается viewModel.load()
   ```

3. **Загрузка данных:**
   ```
   ViewModel.isLoading = true
   ↓
   Вызывается service.fetchCryptos()
   ↓
   RealCryptoService делает HTTP запрос
   ↓
   URLSession загружает данные из интернета
   ↓
   Получаем JSON
   ↓
   JSONDecoder превращает JSON в [Crypto]
   ```

4. **Обработка данных:**
   ```
   Сортируем по цене (Plus)
   ↓
   Сохраняем в items
   ↓
   Сохраняем в cachedItems (кэш)
   ↓
   ViewModel.isLoading = false
   ```

5. **Обновление экрана:**
   ```
   @Observable видит изменение items
   ↓
   SwiftUI автоматически обновляет ContentView
   ↓
   Отображается список криптовалют
   ```

6. **Взаимодействие:**
   ```
   Пользователь тянет вниз (pull-to-refresh)
   ↓
   .refreshable срабатывает
   ↓
   Вызывается viewModel.refresh()
   ↓
   Очищается кэш
   ↓
   Загружаются свежие данные
   ```

---

## 📝 Часть 8: Важные концепции для новичков

### 1. Типы данных

**String (строка):**
```swift
let name: String = "Bitcoin"
```

**Int (целое число):**
```swift
let count: Int = 5
```

**Double (число с точкой):**
```swift
let price: Double = 50.5
```

**Bool (да/нет):**
```swift
let isLoading: Bool = true
```

**Массив:**
```swift
let items: [Crypto] = [crypto1, crypto2, crypto3]
```

**Опционал (может быть nil):**
```swift
let error: String? = nil  // или "Ошибка"
```

**Enum (перечисление):**
```swift
enum SortOption: String, CaseIterable {
    case priceDescending = "Price: High to Low"
    case priceAscending = "Price: Low to High"
}
let option: SortOption = .priceDescending
print(option.rawValue)  // "Price: High to Low"
```
- Список вариантов (можно выбрать только один)
- Как меню в ресторане
- `: String` - каждый вариант имеет строковое значение (rawValue)
- `CaseIterable` - можно перебрать все варианты через `.allCases`

### 2. Управляющие конструкции

**if-else (если-иначе):**
```swift
if isLoading {
    // показываем загрузку
} else {
    // показываем контент
}
```

**if let (безопасное извлечение опционала):**
```swift
if let error = viewModel.error {
    // error здесь точно не nil
    Text("Error: \(error)")
}
```

**for-in (цикл):**
```swift
for crypto in cryptos {
    // делаем что-то с каждой криптовалютой
}
```

### 3. Функции

**Синтаксис:**
```swift
func название(параметр: Тип) -> ТипВозврата {
    // код
    return результат
}
```

**Пример:**
```swift
func formatPrice(_ price: Double) -> String {
    return "$\(price)"
}
```

### 4. async/await

**async функция:**
```swift
func load() async {
    // может занять время
}
```

**await вызов:**
```swift
await load()  // ждем завершения
```

**Task для вызова async из синхронного кода:**
```swift
Task {
    await load()
}
```

### 5. Обработка ошибок

**do-catch:**
```swift
do {
    try await load()
} catch {
    // обработка ошибки
}
```

---

## ✅ Часть 9: Проверка выполнения ТЗ

### Base уровень ✅

- ✅ Модель Crypto (id, name, symbol, current_price, image)
- ✅ Протокол CryptoService
- ✅ Реализация RealCryptoService с URLSession.shared.data(from:)
- ✅ ViewModel с load() async, items, isLoading, error
- ✅ .task { await vm.load() }
- ✅ Список: иконка, название, цена
- ✅ Состояния: loading, error + retry, empty, content
- ✅ Минимум 2 отдельные вьюхи (CryptoRowView, CryptoListView)

### Plus уровень ✅

- ✅ Кэширование (cachedItems)
- ✅ Сортировка по цене с возможностью выбора (SortOption, applySort, Picker)
- ✅ Форматирование цены (formatPrice)

### Pro уровень ✅

- ✅ AsyncImage с placeholder
- ✅ Pull-to-refresh (.refreshable)
- ✅ Секция "Top Gainers" (TopGainersView)

---

## 🎓 Часть 10: Что дальше изучать?

1. **Swift основы:**
   - Переменные и константы
   - Типы данных
   - Функции
   - Классы и структуры

2. **SwiftUI:**
   - Компоненты (Text, Image, Button)
   - Layout (HStack, VStack, ZStack)
   - Списки (List, ForEach)
   - Навигация

3. **Асинхронность:**
   - async/await
   - Task
   - Обработка ошибок

4. **Архитектура:**
   - MVVM
   - Разделение ответственности
   - Тестирование

---

## 💡 Заключение

Вы создали полнофункциональное приложение! Теперь вы понимаете:
- Как структурировать код
- Как загружать данные из интернета
- Как отображать данные на экране
- Как обрабатывать разные состояния
- Как использовать современные технологии Swift/SwiftUI

Продолжайте практиковаться и изучать новые концепции! 🚀

