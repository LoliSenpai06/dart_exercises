import 'dart:io';

// Defines the service description every train type must provide.
abstract class TrainService {
  String serviceDescription();
}

// Adds announcement behavior that can be shared by different classes.
mixin PassengerMessaging {
  void sendMessage(String message) {
    print('Announcement: $message');
  }
}

// Stores shared train data and behavior for the specific train types.
abstract class Lrt2Train implements TrainService {
  String trainNumber;
  String direction;
  int sampleCapacity;
  int _passengerCount;

  // Initializes a train and rejects passenger or capacity values that
  // would put the train in an invalid state.
  Lrt2Train({
    required this.trainNumber,
    required this.direction,
    required this.sampleCapacity,
    int passengerCount = 0,
  }) : _passengerCount = passengerCount {
    if (sampleCapacity <= 0) {
      throw ArgumentError('Capacity must be greater than zero.');
    }
    if (passengerCount < 0 || passengerCount > sampleCapacity) {
      throw ArgumentError('Passenger count must be within the train capacity.');
    }
  }

  // Allows other code to read the count without directly changing it.
  int get passengerCount => _passengerCount;

  // Adds one passenger if there is room; returns false when the train is full.
  bool boardPassenger() {
    if (_passengerCount >= sampleCapacity) {
      return false;
    }

    _passengerCount++;
    return true;
  }

  // Simulates an asynchronous save operation and returns a confirmation.
  Future<String> saveTrainRecord() async {
    await Future.delayed(const Duration(seconds: 1));
    return 'Train $trainNumber record saved.';
  }

  // Prints the shared train details.
  void displayStatus() {
    print(
      'Train $trainNumber | Direction: $direction | '
      'Passengers: $_passengerCount/$sampleCapacity',
    );
  }
}

// Represents a local train and provides its own service description.
class LocalTrain extends Lrt2Train with PassengerMessaging {
  // Passes the local train's details to the shared parent constructor.
  LocalTrain({
    required String trainNumber,
    required String direction,
    required int sampleCapacity,
    int passengerCount = 0,
  }) : super(
          trainNumber: trainNumber,
          direction: direction,
          sampleCapacity: sampleCapacity,
          passengerCount: passengerCount,
        );

  // Implements the service description required by TrainService.
  @override
  String serviceDescription() {
    return 'Local service: stops at every station.';
  }

  // Adds the local-service label before printing the shared status.
  @override
  void displayStatus() {
    print('LOCAL | ${serviceDescription()}');
    super.displayStatus();
  }
}

// Represents an express train and provides its own service description.
class ExpressTrain extends Lrt2Train with PassengerMessaging {
  // Passes the express train's details to the shared parent constructor.
  ExpressTrain({
    required String trainNumber,
    required String direction,
    required int sampleCapacity,
    int passengerCount = 0,
  }) : super(
          trainNumber: trainNumber,
          direction: direction,
          sampleCapacity: sampleCapacity,
          passengerCount: passengerCount,
        );

  // Implements the service description required by TrainService.
  @override
  String serviceDescription() {
    return 'Express service: skips selected stations.';
  }

  // Adds the express-service label before printing the shared status.
  @override
  void displayStatus() {
    print('EXPRESS | ${serviceDescription()}');
    super.displayStatus();
  }
}

// Provides a station kiosk with the shared announcement behavior.
class StationKiosk with PassengerMessaging {}

// Finds a train by its number, or returns null if no train matches.
Lrt2Train? findTrain(List<Lrt2Train> trains, String trainNumber) {
  for (final train in trains) {
    if (train.trainNumber == trainNumber) {
      return train;
    }
  }

  return null;
}

// Runs the menu and handles user choices.
Future<void> main() async {
  final trains = <Lrt2Train>[
    LocalTrain(
      trainNumber: 'L2-101',
      direction: 'Recto to Antipolo',
      sampleCapacity: 5,
    ),
    ExpressTrain(
      trainNumber: 'L2-202',
      direction: 'Antipolo to Recto',
      sampleCapacity: 4,
      passengerCount: 1,
    ),
  ];

  final kiosk = StationKiosk();

  while (true) {
    print('\n--- LRT-2 Train Manager ---');
    print('1. View train status');
    print('2. Board a passenger');
    print('3. Save a train record');
    print('4. Make an announcement');
    print('0. Exit');
    stdout.write('Choose an option: ');

    final choice = stdin.readLineSync()?.trim();

    if (choice == '1') {
      // Calling the same method on different train types demonstrates
      // polymorphism: each type displays its own service label.
      for (final train in trains) {
        train.displayStatus();
      }
    } else if (choice == '2') {
      stdout.write('Enter the train number: ');
      final trainNumber = stdin.readLineSync()?.trim() ?? '';
      final train = findTrain(trains, trainNumber);

      if (train == null) {
        print('No train found with that number.');
      } else if (train.boardPassenger()) {
        print('Passenger boarded train $trainNumber.');
      } else {
        print('Train $trainNumber is at capacity.');
      }
    } else if (choice == '3') {
      stdout.write('Enter the train number: ');
      final trainNumber = stdin.readLineSync()?.trim() ?? '';
      final train = findTrain(trains, trainNumber);

      if (train == null) {
        print('No train found with that number.');
      } else {
        print('Saving train record...');
        final result = await train.saveTrainRecord();
        print(result);
      }
    } else if (choice == '4') {
      stdout.write('Enter an announcement: ');
      final message = stdin.readLineSync()?.trim() ?? '';

      if (message.isEmpty) {
        print('The announcement cannot be empty.');
      } else {
        kiosk.sendMessage(message);
      }
    } else if (choice == '0') {
      print('Goodbye!');
      break;
    } else {
      print('Invalid option. Please choose 0, 1, 2, 3, or 4.');
    }
  }
}
