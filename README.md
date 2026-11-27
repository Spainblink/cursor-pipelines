# cursor-php-js-pipeline

Личный набор глобальных настроек Cursor для стека **PHP + JS/TS**:

- роли: `architecture-analyst` → `implementer` → `tester` → `code-reviewer`
- команда: `/php-js-pipeline`
- правила: PHPDoc RU / PSR, no migrations, no commit/push, review-rework


## Установка

Из корня репо:

**Windows (PowerShell):**

```powershell
.\install.ps1
```

**macOS / Linux:**

```bash
chmod +x install.sh
./install.sh
```

Скрипт копирует файлы в `~/.cursor/` (`agents`, `commands`, `rules`, `plugins/local/global-dev-rules`).

После установки: **Developer: Reload Window**, проверь `/php-js-pipeline` и роли в Customize.

## Обновление с другой машины

```bash
git pull
# Windows: .\install.ps1
# Unix:    ./install.sh
```

Чтобы забрать правки обратно в репо после ручных правок в `~/.cursor`:

```powershell
.\sync-from-cursor.ps1   # Windows
./sync-from-cursor.sh    # Unix
git status
```

## Что не входит

- User Rules из Cursor Settings (аккаунт) — их нужно перенести отдельно.
- Project `.cursor/` внутри конкретных репозиториев — это другой слой (для CLI/Cloud).

## Использование

```text
/php-js-pipeline <задача: фича или рефактор>
```
