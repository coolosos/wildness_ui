# Wildness UI

![wildness_project](https://github.com/coolosos/wildness_ui/assets/3104968/3ba723e5-0c67-4388-a18b-24e619acc5b2)

A modular Flutter monorepo providing a type-safe, component-driven design system framework with **granular rebuilds** and a streamlined **golden testing toolkit**.

---

## 📦 Packages in this Repository

| Package | Version | Description |
|---------|---------|-------------|
| [`wildness_ui`](packages/wildness_ui) | [![pub package](https://img.shields.io/pub/v/wildness_ui.svg)](https://pub.dev/packages/wildness_ui) | Core design system engine with F-bounded polymorphism, `WildnessComponentProvider`, and granular rebuilds. |
| [`wildness_ui_golden_toolkit`](packages/wildness_ui_golden_toolkit) | [![pub package](https://img.shields.io/pub/v/wildness_ui_golden_toolkit.svg)](https://pub.dev/packages/wildness_ui_golden_toolkit) | Lightweight golden test toolkit for testing Wildness components across scenarios and devices. |

---

## 🚀 Quick Start

### 1. `wildness_ui`

Add `wildness_ui` to your `pubspec.yaml`:

```yaml
dependencies:
  wildness_ui: ^2.0.0-rc.1
```

For full documentation and usage examples, check [packages/wildness_ui/README.md](packages/wildness_ui/README.md).

### 2. `wildness_ui_golden_toolkit`

Add `wildness_ui_golden_toolkit` to your `dev_dependencies`:

```yaml
dev_dependencies:
  wildness_ui_golden_toolkit: ^2.0.0-rc.1
```

For golden testing guide and examples, check [packages/wildness_ui_golden_toolkit/README.md](packages/wildness_ui_golden_toolkit/README.md).

---

## 🛠️ Workspace Development & Scripts

This monorepo is managed with [Melos](https://melos.invertase.io/).

```bash
# Analyze all packages
melos run analyze

# Run tests across all packages
melos run test

# Format all code
melos run format
```

---

## 📄 License

MIT © [Coolosos](https://github.com/coolosos)