# cursor-pipelines

Личные глобальные пайплайны Cursor. Каждый стек — папка в `pipelines/`.

Сейчас:

| Папка | Стек | Команда |
|---|---|---|
| `pipelines/php-js/` | PHP + JS/TS | `/php-js-pipeline` |

Структура одного пайплайна:

```text
pipelines/<name>/
  agents/
  commands/
  rules/
  plugins/local/<plugin>/
```

## Установка в текущий Cursor

Из корня репо:

```powershell
.\install.ps1 php-js
```

```bash
chmod +x install.sh sync-from-cursor.sh
./install.sh php-js
```

Аргумент — имя папки в `pipelines/`. Скрипт копирует содержимое в `~/.cursor/` (`agents`, `commands`, `rules`, `plugins/local/...`).

После: **Developer: Reload Window**.

Без аргумента скрипт покажет список доступных пайплайнов.

## Забрать правки из Cursor обратно в репо

```powershell
.\sync-from-cursor.ps1 php-js
```

```bash
./sync-from-cursor.sh php-js
```

Синхронизируются только файлы/плагины, которыми владеет этот пайплайн (по именам в `pipelines/<name>/`).

## Что не входит

- User Rules из Cursor Settings (аккаунт)
- Project `.cursor/` внутри рабочих репозиториев

## Использование (php-js)

```text
/php-js-pipeline <задача: фича или рефактор>
```

Роли: `architecture-analyst` → `implementer` → `tester` → `code-reviewer`
