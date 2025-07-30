import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UniversalSearchDelegate extends SearchDelegate {
  final String collectionName;
  final Widget Function(Map<String, dynamic> data) resultBuilder;
  final List<String> searchableFields;

  UniversalSearchDelegate({
    required this.collectionName,
    required this.resultBuilder,
    this.searchableFields = const ['name'],
  });

  List<Map<String, dynamic>> _results = [];

  Future<List<Map<String, dynamic>>> search(String query) async {
    final snapshot =
        await FirebaseFirestore.instance.collection(collectionName).get();

    final allDocs = snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();

    return allDocs.where((doc) {
      return searchableFields.any((field) {
        final value = doc[field];
        if (value is List) {
          return value.any((item) =>
              item.toString().toLowerCase().contains(query.toLowerCase()));
        } else if (value is String) {
          return value.toLowerCase().contains(query.toLowerCase());
        }
        return false;
      });
    }).toList();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text("ابدأ بالبحث"),
      );
    }

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: search(query),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final suggestions = snapshot.data!;

        if (suggestions.isEmpty) {
          return Center(child: Text("لا يوجد اقتراحات"));
        }

        return ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            return resultBuilder(suggestions[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: search(query),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        _results = snapshot.data!;

        if (_results.isEmpty) {
          return Center(child: Text("لا يوجد نتائج مطابقة"));
        }

        return ListView.builder(
          itemCount: _results.length,
          itemBuilder: (context, index) {
            return resultBuilder(_results[index]);
          },
        );
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }
}
