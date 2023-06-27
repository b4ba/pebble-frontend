# Pebble Vote

This is a project for a mobile client that interacts with the [E-cclesia e-voting protocol](https://www.pebble.vote/). The client is developed using [Flutter](https://flutter.dev/) and [BLoC](https://bloclibrary.dev/#/) as the state management.

## State of project

At the moment, the UI is not connected with the backend. To connect it, you should understand how to use BLoC because it is the state management that has been setup. Currently dummy data is being populated in the UI.

## How to start the project

### Installing Flutter

Make sure you have flutter installed first. To check if flutter is installed in your machine, run this command:

```
flutter --version
```

If the version of flutter did not print out, it means your machine does not have flutter installed. Click [here](https://docs.flutter.dev/get-started/install/windows) to learn how to install flutter into your machine.

Once you have installed Flutter, go into the directory of this project and run:

```
flutter pub get
flutter run
```

If flutter has a problem, run:

```
flutter doctor
```

And fix any error that is presented and try to run again.

## Developer notes

1. Dummy data can be found in the respective model dart files, `lib/data/models`.
2. This project uses `app_router` for routes.