import 'package:flutter/material.dart';

class HomwOwner extends StatelessWidget {
  const HomwOwner({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.menu,
            size: 30,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.near_me_outlined,
              size: 30,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Column(
          children: [
            SizedBox(
              height: 60,
              child: ListView(
                padding: const EdgeInsets.only(bottom: 10),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: const [
                  ChoiceChip(
                    label: Text('Full house'),
                    selected: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    backgroundColor: Colors.amber,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ChoiceChip(
                    label: Text('Bedroom'),
                    selected: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    backgroundColor: Colors.amber,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ChoiceChip(
                    label: Text('Kitchen'),
                    selected: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    backgroundColor: Colors.amber,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ChoiceChip(
                    label: Text('Staircase'),
                    selected: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    backgroundColor: Colors.amber,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ChoiceChip(
                    label: Text('Sit out'),
                    selected: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    backgroundColor: Colors.amber,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Muhammed ijaz kp',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.more_vert),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Image.asset('assets/splashscreen.gif'),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.favorite_border),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(Icons.mode_comment),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(Icons.share),
                                onPressed: () {},
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.bookmark_border),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _buildCaption('Muhammed ijaz kp',
                              'This is a sample caption for the post. It might be quite long and needs to be truncated with a read more option to display the full content.'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaption(String username, String caption) {
    bool isExpanded = false;
    String displayCaption = caption;
    if (caption.length > 100) {
      displayCaption = '${caption.substring(0, 100)}...';
      isExpanded = true;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$username: $displayCaption',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        if (isExpanded)
          GestureDetector(
            onTap: () {},
            child: const Text(
              'Read more',
              style: TextStyle(color: Colors.blue),
            ),
          ),
      ],
    );
  }
}
