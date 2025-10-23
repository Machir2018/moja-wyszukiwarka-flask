class LinkItem {
  final String title;
  final String description;
  final String url;

  LinkItem({
    required this.title,
    required this.description,
    required this.url,
  });

  // 🔍 Tworzenie obiektu z dokumentu Firestore
  factory LinkItem.fromFirestore(Map<String, dynamic> data) {
    return LinkItem(
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      url: data['url'] ?? '',
    );
  }

  // 📝 Zamiana obiektu na mapę do zapisu w Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'url': url,
    };
  }
}