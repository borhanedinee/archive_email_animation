import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late ScrollController scrollController;

  double archiveWidth = 0; // Initialize offsets for each item
  double archiveTopOffset = 0;

  int targetedItem = 0; // Initialize offsets for each item

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    controller = AnimationController.unbounded(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade800,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    searchBar(),
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'Inbox',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  Positioned(
                    top: archiveTopOffset,
                    right: 0,
                    width: archiveWidth,
                    child: Container(
                      height: 100,
                      decoration: const BoxDecoration(color: Colors.green),
                      child: const Center(child: Icon(Icons.archive)),
                    ),
                  ),
                  Positioned(
                    top: archiveTopOffset,
                    left: 0,
                    width: archiveWidth,
                    child: Container(
                      height: 100,
                      decoration: const BoxDecoration(color: Colors.green),
                      child: const Center(child: Icon(Icons.archive)),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, index) => AnimatedBuilder(
                      animation: controller,
                      builder: (context, child) => Transform.translate(
                        offset: Offset(
                            index == targetedItem ? controller.value : 0, 0),
                        child: GestureDetector(
                          onTap: () {
                            print(scrollController.offset);
                          },
                          onHorizontalDragUpdate: (details) {
                            setState(() {
                              // archiveTopOffset = 100.0 * index - scrollController.offset - 150;
                              archiveTopOffset = 100.0 * index;
                              controller.value += details.delta.dx;
                              archiveWidth = controller.value.abs();
                            });
                          },
                          onHorizontalDragStart: (details) {
                            targetedItem = index;
                          },
                          onHorizontalDragEnd: (details) {
                            // Optional: Reset the offset when dragging ends
                            setState(() {
                              if (controller.value.abs() < 100) {
                                controller.value = 0;
                                archiveWidth = 0;
                              } else {
                                archiveWidth = size.width;
                                archiveTopOffset = 0;
                                controller.value = 0;
                                items.removeAt(index);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    margin: EdgeInsets.only(top: 10),
                                    behavior: SnackBarBehavior.floating,
                                    content: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 15,
                                          backgroundColor: Colors.greenAccent,
                                          child: Icon(
                                            Icons.done,
                                            size: 24,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        Text(
                                          'Archived successfully',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            });
                          },
                          child: items[index],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> items = List.generate(
    14,
    (index) => Container(
      padding: const EdgeInsets.all(8),
      height: 100,
      decoration: BoxDecoration(color: Colors.grey.shade800),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: CircleAvatar(
              radius: 20,
              child: Container(
                child: const Text('A'),
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Figma $index',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Text(
                        '00:12',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  'Updates to our Terms of Service and Privacy',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Text(
                  'New admin settings for AI are set in the settings file for the current user',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Container searchBar() {
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade700,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        decoration: InputDecoration(
          suffixIcon: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: const CircleAvatar(
              radius: 4,
              child: Text('B'),
            ),
          ),
          icon: const Icon(Icons.search, color: Colors.white),
          hintText: 'Search mail',
          hintStyle: const TextStyle(color: Colors.white54),
          border: InputBorder.none,
        ),
        style: const TextStyle(color: Colors.white),
        onChanged: (value) {
          // Handle search logic
          print('Search: $value');
        },
      ),
    );
  }
}
