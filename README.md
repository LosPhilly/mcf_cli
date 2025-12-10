# Mission-Critical Flutter CLI (MCF)

[![Pub Version](https://img.shields.io/pub/v/mcf_cli?color=blue)](https://pub.dev/packages/mcf_cli)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)

**Forensic-grade engineering for high-stakes mobile applications.**

---

## 💭 Synopsis

In the world of mobile development, "move fast and break things" is often the default setting. For social apps or prototypes, this is fine. But in **Mission-Critical** environments—FinTech, MedTech, Aerospace, and Enterprise—failure is not an option.

Standard Flutter tooling prioritizes development speed and flexibility. However, flexibility is the enemy of reliability. It leaves the door open for architectural drift, circular dependencies, and unhandled runtime states.

**☝️ This is a liability problem.**

The **Mission-Critical Flutter CLI (MCF)** is the enforcement arm of the Mission-Critical methodology. It generates applications that are **correct by construction**, enforcing rigorous architectural isolation and type safety from the very first line of code.

## 🧠 The Philosophy: Paternalistic Architecture

**mcf_cli** is intentionally strict. Drawing inspiration from the Joint Strike Fighter (JSF) C++ Coding Standards, it operates on the principle that the architecture should physically prevent developers from making mistakes.

While clean architecture guidelines exist, they rely on developer discipline. A developer *can* import a Repository into a Widget, or forget to handle a loading state, or use the `!` operator because they are in a rush.

**mcf_cli** takes a paternalistic stance. It generates code where:
1.  **Isolation is physical:** The directory structure makes illegal imports obvious.
2.  **Safety is mandatory:** Linter rules prevent `dynamic` types and implicit casts.
3.  **State is exhaustive:** You cannot add a UI state without handling it.

The goal is to shift the burden of safety from *developer memory* to *tooling enforcement*.

## 🚀 Getting Started

### 1. Install the CLI
```bash
dart pub global activate mcf_cli
```

### 2. Create a Project  
Scaffold a complete forensic-grade application skeleton.
```bash
mcf new my_secure_app
```

### 3. Generate a Feature  
Create a vertical slice (Domain, Data, Presentation) with 100% test coverage.
```bash
cd my_secure_app
mcf feature --name authentication
```

### 4. Audit Compliance
Run the deep-inspection tool to verify architectural integrity.
```bash
mcf audit
```

## ✨ Core Features & Design

### **Forensic Scaffolding**
`mcf new` doesn't just create folders; it sets up a Composition Root, installs very_good_analysis with custom strict overrides, and configures a Golden Test harness.

### **Vertical Slicing Generator**
`mcf feature` generates the "Muscle" of your app. It creates the Entity, Repository (Interface & Implementation), Cubit, and State simultaneously. It automatically injects Reentrancy Guards into your logic to prevent race conditions.

### **The Compliance Engine**
`mcf audit` is your CI/CD gatekeeper. It scans your codebase for violations of the MCF rules (e.g., Domain layer importing Flutter, usage of the `!` operator, missing copyright headers) and fails the build if your architecture has drifted.

### **Golden Test Enforcement**
The generated structure mandates Visual Regression Testing for all critical UI components, ensuring that pixel-perfect rendering is locked in over time.

---

## ☝️ When to Use / Not Use

### **Use it for:**

✅ FinTech & Banking  
✅ MedTech & Healthcare  
✅ Enterprise & Government  
✅ Large Teams  

### **Do NOT use it for:**

❌ Hackathons  
❌ Simple MVP Prototypes  
❌ Solo Hobby Projects  

---

## 🪨 The Architecture: Rule by Rule

### **1. Strict Layering (Rule 2.2)**  
- **Domain:** Pure logic. No Flutter, JSON, DB.  
- **Data:** Networking, DTOs, storage.  
- **Presentation:** UI only. No logic.  
✔ Constraint: Presentation **never** imports Data.

### **2. Zero Tolerance for “Bang” Operator (Rule 3.4)**  
The `!` operator causes runtime crashes. The audit tool flags any usage.

### **3. Deterministic State (Rule 5.3)**  
All generated Cubits use sealed state classes, forcing exhaustive UI handling.

### **4. Async Reentrancy (Rule 6.6)**  
Generated Cubits prevent multiple async triggers (e.g., double-taps on buttons).

---

## ⚠️ Enable the Compliance Audit
Add this to CI/CD:

```bash
mcf audit
```

If a developer breaks architecture boundaries, the audit fails.

---

## 💬 Contributing & Discussions  
We welcome contributions from engineers who care about software quality.

- Report bugs  
- Suggest rules  
- Improve documentation  

---

## 📄 License  
Released under the MIT License.

> "The difference between a prototype and a product is not features; it is predictability."
