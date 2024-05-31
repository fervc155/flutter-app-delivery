import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application_1/src/pages/client/map/client_address_map_controller.dart';
import 'package:flutter_application_1/src/utils/my_colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClientAddressMapPage extends StatefulWidget {
  const ClientAddressMapPage({super.key});

  @override
  State<ClientAddressMapPage> createState() => _ClientAddressMapPageState();
}

class _ClientAddressMapPageState extends State<ClientAddressMapPage> {
  ClientAddressMapController controller = new ClientAddressMapController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      controller.init(context, refresh);
    });
  }

  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ubica tu dirección en el mapa'),
      ),
      body: Container(
        width: double.infinity,
        child: Stack(
          children: [
            _map(),
            Container(
              alignment: Alignment.center,
              child: _iconMyLocation(),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              alignment: Alignment.topCenter,
              child: _cardAddres(),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: _buttonAccept(),
            ),
            Positioned(
              bottom: 80,
              right: 10,
              child: Column(
                children: [
                  FloatingActionButton(
                    onPressed: controller.zoomIn,
                    child: Icon(Icons.zoom_in),
                  ),
                  SizedBox(height: 10),
                  FloatingActionButton(
                    onPressed: controller.zoomOut,
                    child: Icon(Icons.zoom_out),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardAddres() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 30),
      decoration: BoxDecoration(
        color: Color.fromARGB(172, 46, 46, 46),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(controller.address,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }

  Widget _map() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: controller.initialPosition,
      onMapCreated: controller.onMapCreated,
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
      onCameraMove: (position) {
        controller.initialPosition = position;
      },
      onCameraIdle: () async {
        await controller.setLocationDraggableInfo();
      },
    );
  }

  Widget _iconMyLocation() {
    return Image.asset('assets/img/my_location.png', width: 65, height: 65);
  }

  Widget _buttonAccept() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 30, horizontal: 50),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: controller.selectRefPoint,
        child: Text('Aceptar', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
