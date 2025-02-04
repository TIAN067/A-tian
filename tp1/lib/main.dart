import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CategoryProvider(),
      child: MaterialApp(
        title: 'Assistante de gestion de média',
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
  final String title;
  final String category;
  final String coverUrl;
  final double rating;
  final String description;
  bool isFavorite;
  bool isToWatch;
  List<double> userRatings;
  List<String> comments;

  MediaItem({
    required this.title,
    required this.category,
    required this.coverUrl,
    required this.rating,
    required this.description,
    this.isFavorite = false,
    this.isToWatch = false,
    this.userRatings = const [],
    this.comments = const [],
  });

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

  List<MediaItem> get favorites => _allItems.where((item) => item.isFavorite).toList();
  List<MediaItem> get toWatchItems => _allItems.where((item) => item.isToWatch).toList();

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
      MediaItem(
        title: '三体',
        category: 'Livre',
        coverUrl: 'https://example.com/book1.jpg',
        rating: 4.8,
        description: '科幻经典，描述人类与三体文明的接触...',
      ),
      MediaItem(
        title: '海贼王',
        category: 'Bd',
        coverUrl: 'https://example.com/comic1.jpg',
        rating: 4.9,
        description: '路飞与伙伴们的航海冒险故事...',
      ),
      MediaItem(
        title: '星际穿越',
        category: 'Film',
        coverUrl: 'https://example.com/movie1.jpg',
        rating: 4.7,
        description: '宇航员穿越虫洞寻找新家园的科幻史诗...',
      ),
      MediaItem(
        title: '黑镜',
        category: 'Serie',
        coverUrl: 'https://example.com/series1.jpg',
        rating: 4.5,
        description: '探讨现代科技对人性的影响的科幻剧集...',
      ),
      MediaItem(
        title: '世界杯2022',
        category: 'Sport',
        coverUrl: 'https://example.com/sport1.jpg',
        rating: 4.6,
        description: '卡塔尔世界杯精彩集锦...',
      ),
    ];
  }
}

class DetailPage extends StatelessWidget {
  final MediaItem item;

  const DetailPage({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CategoryProvider>(context, listen: false);
    final commentController = TextEditingController();
    double? newRating;

    provider.addToHistory(item);

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
            Hero(
              tag: item.coverUrl,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item.coverUrl,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(Icons.error, size: 50),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber),
                SizedBox(width: 8),
                Text('${item.averageRating.toStringAsFixed(1)}/5',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Spacer(),
                IconButton(
                  icon: Icon(
                    item.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: item.isFavorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: () => provider.toggleFavorite(item),
                ),
                IconButton(
                  icon: Icon(
                    item.isToWatch ? Icons.bookmark_added : Icons.bookmark_add,
                    color: item.isToWatch ? Colors.blue : Colors.grey,
                  ),
                  onPressed: () => provider.toggleToWatch(item),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('评分'),
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
                                Text('当前评分: ${newRating?.toStringAsFixed(1) ?? item.averageRating.toStringAsFixed(1)}'),
                              ],
                            );
                          },
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('取消'),
                          ),
                          TextButton(
                            onPressed: () {
                              if (newRating != null) {
                                provider.addRating(item, newRating!);
                                Navigator.pop(context);
                              }
                            },
                            child: Text('提交'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text('我要评分'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text('描述:', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(item.description, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            SizedBox(height: 24),
            Text('评论 (${item.comments.length})', 
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
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
                hintText: '写评论...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
                  onPressed: () {
                    if (commentController.text.isNotEmpty) {
                      provider.addComment(item, commentController.text);
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '主页'),
          BottomNavigationBarItem(icon: Icon(Icons.watch_later), label: '待看'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: '收藏'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: '历史'),
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
                hintText: '搜索...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.white70),
              ),
              style: TextStyle(color: Colors.white),
              onChanged: (q) => Provider.of<CategoryProvider>(context, listen: false)
                  .setSearchQuery(q),
            )
          : Text('媒体管理助手', style: TextStyle(fontWeight: FontWeight.bold)),
      elevation: 0,
      backgroundColor: Colors.blue,
      actions: [
        if (!_showSearch) IconButton(
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
            child: Text('分类', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
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
      case 'Livre': return Icons.book;
      case 'Bd': return Icons.photo_album;
      case 'Film': return Icons.movie;
      case 'Serie': return Icons.tv;
      case 'Sport': return Icons.sports;
      default: return Icons.category;
    }
  }
}

class _MediaListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CategoryProvider>(context);
    final items = provider.currentItems;

    return items.isEmpty
        ? Center(child: Text('没有找到相关内容', style: TextStyle(fontSize: 18, color: Colors.grey)))
        : ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) => _MediaItemTile(item: items[index]),
          );
  }
}

class _MediaItemTile extends StatelessWidget {
  final MediaItem item;

  const _MediaItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            item.coverUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Icon(Icons.broken_image, size: 40),
          ),
        ),
        title: Text(item.title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('评分: ${item.averageRating.toStringAsFixed(1)}', style: TextStyle(color: Colors.grey)),
        trailing: Icon(Icons.chevron_right, color: Colors.blue),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailPage(item: item)),
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
        ? Center(child: Text('暂无收藏内容', style: TextStyle(fontSize: 18, color: Colors.grey)))
        : ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) => _MediaItemTile(item: favorites[index]),
          );
  }
}

class _ToWatchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final toWatchItems = Provider.of<CategoryProvider>(context).toWatchItems;

    return toWatchItems.isEmpty
        ? Center(child: Text('暂无待看内容', style: TextStyle(fontSize: 18, color: Colors.grey)))
        : ListView.builder(
            itemCount: toWatchItems.length,
            itemBuilder: (context, index) => _MediaItemTile(item: toWatchItems[index]),
          );
  }
}

class _HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final history = Provider.of<CategoryProvider>(context).viewHistory.reversed.toList();
    
    return history.isEmpty
        ? Center(child: Text('暂无浏览历史', style: TextStyle(fontSize: 18, color: Colors.grey)))
        : ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) => _MediaItemTile(item: history[index]),
          );
  }
}