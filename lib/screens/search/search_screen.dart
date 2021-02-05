import 'package:app/services/theme.dart';
import 'package:app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: DataSearch());
            },
          )
        ],
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  final cities = [
    "Bhandup",
    "Mumbai",
    "Visakhapatnam",
    "Coimbatore",
    "Delhi",
    "Bangalore",
    "Pune",
    "Nagpur",
    "Lucknow",
    "Vadodara",
    "Indore",
    "Jalalpur",
    "Bhopal",
    "Kolkata",
    "Kanpur",
    "New Delhi",
    "Faridabad",
    "Rajkot",
    "Ghaziabad",
    "Chennai",
    "Meerut",
    "Agra",
    "Jaipur",
    "Jabalpur",
    "Varanasi",
    "Allahabad",
    "Hyderabad",
    "Noida",
    "Howrah",
    "Thane",
  ];
  final recentCities = [
    "New Delhi",
    "Faridabad",
    "Rajkot",
    "Ghaziabad",
  ];

  @override
  ThemeData appBarTheme(BuildContext context) {
    AppTheme _themeProvider = Provider.of<AppTheme>(context);
    ThemeData appTheme = _themeProvider.theme;
    ThemeData appBarTheme = appTheme.copyWith(
      primaryColor: appTheme.appBarTheme.color,
    );
    return appBarTheme;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
      SizedBox(width: AppLayout.appBarActionMargin)
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Container(
        height: 100,
        width: 100,
        child: Card(
          color: Colors.red,
          child: Center(
            child: Text(query),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentCities
        : cities
            .where(
              (element) => element.startsWith(query),
            )
            .toList();
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          onTap: () {
            showResults(context);
          },
          leading: Icon(Icons.location_city),
          title: RichText(
            text: TextSpan(
              text: suggestionList[index].substring(0, query.length),
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              children: <InlineSpan>[
                TextSpan(
                  text: suggestionList[index].substring(query.length),
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
