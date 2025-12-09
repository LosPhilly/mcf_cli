# Mission-Critical Feature Generator

[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)

A Mason brick that generates a **Vertical Feature Slice** compliant with the Mission-Critical Flutter (MCF) architecture.

> **Stop writing boilerplate. Start shipping logic.**

## 🏗 What it Generates

This brick creates the four essential layers for any new feature, strictly enforcing **Dependency Inversion** and **Safety**:

1.  **Domain Contract:** `i_{name}_repository.dart`
    * *Enforces Rule 2.2:* Pure abstract interface.
2.  **Data Implementation:** `{name}_repository_impl.dart`
    * *Enforces Rule 3.12:* Catches generic exceptions and throws Domain Failures.
3.  **Logic (Cubit):** `{name}_cubit.dart`
    * *Enforces Rule 6.6:* Includes **Async Reentrancy Guards** (`if (state is Loading) return;`) to prevent race conditions.
4.  **State (Union):** `{name}_state.dart`
    * *Enforces Rule 5.3:* Uses `sealed` classes for exhaustive switching.

## 📦 Usage

### 1. Run the Generator
Navigate to your project root and run:

```bash
mason make mcf_feature --name payment
2. Resulting Structure
It automatically creates:

Plaintext

lib/
├── domain/repositories/i_payment_repository.dart
├── data/repositories/payment_repository_impl.dart
└── presentation/cubit/
    ├── payment_cubit.dart
    └── payment_state.dart
📄 License
Copyright (c) 2025 Carlos Phillips / Mission-Critical Flutter. Licensed under the MIT License.


#### **3. `CHANGELOG.md`**
**Location:** `bricks/mcf_feature/CHANGELOG.md`

```markdown
# 1.0.0

- Initial release.
- Generates fully isolated Domain, Data, and Presentation layers.
- Auto-injects Reentrancy Guards into Cubits.