# Hazemoor — розпаковані артефакти з ALL_ARTIFACTS_COMBINED.pdf

Джерело: `/home/niki/.hermes/cache/documents/doc_47c7a766baf5_ALL_ARTIFACTS_COMBINED.pdf`

Дата імпорту: 2026-07-01

## Що тут є

Ця папка містить реальні файли, витягнуті з PDF-пакета попередньої роботи:

- `00_INDEX.md` — індекс/зміст оригінального PDF
- 19 markdown-документів з гайдами
- `hermes_game_developer_local.py` — очищена валідна Python-версія локального агента

## Примітка про Python-файл

Оригінальний `hermes_game_developer_local.py` у PDF був зіпсований переносами рядків та декоративними розділювачами PDF. Його очищено і переписано як валідний Python-скрипт зі збереженням призначення:

- локальна перевірка Godot-проєкту;
- відкриття Godot Editor;
- запуск гри;
- Telegram-команди через `python-telegram-bot`;
- без збереження токенів у файлі.

Перевірка синтаксису:

```bash
python3 -m py_compile hermes_game_developer_local.py
```

## Запуск локальної перевірки

Windows/PowerShell:

```powershell
cd E:\Hazemoor\game-bible\docs\artifacts
python hermes_game_developer_local.py E:\Hazemoor\game-bible --validate-only
```

WSL:

```bash
cd /mnt/e/Hazemoor/game-bible/docs/artifacts
python3 hermes_game_developer_local.py /mnt/e/Hazemoor/game-bible --validate-only
```

## Безпека

Після імпорту виконано пошук ключових слів типу `token`, `api_key`, `secret`, `password`, `bearer`, `authorization`. Реальних секретів у витягнутих файлах не знайдено.
