import 'package:d_art/view/modules/creatingprofile_page/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BioTextField extends StatelessWidget {
  const BioTextField({
    super.key,
    required this.controller,
  });

  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: 3,
      decoration: const InputDecoration(
        labelText: 'Bio',
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(17))),
      ),
      onChanged: (value) => controller.bio.value = value,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your bio';
        }
        return null;
      },
    );
  }
}

class LocationFetching extends StatelessWidget {
  const LocationFetching({
    super.key,
    required this.controller,
  });

  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.fetchLocation(),
      child: AbsorbPointer(
        child: Obx(() {
          return TextFormField(
            decoration: const InputDecoration(
              labelText: 'Enable your location',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(17)),
              ),
              prefixIcon: Icon(Icons.location_on, color: Colors.red),
            ),
            validator: (value) {
              if (controller.location.value.isEmpty) {
                return 'Please enable your location';
              }
              return null;
            },
            controller: TextEditingController(
              text: controller.location.value,
            ),
          );
        }),
      ),
    );
  }
}

class PhoneTextField extends StatelessWidget {
  const PhoneTextField({
    super.key,
    required this.controller,
  });

  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Phone',
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(17))),
      ),
      onChanged: (value) => controller.phone.value = value,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your phone number';
        }
        return null;
      },
    );
  }
}

class NameTextField extends StatelessWidget {
  const NameTextField({
    super.key,
    required this.controller,
  });

  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Name',
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(17))),
      ),
      onChanged: (value) => controller.name.value = value,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your name';
        }
        return null;
      },
    );
  }
}
