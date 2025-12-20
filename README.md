# 🎒 Bags Classification App (IT 120 Final Project)

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![TFLite](https://img.shields.io/badge/TFLite-FF6F00?style=for-the-badge&logo=tensorflow&logoColor=white)](https://www.tensorflow.org/lite)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com/)

A professional Flutter-based mobile application that uses **Machine Learning (TensorFlow Lite)** to classify different types of bags in real-time. This project was developed as a final requirement for **IT 120**.

---

## 📸 Project Showcase

### Application UI
| Landing Screen | Classification | Analysis |
| :---: | :---: | :---: |
| <img src="output/screenshots/Output 1.png" width="200"> | <img src="output/screenshots/Output 5.png" width="200"> | <img src="output/screenshots/Output 9.png" width="200"> |

### Model Performance
- **Accuracy per Class:** View the [Graph](output/results/Accuracy%20Per%20Class.png)
- **Training Results:** View [Accuracy per Epoch](output/results/Accuracy%20Per%20Epoch.png) and [Loss per Epoch](output/results/Loss%20Per%20Epoch.png)

---

## 🚀 Key Features

- **Real-time Image Classification:** Identifies multiple bag types using the device camera.
- **TFLite Integration:** Local inference for fast and efficient classification.
- **Firebase Backend:** Seamless integration with FireStore for data management.
- **Responsive UI:** Modern design built with Flutter.

---

## 📂 Repository Structure

- `app/lib/`: Core Flutter source code (Screens, Services, Models).
- `assets/model/`: Pre-trained TFLite model and labels.
- `docs/`: Technical documentation and database rules.
- `output/screenshots/`: Visual overview of the application.
- `output/results/`: Performance metrics and training graphs.

---

## 🛠️ Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Firebase account](https://console.firebase.google.com/)
- Android Studio / VS Code

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/[Your-Username]/bags-classification-app.git
   ```
2. Navigate to the project directory:
   ```bash
   cd Cabilogan_Bags_Classification_FinalProject
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the application:
   ```bash
   flutter run
   ```

---

## ⚖️ Database Configuration
The app uses **Firebase Cloud Firestore** and **Real-time Database**. Security rules and structure snapshots can be found in the `docs/images/` folder.

---

**Cabilogan - Final Project for IT 120**
