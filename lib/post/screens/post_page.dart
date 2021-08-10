import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_list/post/bloc/post_bloc.dart';
import 'package:infinite_list/post/screens/post_list.dart';

class PostPage extends StatelessWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List Posts"),
      ),
      body: BlocProvider(
        create: (context) => PostBloc()..add(PostFetched()),
        child: PostBody(),
      ),
    );
  }
}

class PostBody extends StatefulWidget {
  const PostBody({Key? key}) : super(key: key);

  @override
  _PostBodyState createState() => _PostBodyState();
}

class _PostBodyState extends State<PostBody> {
  ScrollController _scrollController = ScrollController();
  late PostBloc _postBloc;

  @override
  void initState() {
    super.initState();
    _postBloc = context.read<PostBloc>();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        // post is initialize
        if (state is PostInitial) {
          return Center(child: CircularProgressIndicator());
        }

        // post is loaded
        if (state is PostLoaded) {
          if (state.posts.isEmpty)
            return Center(
              child: Text("No Post"),
            );

          return PostList(
            scrollController: _scrollController,
            state: state,
          );
        }

        // post is error
        return Center(child: Text("Error Fetched Posts"));
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;
    if (currentScroll == maxScroll) _postBloc..add(PostFetched());
  }
}
