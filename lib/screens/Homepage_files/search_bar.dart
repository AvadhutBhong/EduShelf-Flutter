import 'package:flutter/material.dart';
class HomeSearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final String searchQuery; // Current search query
  final VoidCallback onClear;

  const HomeSearchBar({
    Key? key,
    required this.onSearch,
    required this.searchQuery, // Accept current search query
    required this.onClear,
  }) : super(key: key);

  @override
  _HomeSearchBarState createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  final FocusNode _focusNode = FocusNode(); // Focus node to track focus state

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {}); // Update the state when focus changes
    });
  }

  @override
  void dispose() {
    _focusNode.dispose(); // Dispose the focus node
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              focusNode: _focusNode, // Assign the focus node to the TextField
              onChanged: widget.onSearch,
              decoration: InputDecoration(
                labelText: 'Search Products',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
                suffixIcon: widget.searchQuery.isNotEmpty || _focusNode.hasFocus // Show clear icon if text is present or focused
                    ? IconButton(
                  icon: Icon(Icons.clear_rounded),
                  onPressed: widget.onClear, // Call the clear function
                )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
