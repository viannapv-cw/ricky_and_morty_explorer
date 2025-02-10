# rick_and_morty_explorer

A new Flutter project.

## Getting Started

# Flutter Challenge: Rick and Morty Explorer

## Overview
Develop a Flutter application that allows users to explore the Rick and Morty universe, focusing on episodes and their characters.

## Main Objectives
- Create an intuitive and responsive interface
- Implement development best practices
- Demonstrate clean architecture knowledge
- Provide a smooth user experience

## Essential Features

### Home Screen
#### Episodes List
- Infinite scroll for progressive loading
- Search by episode name
- Filter by season
- Display episode code (e.g., S01E01)
- Display air date

#### Episode Card
- Episode name
- Episode code
- Air date
- Favorite episode button

#### Screen States
- Loading
- Empty State
- Error State
- Success State

### Episode Details Page
#### Episode Information
- Complete episode data
  - Name
  - Air date
  - Episode code
  - Season number
- Favorite episode option

#### Characters List
- Characters list that appear in the episode
  - Character photo
  - Name
  - Status indicator (alive/dead/unknown)
  - Species
  - Current location

#### Screen States
- Loading
- Empty State
- Error State
- Success State

### Favorites Episodes Page
#### Favorites List
- List of favorited episodes
- Favorites management
- Quick access to episode details

#### Screen States
- Loading
- Empty State
- Error State
- Success State

## Technical Specifications

### State Management
- We recommend Bloc/Cubit for state management

### Storage and API
- Rick and Morty API integration
- Local persistence for favorite episodes
- Proper error handling

### Testing
- Unit tests implementation
- Significant code coverage

### Interface
- Modern and intuitive design
- Fluid user experience
- Responsiveness

## Resources
### Rick and Morty API
- Base URL: [https://rickandmortyapi.com/api](https://rickandmortyapi.com/api)
- Episodes endpoint: `/episode`
- Characters endpoint: `/character`

## Evaluation Criteria
- Code quality and organization
- Features implementation
- Error handling
- Unit tests
- UI/UX
- Performance
- Architecture and project structure

## Delivery
- Source code in Git repository
- README with execution instructions
- Documentation of any additional features or improvements

