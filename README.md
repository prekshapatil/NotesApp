# NotesApp
NotesApp – a sleek and intuitive Swift-powered app where users can register, log in, and effortlessly capture, organize, and manage their notes!

## Features

- **Authentication:**  
  Securely register, log in, and manage your account with email and password. (Logout functionality is simulated locally due to API limitations.)

- **Profile Management:**  
  View and update your profile details once you're logged in.

- **Notes Management:**  
  - View all your created notes in one place.
  - Easily create new notes with multiline support via `UITextView`.
  - Delete notes that you no longer need.

- **Persistence (Optional Extra Credit):**  
  Retain the logged-in state between app launches using `UserDefaults`, so you don’t have to log in again.

## API Details

The application interacts with a provided JSON API for handling authentication, profile management, and notes operations (details provided in your assignment documentation).

## Getting Started

### Clone the Repository

Clone the repository to your local machine:

git clone https://github.com/prekshapatil/NotesApp

### Install Dependencies

If you’re using CocoaPods, install the dependencies with:
pod install
If you're not using CocoaPods, manually integrate Alamofire using Package Dependencies to handle network requests.

### Run the App
Open the project in Xcode and run it on your simulator or device.

## Usage

1. Login Screen
Upon launch, the app will display the login screen. If you're a new user:
Enter your name, email, and password to register.
The app ensures a valid email format and prevents duplicate registrations based on API limitations.

2. Log In
For returning users, enter your registered email and password to log in. The app will validate the credentials and log you into your notes screen.

3. Create a New Note
Tap the "Add Note" button.
Enter your note content in the UITextView.
Tap "Save" to create the note.

5. View Notes
Your notes will be displayed in a list.
Tap a note to view its details.

7. Delete a Note
When viewing a note, tap the delete button to remove it from the database.
Confirm the deletion.

Extra Features (Optional)
UserDefaults:
The app attempts to retain your logged-in state between sessions using UserDefaults. If successful, you won’t need to log in again on subsequent app launches.
Contributing
Feel free to fork the repository, contribute improvements, and open pull requests for any fixes or features you'd like to add.
