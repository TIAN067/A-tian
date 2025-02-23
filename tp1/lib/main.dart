import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CategoryProvider(),
      child: MaterialApp(
        title: 'Moments décontractés',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Roboto',
        ),
        home: HomePage(),
      ),
    );
  }
}

class MediaItem {
  final String id;
  final String title;
  final String category;
  final String coverUrl;
  final double rating;
  final String description;
  final String? author;       // 新增作者字段（书籍/漫画）
  final String? director;     // 新增导演字段（电影/剧集）
  final List<String>? actors; // 新增主演字段（电影/剧集）
  final String? team;         // 新增队伍/运动员字段（体育）
  bool isFavorite;
  bool isToWatch;
  List<double> userRatings;
  List<String> comments;
  DateTime viewTime;

  MediaItem({
    required this.id,
    required this.title,
    required this.category,
    required this.coverUrl,
    required this.rating,
    required this.description,
    this.author,
    this.director,
    this.actors,
    this.team,
    this.isFavorite = false,
    this.isToWatch = false,
    this.userRatings = const [],
    this.comments = const [],
    required this.viewTime,
  });

  MediaItem copyWith({DateTime? viewTime}) {
    return MediaItem(
      id: id,
      title: title,
      category: category,
      coverUrl: coverUrl,
      rating: rating,
      description: description,
      author: author,
      director: director,
      actors: actors,
      team: team,
      isFavorite: isFavorite,
      isToWatch: isToWatch,
      userRatings: userRatings,
      comments: comments,
      viewTime: viewTime ?? this.viewTime,
    );
  }

  double get averageRating {
    if (userRatings.isEmpty) return rating;
    return userRatings.reduce((a, b) => a + b) / userRatings.length;
  }
}

class CategoryProvider with ChangeNotifier {
  String _selectedCategory = 'Livre';
  String _searchQuery = '';
  List<MediaItem> _allItems = [];
  List<MediaItem> _viewHistory = [];

  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  List<MediaItem> get viewHistory => _viewHistory;

  List<MediaItem> get currentItems {
    return _allItems.where((item) {
      return item.category == _selectedCategory &&
          item.title.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  List<MediaItem> get favorites =>
      _allItems.where((item) => item.isFavorite).toList();
  List<MediaItem> get toWatchItems =>
      _allItems.where((item) => item.isToWatch).toList();

  void setCategory(String category) {
    _selectedCategory = category;
    _searchQuery = '';
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleFavorite(MediaItem item) {
    item.isFavorite = !item.isFavorite;
    notifyListeners();
  }

  void toggleToWatch(MediaItem item) {
    item.isToWatch = !item.isToWatch;
    notifyListeners();
  }

  void addRating(MediaItem item, double rating) {
    item.userRatings.add(rating);
    notifyListeners();
  }

  void addComment(MediaItem item, String comment) {
    item.comments.add(comment);
    notifyListeners();
  }

  void addToHistory(MediaItem item) {
    if (!_viewHistory.contains(item)) {
      _viewHistory.add(item);
      notifyListeners();
    }
  }

  CategoryProvider() {
    _allItems = [
      // Livres (données d'exemple)
      MediaItem(
        id: 'book1',
        title: 'Le Problème à trois corps',
        category: 'Livre',
        coverUrl: 
        'https://media.gibert.com/media/catalog/product/cache/9c5d587d35c1c68f95b397933fab7f6b/c/_/c_9782330181055-9782330181055_1.jpg',
        rating: 4.3,
        description:'''
1967, durant la révolution culturelle chinoise, Ye Wenjie assiste au pugilat en public de son père, un éminent professeur de physique dont les idées étaient jugées trop « réactionnaires » pour la nouvelle science révolutionnaire. En effet, à cette époque les gardes rouges, bras armés de la révolution, estimaient que la science, même physique, était politique. Ils promulguaient une science qui se voulait une science du peuple, moins influencée par les  esprits occidentaux. Et ceux qui enseignaient l'ancienne science devaient être jugés et punis. Ayant assisté à la mort de son père, jugée elle-même comme « ennemie du peuple » au vu de sa filiation, Ye Wenjie est envoyée en « rééducation ». Après quelques années d'enfer, on estime ses compétences scientifiques comme potentiellement utiles à un projet gouvernemental secret. C'est à moitié morte de faim et de froid qu'on l'emmène dans la station de Côte rouge, une station d'observation militaire ultra sécurisée. On la prévient alors : si elle y entre, elle ne pourra plus jamais en ressortir.

Trente-huit ans plus tard, Wang Miao, éminent chercheur en physique appliquée, est convoqué à une réunion des plus confidentielle. Policiers, militaires, scientifiques, et même quelques membres de la CIA sont réunis pour parler d'un phénomène grave : le suicide en masse des esprits scientifiques les plus brillants du globe. Parmi certains de ces noms, des connaissances relativement proches de Wang Miao.

Le bilan est clair : un ennemi invisible cherche à freiner les avancées scientifiques du genre humain tout entier. Pourquoi ? Par quels moyens ? On demande à Wang Miao d'enquêter parmi ses relations pour comprendre qui a pu inciter au suicide les plus grands esprits de son milieu. Aidé du roublard commissaire Shi Qiang, le physicien s'apprête donc à s'enfoncer dans les méandres nauséabonds d'une enquête criminelle.

Ce chemin le mène à se rendre compte qu'un lien existe entre ces morts et un jeu en ligne : Les Trois corps. Ce jeu sonne comme un défi pour l'esprit scientifique de Wang Miao. Dans le monde des Trois corps, la survie est le maître mot. Ce monde aride ne connaît pas la stabilité : il oscille entre des ères chaotiques où les lois de la nature se détraquent complètement pour des périodes indéterminées, et des ères régulières où la vie est à nouveau en mesure de fleurir. Les habitants de ce monde redoutent l'arrivée brutale et toujours inattendue de ces ères chaotiques et supplient le joueur de trouver une réponse à leur problème : comment prévoir l'arrivée d'une ère chaotique et sa durée afin de mieux s'y préparer ? Un défi physique et mathématique pour l'esprit aiguisé de Wang Miao qui comprend que ce jeu, non seulement a dû servir d'appât aux victimes, mais cache un secret bien plus terrible sous son innocente apparence ludique. Un secret qui pourrait bien mettre à mal l'espèce humaine tout entière.
        ''',
        author: '(Chine)Liu Cixin',
        viewTime: DateTime.now(),
      ),
      MediaItem(
        id: 'book2',
        title: 'La Peste',
        category: 'Livre',
        coverUrl: 
        'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c6/La_Peste_book_cover.jpg/800px-La_Peste_book_cover.jpg',
        rating: 4.5,
        description: '''
Le récit, structuré en cinq parties comme les actes d'une tragédie classique, débute par la mort mystérieuse de plusieurs rats dans les rues d'Oran. Le concierge de l'immeuble du docteur Rieux succombe à une maladie étrange malgré les soins apportés par le médecin. L'employé de mairie, Grand, informe Rieux de la mort massive des rats. Face à la progression de l'épidémie qui s'avère être la peste, les autorités décident finalement de fermer la ville pour en empêcher la propagation.

Au cours de la deuxième partie, le journaliste Rambert cherche désespérément à quitter Oran pour retrouver sa compagne à Paris, tandis que Cottard profite de la situation pour se lancer dans un commerce illégal profitable. Parallèlement, Grand tente d'écrire un livre et le père Paneloux interprète l’épidémie comme un châtiment divin.

L'été arrive et avec lui une augmentation des décès, mais les habitants commencent à s'habituer aux effets dévastateurs de l'épidémie. À l'automne, Rambert décide de joindre ses efforts à ceux de Rieux et Tarrou pour combattre la maladie. La mort d'un jeune enfant, particulièrement douloureuse et atroce, bouleverse profondément Paneloux, renforçant sa foi.

En janvier, la peste commence à reculer et le sérum développé par Castel devient étrangement efficace. Tarrou, malgré les soins de Rieux, succombe à la maladie, devenant l'une des dernières victimes. Dans un accès de folie, Cottard commence à tirer sur des passants depuis son appartement, ce qui conduit à son arrestation. Le même jour, Rieux apprend le décès de sa femme, qui était partie se soigner de la tuberculose hors d'Oran avant l'épidémie. Après avoir lutté contre la tuberculose pendant près d'un an, Rieux se retrouve face aux pertes personnelles et aux ravages causés par la maladie. Le roman se clôt sur l'image d'un Rieux lucide et pleinement conscient des dégâts infligés par la peste.
        ''',
        author: '(France)Albert Camus',
        viewTime: DateTime.now(),
      ),
      MediaItem(
        id: 'book3',
        title: 'Le Code Da Vinci',
        category: 'Livre',
        coverUrl:
            'https://m.media-amazon.com/images/I/81WxCI8QOvL.jpg',
        rating: 4.6,
        description:'''
Robert Langdon, un symbologue américain, est entraîné malgré lui, lors d'un voyage à Paris, dans l'affaire du meurtre de Jacques Saunière, conservateur au Musée du Louvre. Langdon est soupçonné du meurtre, principalement à cause d’un message que Saunière a écrit sur le sol avant de mourir, s’achevant par la phrase « P.S. Trouver Robert Langdon ». Seule Sophie Neveu, cryptologue et petite-fille de Saunière, croit en l’innocence de l’Américain. Persuadée que le message de son grand-père s'adresse à elle en particulier, Neveu demande à Langdon de l'aider à en comprendre le sens (le message pouvant d'ailleurs leur permettre de comprendre qui est le vrai meurtrier). En retour, elle l'aide à échapper au commissaire Fache, lancé à ses trousses...

Langdon et Neveu découvrent par la suite que Saunière était à la tête du Prieuré de Sion, une ancienne et puissante confrérie, et qu'il a été assassiné par un membre de l'Opus Dei. L'assassin voulait protéger un secret dont le conservateur du Louvre avait connaissance, un secret susceptible d’ébranler les fondements de la foi chrétienne : Jésus de Nazareth aurait eu un enfant avec Marie Madeleine. Touché d’une balle dans le ventre, agonisant, Saunière a eu peur que le secret ne se perde après sa mort, et a donc cherché à le transmettre à sa petite-fille. Pour cela, il a écrit sur le sol un message abscons, espérant qu'elle seule pourrait le comprendre, à condition qu'elle soit aidée par le symbologiste Langdon, qu'il connaissait et en qui il avait confiance (d’où le « Trouver Robert Langdon », qui n’est nullement une accusation contre l'Américain). Il a également choisi de mourir dans une position symbolique rituelle, rappelant celle de l’Homme de Vitruve, de Léonard de Vinci, permettant ainsi à Langdon et à Neveu de comprendre que le secret a un rapport avec le peintre italien : en effet, celui-ci aurait été le chef du Prieuré de Sion et aurait cherché à exprimer à travers ses œuvres, de façon indirecte, ses idées sur la nature de la relation entre Jésus et Marie Madeleine.

Le thème central du Da Vinci Code est la lutte secrète entre les instances dirigeantes de l'Église catholique romaine et le Prieuré de Sion. L'objet de cette lutte est un secret connu des deux organisations, à savoir la paternité du Christ. La divulgation de ce secret menacerait le pouvoir de l'Église et risquerait d'ébranler les fondements de la civilisation occidentale. Soucieuse de conserver son pouvoir, l'Église semble donc chercher à détruire tout détenteur du fameux secret (dont le Prieuré), tandis que les membres du Prieuré luttent pour la préservation de ce même secret, qu'ils se transmettent de génération en génération. Sont par ailleurs évoquées en arrière-plan les deux idées selon lesquelles l'Église Catholique, voulant acquérir et garder le pouvoir, s'est interposée et imposée comme intermédiaire entre l'homme et Dieu, et l'union sexuelle, qui laisse toute la place à l'altérité homme - femme et qui est un moyen privilégié d'entrer en contact direct avec Dieu (voir la scène du Hieros Gamos, Union sacrée), est déclarée péché.
        ''',
        author: '(États-Unis)Dan Brown',
        viewTime: DateTime.now(),
      ),
      MediaItem(
        id: 'book4',
        title: 'Chroniques du Sahara',
        category: 'Livre',
        coverUrl: 'https://www.gannett-cdn.com/presto/2020/12/01/PNJM/fce5addd-11c4-4403-acd3-39c04fa0a61a-sanmaobook.jpg?width=1588',
        rating: 4.7,
        description:'''
« Chroniques du Sahara  » relate principalement ce que Sanmao et José ont vu et vécu durant leur séjours dans le désert du Sahara, ainsi que les histoires de leurs rencontres et amitiés avec les habitants locaux. Chaque récit révèle l’amour de la vie de cette femme discrète et sa détermination face aux difficultés.

Le livre est composé d’une dizaine de récits en prose captivants et émouvants, dont « L’Hôtel dans le Désert » qui fut la première œuvre reprise par Sanmao après s’être adaptée à la vie monotone et aride du désert. À partir de ce moment, elle écrivit une série d’histoires dont le décor était le désert.

Sanmao apprit à s’adapter et à chérir ce vaste désert ; sous sa plume, les habitants et les éléments du Sahara prenaient des couleurs multiples. Adopte le ton d’une voyageuse errante, elle relate avec légèreté les détails et les expériences épars de sa vie dans le désert du Sahara : la nouveauté du désert, les plaisirs simples de la vie, les grandes tentes usées, les petites maisons de tôle, le chameau à une bosse et les troupeaux de chèvres.

Que ce soit dans l’épisode où José mange ses vermicelles comme s’il s’agissait de pluie, ou lors de leur mariage d’une simplicité désarmante, de leurs sorties pour pêcher en bord de mer, ou encore de leur aventure pour bâtir de leurs propres mains la plus belle maison du désert, chaque moment transpire l’affection chaleureuse et sincère qui les unit.
''',
        author: '(Chine)Sanmao',
        viewTime: DateTime.now(),
      ),
      MediaItem(
        id: 'book5',
        title: 'Cent Ans de Solitude',
        category: 'Livre',
        coverUrl: 'https://fr.web.img5.acsta.net/c_310_420/img/4e/af/4eafcbc083a57614cbeec3a6379056f9.jpg',
        rating: 4.5,
        description: '''
« Cent Ans de Solitude » relate l’histoire de la famille Buendía sur six générations dans le village imaginaire de Macondo. Fondé par José Arcadio Buendía et Ursula Iguarán, un couple de cousins, le village se développe malgré les appréhensions dues à leur parenté. Le village s’étend, les habitants arrivent, mais des malheurs comme la peste de l’insomnie et de l’oubli frappent. Aureliano étiquette les objets pour se souvenir, jusqu’à ce que Melquiades revienne avec une boisson pour rétablir la mémoire. La guerre civile éclate, et le colonel Aureliano Buendía devient un leader de la résistance. La guerre se termine par un traité de paix, et Aureliano se retire de la politique. Son fils, Aureliano le Triste, amène le train à Macondo, apportant développement et prospérité.

Cependant, la grève des travailleurs de la bananeraie se termine par un massacre, suivi de pluies incessantes qui durent quatre ans. Ursula meurt, et Macondo reste désolé. Aureliano Babilonia, le dernier Buendía, découvre que les événements étaient prédits dans les parchemins de Melquiades. Sa liaison avec Amaranta Ursula aboutit à la naissance d’un enfant avec une queue de cochon, symbolisant la fin de la lignée. Aureliano déchiffre les parchemins, comprenant que son histoire et celle de Macondo se terminent.
''',        
        author: '(Colombie)Gabriel García Márquez',
        viewTime: DateTime.now(),
      ),
      // Bandes dessinées
      MediaItem(
        id: 'comic1',
        title: 'Les Aventures de Tintin',
        category: 'Bd',
        coverUrl: 'https://m.media-amazon.com/images/S/pv-target-images/79c59cc44cac2c53663a4fd437bb8670f7d794cb379510da09c1c3ece56b0a8f.jpg',
        rating: 4.9,
        description: '''
Les Aventures de Tintin est une série de bandes dessinées créée par le dessinateur belge Hergé. Débutée en 1929, la série compte 24 albums et jouit d'une renommée mondiale. Elle raconte les péripéties de Tintin, un jeune reporter belge, accompagné de son fidèle fox-terrier Milou. Ensemble, ils parcourent le monde pour dévoiler des vérités et combattre le crime. Au fil de leurs aventures, ils se lient d'amitié avec divers personnages, tels que le capitaine Haddock, le professeur Tournesol et les détectives Dupond et Dupont. Leurs expéditions les mènent des pyramides d'Égypte aux jungles d'Amérique du Sud, en passant par des voyages sur la Lune et des chasses aux trésors sous-marins. La série est reconnue pour ses intrigues captivantes, son humour subtil et son style graphique soigné, séduisant un large public de tous âges.
        ''',
        author: '(Belgique)Hergé',
        viewTime: DateTime.now(),
      ),
      MediaItem(
        id: 'comic2',
        title: "Gen d'Hiroshima",
        category: 'Bd',
        coverUrl: 'https://media.senscritique.com/media/000007194885/0/gen_d_hiroshima.jpg',
        rating: 4.7,
        description:'''
L'histoire suit Gen Nakaoka, un jeune garçon vivant à Hiroshima pendant la Seconde Guerre mondiale. Le 6 août 1945, la ville est dévastée par une explosion atomique. Gen perd sa famille et sa maison dans l'attaque. Seul survivant, il lutte pour sa survie dans un environnement hostile, confronté à la faim, aux blessures et aux stigmates de la radiation. Au fil des chapitres, le manga explore les défis auxquels Gen est confronté, sa résilience et son désir de reconstruire sa vie après la tragédie.
        ''',
        author: '(Japon)Keiji Nakazawa',
        viewTime: DateTime.now(),
      ),
      // Films
      MediaItem(
        id: 'movie1',
        title: 'The Shawshank Redemption',
        category: 'Film',
        coverUrl: 'https://www.closeupshop.fr/media/oart_0/oart_s/oart_13753/thumbs/1269408_4552416.jpg',
        rating: 4.8,
        description:'''
Une affaire de meurtre conduit le banquier Andy Dufresne (interprété par Tim Robbins) en prison, accusé à tort du meurtre de sa femme et de son amant, le condamnant à la réclusion à perpétuité. À son arrivée à la prison de Shawshank, il attire l'attention de Red (Morgan Freeman), un détenu influent. Red aide Andy à obtenir un marteau de géologue et une affiche d'une star de cinéma, et une amitié naît entre eux.

Rapidement, Andy se distingue en tant que bibliothécaire de la prison et utilise ses connaissances financières pour aider les gardiens à éviter les impôts, ce qui attire l'attention du directeur, qui l'engage pour blanchir de l'argent. Un jour, un nouveau détenu révèle qu'il peut prouver l'innocence d'Andy. Plein d'espoir, Andy demande au directeur de l'aider à réviser son procès, mais ce dernier, hypocrite et rusé, fait tuer le nouveau détenu, anéantissant ainsi les chances d'Andy de prouver son innocence légalement.

Malgré sa déception, Andy ne perd pas espoir. Par une nuit orageuse, il met en œuvre un plan d'évasion qu'il a secrètement élaboré pendant des décennies, retrouvant ainsi sa liberté. Son ami Red, inspiré et aidé par Andy, trouve également le courage de chercher sa propre liberté.        ''',
        director: '(France)Frank Darabont', // 添加导演
        actors: ['Tim Robbins', 'Morgan Freeman','Bob Gunton','William Sadler','Clancy Brown'], // 添加主演
        viewTime: DateTime.now(),
      ),
      MediaItem(
        id: 'movie2',
        title: 'Vivre !',
        category: 'Film',
        coverUrl: 'https://www.originalfilmart.com/cdn/shop/products/To_Live_1994_original_film_art_41ca749a-1b8d-41e6-8213-ffdf5c889242_5000x.jpg?v=1572473903',
        rating: 4.6,
        description: '''
Adapté du roman éponyme de Yu Hua.

"Vivre !" raconte l'histoire de Xu Fugui (interprété par Ge You), un jeune homme issu d'une famille aisée, accro au jeu. Malgré les avertissements répétés de sa femme, Jiazhen (jouée par Gong Li), il continue de jouer jusqu'à perdre tous ses biens, provoquant la mort de son père par la colère. Contraint de vendre les bijoux de sa mère pour louer une modeste maison, il sombre dans la pauvreté.

Un an plus tard, Jiazhen revient avec leur fille Fengxia et leur nouveau-né Youqing. Fugui, ayant pris conscience de ses erreurs, se consacre à sa famille en se produisant dans des spectacles d'ombres chinoises. Cependant, pendant la guerre civile, il est enrôlé de force par l'armée nationaliste. Après de nombreuses péripéties, il retrouve enfin sa famille, mais découvre que Fengxia est devenue muette à la suite d'une maladie.

Au fil des campagnes politiques telles que le Grand Bond en avant et la Révolution culturelle, la famille traverse des épreuves déchirantes. Malgré quelques moments de bonheur, les tragédies s'enchaînent, mettant à l'épreuve leur résilience face aux aléas de la vie.
        ''',
        director: '(Chine)Yimou Zhang',
        actors: ['You Ge', 'Li Gong','Wu Jiang','Ben Niu','Tao Guo'],
        viewTime: DateTime.now(),
      ),
      MediaItem(
        id: 'movie3',
        title: 'Yip Man 4：The Finale',
        category: 'Film',
        coverUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQQcY3mZWxFnzON2Alfno-9SyMM76ifkkjJnA&s',
        rating: 3.4,
        description:''' 
«Yip Man 4：The Finale» raconte l'histoire de Ip Man (interprété par Donnie Yen) qui, après le décès de son épouse, se rend seul aux États-Unis pour trouver une école appropriée pour son fils. À San Francisco, il découvre que son élève Bruce Lee (incarné par Danny Chan) suscite le mécontentement des maîtres locaux en enseignant les arts martiaux chinois aux étrangers. Parallèlement, la fille de son ami Wan Zonghua (joué par Wu Yue), Yonah (interprétée par Vanda Margraf), est victime de discrimination et de harcèlement à l'école. En les aidant, Ip Man met en lumière le racisme présent au sein de l'armée américaine et, grâce à l'esprit des arts martiaux, gagne le respect, obtenant ainsi des droits pour la communauté chinoise.
         ''',        
        director: '(Chine)Wilson Yip',
        actors: ['Donnie Yen', 'Yue Wu','Vanness Wu','Scott Adkins','Vanda Margraf'],
        viewTime: DateTime.now(),
      ),
      MediaItem(
        id: 'movie4',
        title: 'Dune: Part Two',
        category: 'Film',
        coverUrl: 'https://i.ytimg.com/vi/COELrJTyosw/hq720.jpg?sqp=-oaymwE7CK4FEIIDSFryq4qpAy0IARUAAAAAGAElAADIQj0AgKJD8AEB-AH-CYAC0AWKAgwIABABGH8gQSgTMA8=&rs=AOn4CLDkJ1aRb9E2LttJ1p4WA6ZCxZjgMQ',
        rating: 4.8,
        description: '''
Dans《 Dune: Part Two 》, Paul Atréides et sa mère, Dame Jessica, rejoignent les Fremen et s'adaptent progressivement à l'environnement hostile de la planète Arrakis. Paul révèle son potentiel en tant qu'« élu » et est considéré par les Fremen comme leur messie, « Muad'Dib ». Il noue une amitié avec le chef Fremen Stilgar et développe une relation romantique avec la guerrière Chani.

Les capacités de prescience de Paul s'intensifient, lui permettant de voir une future guerre sainte qu'il tente d'éviter. Parallèlement, la tyrannie des Harkonnen provoque la révolte des Fremen. Paul mène les Fremen dans une lutte contre les Harkonnen et les forces de l'Empereur, utilisant l'environnement désertique et des tactiques de guérilla pour remporter des victoires. Lors de la bataille finale, Paul affronte et vainc son ennemi juré, Feyd-Rautha Harkonnen, prenant le contrôle de la production d'épice et forçant l'Empereur à se soumettre.

Bien que Paul devienne le nouvel Empereur et épouse Chani, il réalise qu'il ne peut pas complètement éviter la guerre sainte qu'il a vue dans ses visions, et que son chemin reste semé d'embûches. Le film explore des thèmes profonds tels que le destin, le pouvoir, la foi et l'écologie, tout en dépeignant l'ascension de Paul et les luttes pour le contrôle de l'univers.
        ''',
        director: '(Canada)Denis Villeneuve',
        actors: ['Timothée Chalamet', 'Zendaya','Rebecca Ferguson','Josh Brolin'],
        viewTime: DateTime.now(),
      ),
      MediaItem(
        id: 'movie5',
        title: 'The Godfather Part II',
        category: 'Film',
        coverUrl: 'https://ntvb.tmsimg.com/assets/p6319_v_h8_bi.jpg?w=1280&h=720',
        rating: 4.8,
        description:''' 
《 The Godfather Part II 》 utilise une narration double pour raconter l'ascension de Vito Corleone et la consolidation du pouvoir de Michael Corleone. Jeune, Vito fuit l'Italie et immigre aux États-Unis, où il devient le chef de Little Italy grâce à son intelligence et à sa ruse. Après la mort de son père, Michael devient le nouveau parrain de la famille, cherchant à blanchir l'argent de la famille par des moyens légaux. Cependant, il fait face à des menaces internes et externes, éliminant ses ennemis avec une froideur impitoyable, allant jusqu'à exécuter son frère Fredo pour trahison. Le film alterne entre les histoires de Vito et de Michael, montrant les destins différents des deux parrains : Vito a bâti son empire avec sagesse et humanité, tandis que Michael, dans sa quête de pouvoir, perd peu à peu son humanité, se retrouvant seul et vide dans le domaine familial.
        ''',
        director: '(États-Unis)Francis Ford Coppola',
        actors: ['Al Pacino', 'Robert De Niro','Diane Keaton'],
        viewTime: DateTime.now(),
      ),
      // Séries
      MediaItem(
        id: 'series1',
        title: 'House of the Dragon Season 1',
        category: 'Serie',
        coverUrl: 'https://news.agentm.tw/wp-content/uploads/cover-1-1942-750x422.jpg',
        rating: 4.4,
        description: '''
La première saison de House of the Dragon raconte comment les germes de la lutte pour le pouvoir au sein de la dynastie Targaryen ont commencé à germer discrètement à la cour royale. L’histoire se situe 200 ans avant Game of Thrones, à une époque où le royaume était régi par le roi Viserys I, qui s’efforçait de maintenir l’harmonie au sein de sa famille et la prospérité dans tout le royaume.

Cependant, avec l’émergence des problèmes de succession, la cour se divise en deux camps opposés – d’un côté, la faction dite « noire », centrée sur l’héritière désignée par le roi, Rhaenyra Targaryen, et de l’autre, la faction « verte » qui soutient la reine Alicent Hightower et les intérêts de sa famille. Dans ce contexte, les mariages politiques, les intrigues souterraines et les relations personnelles complexes s’entremêlent, exacerbant progressivement les conflits internes à la famille.

Face aux manœuvres de chacun, Rhaenyra doit non seulement défendre sa légitimité en tant qu’héritière légitime, mais aussi affronter les défis posés par la reine et ses alliés. Les complots de cour, les transactions de pouvoir et les rancœurs familiales s’intensifient, présageant l’éclatement imminent d’une guerre civile dévastatrice – connue sous le nom de « Dance of the Dragons » –, qui transformera radicalement le destin de la dynastie Targaryen.

En somme, la première saison jette les bases de la guerre civile à venir au sein des Targaryen, en exposant un univers politique vaste et impitoyable et en annonçant inévitablement le déclin de l’ère glorieuse des dragons.        ''',
        actors: ['Paddy Considine', 'Matthew Robert Smith','Olivia Cooke',"Emma D'Arcy"],
        viewTime: DateTime.now(),
      ),
      MediaItem(
        id: 'series2',
        title: 'Friends Season 1',
        category: 'Serie',
        coverUrl: 'https://m.media-amazon.com/images/S/pv-target-images/77baa975ed124a8f667a03563e92d1c301810e1aa9d356b056fbe26c7a7863f1.jpg',
        rating: 4.6,
        description: '''
La première saison de Friends raconte l'histoire de six amis qui vivent à New York et se soutiennent mutuellement dans les hauts et les bas de la vie. Au début, Rachel, qui vient d'abandonner son mariage raté, débarque en courant dans le café Central Perk et finit par emménager chez Monica, amorçant ainsi sa quête d'indépendance. Parallèlement, Ross traverse un divorce difficile (sa femme Carol étant lesbienne), ce qui le plonge dans la mélancolie, tandis que Chandler, Joey et Phoebe affrontent eux aussi leurs propres soucis.

Au fil des épisodes, le groupe se réunit régulièrement au Central Perk pour partager rires et larmes. Rachel s'efforce de s'adapter à sa nouvelle vie en prenant un emploi dans le café, tandis que Ross, encore marqué par son divorce, voit renaître ses sentiments pour Rachel. Chandler, quant à lui, utilise son humour pour masquer ses insécurités, et Joey, malgré ses ambitions d'acteur, rencontre de nombreux obstacles. Phoebe, avec sa personnalité excentrique et imprévisible, apporte une touche de spontanéité et de joie qui équilibre le groupe.

En somme, cette saison est à la fois pleine de moments hilarants et le terreau sur lequel se construiront les relations complexes – notamment celle entre Ross et Rachel – tout en illustrant la force de l'amitié et du soutien inconditionnel entre ces six personnes.
        ''',
        actors: ["Jennifer Aniston","Courteney Cox","Lisa Kudrow","Matt LeBlanc","Matthew Perry","David Schwimmer"],
        viewTime: DateTime.now(),
      ),
      MediaItem(
        id: 'series3',
        title: 'Breaking Bad Season 1',
        category: 'Serie',
        coverUrl: 'https://i.ytimg.com/vi/Xa7UaHgOGfM/maxresdefault.jpg',
        rating: 4.6,
        description: '''
La première saison de "Breaking Bad" raconte l'histoire de Walter White, un professeur de chimie dans un lycée d'Albuquerque, au Nouveau-Mexique. Âgé de cinquante ans, Walter mène une vie ordinaire et fait face à des difficultés financières. Il vit avec sa femme enceinte, Skyler, et son fils handicapé, Walter Jr. Lorsqu'il apprend qu'il est atteint d'un cancer du poumon inopérable, son monde s'effondre.

Pour assurer l'avenir financier de sa famille avant sa mort, Walter décide d'utiliser ses compétences en chimie pour fabriquer et vendre de la méthamphétamine. Il s'associe avec un ancien élève, Jesse Pinkman, devenu petit trafiquant, et ensemble, ils commencent à produire de la méthamphétamine de haute pureté dans un vieux camping-car. Grâce à l'expertise de Walter, leur produit, surnommé "Blue Sky" en raison de sa pureté et de sa couleur bleutée, devient rapidement populaire sur le marché.

Cependant, le monde du trafic de drogue est rempli de dangers et de défis. Walter et Jesse doivent non seulement faire face à des concurrents impitoyables, mais aussi échapper aux forces de l'ordre. Ironiquement, Hank Schrader, le beau-frère de Walter, est un agent de la DEA chargé de lutter contre le trafic de drogue dans la région. Au fil des épisodes, Walter évolue d'un enseignant respectueux des lois à un fabricant de drogue prêt à tout, s'engageant sur une voie criminelle sans retour.        
        ''',
        actors: ['Bryan Cranston', 'Aaron Paul'],
        viewTime: DateTime.now(),
      ),
      MediaItem(
        id: 'series4',
        title: 'House of Cards Season 1',
        category: 'Serie',
        coverUrl: 'https://i.ytimg.com/vi/8QnMmpfKWvo/maxresdefault.jpg',
        rating: 4.6,
        description: '''
La première saison de "House of Cards" raconte l'histoire de Frank Underwood, le whip de la majorité à la Chambre des représentants des États-Unis. Après avoir aidé Garrett Walker à remporter l'élection présidentielle, Frank, se sentant trahi en n'obtenant pas le poste de secrétaire d'État qu'on lui avait promis, élabore une série de plans minutieux pour se venger et accéder à un pouvoir supérieur. Dans ce processus, il établit une relation mutuellement bénéfique avec la jeune journaliste Zoe Barnes, utilisant les médias pour manipuler l'opinion publique ; en même temps, il manipule le représentant de la Pennsylvanie, Peter Russo, pour atteindre ses objectifs politiques. L'épouse de Frank, Claire Underwood, montre également son ambition à travers son ONG "Clean Water Initiative", collaborant avec Frank dans leur quête commune du pouvoir. La première saison se termine avec Frank réussissant à se positionner comme candidat à la vice-présidence, ouvrant la voie à sa poursuite ultérieure du pouvoir.
        ''',
        actors: ['Kevin Spacey', 'Robin Wright','Kate Mara','Corey Stoll'],
        viewTime: DateTime.now(),
      ),
      MediaItem(
        id: 'series5',
        title: 'The Walking Dead :Season 1',
        category: 'Serie',
        coverUrl: 'https://cdn1.epicgames.com/offer/bloodroot/TWD1_EPIC_Landscape_2560x1440_2560x1440-769095bad4d31fa3570f4d247b90c507',
        rating: 4.6,
        description:'''
Le shérif adjoint Rick Grimes se réveille d'un coma pour découvrir que le monde est ravagé par des zombies, appelés "marcheurs". Il entreprend de retrouver sa famille et rencontre un groupe de survivants à Atlanta. Rick retrouve sa femme Lori et son fils Carl, ainsi que son ancien partenaire Shane Walsh. Le groupe fait face à des défis constants, luttant pour survivre dans ce nouveau monde dangereux. 
        ''',
        actors: ['Andrew Lincoln', 'Jon Bernthal','Sarah Wayne Callies','Chandler Riggs','Laurie Holden','Jeffrey DeMunn'],
        viewTime: DateTime.now(),
      ),
      // Sport
      MediaItem(
        id: 'sport1',
        title: "Premier tour du simple dames de la Coupe d'Asie de tennis de table 2025",
        category: 'Sport',
        coverUrl: 'https://i.ytimg.com/vi/9RnHl1ynPYo/maxresdefault.jpg',
        rating: 4.6,
        description: ''' 
Le 19 février 2025, lors du premier tour du simple dames de la Coupe d'Asie de tennis de table à Fukuoka, au Japon, la joueuse chinoise Sun Yingsha a affronté la Taïwanaise Jian Tongjuan. En tant que tête de série numéro un du tournoi, Sun Yingsha a démontré une grande puissance et une stabilité mentale tout au long du match.

Dès la première manche, Sun Yingsha est entrée rapidement dans le jeu, s'imposant 11-3. Dans la deuxième manche, Jian Tongjuan a ajusté sa stratégie en renforçant son attaque, mais Sun Yingsha, grâce à une défense solide et des contre-attaques efficaces, a remporté la manche 11-7. La troisième manche a vu Sun Yingsha maintenir son avantage, concluant le match avec un score de 11-5, et s'imposant ainsi 3-0 au total pour accéder au tour suivant.

Après le match, Sun Yingsha a déclaré lors d'une interview que son adversaire avait bien joué et qu'elle-même était restée concentrée, appliquant la stratégie prévue, ce qui lui a permis d'obtenir le résultat escompté.
        ''',
        team: 'Sun Yingsha vs Jian Tongjuan',
        viewTime: DateTime.now(),
      ),
      MediaItem(
        id: 'sport2',
        title: 'NBA All-Star Game 2025',
        category: 'Sport',
        coverUrl: 'https://q1.itc.cn/images01/20241123/8d2df686a77345979513db4fd093f376.jpeg',
        rating: 4.7,
        description: '''
Le NBA All-Star Game 2025 s'est tenu le 16 février au Staples Center de Los Angeles. Ce match opposait l'Équipe des Stars de l'Est à l'Équipe des Stars de l'Ouest, réunissant les meilleurs joueurs de la ligue. Dès le début du match, l'équipe de l'Est a pris l'avantage grâce à des tirs à trois points précis et une défense bien organisée, tandis que l'équipe de l'Ouest a progressivement réduit l'écart grâce à des contre-attaques rapides et une coopération collective efficace. Au cours de la rencontre, les joueurs des deux équipes ont démontré des compétences individuelles exceptionnelles ainsi qu'une grande harmonie sur le terrain. Notamment, dans les dernières minutes, le capitaine de l'équipe de l'Ouest a réussi un tir à trois points décisif qui a permis à son équipe de renverser la situation et de remporter la victoire. Ce match palpitant, riche en moments d'émotion, a non seulement mis en lumière le niveau de jeu des stars de la NBA, mais a également illustré toute la beauté et l'intensité du basketball, offrant aux fans un véritable spectacle.
        ''',
        team: "Équipe de l'Est vs Équipe de l'Ouest",
        viewTime: DateTime.now(),
      ),
    ];
  }
}

class DetailPage extends StatelessWidget {
  final MediaItem item;

  const DetailPage({Key? key, required this.item}) : super(key: key);

  Widget _buildCreatorInfo(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 16, color: Colors.black),
        children: [
          TextSpan(
            text: '$label : ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: value),
        ],
      ),
    ),
  );
 }

  @override
  Widget build(BuildContext context) {
    final commentController = TextEditingController();
    double? newRating;

    Provider.of<CategoryProvider>(context, listen: false).addToHistory(item);

    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
        elevation: 0,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 修改 Hero 组件的父容器
            Center( // 添加 Center 组件使图片居中
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4, // 限制最大高度
                  maxWidth: MediaQuery.of(context).size.width * 0.8, // 限制最大宽度
                ),
                child: Hero(
                  tag: item.coverUrl,
                  child: CachedNetworkImage(
                    imageUrl: item.coverUrl,
                    fit: BoxFit.contain,
                    placeholder: (_, __) => Container(
                      color: Colors.grey[200],
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (_, __, ___) => Icon(Icons.broken_image, size: 50),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber),
                SizedBox(width: 8),
                Text(
                  '${item.averageRating.toStringAsFixed(1)}/5',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Consumer<CategoryProvider>(
                  builder: (context, provider, child) {
                    return IconButton(
                      icon: Icon(
                        item.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: item.isFavorite ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        provider.toggleFavorite(item);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(item.isFavorite
                                ? 'Ajouté aux favoris'
                                : 'Retiré des favoris'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    );
                  },
                ),
                Consumer<CategoryProvider>(
                  builder: (context, provider, child) {
                    return IconButton(
                      icon: Icon(
                        item.isToWatch
                            ? Icons.bookmark_added
                            : Icons.bookmark_add,
                        color: item.isToWatch ? Colors.blue : Colors.grey,
                      ),
                      onPressed: () {
                        provider.toggleToWatch(item);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(item.isToWatch
                                ? 'Ajouté à la liste à regarder'
                                : 'Retiré de la liste à regarder'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Évaluation'),
                        content: StatefulBuilder(
                          builder: (context, setState) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Slider(
                                  min: 0,
                                  max: 5,
                                  divisions: 5,
                                  label: newRating?.toStringAsFixed(1),
                                  value: newRating ?? item.averageRating,
                                  onChanged: (value) {
                                    setState(() => newRating = value);
                                  },
                                ),
                                Text(
                                  'Note actuelle: ${newRating?.toStringAsFixed(1) ?? item.averageRating.toStringAsFixed(1)}',
                                ),
                              ],
                            );
                          },
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Annuler'),
                          ),
                          TextButton(
                            onPressed: () {
                              if (newRating != null) {
                                Provider.of<CategoryProvider>(context, listen: false)
                                    .addRating(item, newRating!);
                                Navigator.pop(context);
                              }
                            },
                            child: Text('Soumettre'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text('Noter'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Description:',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              item.description,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),

            if (item.author != null)
              _buildCreatorInfo('Auteur', item.author!),
            if (item.director != null)
              _buildCreatorInfo('Réalisateur', item.director!),
            if (item.actors != null && item.actors!.isNotEmpty)
              _buildCreatorInfo('Acteurs', item.actors!.join(', ')),
            if (item.team != null)
              _buildCreatorInfo('Équipes', item.team!),

            SizedBox(height: 24),
            Text(
              'Commentaires (${item.comments.length})',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ...item.comments.map((c) => Card(
                  margin: EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(child: Icon(Icons.person)),
                    title: Text(c),
                  ),
                )),
            SizedBox(height: 16),
            TextField(
              controller: commentController,
              decoration: InputDecoration(
                hintText: 'Écrire un commentaire...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
                  onPressed: () {
                    if (commentController.text.isNotEmpty) {
                      Provider.of<CategoryProvider>(context, listen: false)
                          .addComment(item, commentController.text);
                      commentController.clear();
                    }
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final TextEditingController _searchController = TextEditingController();
  int _currentIndex = 0;
  bool _showSearch = false;

  final List<Widget> _pages = [
    _MediaListPage(),
    _ToWatchPage(),
    _FavoritePage(),
    _HistoryPage(),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      endDrawer: _buildCategoryDrawer(),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(
              icon: Icon(Icons.watch_later), label: 'À regarder'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favoris'),
          BottomNavigationBarItem(
              icon: Icon(Icons.history), label: 'Historique'),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: _showSearch
          ? TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Rechercher...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.white70),
              ),
              style: TextStyle(color: Colors.white),
              onChanged: (q) =>
                  Provider.of<CategoryProvider>(context, listen: false)
                      .setSearchQuery(q),
            )
          : Text('Assistant de gestion des médias',
              style: TextStyle(fontWeight: FontWeight.bold)),
      elevation: 0,
      backgroundColor: Colors.blue,
      actions: [
        if (!_showSearch)
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => setState(() {
              _showSearch = true;
              _searchController.clear();
            }),
          ),
        IconButton(
          icon: Icon(Icons.filter_list),
          onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
        ),
      ],
    );
  }

  Widget _buildCategoryDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Catégories',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
          ...['Livre', 'Bd', 'Film', 'Serie', 'Sport'].map((category) => ListTile(
                leading: Icon(_getCategoryIcon(category), color: Colors.blue),
                title: Text(category, style: TextStyle(fontSize: 16)),
                onTap: () {
                  Provider.of<CategoryProvider>(context, listen: false)
                      .setCategory(category);
                  Navigator.pop(context);
                  setState(() => _showSearch = false);
                },
              )),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Livre':
        return Icons.book;
      case 'Bd':
        return Icons.photo_album;
      case 'Film':
        return Icons.movie;
      case 'Serie':
        return Icons.tv;
      case 'Sport':
        return Icons.sports;
      default:
        return Icons.category;
    }
  }
}

class _MediaListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CategoryProvider>(context);
    final items = provider.currentItems;

    return items.isEmpty
        ? Center(
            child: Text(
              'Aucun contenu correspondant trouvé',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          )
        : ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) =>
                _MediaItemTile(item: items[index]),
          );
  }
}

class _MediaItemTile extends StatelessWidget {
  const _MediaItemTile({Key? key, required this.item}) : super(key: key);
  final MediaItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: ValueKey(item.id),
      margin: const EdgeInsets.all(8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailPage(item: item),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 图片区域
              Hero(
                tag: item.coverUrl,
                child: Container(
                  width: 80,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: item.coverUrl,
                      fit: BoxFit.contain,
                      placeholder: (_, __) => Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.blue),
                        ),
                      ),
                      errorWidget: (_, __, ___) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.broken_image, 
                              size: 24, 
                              color: Colors.grey[400]),
                            Text('Échec du chargement',
                              style: TextStyle(fontSize: 10, color: Colors.grey[500]))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              // 文字信息区域
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        SizedBox(width: 4),
                        Text(
                          '${item.averageRating.toStringAsFixed(1)}/5',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    if (item.category != null)
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.category!,
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.blue,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FavoritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favorites = Provider.of<CategoryProvider>(context).favorites;

    return favorites.isEmpty
        ? Center(
            child: Text(
              'Aucun favori disponible',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          )
        : ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) =>
                _MediaItemTile(item: favorites[index]),
          );
  }
}

class _ToWatchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final toWatchItems =
        Provider.of<CategoryProvider>(context).toWatchItems;

    return toWatchItems.isEmpty
        ? Center(
            child: Text(
              'Aucun contenu à regarder',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          )
        : ListView.builder(
            itemCount: toWatchItems.length,
            itemBuilder: (context, index) =>
                _MediaItemTile(item: toWatchItems[index]),
          );
  }
}

class _HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final history =
        Provider.of<CategoryProvider>(context).viewHistory.reversed.toList();

    return history.isEmpty
        ? Center(
            child: Text(
              'Aucun historique de navigation',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          )
        : ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) =>
                _MediaItemTile(item: history[index]),
          );
  }
}