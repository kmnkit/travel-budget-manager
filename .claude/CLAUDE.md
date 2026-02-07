# TripWallet Project Instructions

## Project Status

- **All 38 tasks complete** across 7 implementation phases
- **199+ unit and widget tests passing**
- **flutter analyze**: zero warnings
- **Integration tests**: 4 files created
- **Status**: Production-ready

## TDD Enforcement (MANDATORY)

**This project follows strict Test-Driven Development. ALL code changes MUST follow this cycle:**

### Red-Green-Refactor

1. **RED**: Write a failing test that describes the expected behavior
2. **GREEN**: Write the MINIMUM code to make the test pass
3. **REFACTOR**: Improve code quality while keeping all tests green

### Rules

- NEVER write implementation code in `lib/` without a corresponding test in `test/`
- NEVER skip tests. Tests are the specification, not an afterthought
- Domain layer (entities, use cases): MUST have unit tests
- Data layer (repositories, datasources): MUST have unit tests with `mocktail` mocks
- Presentation layer (providers): SHOULD have unit tests
- Custom widgets with interaction: MUST have widget tests
- Use `mocktail` for mocking (NOT `mockito`)

### Before Every Commit

```bash
flutter analyze   # MUST pass with zero warnings
flutter test      # MUST pass with zero failures
```

## Architecture

- **Pattern**: Clean Architecture (domain/data/presentation per feature)
- **State Management**: Riverpod v3 (`flutter_riverpod` ^3.1.0)
  - Uses `Notifier`/`NotifierProvider` (NOT StateNotifier - removed in v3)
  - `StreamProvider` for reactive Drift queries
  - `FutureProvider.family` for parameterized queries
- **Database**: Drift ^2.30.1 (SQLite) - NOT Isar
  - `.watch()` for reactive streams
  - SQL SUM for budget aggregation
  - 4 tables: Trips, Expenses, PaymentMethods, ExchangeRates
- **Routing**: GoRouter ^17.0.1
- **i18n**: intl + ARB (137 strings, Korean/English)
- **Charts**: fl_chart ^1.1.1
- **Code Generation**: Freezed v3 + Drift build_runner
- **Design**: Material Design 3, Teal #00897B, Lexend font, 8px/12px radius

### Layer Rules

- `domain/` MUST NOT import from `data/` or `presentation/`
- `presentation/` MUST NOT import from `data/` directly
- `data/` imports `domain/` for interfaces only
- Dependencies flow: `presentation → domain ← data`

### Code Generation

After changing Drift tables or Freezed models:
```bash
dart run build_runner build --delete-conflicting-outputs
```

## Features

- **7 supported currencies**: KRW, USD, EUR, JPY, GBP, AUD, CAD
- **8 expense categories**: Food, Transportation, Accommodation, Entertainment, Shopping, Activities, Communication, Miscellaneous
- **5 payment method types**: Cash, Credit Card, Debit Card, Mobile Payment, Other
- **Dual-currency display**: Original amount + converted amount
- **4-step exchange rate fallback**:
  1. Trip-specific rate
  2. Global rate
  3. Reverse rate (1/rate)
  4. USD pivot rate
- **Dual API fallback**: open.er-api.com → jsdelivr
- **Budget tracking**: 4 status levels (under, warning, at limit, over)
- **Statistics**: Pie chart (by category), bar chart (by date), payment method breakdown

## Key Development Notes

### Riverpod v3 Migration
- No `StateProvider` → use `NotifierProvider` with custom Notifier class
- No `valueOrNull` → use `.value` directly after null check
- Testing: Call `container.listen()` BEFORE reading `StreamProvider` state

### Mocking & Testing
- Use `mocktail` (NOT mockito) for all mocks
- For Freezed objects: use `any()` matcher
- For AsyncValue types: `registerFallbackValue(AsyncValue.data(...))`
- Drift mocks: `MockDatabase` with when/thenAnswer pattern

### Drift Quirks
- `selectOnly()` with `intEnum` returns raw `int`, not enum
- Cast manually: `final status = ExpenseStatus.values[int_value]`
- `.watch()` returns `Stream<List<T>>`, not single item

### Flutter 3.x Deprecations
- `surfaceVariant` (removed) → use `surfaceContainerHighest`
- Switch `activeColor` (deprecated) → use `activeTrackColor`
- AppBar `centerTitle` behavior changed → verify layout
- `bodyMedium`/`labelSmall` nullable → add null coalescing

## Design Reference

- Stitch Project ID: `1536195772045761405`
- Use `get_screen` MCP tool to view screen designs
- Primary color: Teal `#00897B` (NOT sky blue)
- Font: Lexend via `google_fonts`
- 8 expense categories, 5 payment types, 7 currencies

## Commands

```bash
flutter analyze                    # MUST pass with zero warnings
flutter test                       # MUST pass with zero failures
flutter gen-l10n                   # Regenerate localization after ARB changes
dart run build_runner build --delete-conflicting-outputs  # After Drift/Freezed changes
```

## Key Documents

- PRD: `.omc/prd.json`
- Implementation Plan: `.omc/plans/stitch-design-implementation.md`
- Root AGENTS.md: `AGENTS.md`
- Stitch Project: `1536195772045761405`

## Branch & Git

- **Working branch**: `ralph/trip-wallet-v2`
- **Commits**: Write in Korean (한글)

## Tool Usage Priority (MANDATORY)

**Serena tools are PRIMARY. Use Claude Code basic tools only when Serena cannot.**

### Code Exploration & Navigation

| Task | Use This (Serena) | Fallback (Claude Code) |
|------|-------------------|-------------------------|
| Understand file structure | `mcp__serena__get_symbols_overview` | `Read` (entire file) |
| Find class/method by name | `mcp__serena__find_symbol` | `Grep` |
| Find references to symbol | `mcp__serena__find_referencing_symbols` | `Grep` + manual search |
| Search code patterns | `mcp__serena__search_for_pattern` | `Grep` |
| List directory | `mcp__serena__list_dir` | `Glob` or `Bash(ls)` |
| Find files by name | `mcp__serena__find_file` | `Glob` |

### Code Editing

| Task | Use This (Serena) | Fallback (Claude Code) |
|------|-------------------|-------------------------|
| Replace method/function | `mcp__serena__replace_symbol_body` | `Edit` (manual range) |
| Add new method/class | `mcp__serena__insert_after_symbol` | `Edit` or `Write` |
| Insert import/code before | `mcp__serena__insert_before_symbol` | `Edit` |
| Rename symbol globally | `mcp__serena__rename_symbol` | LSP `lsp_rename` |
| **Create new file** | ❌ | `Write` (Serena cannot create files) |

### Memory & Context Management

**ALWAYS use Serena for project memory:**
- `mcp__serena__read_memory` - Load project context (do this first!)
- `mcp__serena__write_memory` - Save important findings
- `mcp__serena__list_memories` - Check available memories
- `mcp__serena__edit_memory` - Update existing memory

### When to Use Claude Code Basic Tools

**ONLY use these when Serena cannot handle it:**

1. **File Creation**: `Write` (Serena cannot create new files)
2. **Quick Pattern Search**: `Grep` (when you know exact pattern, faster than Serena)
3. **Simple File Listing**: `Glob` (when you just need file names, not structure)
4. **Manual String Replacement**: `Edit` (when symbol-based editing is not applicable)
5. **Shell Commands**: `Bash` (non-code operations)

### Code Intelligence (LSP)

Use MCP LSP plugin for advanced refactoring:
- `mcp__plugin_oh-my-claudecode_t__lsp_find_references`
- `mcp__plugin_oh-my-claudecode_t__lsp_rename`
- `mcp__plugin_oh-my-claudecode_t__lsp_goto_definition`
- `mcp__plugin_oh-my-claudecode_t__lsp_diagnostics`

### Workflow Example

**CORRECT (Serena-first approach):**
```
1. mcp__serena__list_memories → Read project context
2. mcp__serena__get_symbols_overview → Understand file structure
3. mcp__serena__find_symbol → Locate specific method
4. mcp__serena__replace_symbol_body → Edit the method
5. mcp__serena__write_memory → Save insights
```

**WRONG (Token-wasteful approach):**
```
1. Read entire file → Wastes tokens
2. Grep for method → Manual work
3. Edit with string replacement → Error-prone
```

### Summary

```
Priority 1: Serena (code exploration, symbol editing, memory)
Priority 2: MCP LSP plugin (advanced refactoring)
Priority 3: Claude Code basic tools (file creation, shell commands)
```

**Key Principle**: Use Serena's symbol-based tools to avoid reading entire files. This saves tokens and provides more precise code manipulation.
