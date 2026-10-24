abstract class TrainService {
  String serviceDescription();
}

mixin PassengerMessaging {
  void sendMessage(String message) {
    print('Announcement: $message');
  }
}

abstract class Lrt2Train implements TrainService {
  String trainNumber;
  String direction;
  int sampleCapacity;
  int _passengerCount;

  Lrt2Train({
    required this.trainNumber,
    required this.direction,
    required this.sampleCapacity,
    int passengerCount = 0,
  }) : _passengerCount = passengerCount;

  int get passengerCount => _passengerCount;

  bool boardPassenger() {
    if (_passengerCount >= sampleCapacity) {
      return false;
    }

    _passengerCount++;
    return true;
  }

  Future<String> saveTrainRecord() async {
    await Future.delayed(const Duration(seconds: 2));
    return 'Train $trainNumber record saved.';
  }

  void displayStatus() {
    print(
      'Train $trainNumber | Direction: $direction | '
      'Passengers: $_passengerCount/$sampleCapacity',
    );
  }
}

class LocalTrain extends Lrt2Train with PassengerMessaging {
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

  @override
  String serviceDescription() {
    return 'Local service: stops at every station.';
  }

  @override
  void displayStatus() {
    print('LOCAL | ${serviceDescription()}');
    super.displayStatus();
  }
}

class ExpressTrain extends Lrt2Train with PassengerMessaging {
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

  @override
  String serviceDescription() {
    return 'Express service: skips selected stations.';
  }

  @override
  void displayStatus() {
    print('EXPRESS | ${serviceDescription()}');
    super.displayStatus();
  }
}

class StationKiosk with PassengerMessaging {}

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

  trains[0].boardPassenger();
  trains[0].boardPassenger();
  trains[1].boardPassenger();

  for (final train in trains) {
    train.displayStatus();
  }

  print('Passengers on the first train: ${trains[0].passengerCount}');

  final saveFuture = trains[0].saveTrainRecord();

  Future.delayed(const Duration(seconds: 1), () {
    print('The program is still running while the save is in progress.');
  });

  print('Saving train record...');
  final result = await saveFuture;
  print(result);

  final kiosk = StationKiosk();
  kiosk.sendMessage('Please stand behind the yellow line.');
}