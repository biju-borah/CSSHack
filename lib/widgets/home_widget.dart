import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final String url =
      "https://api.nasa.gov/planetary/apod?api_key=C7O0kpddVotEZAQO51ggplgObPIUvxqciDCgtsPQ";

  fetchData() async {
    var result = await http.get(Uri.parse(url));
    print(result.body);
    setState(() {
      imageURL = json.decode(result.body)["url"];
      content = json.decode(result.body)["explanation"];
      isLoading = false;
    });
  }

  String imageURL = "";
  String content = "";
  bool isLoading = true;
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  fromgallery()async{
     XFile? image=await ImagePicker().pickImage(source: ImageSource.gallery);
     if (image != null) {
        File imageFile = File(image.path);
        await FirebaseStorage.instance.ref('/').putFile(imageFile);
    }
  }
  fromcam()async{}
  showconfirm(BuildContext context) => showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            children: [
              GestureDetector(
                onTap: () => fromgallery(),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: const Text('Gallery'),
                ),
              ),
              const SizedBox(height: 3),
              GestureDetector(
                onTap: () => fromcam(),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: const Text('Camera'),
                ),
              ),
            ],
          );
        },
      );
  showsheet(BuildContext context) => showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(12),
          child: Text(content),
        );
      });
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: [
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      showsheet(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(2),
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          imageURL,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 35,
                    left: 35,
                    child: Text(
                      "Image of the Day",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  showconfirm(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(12),
                  child: Center(
                    child: Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
