import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:infinite_list/post/model/post.dart';
import 'package:infinite_list/post/model/post_api.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(PostInitial());

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    if (event is PostFetched) {
      yield await _mapPostToState(state);
    }
    if (event is PostRefresh) {
      yield PostInitial();

      yield await _mapPostToState(state);
    }
  }

  Future<PostState> _mapPostToState(PostState state) async {
    List<Post> posts;

    try {
      if (state is PostInitial) {
        posts = await PostApi.fetchPost(0, 10);
        return PostLoaded(posts: posts);
      }
      PostLoaded postLoaded = state as PostLoaded;
      posts = await PostApi.fetchPost(postLoaded.posts.length, 10);
      return posts.isEmpty
          ? postLoaded.copyWith(hasReachedMax: true)
          : postLoaded.copyWith(posts: postLoaded.posts + posts);
    } on Exception {
      return PostError();
    }
  }
}
