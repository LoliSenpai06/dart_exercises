class Lrt2Train {
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

  void displayStatus() {
    print(
      'Train $trainNumber | Direction: $direction | '
      'Passengers: $_passengerCount/$sampleCapacity',
    );
  }
}

void main() {
  final trains = <Lrt2Train>[
    Lrt2Train(
      trainNumber: 'L2-101',
      direction: 'Recto to Antipolo',
      sampleCapacity: 5,
    ),
    Lrt2Train(
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
}