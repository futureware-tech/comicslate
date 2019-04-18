import 'package:comicslate/models/comics.dart';
import 'package:comicslate/models/comics_category.dart';
import 'package:meta/meta.dart';

// TODO(dotdoom): return real data instead of mocks.
@immutable
class ComicslateServer {
  final String language;

  ComicslateServer({@required this.language});

  Future<List<ComicsCategory>> getComicsList() async {
    return [
      ComicsCategory(
        id: 'sci-fi',
        name: 'Sci-Fi',
        comicses: [
          Comics(
            homePageURL: Uri.parse(
                'https://comicslate.org/$language/sci-fi/freefall/index'),
            thumbnailURL: Uri.parse(
                'https://comicslate.org/_media/$language/sci-fi/freefall/main.png'),
            id: 'sci-fi:freefall',
            name: 'Freefall',
            numberOfStrips: 3900,
            rating: 5,
            updatedAt: DateTime.now().subtract(const Duration(days: 2)),
          ),
          Comics(
            homePageURL: Uri.parse(
                'https://comicslate.org/$language/sci-fi/commander-kitty/index'),
            thumbnailURL: Uri.parse(
                'https://comicslate.org/_media/$language/sci-fi/commander-kitty/title.jpg'),
            id: 'sci-fi:commander-kitty',
            name: 'Commander Kitty',
            numberOfStrips: 115,
            rating: 5,
            updatedAt: DateTime.now().subtract(const Duration(days: 142)),
          ),
        ],
      ),
      ComicsCategory(
        id: 'tlk',
        name: 'The Lion King',
        comicses: [
          Comics(
            homePageURL: Uri.parse(
                'https://comicslate.org/$language/tlk/a-traitor-to-the-king/index'),
            thumbnailURL: null,
            id: 'tlk:a-traitor-to-the-king',
            name: 'The Lion King',
            numberOfStrips: 125,
            rating: 3,
            updatedAt: DateTime.now().subtract(const Duration(days: 400)),
          ),
        ],
      ),
      ComicsCategory(
        id: 'wolves',
        name: language == 'en' ? 'Wolf world' : 'Волчий мир',
        comicses: [],
      ),
      ComicsCategory(
        id: 'mlp',
        name: 'My Little Pony',
        comicses: [],
      ),
      ComicsCategory(
        id: 'furry',
        name: language == 'en' ? 'Furry' : 'Фуркомиксы',
        comicses: [],
      ),
      ComicsCategory(
        id: 'gamer',
        name: language == 'en' ? 'Gamers' : 'Игровые',
        comicses: [],
      ),
      ComicsCategory(
        id: 'other',
        name: language == 'en' ? 'Other' : 'Прочие',
        comicses: [],
      ),
      ComicsCategory(
        id: 'interrobang',
        name: 'Interrobang Studios',
        comicses: [],
      ),
    ];
  }
}
