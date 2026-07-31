# ⚙️ Config Server (Централизованные конфигурации)

Инфраструктурный микросервис, обеспечивающий централизованное управление конфигурациями всех модулей распределенной системы. Построен на базе **Spring Cloud Config Server**, **Spring Boot 3.2.2** и **Java 21**.

Сервис работает на порту **`8888`** и избавляет от необходимости хранить файлы настроек (`application.yml`) внутри репозиториев самих микросервисов.

---

## 🛠️ Назначение и принцип работы

* **Externalized Configuration:** Хранит настройки всех сервисов системы в одном месте. При изменении параметров (например, пароля к БД или топика Kafka) не нужно пересобирать сами микросервисы — достаточно обновить файл настроек и перезапустить контейнер, либо обновить контекст приложений.
* **Профиль `native`:** Сервер настроен на чтение конфигурационных файлов из локальной файловой системы (директории репозитория конфигураций). 
* **Интеграция с Service Discovery:** Сервер автоматически регистрируется в Eureka Client, благодаря чему остальные микросервисы могут находить хранилище настроек динамически.

---

## 🗺️ Структура репозитория настроек (`config-repo`)

Сервер считывает свойства для каждого микросервиса на основе его имени (`spring.application.name`). В папке конфигураций должны находиться следующие файлы:
```text
config-repo/
├── api-gateway.yml          # Общие настройки маршрутов шлюза
├── user-service.yml         # Свойства подключения к PostgreSQL и Kafka для модуля пользователей
└── notification-service.yml # Параметры SMTP-сервера и Kafka Consumer для модуля уведомлений
```

---

## 💻 Технологический стек

* **Runtime:** Java 21 (LTS).
* **Core Framework:** Spring Boot 3.2.2 & Spring Cloud Config Server.
* **Service Discovery:** `spring-cloud-starter-netflix-eureka-client` для регистрации в сервис-локаторе.
* **Тестирование:** JUnit 5.

---

## ⚙️ Рабочая конфигурация (`application.yml`)

Текущие локальные настройки сервера задают порт, включают `native` профиль поиска и указывают путь к файлам конфигурации:

```yaml
server:
  port: 8888

spring:
  application:
    name: config-server
  profiles:
    active: native
  cloud:
    config:
      server:
        native:
          search-locations: file:///C:/config-repo/  # Для переносимости на GitHub можно заменить на file:./config-repo/

eureka:
  client:
    service-url:
      defaultZone: http://localhost:8761/eureka/
```

---

## 📂 Архитектурная структура модулей

```text
config-server/
├── gradle/wrapper/            # Настройки сборщика Gradle Wrapper
└── src/
    ├── test/                  # Тестирование инициализации контекста сервера
    └── main/
        ├── resources/         # Локальные свойства инициализации (application.yml)
        └── java/io/gsc/     
            └── ConfigServerApplication.java  # Класс запуска сервера с аннотацией @EnableConfigServer
```

---

## 🛰️ Проверка работоспособности (REST API)

Вы можете проверить, какие конфигурации отдает сервер, сделав прямой HTTP-запрос через браузер, Postman или cURL:
* `http://localhost:8888/user-service/default` — возвращает настройки для `user-service`.
* `http://localhost:8888/api-gateway/default` — возвращает настройки маршрутов шлюза.
* `http://localhost:8888/notification-service/default` — возвращает настройки для службы уведомлений.

---

## 🚀 Команды для сборки и локального запуска

Для компиляции и сборки проекта требуется установленный **JDK 21**.

* **Сборка проекта в переносимый JAR-файл (без запуска тестов):**
  ```bash
  ./gradlew clean build -x test
  ```
* **Локальный запуск артефакта через терминал:**
  ```bash
  java -jar build/libs/config-server-0.0.1-SNAPSHOT.jar
  ```
* **Запуск тестов:**
  ```bash
  ./gradlew test
  ```
