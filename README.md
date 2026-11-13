# Task Manager

Task Manager is a responsive mobile application designed for users to organize, track, and manage daily tasks efficiently. Built using Flutter and Firebase, the application provides secure authentication, real-time data persistence, task prioritization, due date tracking, and customizable appearance settings across mobile devices.

Features:

- User Authentication: User registration and login using Firebase Authentication with Email and Password, along with Google OAuth single sign-on.
- Error Handling: Real-time user feedback with error messages for invalid credentials, weak passwords, or unformatted input.
- Task Creation and Editing: Ability to create new tasks or update existing tasks, including title, description, due date, time, and priority level.
- Priority Assignment: Support for Low, Medium, and High priority levels with color-coded indicators.
- Completion Tracking: Ability to mark tasks as complete or incomplete with visual strikethrough styling and state updates.
- Real-time Storage: Data stored and synchronized in real time using Cloud Firestore.
- Task Filtering: Ability to filter tasks by priority (All, Low, Medium, High) and status (Completed, Incomplete).
- Sorted List View: Tasks displayed in a list format, automatically sorted by due date from earliest to latest.
- User Interface: Responsive UI adhering to Material Design principles with Light Mode, Dark Mode, and System Default themes.
