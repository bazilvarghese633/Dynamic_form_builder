# Dynamic Form Builder 📋
> *A Flutter app for building, submitting, and managing dynamic forms — powered by Firebase and clean architecture.*

---

## What is Dynamic Form Builder?

Dynamic Form Builder is a Flutter application that renders forms dynamically from a JSON configuration. Users can fill in multi-section forms with various input types, save submissions to Firebase, and manage entries with full edit and delete support — all with a clean and intuitive UI.

---

## ✨ Features

| Feature | Description |
|---|---|
| 📄 **Dynamic Forms** | Forms rendered at runtime from local JSON configuration |
| 🗂️ **Multi-tab Layout** | Main tabs and pill-style section tabs for organized navigation |
| 🔤 **Rich Input Types** | Text, multiline, dropdown, date picker, radio, and checkbox |
| 💾 **Firebase Sync** | Submissions saved and synced in real-time via Firestore |
| ✏️ **Edit Entries** | Edit existing submissions using the same form screen |
| 🗑️ **Delete Entries** | Delete submissions with a confirmation dialog |
| 📋 **Submissions List** | View all saved entries per section with expandable answer cards |
| 📅 **Date Formatting** | Dates displayed in readable format (e.g. 15 March 2025) |

---

## 🛠️ Tech Stack

```
Flutter          →  Cross-platform mobile framework
BLoC             →  State management
Firebase         →  Firestore for real-time data storage
Clean Architecture →  Domain, Data, Presentation layers
JSON             →  Local form schema configuration
Material 3       →  UI design system
```

---

## 📦 Dependencies

```yaml
flutter_bloc: ^9.1.1
cloud_firestore: ^5.6.8
firebase_core: ^3.13.1
```

---

## 📁 Project Structure

```
lib/
├── core/
│   ├── color.dart                  # App color constants
│   └── utils/
│       └── answer_formatter.dart   # Date and answer formatting
│
├── features/
│   ├── data/
│   │   ├── datasource/
│   │   │   ├── firestore_service.dart        # Firestore CRUD operations
│   │   │   └── form_local_datasource.dart    # JSON form loader
│   │   ├── models/
│   │   │   └── form_model.dart               # JSON deserialization models
│   │   └── repositories/
│   │       └── form_repository_impl.dart
│   │
│   ├── domain/
│   │   ├── entities/
│   │   │   └── form_entity.dart              # Core data models
│   │   ├── repositories/
│   │   │   └── form_repository.dart
│   │   └── usecases/
│   │       ├── get_form_data.dart
│   │       ├── save_form_data.dart
│   │       ├── update_submission.dart
│   │       └── delete_submission.dart
│   │
│   └── presentation/
│       ├── bloc/                             # FormBloc, events, states
│       ├── screen/
│       │   ├── form_screen.dart              # Root screen
│       │   └── add_screen/
│       │       ├── add_entry_screen.dart     # Add / Edit form screen
│       │       └── widget/
│       │           ├── question_card.dart
│       │           └── section_header.dart
│       ├── utils/
│       │   └── app_snackbar.dart
│       └── widgets/
│           ├── main_tab.dart
│           ├── sub_tab.dart
│           ├── pill_tab.dart
│           ├── section_page.dart
│           ├── question/                     # Input type widgets
│           │   ├── question_widget.dart
│           │   ├── styled_dropdown.dart
│           │   ├── styled_text_field.dart
│           │   ├── styled_date_picker.dart
│           │   ├── styled_checkbox.dart
│           │   ├── styled_radio.dart
│           │   ├── selectable_row.dart
│           │   └── input_decoration.dart
│           └── submission/                   # Submission list widgets
│               ├── saved_submissions_widget.dart
│               ├── submission_card.dart
│               ├── answer_row.dart
│               ├── empty_state.dart
│               ├── icon_btn.dart
│               └── delete_dialog.dart
│
├── assets/
│   └── sample.json                           # Form schema definition
│
└── main.dart
```

---

<p align="center">Made with ❤️ using Flutter</p>