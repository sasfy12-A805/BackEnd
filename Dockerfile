# 빌드를 위해 자바 17 slim 이미지 사용
FROM openjdk:17-jdk-slim AS build

# 작업 디렉토리 설정
WORKDIR /app

# 소스 코드 및 Gradle 관련 파일 복사
COPY gradlew .
COPY build.gradle .
COPY settings.gradle .
COPY ./gradle ./gradle
COPY ./src ./src

# Gradle 빌드 실행 (테스트 제외를 원하면 "-x test")
RUN chmod +x ./gradlew
RUN ./gradlew clean bootJar -x test

# 실행을 위해 자바 17 slim 이미지 사용
FROM openjdk:17-jdk-slim

# 작업 디렉토리 설정
WORKDIR /app

# jar파일 복사
COPY --from=build /app/build/libs/*.jar app.jar

# wait-for-it을 사용하여 DB 연결 확인 후 앱 시작
ENTRYPOINT ["java", "-jar", "app.jar"]