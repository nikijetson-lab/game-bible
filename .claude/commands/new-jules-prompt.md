# /new-jules-prompt

Сформулюй промпт для Jules за структурою "Anatomy of a Perfect Prompt" (Purpose, Task,
Context, Effort, Boundaries, Verification Rules, Stop Conditions, Output Format), і
ЗАВЖДИ включи на початку критичні правила з `.claude/CLAUDE.md`:

- commit directly to main (no PR/branches)
- read full quest file before scene key assignment (never keyword matching)
- touch only what's needed (no refactoring adjacent code, report don't fix unrelated issues)
- minimum code / no speculative abstractions
- increment ?v=N on the relevant `<script>` tag in web/index.html after any JS change
- don't commit .godot/, .import/, node_modules or test dependencies

Запитай у Дмитра деталі завдання (Purpose, Task, Context), якщо вони не вказані в
аргументі команди, замість того щоб вгадувати.
