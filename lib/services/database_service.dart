import 'dart:async';
import 'package:flutter/foundation.dart';
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
        shelf_life_opened INTEGER,
        nutrition_data TEXT,
        health_benefits TEXT,
        health_warnings TEXT,
        storage_tips TEXT,
        image_url TEXT
      )
    ''');

    // Create FTS5 virtual table for product search
    await db.execute('''
      CREATE VIRTUAL TABLE product_search USING fts5(
        product_id UNINDEXED,
        name_vi,
        name_en,
        aliases,
        category UNINDEXED
      )
    ''');

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
  }

  /// Load initial data
  Future<void> _loadInitialData(Database db) async {
    debugPrint('📥 Loading initial data...');

    try {
      // Insert default categories
      await _insertDefaultCategories(db);

      // TODO: Load product templates from JSON file
      // final productsData = await rootBundle.loadString(
      //   AppConstants.productsDataFile,
      // );
      // await _insertProductTemplates(db, productsData);

      debugPrint('✅ Initial data loaded successfully');
    } catch (e) {
      debugPrint('⚠️ Error loading initial data: $e');
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
