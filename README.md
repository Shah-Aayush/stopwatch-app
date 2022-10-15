# stopwatch

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## Problems encounted
- Milliseconds to second's 100th part conversion
- moving digits in stopwatch as digit has differnt widths
	- solved using `fontFeatures: [FontFeature.tabularFigures()],`
	> but flickering happened
	- next solution : individual containers for each second, minutes and milliseconds/10.