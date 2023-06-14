import 'package:flutter/material.dart';
import "single_train_top_bar.dart";
import 'package:DajeTrains/api/trip_api.dart';
import 'package:DajeTrains/structures/train_info.dart';

class SingleTrainPage extends StatefulWidget {
  final String trainID;

  const SingleTrainPage({
    required this.trainID,
    super.key,
  });

  @override
  State<SingleTrainPage> createState() => _SingleTrainPageState();
}

class _SingleTrainPageState extends State<SingleTrainPage>
    with TickerProviderStateMixin {

  bool _defaultMessage = true;

  TripApi api = TripApi();
  TrainInfo? trainInfo;


  @override
  void initState() {
    _getTrainInfo();
    super.initState();
  }

  void _getTrainInfo() async {
    List<TrainInfo> l = await api.getTrip(widget.trainID);
    print(l);
    
    if (l.isNotEmpty) {
      setState(() {
        trainInfo = l[0];
        _defaultMessage = false;
      });
    } else {
      throw Exception("Non valid Train ID");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _defaultMessage
      ? null
      : SingleTrainTripTopBar(trainInfo: trainInfo!),
      body: _defaultMessage
      ? null
      : Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
        child: ListView.builder(
            itemCount: trainInfo!.trip.length,
            itemBuilder: (BuildContext context, int index) {
              return _TripStationView(tripStation: trainInfo!.trip[index]);
            }
        ),
      ) 
    );
  }
}

class _TripStationView extends StatelessWidget {

  final TripStation tripStation;

  const _TripStationView({
    required this.tripStation,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column( // Dots
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0,0,16,0),
                child: Icon(
                Icons.radio_button_checked,
                color: Color(0xFFA5E6FB),
                size: 25,
              ),
              )
            ],
          ),
        ),
        
        Expanded(
          flex: 5,
          child: Column( // Info
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tripStation.station.name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Departure:"),
                  Text(
                    tripStation.scheduledDepartureTime,
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Arrival:"),
                  Text(
                    tripStation.scheduledArrivalTime,
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        
        Expanded(
          flex: 3,
          child: Column( // Platform
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  color: Colors.transparent,
                  child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xFFA5E6FB),
                          borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      child: Center(
                        child: Text(
                          "${tripStation.platform}",
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      )),
                ),
              ),
            ],
          )
        )

      ],
    );
  }

}
