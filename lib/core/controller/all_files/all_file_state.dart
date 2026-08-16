// ignore_for_file: public_member_api_docs, sort_constructors_first
class AllFileState {
  final bool isLoading;

  AllFileState({required this.isLoading});

  AllFileState copyWith({bool? isLoading}) {
    return AllFileState(isLoading: isLoading ?? this.isLoading);
  }
}
