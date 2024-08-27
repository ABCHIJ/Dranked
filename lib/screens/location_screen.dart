import 'package:sperro_neu/components/large_heading_widget.dart';
import 'package:sperro_neu/screens/main_navigatiion_screen.dart';
import 'package:sperro_neu/constants/colors.dart';
import 'package:sperro_neu/constants/widgets.dart';
import 'package:sperro_neu/services/user.dart';
import 'package:sperro_neu/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:geolocator/geolocator.dart';

class LocationScreen extends StatefulWidget {
  final bool? onlyPop;
  final String? popToScreen;
  static const String id = 'location_screen';

  const LocationScreen({
    this.popToScreen,
    this.onlyPop,
    Key? key,
  }) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: _body(context),
      bottomNavigationBar: BottomLocationPermissionWidget(
        onlyPop: widget.onlyPop,
        popToScreen: widget.popToScreen ?? '',
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      children: [
        const LargeHeadingWidget(
          heading: 'Choose Location',
          subheadingTextSize: 16,
          headingTextSize: 30,
          subHeading:
              'To continue, we need to know your sell/buy location so that we can further assist you',
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 300,
          width: 300,
          child: Lottie.asset('assets/lottie/location_lottie.json'),
        ),
      ],
    );
  }
}

class BottomLocationPermissionWidget extends StatefulWidget {
  final bool? onlyPop;
  final String popToScreen;

  const BottomLocationPermissionWidget({
    required this.popToScreen,
    this.onlyPop,
    Key? key,
  }) : super(key: key);

  @override
  State<BottomLocationPermissionWidget> createState() =>
      _BottomLocationPermissionWidgetState();
}

class _BottomLocationPermissionWidgetState
    extends State<BottomLocationPermissionWidget> {
  final UserService firebaseUser = UserService();

  // Variables to hold the selected location values
  String countryValue = 'India';
  String? stateValue = '';
  String? cityValue = '';
  String? address = '';
  String? manualAddress = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: roundedButton(
        context: context,
        text: 'Choose Location',
        bgColor: secondaryColor,
        onPressed: () {
          openLocationBottomSheet(context);
        },
      ),
    );
  }

  Future<void> openLocationBottomSheet(BuildContext context) async {
    loadingDialogBox(context, 'Fetching details...');
    try {
      final location = await getLocationAndAddress(context);
      Navigator.pop(context); // Close the loading dialog
      if (location != null) {
        setState(() {
          address = location ?? '';
        });
        showLocationBottomSheet(context);
      } else {
        // Handle location fetching failure
        showErrorSnackbar(context, 'Failed to fetch location');
      }
    } catch (e) {
      Navigator.pop(context); // Ensure the loading dialog is closed
      showErrorSnackbar(context, 'Error fetching location: $e');
      if (kDebugMode) {
        print("Error fetching location: $e");
      }
    }
  }

  Future<Position?> getCurrentLocation(BuildContext context) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        showErrorSnackbar(context, "Location services are disabled.");
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          showErrorSnackbar(context, "Location permissions are denied.");
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        showErrorSnackbar(
            context, "Location permissions are permanently denied.");
        return null;
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      showErrorSnackbar(context, "Failed to fetch location: $e");
      return null;
    }
  }

  Future<void> updateLocation(
    BuildContext context, {
    required bool useCurrentLocation,
  }) async {
    loadingDialogBox(context, 'Updating location...');
    try {
      if (useCurrentLocation) {
        final position = await getCurrentLocation(context);
        if (position != null) {
          address = (await getFetchedAddress(context, position)) ?? '';
          await firebaseUser.updateFirebaseUser(context, {
            'location': GeoPoint(position.latitude, position.longitude),
            'address': address!,
          });
        } else {
          showErrorSnackbar(context, 'Failed to fetch current location');
          return;
        }
      } else {
        if (manualAddress != null && manualAddress!.isNotEmpty) {
          await firebaseUser.updateFirebaseUser(context, {
            'address': manualAddress,
            'state': stateValue,
            'city': cityValue,
            'country': countryValue,
          });
        } else {
          showErrorSnackbar(context, 'Please select a valid location');
          return;
        }
      }
      navigateToNextScreen();
    } catch (e) {
      showErrorSnackbar(context, 'Error updating location: $e');
      if (kDebugMode) {
        print("Error updating location: $e");
      }
    } finally {
      Navigator.pop(context); // Close the loading dialog
    }
  }

  void showLocationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: true,
      context: context,
      builder: (context) {
        return Container(
          color: whiteColor,
          child: Column(
            children: [
              const SizedBox(height: 30),
              AppBar(
                automaticallyImplyLeading: false,
                iconTheme: IconThemeData(color: blackColor),
                elevation: 1,
                backgroundColor: whiteColor,
                title: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.clear),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Select Location',
                      style: TextStyle(color: blackColor),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: TextFormField(
                  decoration: InputDecoration(
                    suffixIcon: const Icon(Icons.search),
                    hintText: 'Select city, area, or neighbourhood',
                    hintStyle: TextStyle(
                      color: greyColor,
                      fontSize: 12,
                    ),
                    contentPadding: const EdgeInsets.all(20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              ListTile(
                onTap: () async {
                  await updateLocation(context, useCurrentLocation: true);
                },
                horizontalTitleGap: 0,
                leading: Icon(Icons.my_location, color: secondaryColor),
                title: Text(
                  'Use current Location',
                  style: TextStyle(
                    color: secondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  address == null || address!.isEmpty
                      ? 'Fetch current Location'
                      : address!,
                  style: TextStyle(
                    color: greyColor,
                    fontSize: 10,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  'Choose City',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: blackColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: CSCPicker(
                  layout: Layout.vertical,
                  flagState: CountryFlag.DISABLE,
                  dropdownDecoration:
                      const BoxDecoration(shape: BoxShape.rectangle),
                  onCountryChanged: (value) async {
                    setState(() {
                      countryValue = value;
                    });
                  },
                  onStateChanged: (value) async {
                    setState(() {
                      if (value != null) {
                        stateValue = value;
                      }
                    });
                  },
                  onCityChanged: (value) async {
                    setState(() {
                      if (value != null) {
                        cityValue = value;
                        manualAddress = "$cityValue, $stateValue";
                        print(manualAddress);
                        updateLocation(context, useCurrentLocation: false);
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void navigateToNextScreen() {
    if (widget.onlyPop == true && widget.popToScreen.isNotEmpty) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        widget.popToScreen,
        (route) => false,
      );
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(
        MainNavigationScreen.id,
        (route) => false,
      );
    }
  }

  void showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
