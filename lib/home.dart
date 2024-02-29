import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:developer';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = new TextEditingController();

  getRecipe(String query) async
  {
    String url = "https://api.edamam.com/search?q=$query&app_id=f17190eb&app_key=952b03c52f3e9d34a726fc4d65eb845f";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    log(data.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRecipe("Ladoo");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xff213A50), Color(0xff071846)])),
          ),
          Column(
            children: [
              SafeArea(
                child: Container(
                  //Search Wala Container

                  padding: EdgeInsets.symmetric(horizontal: 8),
                  margin: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24)),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if ((searchController.text).replaceAll(" ", "") ==
                              "") {
                            print("Blank search");
                          } else {
                            getRecipe(searchController.text);
                          }
                        },
                        child: Container(
                          child: Icon(
                            Icons.search,
                            color: Colors.blueAccent,
                          ),
                          margin: EdgeInsets.fromLTRB(3, 0, 7, 0),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search recipe to Cook"),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "WHAT DO YOU WANT TO COOK TODAY",
                      style: TextStyle(fontSize: 33, color: Colors.white),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Let's Cook Something New!",
                        style: TextStyle(fontSize: 20, color: Colors.white))
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
