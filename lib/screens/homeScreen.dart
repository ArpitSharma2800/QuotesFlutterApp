import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_clipboard_manager/flutter_clipboard_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qoute2/model/postResponse.dart';
import 'package:qoute2/model/qouteData.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = false;
  List<QouteElement> _users;
  List<QouteElement> fileterdUsers;
  bool _update = false;
  final TextEditingController quoteController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  void setupQouteApi() async {
    setState(() {
      loading = true;
    });
    await Services.getdata().then((data) {
      setState(() {
        _users = data[0].qoute;
        fileterdUsers = data[0].qoute;
        loading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setupQouteApi();
  }

  String apiUrlLogin = "https://qoute.arpitsharma.tech/add";
  Future<Postresponse> login(String quote) async {
    Map map = {
      'uuid': 'arpit',
      'qoute': [
        {'title': quote}
      ]
    };
    String body = json.encode(map);
    try {
      var response = await http.post(
        Uri.encodeFull(apiUrlLogin),
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      if (200 == response.statusCode) {
        setupQouteApi();
        return (null);
      } else {
        print(response.body);
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    void _showDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          var screenSize = MediaQuery.of(context).size;
          return (_update == false
              ? AlertDialog(
                  title: new Text(
                    "Add your quote!!",
                    style: TextStyle(color: Colors.green),
                  ),
                  backgroundColor: Colors.blueGrey[900],
                  content: Container(
                    height: screenSize.height / 2,
                    // width: screenSize.width - 50.0,
                    padding: EdgeInsets.fromLTRB(00.0, 10.0, 0.0, 0.0),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          controller: quoteController,
                          // obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.text_fields,
                              color: Colors.green,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Colors.blueGrey[50],
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Colors.green,
                                width: 2.0,
                              ),
                            ),
                            border: OutlineInputBorder(),
                            labelText: 'Quote',
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 40.0),
                        Text(
                          "Page wll automatically refresh after 2 seconds!!",
                          style: TextStyle(
                            color: Colors.red,
                            // fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text("Submit"),
                      onPressed: () {
                        final String quote = quoteController.text;
                        if (quote.isNotEmpty) {
                          login(quote);
                          Navigator.of(context).pop();
                          setState(() {
                            _update = true;
                          });
                        }
                      },
                    ),
                    new FlatButton(
                      child: new Text("Close"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
              : Center(
                  child: SpinKitCubeGrid(
                    color: Colors.green[400],
                    size: 80.0,
                  ),
                ));
        },
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 50.0, 30.0, 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SvgPicture.asset(
                      "assets/images/img.svg",
                      height: 100,
                    ),
                    Text(
                      'Qoute',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  // controller: searchController,
                  onChanged: (string) {
                    setState(() {
                      fileterdUsers = _users
                          .where((u) => (u.title
                              .toLowerCase()
                              .contains(string.toLowerCase())))
                          .toList();
                    });
                  },
                  // obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.text_fields,
                      color: Colors.green,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        color: Colors.blueGrey[50],
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        color: Colors.green,
                        width: 2.0,
                      ),
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'Search',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: Icon(Icons.refresh, size: 34.0),
                      tooltip: 'Refresh',
                      color: Colors.green,
                      onPressed: () {
                        setupQouteApi();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: Icon(Icons.add_circle, size: 34.0),
                      tooltip: 'Add new quote',
                      color: Colors.green,
                      onPressed: () {
                        _showDialog();
                      },
                    ),
                  ),
                ],
              ),
              Container(
                  alignment: Alignment.topCenter,
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height,
                      maxWidth: MediaQuery.of(context).size.width),
                  padding: EdgeInsets.all(35.0),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey[900],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50.0),
                          topRight: Radius.circular(50.0))),
                  child: loading == true
                      ? SpinKitCubeGrid(
                          color: Colors.green,
                          size: 50.0,
                        )
                      : ListView.builder(
                          scrollDirection: Axis.vertical,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:
                              null == fileterdUsers ? 0 : fileterdUsers.length,
                          itemBuilder: (context, index) {
                            // String user = ;
                            return ListTile(
                              title: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: 30.0),
                                    width:
                                        MediaQuery.of(context).size.width - 108,
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey[800],
                                      border: Border(
                                        left: BorderSide(
                                            color: Colors.green,
                                            width: 5.0,
                                            style: BorderStyle.solid),
                                      ),
                                    ),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 5.0),
                                      leading: Container(
                                        padding: EdgeInsets.only(right: 5.0),
                                        decoration: new BoxDecoration(
                                            border: new Border(
                                                right: new BorderSide(
                                                    width: 3.0,
                                                    color: Colors.green))),
                                        child: Icon(Icons.format_quote,
                                            color: Colors.green),
                                      ),
                                      title: Text(
                                        fileterdUsers[index].title,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: Icon(Icons.content_copy,
                                          color: Colors.green, size: 30.0),
                                      onTap: () {
                                        FlutterClipboardManager.copyToClipBoard(
                                                fileterdUsers[index].title)
                                            .then((result) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content:
                                                Text('Copied to Clipboard'),
                                            action: SnackBarAction(
                                              label: 'Okay',
                                              onPressed: () {},
                                            ),
                                          ));
                                        });
                                      },
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ))
            ],
          ),
        ),
      ),
    );
  }
}
