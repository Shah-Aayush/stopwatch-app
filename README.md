# StopWatch : A flutter app
toddle internship task

## Basic functionalities
-  Start / Stop timer button
-  Lap / Reset button:
	-  Lap button : records the laps from the overall timer.
	-  Reset button : resets the overall timer and clears the laps
records
-  List of laps
-  Save laps with a title as a record
-  Search records
-  Edit record title
-  Delete record

## Bonus functionalities
-  Records should persist even on app re-open
-  Row animation when a lap is added to the list
-  Delete lap row animation
-  Hour-Format conversion switch

## Steps to run my app
1. Assuming flutter is installed on the computer, 
	> if not, install flutter from [here](https://docs.flutter.dev/get-started/install)
	- check your flutter installation is properly done or not with `flutter doctor -v`
2. go to main directory i.e. which contains `lib`,`ios`,`android` files
3. see available devices with `flutter devices`
4. select any available device name and append it to following command
	- `flutter run -d <your-device-name>`
- additional : 
	- To run on any iphone on release mode which has name `Aayush’s iPhone` displayed under devices section, run `flutter run -d 'Aayush’s iPhone' --release`
	- For building release apk for android, run following command `flutter  build apk --release`

# Author
- Name : Aayush Shah
- Roll Number : 19BCE245
- College : Nirma University