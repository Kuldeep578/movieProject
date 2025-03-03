# movieProject

Architecture Decisions
1. MVVM (Model-View-ViewModel)

a) Separation of concerns: UI logic is in Views, business logic in ViewModel, and data handling in Services.
b) Enables better unit testing and maintainability.

2) Asynchronous API Calls

a) Uses async/await for network requests, improving readability.
b) Core Data for Persistence

3) Ensures offline access to movies and favorites.

a) Optimized with duplicate checking before saving.
b) Combine for State Management

4) Debounces search input to reduce unnecessary API calls.
   
a)Performance Optimizations

5) Uses WebImage from SDWebImageSwiftUI for efficient image loading.
   
a)Avoids redundant database writes by checking for existing data before saving.


Features

1) Movie Listing & Details

  a) Displays a list of movies with posters, titles, and release dates.
  b) Clicking a movie opens its detail view.
  c) Search with Real-time Filtering & Sorting

2) Searches for movies as the user types (debounced for efficiency).

  a) Sorting: Movies that start with the typed character appear first.
  b) Favorites System

3) Allows users to mark/unmark movies as favorites.

  a) Uses Core Data to persist favorite selections.
  b) Offline Mode

4) Saves fetched movies locally using Core Data.

  a) When offline, previously saved movies are displayed.
  b) Avoids saving duplicates in the database.
  c) Error Handling & User Feedback

Displays errors when API calls fail.
Shows loading indicators when fetching data.
