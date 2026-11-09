# 1. Берем легкий образ с Java 21
FROM eclipse-temurin:21-jre-alpine

# 2. Указываем рабочую папку внутри контейнера
WORKDIR /app

# 3. Копируем скомпилированный JAR файл в контейнер под именем app.jar
# (Звездочка нужна, чтобы Docker подхватил любой JAR в этой папке)
COPY build/libs/*.jar app.jar

# 4. Команда для запуска нашего приложения
ENTRYPOINT ["java", "-jar", "app.jar"]
