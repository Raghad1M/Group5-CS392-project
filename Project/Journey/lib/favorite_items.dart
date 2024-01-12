class FavoriteItems {
  static List<int> favorites = [];

  static void addToFavorites(int itemIndex) {
    favorites.add(itemIndex);
  }

  static void removeFromFavorites(int itemIndex) {
    favorites.remove(itemIndex);
  }
}
