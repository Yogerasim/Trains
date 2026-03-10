# Trains

Railway timetable iOS app built with **SwiftUI**, **MVVM**, **Combine**, **Swift Concurrency**, and **Yandex Schedule API**.

## Overview

**Trains** is an iOS application for searching railway routes between stations across Russia. The app is built entirely with **SwiftUI** and follows an **MVVM** architecture with a protocol-oriented service layer, reusable UI components, and a design-system-based structure.

The project combines real API integration, generated networking via **Swift OpenAPI Generator**, modern asynchronous programming with **async/await**, filtering logic, caching, stories UI, settings management, and multiple loading / error states. It was designed as a production-style mobile application rather than a simple demo.

## Key Features

- Search railway routes between stations
- Two-level location flow: **city → station**
- Swap origin and destination in one tap
- Interactive **stories** with progress bar, gestures, and timer
- Filtering by departure time and transfer availability
- Carrier details screen with contact information
- Theme switching: system / light / dark
- User agreement screen
- Local caching of city data in `UserDefaults`
- Placeholder states for:
  - no internet
  - server error
  - empty results

## Product Functionality

### Main Search Flow
The main screen includes:
- stories carousel
- route card with origin and destination
- swap button
- animated search action
- loading / error / content states

### City and Station Selection
The user selects:
1. city
2. station

This flow supports:
- real-time search
- async loading
- cached city list
- `NavigationStack`-based navigation

### Search Results
The results screen displays:
- list of railway routes
- carrier logo
- departure / arrival information
- travel duration
- transfer information
- filtering controls
- navigation to carrier details

### Stories
The app includes a fully custom stories implementation with:
- segmented progress bar
- automatic timer
- swipe navigation
- tap zones for previous / next story
- viewed stories tracking

## Architecture

The project follows **MVVM** with a clear separation between:
- Views
- ViewModels
- domain models
- services
- reusable UI components
- design system tokens

### Main Architectural Decisions
- **MVVM**
- **Protocol-Oriented Services**
- **Actor-based networking**
- **@MainActor ViewModels**
- **Dependency Injection through init**
- **Design System for colors and typography**
- **Reusable SwiftUI components**
- **State-driven UI**

## Tech Stack

- **Swift**
- **SwiftUI**
- **MVVM**
- **Combine**
- **Swift Concurrency**
- **async/await**
- **actor**
- **Swift OpenAPI Generator**
- **OpenAPIRuntime**
- **OpenAPIURLSession**
- **URLSession**
- **UserDefaults**
- **@AppStorage**
- **JSONDecoder**
- **YAML / OpenAPI**
- **Design System**
- **Programmatic UI**

## Networking

The app integrates with **Yandex Schedule API** and uses a mix of:
- generated API client code from OpenAPI specification
- runtime networking via `OpenAPIRuntime`
- transport layer based on `OpenAPIURLSession`
- custom decoding logic for Yandex-specific date formats

### Covered API Domains
- route search
- station schedule
- route thread
- stations list
- carrier details
- nearest stations
- nearest settlement
- copyright information

## Technical Highlights

### Actor-Based Services
All networking services are implemented as `actor`, providing thread-safe async access without manual locking.

### OpenAPI-Based Client Generation
The project uses **Swift OpenAPI Generator** to create a typed networking layer from an OpenAPI specification, making the API integration more structured and scalable.

### Custom Transport Layer
A custom transport handles non-standard API responses and adapts them for JSON decoding.

### Custom JSON Decoding
The app includes a decoder that supports multiple date formats returned by Yandex Schedule API.

### Reactive Filtering
Filtering and UI updates are driven by state and reactive flows in the ViewModel layer.

## Design System

The project uses a centralized design system with:
- color tokens
- typography tokens
- reusable controls
- placeholder states
- navigation title components
- selection rows
- stories progress UI

This helps keep the UI consistent and easier to scale.

## Why this project is strong

Trains demonstrates more than just screen building. It shows:

- real API integration
- generated networking layer
- modern Swift concurrency
- structured MVVM architecture
- reusable component approach
- state-driven SwiftUI development
- filtering and search flows
- custom stories implementation
- theme management
- caching and persistence for app state
- production-style project organization

This makes it a strong example of an iOS product project with both engineering depth and user-facing polish.

## Possible Next Steps

Potential product extensions:
- favorites / recent routes
- offline cache for route search
- push notifications for route changes
- widget support
- broader localization
- analytics integration
- advanced tests for ViewModels and services

## Author

**Philip Gerasimov**  
iOS Developer  
GitHub: [Yogerasim](https://github.com/Yogerasim)
