import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_recipe/model.dart';
import 'package:food_recipe/recipe.dart';
import 'package:http/http.dart';
import 'dart:developer';

class Search extends StatefulWidget {
  String query;
  Search(this.query);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool isLoading = true;
  List<RecipeModel> recipeList = <RecipeModel>[];
  TextEditingController searchController = new TextEditingController();
  List recipeCatList = [
    {
      "imgUrl":
          "https://media.istockphoto.com/id/1451840010/photo/rajma-chawal-an-indian-food.webp?b=1&s=170667a&w=0&k=20&c=d9IH7ZcE7UKCy4y--inbAK5IhOfZfrQ5YLDPpw89wLA=",
      "heading": "North Indian"
    },
    {
      "imgUrl":
          "https://media.istockphoto.com/id/1292563627/photo/assorted-south-indian-breakfast-foods-on-wooden-background-ghee-dosa-uttappam-medhu-vada.webp?b=1&s=170667a&w=0&k=20&c=qpDMBxf0FbkwLG7ExT3bwTpHDdkR_KmuBoWN-AyUxEM=",
      "heading": "South Indian"
    },
    {
      "imgUrl":
          "https://media.istockphoto.com/id/1144501138/photo/manchurian-hakka-schezwan-noodles-popular-indochinese-food-served-in-a-bowl-selective-focus.webp?b=1&s=170667a&w=0&k=20&c=g_HX36USTNdxNgEdlSUGgJ_JEVw18ZmlTSgWqYM_0OI=",
      "heading": "Chinese"
    },
    {
      "imgUrl":
          "https://media.istockphoto.com/id/1198079266/photo/deluxe-pizza-with-pepperoni-sausage-mushrooms-and-peppers.webp?b=1&s=170667a&w=0&k=20&c=Jmt_A91qLtE2YIDbBxYdqaCJ397haq0ZzWPHLlhtQw0=",
      "heading": "Italian"
    },
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1580822184713-fc5400e7fe10?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8SmFwYW5lc2UlMjBmb29kfGVufDB8fDB8fHww",
      "heading": "Japanese"
    }
  ];

  getRecipe(String query) async {
    String url =
        "https://api.edamam.com/search?q=$query&app_id=f17190eb&app_key=952b03c52f3e9d34a726fc4d65eb845f";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    //log(data.toString());

    data["hits"].forEach((element) {
      RecipeModel recipeModel = new RecipeModel();
      recipeModel = RecipeModel.fromMap(element["recipe"]);
      recipeList.add(recipeModel);
      setState(() {
        isLoading = false;
      });
      log(recipeList.toString());
    });

    // recipeList.forEach((Recipe) {
    //  print(Recipe.appcalories);
    // });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRecipe(widget.query);
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
          SingleChildScrollView(
            child: Column(
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
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Search(searchController.text)));
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
                  child: isLoading
                      ? CircularProgressIndicator()
                      : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: recipeList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> RecipeView(recipeList[index].appurl)));
                              },
                              child: Card(
                                margin: EdgeInsets.all(20),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                elevation: 0.0,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        recipeList[index].appimgUrl,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: 200,
                                      ),
                                    ),
                                    Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                            decoration: BoxDecoration(
                                                color: Colors.black26),
                                            child: Text(
                                              recipeList[index].applabel,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ))),
                                    Positioned(
                                        right: 0,
                                        height: 30,
                                        width: 80,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(10))),
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons
                                                      .local_fire_department),
                                                  Text(recipeList[index]
                                                      .appcalories
                                                      .toString()
                                                      .substring(0, 6)),
                                                ],
                                              ),
                                            )))
                                  ],
                                ),
                              ),
                            );
                          }),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
