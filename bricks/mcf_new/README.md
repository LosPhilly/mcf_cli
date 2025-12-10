# Mission-Critical Flutter Scaffold

[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)

> **A High-Integrity Flutter application scaffold built with rigor, reliability, and strict engineering standards derived from the Joint Strike Fighter (JSF) C++ Coding Standards.**

![Mission Critical Flutter Banner](https://github.com/LosPhilly/mission-critical-flutter/blob/main/assets/images/mcfBookCoverTallBycphil.png?raw=true)

---

## 📖 Overview

This Mason brick generates the reference implementation for the **Mission-Critical Flutter (MCF)** methodology. It scaffolds a safety-critical mobile application structure where failure is not an option.

Unlike standard Flutter templates, this project prioritizes **determinism**, **type safety**, and **architectural isolation** over development speed. It enforces a strict subset of the Dart language to eliminate entire classes of runtime errors (e.g., `TypeError`, `NullPointer`, `RaceCondition`).

### **Core Philosophy**
1.  **Architecture:** Strict separation of concerns (Presentation, Domain, Data).
2.  **Safety:** Zero tolerance for `dynamic` types or implicit casting.
3.  **State:** Unidirectional, immutable, and exhaustive state machines.
4.  **Verification:** 100% logic coverage and pixel-perfect Golden tests.

---

## 📦 Installation & Usage

### 1. Install Mason
```bash
dart pub global activate mason_cli
2. Add the BrickBashmason add mcf_new
3. Generate Your ProjectBashmason make mcf_new
🧱 Brick VariablesVariableDescriptionDefaultproject_nameThe name of your project (snake_case recommended)my_apporg_nameThe organization domain (reverse notation)com.example🏗 Generated ArchitectureThe generated project follows a rigorous Clean Architecture pattern with a strict Composition Root.Plaintextlib/
├── domain/            # PURE LOGIC (No Flutter, No JSON, No DB)
│   ├── entities/      # Core business objects (User, Address)
│   ├── failures/      # Domain-specific failure definitions
│   └── repositories/  # Abstract Interfaces (Contracts)
│
├── data/              # INFRASTRUCTURE (Dirty Layer)
│   ├── models/        # DTOs that parse JSON -> Entities
│   └── repositories/  # Concrete implementations (Http, Hive)
│
├── presentation/      # UI & STATE (Flutter)
│   ├── cubit/         # State Containers (Blinds Logic from UI)
│   └── screens/       # Stateless Widgets & Decomposed UI
│
└── main.dart          # COMPOSITION ROOT (Dependency Injection)
Key Constraint: The Presentation Layer never imports the Data Layer. All communication occurs via Domain Interfaces.🛡️ MCF Compliance ChecklistThis scaffold pre-configures your project to adhere to the Mission-Critical Audit:[x] MCF 2.2: Strict Layer Isolation (Dependency Inversion Enforced).[x] MCF 3.1: Strict Analysis Options (strict-casts, strict-inference).[x] MCF 3.4: No usage of the bang operator (!).[x] MCF 4.1: UI components are StatelessWidget by default.[x] MCF 5.1: Unidirectional Data Flow via Cubits.[x] MCF 6.5: Heavy JSON parsing offloaded to Isolates via compute().[x] MCF 6.6: Reentrancy guards preventing race conditions on async actions.[x] MCF 7.5: Critical UI components verified via Golden Tests.🧪 Verification & Testing StrategyThe generated project uses a "Testing Pyramid" strategy.Unit Tests (Logic)Verifies 100% of business logic branches (Cubits & Repositories).Bashflutter test test/presentation/cubit/user_cubit_test.dart
Widget Tests (Behavior)Verifies the wiring between the UI and the State Management.Bashflutter test test/presentation/screens/profile_screen_test.dart
Golden Tests (Visual Regression)Verifies pixel-perfect rendering of critical displays.Bashflutter test test/presentation/screens/profile_screen_golden_test.dart
🔧 Technical StackFramework: FlutterLanguage: Dart (Strict Mode)State Management: flutter_blocEquality: equatableNetworking: httpTesting: mocktail, bloc_testLinting: very_good_analysis (Customized)📄 LicenseThis project is licensed under the MIT License - see the LICENSE file for details."The difference between a prototype and a product is not features; it is predictability."✍️ CitationIf you use this architecture in your projects or research, please credit the original work:Phillips, Carlos. (2025). Mission-Critical Flutter: Building High-Integrity Applications.