import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../config/constants.dart';

/// Database Service - Singleton
/// Manages SQLite database operations
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  /// Get database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize database
  Future<Database> _initDatabase() async {
    try {
      final databasesPath = await getDatabasesPath();
      final path = join(databasesPath, AppConstants.databaseName);

      debugPrint('📁 Initializing database at: $path');

      return await openDatabase(
        path,
        version: AppConstants.databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        onOpen: (db) {
          debugPrint('✅ Database opened successfully');
        },
      );
    } catch (e) {
      debugPrint('❌ Error initializing database: $e');
      rethrow;
    }
  }

  /// Create database tables
  Future<void> _onCreate(Database db, int version) async {
    debugPrint('🔨 Creating database tables...');

    // Create user_products table
    await db.execute('''
      CREATE TABLE ${AppConstants.tableUserProducts} (
        id TEXT PRIMARY KEY,
        product_template_id TEXT,
        name TEXT NOT NULL,
        name_en TEXT,
        category TEXT NOT NULL,
        quantity REAL NOT NULL,
        unit TEXT NOT NULL,
        purchase_date TEXT NOT NULL,
        expiry_date TEXT NOT NULL,
        notes TEXT,
        location TEXT,
        image_path TEXT,
        status TEXT NOT NULL DEFAULT 'active',
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Create indexes for user_products
    await db.execute('''
      CREATE INDEX idx_user_products_expiry
      ON ${AppConstants.tableUserProducts}(expiry_date)
    ''');

    await db.execute('''
      CREATE INDEX idx_user_products_category
      ON ${AppConstants.tableUserProducts}(category)
    ''');

    await db.execute('''
      CREATE INDEX idx_user_products_status
      ON ${AppConstants.tableUserProducts}(status)
    ''');

    // Create product_templates table
    await db.execute('''
      CREATE TABLE ${AppConstants.tableProductTemplates} (
        id TEXT PRIMARY KEY,
        name_vi TEXT NOT NULL,
        name_en TEXT NOT NULL,
        aliases TEXT,
        category TEXT NOT NULL,
        shelf_life_refrigerated INTEGER,
        shelf_life_frozen INTEGER,
        shelf_life_pantry INTEGER,
        shelf_life_opened INTEGER,
        nutrition_data TEXT,
        health_benefits TEXT,
        health_warnings TEXT,
        storage_tips TEXT,
        image_url TEXT
      )
    ''');

    // Create indexes for faster LIKE search
    await db.execute('''
      CREATE INDEX idx_product_templates_name_vi
      ON ${AppConstants.tableProductTemplates}(name_vi)
    ''');

    await db.execute('''
      CREATE INDEX idx_product_templates_name_en
      ON ${AppConstants.tableProductTemplates}(name_en)
    ''');

    await db.execute('''
      CREATE INDEX idx_product_templates_category
      ON ${AppConstants.tableProductTemplates}(category)
    ''');

    debugPrint('✅ Product templates table and indexes created successfully');

    // Create custom_product_templates table
    await db.execute('''
      CREATE TABLE ${AppConstants.tableCustomTemplates} (
        id TEXT PRIMARY KEY,
        name_vi TEXT NOT NULL,
        name_en TEXT NOT NULL,
        aliases TEXT,
        category TEXT NOT NULL,
        shelf_life_refrigerated INTEGER,
        shelf_life_frozen INTEGER,
        shelf_life_pantry INTEGER,
        shelf_life_opened INTEGER,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Create indexes for custom templates
    await db.execute('''
      CREATE INDEX idx_custom_templates_name_vi
      ON ${AppConstants.tableCustomTemplates}(name_vi)
    ''');

    await db.execute('''
      CREATE INDEX idx_custom_templates_name_en
      ON ${AppConstants.tableCustomTemplates}(name_en)
    ''');

    debugPrint('✅ Custom templates table and indexes created successfully');

    // Create categories table
    await db.execute('''
      CREATE TABLE ${AppConstants.tableCategories} (
        id TEXT PRIMARY KEY,
        name_vi TEXT NOT NULL,
        name_en TEXT NOT NULL,
        icon TEXT NOT NULL,
        color TEXT NOT NULL,
        sort_order INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Create notifications table
    await db.execute('''
      CREATE TABLE ${AppConstants.tableNotifications} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id TEXT NOT NULL,
        notification_id INTEGER NOT NULL,
        scheduled_date TEXT NOT NULL,
        days_before INTEGER NOT NULL,
        is_sent INTEGER NOT NULL DEFAULT 0,
        sent_at TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    // Create settings table
    await db.execute('''
      CREATE TABLE ${AppConstants.tableSettings} (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    debugPrint('✅ All tables created successfully');

    // Load initial data
    await _loadInitialData(db);
  }

  /// Upgrade database schema
  Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    debugPrint('⬆️ Upgrading database from v$oldVersion to v$newVersion');

    // Handle version upgrades here
    if (oldVersion < 2) {
      // Add location column to user_products
      await db.execute(
        'ALTER TABLE ${AppConstants.tableUserProducts} ADD COLUMN location TEXT'
      );
      debugPrint('✅ Added location column to user_products');
    }

    if (oldVersion < 3) {
      // Reload product templates with expanded database (110 -> 1000 products)
      debugPrint('🔄 Reloading product templates for v3...');

      // Clear existing templates
      await db.delete(AppConstants.tableProductTemplates);
      debugPrint('🗑️ Cleared old product templates');

      // Reload from JSON file
      await _loadProductTemplates(db);
      debugPrint('✅ Product templates reloaded with 1000 items');
    }

    if (oldVersion < 4) {
      // Remove FTS5 and add indexes for LIKE search optimization
      debugPrint('🔄 Upgrading to v4: Removing FTS5, adding indexes...');

      // Drop FTS5 table if it exists (ignore errors if doesn't exist)
      try {
        await db.execute('DROP TABLE IF EXISTS product_search');
        debugPrint('🗑️ Removed FTS5 table');
      } catch (e) {
        debugPrint('⚠️ FTS5 table does not exist or already removed: $e');
      }

      // Create indexes for faster LIKE search (ignore if already exists)
      try {
        await db.execute('''
          CREATE INDEX IF NOT EXISTS idx_product_templates_name_vi
          ON ${AppConstants.tableProductTemplates}(name_vi)
        ''');

        await db.execute('''
          CREATE INDEX IF NOT EXISTS idx_product_templates_name_en
          ON ${AppConstants.tableProductTemplates}(name_en)
        ''');

        await db.execute('''
          CREATE INDEX IF NOT EXISTS idx_product_templates_category
          ON ${AppConstants.tableProductTemplates}(category)
        ''');

        debugPrint('✅ Search indexes created successfully');
      } catch (e) {
        debugPrint('⚠️ Error creating indexes (may already exist): $e');
      }
    }

    if (oldVersion < 5) {
      // Reload product templates with deduplicated data (1000 -> 89 unique products)
      debugPrint('🔄 Upgrading to v5: Reloading with deduplicated data...');

      // Clear existing templates
      await db.delete(AppConstants.tableProductTemplates);
      debugPrint('🗑️ Cleared old product templates');

      // Reload from JSON file with deduplicated data
      await _loadProductTemplates(db);
      debugPrint('✅ Product templates reloaded with unique products only');
    }

    if (oldVersion < 6) {
      // Reload with expanded database (89 -> 122 products)
      debugPrint('🔄 Upgrading to v6: Expanding database with Vietnamese staples...');

      // Clear existing templates
      await db.delete(AppConstants.tableProductTemplates);
      debugPrint('🗑️ Cleared old product templates');

      // Reload from JSON file with expanded data
      await _loadProductTemplates(db);
      debugPrint('✅ Product templates expanded: now 122 Vietnamese products');
    }

    if (oldVersion < 7) {
      // Massive expansion: 100+ fruits, complete Vietnamese meat cuts
      debugPrint('🔄 Upgrading to v7: MASSIVE EXPANSION...');

      // Clear existing templates
      await db.delete(AppConstants.tableProductTemplates);
      debugPrint('🗑️ Cleared old product templates');

      // Reload from JSON file with massive expansion
      await _loadProductTemplates(db);
      debugPrint('✅ Massive expansion completed: 251 products total');
      debugPrint('   - Fruits: 108+ products');
      debugPrint('   - Meat: 70 complete Vietnamese cuts');
    }

    if (oldVersion < 8) {
      // Add pantry shelf life support and custom templates
      debugPrint('🔄 Upgrading to v8: Adding pantry support and custom templates...');

      // Add pantry shelf life column to product_templates
      try {
        await db.execute(
          'ALTER TABLE ${AppConstants.tableProductTemplates} ADD COLUMN shelf_life_pantry INTEGER'
        );
        debugPrint('✅ Added shelf_life_pantry column to product_templates');
      } catch (e) {
        debugPrint('⚠️ Error adding shelf_life_pantry column (may already exist): $e');
      }

      // Create custom_product_templates table
      try {
        await db.execute('''
          CREATE TABLE ${AppConstants.tableCustomTemplates} (
            id TEXT PRIMARY KEY,
            name_vi TEXT NOT NULL,
            name_en TEXT NOT NULL,
            aliases TEXT,
            category TEXT NOT NULL,
            shelf_life_refrigerated INTEGER,
            shelf_life_frozen INTEGER,
            shelf_life_pantry INTEGER,
            shelf_life_opened INTEGER,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL
          )
        ''');
        debugPrint('✅ Created custom_product_templates table');

        // Create indexes for custom templates
        await db.execute('''
          CREATE INDEX idx_custom_templates_name_vi
          ON ${AppConstants.tableCustomTemplates}(name_vi)
        ''');

        await db.execute('''
          CREATE INDEX idx_custom_templates_name_en
          ON ${AppConstants.tableCustomTemplates}(name_en)
        ''');

        debugPrint('✅ Created indexes for custom templates');
      } catch (e) {
        debugPrint('⚠️ Error creating custom templates table: $e');
      }

      debugPrint('✅ v8 upgrade completed: Pantry support and custom templates ready');
    }
  }

  /// Load initial data
  Future<void> _loadInitialData(Database db) async {
    debugPrint('📥 Loading initial data...');

    try {
      // Insert default categories
      await _insertDefaultCategories(db);

      // Load product templates from JSON file
      await _loadProductTemplates(db);

      debugPrint('✅ Initial data loaded successfully');
    } catch (e) {
      debugPrint('⚠️ Error loading initial data: $e');
    }
  }

  /// Load product templates from JSON file
  Future<void> _loadProductTemplates(Database db) async {
    try {
      debugPrint('📦 Loading product templates from JSON...');

      // Load JSON file from assets
      final jsonString = await rootBundle.loadString('assets/data/products_sample.json');
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;

      final products = jsonData['products'] as List<dynamic>;
      debugPrint('📊 Found ${products.length} product templates');

      // Insert into database in batch for better performance
      final batch = db.batch();

      for (final productData in products) {
        final Map<String, dynamic> data = {
          'id': productData['id'],
          'name_vi': productData['name_vi'],
          'name_en': productData['name_en'],
          'aliases': json.encode(productData['aliases']),
          'category': productData['category'],
          'shelf_life_refrigerated': productData['shelf_life_refrigerated'],
          'shelf_life_frozen': productData['shelf_life_frozen'],
          'shelf_life_pantry': productData['shelf_life_pantry'],
          'shelf_life_opened': productData['shelf_life_opened'],
          'nutrition_data': productData['nutrition_data'] != null
              ? json.encode(productData['nutrition_data'])
              : null,
          'health_benefits': productData['health_benefits'] != null
              ? json.encode(productData['health_benefits'])
              : null,
          'health_warnings': productData['health_warnings'] != null
              ? json.encode(productData['health_warnings'])
              : null,
          'storage_tips': productData['storage_tips'],
          'image_url': productData['image_url'],
        };

        batch.insert(
          AppConstants.tableProductTemplates,
          data,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit(noResult: true);
      debugPrint('✅ Product templates loaded successfully');
    } catch (e) {
      debugPrint('⚠️ Error loading product templates: $e');
      // Don't throw - app can still work without templates
    }
  }

  /// Insert default categories
  Future<void> _insertDefaultCategories(Database db) async {
    final categories = [
      {
        'id': 'vegetables',
        'name_vi': 'Rau củ quả',
        'name_en': 'Vegetables',
        'icon': '🥬',
        'color': '#4CAF50',
        'sort_order': 1,
      },
      {
        'id': 'fruits',
        'name_vi': 'Trái cây',
        'name_en': 'Fruits',
        'icon': '🍎',
        'color': '#FF9800',
        'sort_order': 2,
      },
      {
        'id': 'meat',
        'name_vi': 'Thịt',
        'name_en': 'Meat',
        'icon': '🥩',
        'color': '#F44336',
        'sort_order': 3,
      },
      {
        'id': 'eggs',
        'name_vi': 'Trứng',
        'name_en': 'Eggs',
        'icon': '🥚',
        'color': '#FFE082',
        'sort_order': 4,
      },
      {
        'id': 'dairy',
        'name_vi': 'Sữa & chế phẩm',
        'name_en': 'Dairy',
        'icon': '🥛',
        'color': '#2196F3',
        'sort_order': 5,
      },
      {
        'id': 'dry_food',
        'name_vi': 'Đồ khô',
        'name_en': 'Dry Food',
        'icon': '🍞',
        'color': '#795548',
        'sort_order': 6,
      },
      {
        'id': 'frozen',
        'name_vi': 'Đồ đông lạnh',
        'name_en': 'Frozen',
        'icon': '🧊',
        'color': '#00BCD4',
        'sort_order': 7,
      },
      {
        'id': 'condiments',
        'name_vi': 'Gia vị',
        'name_en': 'Condiments',
        'icon': '🧂',
        'color': '#9E9E9E',
        'sort_order': 8,
      },
      {
        'id': 'other',
        'name_vi': 'Khác',
        'name_en': 'Other',
        'icon': '📦',
        'color': '#607D8B',
        'sort_order': 9,
      },
    ];

    final batch = db.batch();
    for (final category in categories) {
      batch.insert(
        AppConstants.tableCategories,
        category,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  /// Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
    debugPrint('🔒 Database closed');
  }

  /// Delete database (for testing/reset)
  Future<void> deleteDatabase() async {
    try {
      final databasesPath = await getDatabasesPath();
      final path = join(databasesPath, AppConstants.databaseName);
      await databaseFactory.deleteDatabase(path);
      _database = null;
      debugPrint('🗑️ Database deleted');
    } catch (e) {
      debugPrint('❌ Error deleting database: $e');
      rethrow;
    }
  }
}
