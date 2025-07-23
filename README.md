# Flutter COCO Dataset

A Flutter application that provides an interactive interface to explore the Microsoft COCO (Common Objects in Context) dataset. The app allows users to browse categories, search for images, view segmentation masks, and read image captions.

## 🌟 Features

### Core Functionality

- **Category Browser**: Explore 80+ COCO categories organized by supercategories
- **Image Search**: Search images by selecting one or multiple categories
- **Segmentation Visualization**: View object segmentation masks overlaid on images
- **Caption Display**: Read AI-generated captions for each image
- **Pagination**: Efficient loading of large datasets with pagination support
- **Image Sharing**: Share images directly from the app
- **URL Navigation**: Open image URLs in external browsers

### Technical Features

- **Clean Architecture**: Domain-driven design with clear separation of concerns
- **State Management**: BLoC pattern implementation for predictable state management
- **Responsive Design**: Screen utility for adaptive layouts across devices
- **Network Caching**: Cached network images for improved performance
- **Error Handling**: Comprehensive error handling and logging
- **Portrait Mode**: Optimized for portrait orientation

## 🏗️ Architecture

The project follows Clean Architecture principles with the following layers:

```
lib/
├── app.dart                    # App configuration
├── main.dart                   # Entry point
├── cubits/                     # State management
│   └── coco/
├── features/                   # Feature modules
│   ├── data/                   # Data layer
│   │   ├── data_sources/       # Local & remote data sources
│   │   ├── models/             # Data models
│   │   └── repositories/       # Repository implementations
│   └── domain/                 # Domain layer
│       ├── entities/           # Domain entities
│       └── repositories/       # Repository interfaces
├── presentation/               # Presentation layer
│   ├── screens/                # UI screens
│   └── widgets/                # Reusable widgets
└── utils/                      # Utilities
    ├── app/                    # App constants & logger
    ├── enum/                   # Enumerations
    ├── extension/              # Extensions
    └── helper/                 # Helper classes
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.32.4) - **Tested with Flutter 3.32.4 • channel stable**
- Dart SDK (>=3.8.1) - **Tested with Dart SDK version: 3.8.1 (stable)**
- iOS/Android development environment

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/NijatNaghiyev/flutter_coco_dataset.git
   cd flutter_coco_dataset
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the application**

   ```bash
   flutter run
   ```

## 📱 Usage

### Basic Navigation

1. **Browse Categories**: The home screen displays all available COCO categories
2. **Select Categories**: Tap on categories to add them to your search filter
3. **Search Images**: After selecting categories, images matching those categories will load
4. **View Details**: Tap on any image to see segmentation masks and captions
5. **Pagination**: Scroll down to load more images automatically

### Features in Detail

#### Category Selection

- Categories are grouped by supercategories (Person, Vehicle, Animal, etc.)
- Multiple categories can be selected for combined searches
- Selected categories appear in a horizontal list for easy removal

#### Image Visualization

- Images load with their original aspect ratios
- Segmentation masks are overlaid in different colors
- Toggle segmentation visibility by tapping category chips
- Share functionality for each image

#### Data Loading

- Implements pagination for efficient memory usage
- Loading states provide user feedback
- Error handling with retry mechanisms

## 🛠️ Technologies Used

### Core Framework

- **Flutter**: Cross-platform mobile development framework
- **Dart**: Programming language

### State Management

- **flutter_bloc**: Business Logic Component pattern implementation
- **equatable**: Value equality for Dart classes

### Networking & Data

- **dio**: HTTP client for API requests
- **cached_network_image**: Image caching and loading
- **pretty_dio_logger**: Network request logging

### UI & UX

- **flutter_screenutil**: Responsive design utilities
- **cupertino_icons**: iOS-style icons

### Utilities

- **logger**: Logging utility
- **share_plus**: Native sharing functionality
- **url_launcher**: URL launching capabilities

### Development Tools

- **flutter_lints**: Flutter linting rules
- **very_good_analysis**: Additional static analysis rules

## 🏃‍♂️ API Integration

The app integrates with the COCO Dataset BigQuery API:

**Base URL**: `https://us-central1-open-images-dataset.cloudfunctions.net/coco-dataset-bigquery`

### Endpoints Used

- **Category Search**: Get image IDs by category IDs
- **Image Metadata**: Fetch image URLs and metadata
- **Segmentation Data**: Retrieve object instance segmentation masks
- **Captions**: Get image captions

### Query Types

- `getImagesByCats`: Search images by category
- `getImages`: Fetch image metadata
- `getInstances`: Get segmentation instances
- `getCaptions`: Retrieve image captions

## 📊 Data Models

### Core Models

- **CatsModel**: Category information with icons
- **ImagesModel**: Image metadata and URLs
- **InstanceEntity**: Segmentation polygon data
- **CaptionsModel**: Image caption text

### Features

- JSON serialization/deserialization
- Equatable implementation for value comparison
- Null safety throughout

## 🎨 UI Components

### Custom Widgets

- **DataSetItem**: Individual image display with segmentation
- **SegmentationPainter**: Custom painter for drawing polygons
- **CategoriesListView**: Category browser interface
- **SelectedCategoriesList**: Selected categories display

### Design Patterns

- **Mixins**: Reusable functionality for widgets
- **Custom Painters**: For drawing segmentation masks
- **Responsive Design**: Adaptive layouts for different screen sizes

## 🔧 Configuration

### App Configuration

- **Portrait-only orientation**
- **Material Design 3** with teal color scheme
- **Screen dimensions**: Optimized for 430x932 design size

### Build Configuration

- **Minimum SDK**: Configured for modern Flutter versions
- **Analysis**: Very Good Analysis for code quality
- **Assets**: Includes local JSON data for categories

## 🚀 Performance Optimizations

- **Image Caching**: Automatic caching of network images
- **Pagination**: Load data in chunks to reduce memory usage
- **State Persistence**: UI images cached in app state
- **Isolate Processing**: JSON parsing in isolates for heavy data
- **Lazy Loading**: Load segmentation data on demand

## 🧪 Code Quality

### Standards

- **Very Good Analysis**: Strict linting rules
- **Clean Architecture**: Separation of concerns
- **Error Handling**: Comprehensive error management
- **Logging**: Detailed logging for debugging

### Best Practices

- **Null Safety**: Full null safety implementation
- **Immutable State**: Using Equatable for state classes
- **Dependency Injection**: Repository pattern implementation
- **Type Safety**: Strong typing throughout

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is available under the MIT License. See the LICENSE file for more details.

## 👨‍💻 Author

**Nijat Naghiyev**

- GitHub: [@NijatNaghiyev](https://github.com/NijatNaghiyev)

## 🙏 Acknowledgments

- **Microsoft COCO Dataset**: For providing the comprehensive dataset
- **Flutter Team**: For the amazing framework
- **Open Source Community**: For the packages used in this project

---

*Built with ❤️ using Flutter*
