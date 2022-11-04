import 'package:aws_iot/aws_iot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_setup_cognito/shared/model/data_user_model.dart';
import 'package:flutter_login_setup_cognito/shared/services/aws_io.dart';
import 'package:flutter_login_setup_cognito/shared/utils/colors.dart';
import 'package:flutter_login_setup_cognito/shared/utils/locator.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

const PADDING_HORIZ_INTERN = 10.0;

class ChartCircular extends StatefulWidget {
  const ChartCircular({
    @required this.waterTank,
  });
  final WaterTank waterTank;

  @override
  _ChartCircularState createState() => _ChartCircularState();
}

class _ChartCircularState extends State<ChartCircular> {
  double percentValue;
  var limitCritic;
  AWSIotDevice awsIotDevice;

  @override
  void initState() {
    percentValue = 50;
    limitCritic = 20;
    awsIotDevice = Locator.instance.get<AwsIot>().awsIotDevice;

    final status = awsIotDevice.client.connectionStatus.state;
    if (status == MqttConnectionState.connected) {
      awsIotDevice.subscribe("tock/${widget.waterTank.thingId}/pub");
      print("subscribed at tock/${widget.waterTank.thingId}/pub");
    }

    super.initState();
  }

  @override
  void didChangeDependencies() {
    awsIotDevice.client.updates.listen((_) {
      _onReceive(awsIotDevice);
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
        boxShadow: [
          new BoxShadow(
              color: ColorsCustom.loginScreenMiddle,
              blurRadius: 4,
              spreadRadius: 0.5),
        ],
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  this.widget.waterTank.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorsCustom.loginScreenMiddle,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  " ($limitCritic %)",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red.shade300,
                    fontSize: 20,
                  ),
                ),
                // _updateButton()
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(height: 20),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: PADDING_HORIZ_INTERN),
            child: Flexible(
              child: Container(
                child: Center(
                  child: SleekCircularSlider(
                    appearance: CircularSliderAppearance(
                      size: MediaQuery.of(context).size.height / 3,
                      customColors: CustomSliderColors(
                        dotColor: Colors.white,
                        progressBarColor: percentValue < limitCritic
                            ? Colors.red.shade300
                            : ColorsCustom.loginScreenMiddle,
                        trackColor: ColorsCustom.loginScreenDown,
                        shadowColor: ColorsCustom.loginScreenUp,
                      ),
                    ),
                    initialValue: percentValue,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _onReceive(AWSIotDevice awsIotDevice) async {
    final AWSIotMsg lastMsg = await awsIotDevice.messages.elementAt(0);

    if (lastMsg.asJson.containsKey("dist")) {
      setState(() {
        percentValue = lastMsg.asJson["dist"];
      });
    }
  }
}
