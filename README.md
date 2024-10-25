# Filmox Clean Architecture

Welcome to the **Filmox Clean Architecture** repository. This project is a refactored version of the Filmox application, designed to follow Clean Architecture principles. By structuring the codebase with a focus on separation of concerns, modularity, and testability, the project is now more maintainable and scalable.

## Table of Contents
- [Project Overview](#project-overview)
- [Clean Architecture Overview](#clean-architecture-overview)
- [Folder Structure](#folder-structure)
- [Getting Started](#getting-started)
- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Project Overview

Filmox is an app that allows users to explore movies and TV series, providing information about each, including cast, crew, and seasons. The project was refactored to adopt **Clean Architecture** principles for better code management, separation of concerns, and long-term scalability.

This repository demonstrates how Clean Architecture is applied to a Flutter app by splitting the code into independent layers: Presentation, Domain, and Data.

## Clean Architecture Overview

Clean Architecture divides the codebase into layers, each with its own responsibility. This keeps concerns separate and allows for better testing, scalability, and maintenance. The core layers of Clean Architecture are:

1. **Presentation**: Handles the UI logic (e.g., Widgets, ViewModels).
2. **Domain**: Contains business logic and use cases. It is independent of external dependencies.
3. **Data**: Manages data sources (e.g., API, local database) and repositories to abstract data operations.

### Clean Architecture Structure:

- **Presentation Layer**: UI logic with state management (e.g., using Provider or Bloc).
- **Domain Layer**: Includes entities, use cases, and repositories.
- **Data Layer**: Contains the implementation of repositories, data sources (e.g., REST APIs, database), and mappers.

## Folder Structure

```plaintext
lib/
├── data/
│   ├── datasources/       # Handles API and local data sources
│   ├── models/            # DTOs and data models
│   └── repositories/      # Implementation of the repository interfaces
├── domain/
│   ├── entities/          # Core business objects
│   ├── repositories/      # Abstract repository interfaces
│   └── usecases/          # Business logic and application-specific rules
├── presentation/
│   ├── bloc/              # State management using Bloc (or Provider)
│   └── pages/             # Flutter widgets for the UI
└── core/                  # Common utilities, constants, and error handling


## Getting Started

To get started with the Filmox Clean Architecture project, follow these steps:

### Prerequisites

- [Flutter](https://flutter.dev) installed on your machine
- An IDE such as [VSCode](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio)
- [Dart](https://dart.dev) SDK

### Installation

1. Clone this repository:

   ```bash
   git clone https://github.com/yourusername/filmox_clean_architecture.git
   
2. Navigate to the project directory:

cd filmox_clean_architecture

3. Install the dependencies:

flutter pub get
### Usage
1. Run the project on an emulator or physical device:

flutter run

2. Browse the app, explore movies and TV series, and navigate through the features!

