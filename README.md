# Chooser App

**Chooser** is an interactive app built with SwiftUI, designed for randomly selecting players based on their touch interactions with the screen. Users can configure the number of players, tasks, and game levels before starting the random selection process. The app also offers different game modes, such as **Simple Mode** and **Task Mode**.

## Features

- **Multi-touch support**: Multiple players can interact simultaneously.
- **Customizable settings**: Configure the number of players, tasks, and time to complete the game.
- **Countdown timer**: Set a time limit for the game.
- **Random selection**: A player is randomly selected based on touch interactions.
- **Task Mode**: Players are assigned tasks they need to complete within a time limit.
- **Game modes**: Choose between Simple Mode and Task Mode.
- **Winner View**: Displays the winner after the game is over with the option to restart.

## Requirements

- iOS 18+
- Swift 6+
- Xcode 16.3

## Installation

To get started with the project, clone this repository:

```bash
git clone https://github.com/yourusername/Chooser.git
```
Choose your own team in **Signing & Capabilities** in project settings

## Design and Development Process

The app was built using SwiftUI to create a modern and responsive interface. The core logic for managing touch interactions and random player selection is handled in CustomTouchView.swift, which processes multi-touch inputs and visually represents them. Game settings, such as the number of players, time limits, and tasks, are managed through the SettingsView.swift and ConstantValues.swift.

## Unique Approaches or Methodologies Used

The app integrates UIImpactFeedbackGenerator to provide haptic feedback when players interact with the screen, enhancing the overall user experience.

## Trade-offs Made During Development

One of the main trade-offs was limiting the number of touches to match the number of players, to prevent performance issues and ensure smooth gameplay. Though additional touches could have been allowed, the game’s simplicity and performance were prioritized.

## Known Issues or Problems
- The Task Mode does not yet include a dynamic task generator beyond the predefined tasks in **FireStore Database**.
- There were difficulties in handling smooth navigation between different screens, leading to occasional glitches in the user experience.
- The system currently struggles to automatically start a new task once a player has been eliminated.

## Why This Technical Stack Was Chosen

I chose to use modern SwiftUI in combination with UIKit because I read that complex animations are better handled using CALayer. SwiftUI offers a modern and declarative syntax, which speeds up development and integrates well with other iOS frameworks. Additionally, it provides powerful tools for managing dynamic layouts, making it ideal for building interactive, touch-based apps.
