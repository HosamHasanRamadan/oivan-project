import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oivan_project/infinite_list/infinite_list_view.dart';
import 'package:oivan_project/presentation/user_book_marks_page.dart';
import 'package:oivan_project/presentation/user_reputation_history_page.dart';
import 'package:oivan_project/view_model/users_view_model.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final viewModel = ref.watch(userViewModelProvider);
        return _UsersPageContent(
          viewModel: viewModel,
        );
      },
    );
  }
}

class _UsersPageContent extends StatefulWidget {
  const _UsersPageContent({
    super.key,
    required this.viewModel,
  });
  final UsersViewModel viewModel;

  @override
  State<_UsersPageContent> createState() => _UsersPageContentState();
}

class _UsersPageContentState extends State<_UsersPageContent> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Users'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const UserBookMarksPage();
                  },
                ),
              );
            },
            icon: const Icon(
              Icons.bookmarks,
            ),
          )
        ],
      ),
      body: Center(
        child: InfiniteListView(
          viewModel: widget.viewModel,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final user = widget.viewModel.value.items[index].user;
            final isBookMarked =
                widget.viewModel.value.items[index].isBookMarked;
            var nameAndAge = user.displayName;
            if (user.age != null) nameAndAge = '$nameAndAge - ${user.age}';
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (isBookMarked == false)
                  IconButton(
                    onPressed: () {
                      widget.viewModel.addBookMark(
                        user,
                      );
                    },
                    icon: const Icon(Icons.bookmark_border),
                  ),
                if (isBookMarked)
                  IconButton(
                    onPressed: () {
                      widget.viewModel.deleteBookMark(
                        user,
                      );
                    },
                    icon: const Icon(Icons.bookmark),
                  ),
                Expanded(
                  child: ListTile(
                    key: ValueKey(user.userId),
                    title: Text(nameAndAge),
                    subtitle:
                        user.location != null ? Text(user.location!) : null,
                    trailing: Text(user.reputation.toString()),
                    leading: CachedNetworkImage(
                      width: 50,
                      height: 50,
                      imageUrl: user.profileImage,
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return UserReputationHistoryPage(
                              userId: user.userId,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
