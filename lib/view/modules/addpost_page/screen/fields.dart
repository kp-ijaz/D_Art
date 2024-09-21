// ignore_for_file: camel_case_types

import 'package:d_art/view/modules/addpost_page/controller/postcontroller.dart';
import 'package:flutter/material.dart';

class Dropdownfortpe_of_work extends StatelessWidget {
  const Dropdownfortpe_of_work({
    super.key,
    required this.controller,
  });

  final PostDetailsController controller;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Type of work',
        border: OutlineInputBorder(),
      ),
      items: ['Full house', 'Bedroom', 'Kitchen', 'Staircase', 'Sitout']
          .map((workType) => DropdownMenuItem(
                value: workType,
                child: Text(workType),
              ))
          .toList(),
      onChanged: (value) {
        controller.workType.value = value!;
      },
    );
  }
}

class Textfieldforclient_contact extends StatelessWidget {
  const Textfieldforclient_contact({
    super.key,
    required this.controller,
  });

  final PostDetailsController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Select clients contact',
        prefixIcon: Icon(Icons.contacts),
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        controller.clientContact.value = value;
      },
    );
  }
}

class Textfieldforlocation extends StatelessWidget {
  const Textfieldforlocation({
    super.key,
    required this.controller,
  });

  final PostDetailsController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        labelText: 'Location of work',
        prefixIcon: Icon(Icons.location_on),
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        controller.location.value = value;
      },
    );
  }
}

class Textformfieldfordetails extends StatelessWidget {
  const Textformfieldfordetails({
    super.key,
    required this.controller,
  });

  final PostDetailsController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: 2,
      decoration: const InputDecoration(
        labelText: 'Add details to get more views for your post',
        hintStyle: TextStyle(fontSize: 16),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
      ),
      onChanged: (value) {
        controller.description.value = value;
      },
    );
  }
}
