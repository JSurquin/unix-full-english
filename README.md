# Unix Training — full English

![Unix Logo](https://venam.net/blog/assets/tux.png)

## About this course

This complete Unix course uses [Slidev](https://github.com/slidevjs/slidev) for an interactive, modern learning experience.

**UNIX/Linux Training — Initiation 2025** 🐧

A practical, complete, progressive course to discover and master Unix/Linux fundamentals.

## Related repos

| Repo | Role |
|------|------|
| [unix](https://github.com/JSurquin/unix) | Source course (French, full initiation track) |
| [unix-english](https://github.com/JSurquin/unix-english) | Lighter English variant (3-day operator track) |
| **unix-full-english** (this repo) | Full English translation of the French initiation course |

## Table of contents

1. 🧱 Unix/Linux introduction and history
2. 🔧 Essential base commands
3. 📦 Package management and maintenance
4. 👥 User and permission management
5. 💾 Storage and filesystems
6. ⚙️ Process and service management
7. 📡 Network configuration
8. 🤖 Automation and scripts
9. 🔐 System security
10. ☁️ Server services
11. 📊 Monitoring & system analysis
12. 🚨 Advanced monitoring (Zabbix)
13. ⚡ Optimization & performance (BONUS)
14. 🌐 Linux network optimization (BONUS)
15. ✅ Final validation MCQ

Each module includes theory, MCQ, and hands-on exercises.

## Hands-on project

A mini-project is built step by step throughout the course to practice every concept.

## Requirements

- Unix or Linux (or macOS / WSL)
- A code editor (VS Code recommended)
- Basic terminal familiarity

## Quick start

```bash
git clone https://github.com/JSurquin/unix-full-english.git
cd unix-full-english
pnpm install --frozen-lockfile
pnpm dev
```

## NPM scripts

| Script | Description |
|--------|-------------|
| `pnpm dev` | Start dev server and open the deck |
| `pnpm build` | Static build → `dist/` |
| `pnpm export` | Export slides (PDF) |
| `pnpm screenshot` | Export slides as PNG |
| `pnpm lint` | Run ESLint |

## Deploy (Vercel)

`vercel.json` is preconfigured. Build output: **`dist/`**.

Live site: [unix-full-english.andromed.fr](https://unix-full-english.andromed.fr)

## License

MIT
