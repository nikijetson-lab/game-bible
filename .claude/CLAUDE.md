# Hazemoor — Agent Rules

## КРИТИЧНІ ПРАВИЛА (порушення неприпустиме)

- **Завжди commit напряму в main branch.** Ніколи не відкривати PR, ніколи не створювати feature branches.
- **Перед призначенням scene key — прочитати повний файл квесту.** Ніякого keyword matching по назві сцени.
- **Торкатись тільки того що потрібно.** Не рефакторити сусідній код. Якщо знайдено несвязану проблему — повідомити, не виправляти.
- **Після будь-яких змін JS — збільшити ?v=N на відповідному script tag** в index.html.
- **node_modules в .gitignore, ніколи не комітити test dependencies.**
- **Godot cache не комітити:** `.godot/`, `.import/`, тимчасові export/build/log/cache папки мають лишатися поза git.
- **Мінімум коду, нуль спекулятивних абстракцій.** Якщо є сумніви — запитати.

## ПРОЄКТ

Hazemoor — 3D dark gothic fantasy RPG на **Godot 4.7**, соло-розробка.
Браузерний симулятор (`web/`) — інструмент для дебагу квестової логіки та наративних зв'язків.
**Це НЕ фінальний продукт.** Не розвивати симулятор як основний продукт.

Репо: `nikijetson-lab/game-bible`

## СТРУКТУРА РЕПО

```
godot-project/   — основний Godot 4.7 проєкт гри
  project.godot  — конфіг Godot, autoload managers, input map
  scenes/        — ігрові сцени (.tscn)
  scripts/       — GDScript системи, AI, gameplay, UI
  data/          — JSON NPC/dialogues/quests/items
  tests/         — Godot headless smoke-тести
quests/          — квест-файли (.md), джерело істини для сцен і діалогів
web/             — браузерний narrative debugger
web/app.js       — основна логіка симулятора
web/quests-data.js — дані всіх сцен
web/assets/maps/ — карти локацій (GDD/reference assets)
web/assets/images/ — портрети персонажів і бестіарій
design/          — world bible, GDD документи
regions/         — лор по регіонах
characters/      — характеристики персонажів
docs/artifacts/  — імпортовані Hermes/GDD artifacts
visual/          — concept art/reference material
```

## GODOT WORKFLOW

- Працювати в `godot-project/` як у головному ігровому проєкті.
- Нові інтерактивні системи перевіряти headless smoke-тестом, коли це можливо.
- Для сюжетних NPC використовувати `scripts/ai/AIPlanner.gd` і `scripts/ai/NPCBehavior.gd` як першу основу взаємодії.
- Сцени локацій додавати в `scenes/locations/...` з реальними Node3D/Area3D вузлами, а не тільки документацією.
- Godot `.uid` файли для нових `.gd`/resource файлів можна комітити разом із відповідним ресурсом.

## ОКРЕМІ ПРОЄКТИ — НІКОЛИ НЕ ЗМІШУВАТИ

- **Hazemoor** — темне фентезі, болото, Мурі, Вартовий, Грейфорд, Валькорн
- **Kest-ri-Gor / Elayna Corvein / Commander D'Alanson / Mètre Ingen / Roën-ri-Oks** — окремий всесвіт, жодного перетину з Hazemoor

## ЛОКАЦІЇ HAZEMOOR

Грейфорд → Сонк-Феррі → Хейзмур (болото) → Тихий Шелест / Галявина Моура
Паралельно: Валькорн (велике місто)

## ПЕРСОНАЖІ (ключові)

Вартовий (гравець), Міа, Моур (дух), Алтея (Чаклунка Грейфорду),
Руфін (зниклий картограф), Каен, Гара Пайк, Ілія, Варрік, Сірра,
Філіппа/Себастьян (Фіпп), Карос, Тован Рід, Келм

## ТЕХНІЧНИЙ СТЕК СИМУЛЯТОРА

- Vanilla JS (без фреймворків)
- Сцени: quests-data.js → об'єкт з ключами сцен
- Карти: MAP_DATA в app.js → ієрархічна навігація
- Аудіо: web/assets/audio/ → MP3 по епізодах
- Cache bust: ?v=N на script tags після кожної зміни JS
