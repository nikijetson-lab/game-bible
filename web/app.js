// ==========================================
// ПОРТАЛ БЛІДОГО ВАРТІВНИКА — ЛОГІКА ТА ГРА
// ==========================================

// --- КАРТА ФАЙЛІВ РЕПОЗИТОРІЮ (ДЛЯ ЛОР-ПРОВІДНИКА) ---
const BIBLE_FILES = {
    design: [
        { name: "Бачення гри (vision.md)", path: "design/vision.md" },
        { name: "Основа світу (world-premise.md)", path: "design/world-premise.md" },
        { name: "Світ Хейзмуру (world.md)", path: "design/world.md" },
        { name: "Назви та мова (world-names.md)", path: "design/world-names.md" },
        { name: "Протагоніст (protagonist.md)", path: "design/protagonist.md" },
        { name: "Прогресія героя (hero-progression.md)", path: "design/hero-progression.md" },
        { name: "Ігрові системи (systems.md)", path: "design/systems.md" },
        { name: "Ігровий цикл (gameplay-loop.md)", path: "design/gameplay-loop.md" },
        { name: "Репутація (reputation.md)", path: "design/reputation.md" },
        { name: "Крафтинг (crafting.md)", path: "design/crafting.md" },
        { name: "Фракції (factions.md)", path: "design/factions.md" },
        { name: "Орден Кинджалів (orden-semy-kyndzhativ.md)", path: "design/orden-semy-kyndzhativ.md" }
    ],
    regions: [
        { name: "Грейфорд (greyford.md)", path: "regions/greyford.md" },
        { name: "Валькорн (valkorn.md)", path: "regions/valkorn.md" },
        { name: "Сонк-Феррі (sunk-ferry.md)", path: "regions/sunk-ferry.md" },
        { name: "Тихий Шелест (tykhyy-shelest.md)", path: "regions/tykhyy-shelest.md" },
        { name: "Галявина Моура (hazemoor-galyavyna-moura.md)", path: "regions/hazemoor-galyavyna-moura.md" }
    ],
    races: [
        { name: "Раса: Мурі (muri.md)", path: "races/muri.md" }
    ],
    characters: [
        { name: "Міа (mia.md)", path: "characters/mia.md" },
        { name: "Одрін (odrin.md)", path: "characters/odrin.md" },
        { name: "Тесса (tessa.md)", path: "characters/tessa.md" }
    ],
    quests: [
        { name: "1. Адресат відсутній (greyford-01)", path: "quests/greyford-01-adresat-vidsutniy.md" },
        { name: "2. Шлях крізь болото (hazemoor-01)", path: "quests/hazemoor-01-shlyakh-kriz-boloto.md" },
        { name: "3. Сім уроків болота (muri-path-01)", path: "quests/muri-path-01-seven-lessons-old.md" },
        { name: "4. Галявина і дух (hazemoor-02)", path: "quests/hazemoor-02-halyna-dusha.md" },
        { name: "5. Квести Тихого Шелесту (tykhy-shelist)", path: "quests/tykhy-shelist-quests.md" },
        { name: "6. Валькорн: Людина з болота", path: "quests/valkorn-01-lyudyna-z-bolota.md" },
        { name: "7. Валькорн: Дві версії правди", path: "quests/valkorn-02-dvi-versii-pravdy.md" },
        { name: "8. Валькорн: Правильна ціна", path: "quests/valkorn-03-pravylna-tsina.md" },
        { name: "9. Валькорн: Людина, що послала", path: "quests/valkorn-04-lyudyna-shcho-poslala-rufina.md" },
        { name: "10. Голод знизу (holod-znuzu)", path: "quests/holod-znuzu.md" },
        { name: "11. Матриця наслідків (holod-znuzu-naslidky)", path: "quests/holod-znuzu-naslidky.md" },
        { name: "12. Сіль у книзі (sil-u-knyzi)", path: "quests/sil-u-knyzi.md" },
        { name: "13. Поромна присяга (poromna-prysyaga)", path: "quests/poromna-prysyaga.md" },
        { name: "14. Попіл під каплицею (popil-pid-kaplytseyu)", path: "quests/popil-pid-kaplytseyu.md" },
        { name: "15. Ніж квоти (nizh-kvoty)", path: "quests/nizh-kvoty.md" },
        { name: "16. Ланцюжок Хейзмуру (hazemoor-lantsyuzhok)", path: "quests/hazemoor-lantsyuzhok.md" }
    ],
    letters: [
        { name: "Лист: Доки не забули (until-forgotten.md)", path: "letters/until-forgotten.md" }
    ]
};

// --- НАВІГАЦІЯ ТА ВКЛАДКИ ---
document.getElementById("nav-bible").addEventListener("click", () => switchTab("bible"));
document.getElementById("nav-simulator").addEventListener("click", () => switchTab("simulator"));

function switchTab(tab) {
    document.querySelectorAll("header nav button").forEach(btn => btn.classList.remove("active"));
    document.querySelectorAll(".view-section").forEach(sec => sec.classList.remove("active"));

    if (tab === "bible") {
        document.getElementById("nav-bible").classList.add("active");
        document.getElementById("section-bible").classList.add("active");
    } else {
        document.getElementById("nav-simulator").classList.add("active");
        document.getElementById("section-simulator").classList.add("active");
        if (!gameStarted) startGame();
    }
}

// --- ЛОР-ПРОВІДНИК (BIBLE EXPLORER) ---
document.querySelectorAll(".cat-btn").forEach(btn => {
    btn.addEventListener("click", (e) => {
        document.querySelectorAll(".cat-btn").forEach(b => b.classList.remove("active"));
        e.target.classList.add("active");
        const category = e.target.getAttribute("data-category");
        renderFileList(category);
    });
});

function renderFileList(category) {
    const fileListDiv = document.getElementById("file-list");
    fileListDiv.innerHTML = "";

    const files = BIBLE_FILES[category] || [];
    if (files.length === 0) {
        fileListDiv.innerHTML = '<p class="placeholder-text">У цій категорії немає файлів.</p>';
        return;
    }

    files.forEach(file => {
        const btn = document.createElement("button");
        btn.className = "file-btn";
        btn.textContent = file.name;
        btn.addEventListener("click", () => loadMarkdownFile(file.path, btn));
        fileListDiv.appendChild(btn);
    });
}

function loadMarkdownFile(path, clickedBtn) {
    document.querySelectorAll(".file-btn").forEach(b => b.classList.remove("active"));
    if (clickedBtn) clickedBtn.classList.add("active");

    const contentDiv = document.getElementById("bible-content");
    contentDiv.innerHTML = '<div class="intro-screen"><p>Завантаження документа...</p></div>';

    // Завантажуємо файл відносно кореня репозиторію (оскільки web/ лежить у корені, шлях буде ../path)
    fetch(`../${path}`)
        .then(response => {
            if (!response.ok) throw new Error("Файл не знайдено");
            return response.text();
        })
        .then(text => {
            contentDiv.innerHTML = parseMarkdown(text);
        })
        .catch(err => {
            contentDiv.innerHTML = `
                <div class="intro-screen">
                    <div style="font-size: 3rem;">❌</div>
                    <h2>Помилка завантаження</h2>
                    <p>Не вдалося завантажити файл з репозиторію: <code>${path}</code></p>
                    <p style="font-size: 0.8rem; color: var(--text-muted);">Переконайтеся, що ви запустили локальний сервер за допомогою <code>python -m http.server</code> або аналогічного інструменту у папці репозиторію.</p>
                </div>
            `;
        });
}

// --- ЛЕГКИЙ КЛІЄНТСЬКИЙ MARKDOWN ПАРСЕР ---
function parseMarkdown(md) {
    if (!md) return "";
    let html = md;

    // Очищення від воскової розмітки frontmatter
    html = html.replace(/^---[\s\S]+?---/, '');

    // Екранування HTML тегів
    html = html.replace(/</g, "&lt;").replace(/>/g, "&gt;");

    // Заголовки
    html = html.replace(/^# (.*$)/gim, '<h1>$1</h1>');
    html = html.replace(/^## (.*$)/gim, '<h2>$1</h2>');
    html = html.replace(/^### (.*$)/gim, '<h3>$1</h3>');

    // Списки
    html = html.replace(/^\s*-\s+(.*$)/gim, '<li>$1</li>');
    html = html.replace(/(<li>.*<\/li>)/gim, '<ul>$1</ul>');
    html = html.replace(/<\/ul>\s*<ul>/g, ''); // об'єднання сусідніх списків

    // Блокноти / Попередження
    html = html.replace(/^&gt;\s*(.*$)/gim, '<blockquote>$1</blockquote>');

    // Жирний та курсив
    html = html.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>');
    html = html.replace(/\*(.*?)\*/g, '<em>$1</em>');

    // Розділювачі
    html = html.replace(/---/g, '<hr>');

    // Параграфи (простий поділ порожніми рядками)
    let paragraphs = html.split(/\n{2,}/);
    for (let i = 0; i < paragraphs.length; i++) {
        let p = paragraphs[i].trim();
        if (p && !p.startsWith('<h') && !p.startsWith('<ul') && !p.startsWith('<li') && !p.startsWith('<block') && !p.startsWith('<hr')) {
            paragraphs[i] = '<p>' + p.replace(/\n/g, '<br>') + '</p>';
        }
    }
    return paragraphs.join('\n');
}

// ==========================================
// ⚔️ СИМУЛЯТОР ГРИ: АДРЕСАТ ВІДСУТНІЙ
// ==========================================

let gameStarted = false;
let playerState = {
    hp: 100,
    will: 50,
    maxHp: 100,
    maxWill: 50,
    doctrine: "Без доктрини",
    reputation: {
        greyford: "Нейтралітет",
        knives: "Нейтралітет",
        hazemoor: "Невідомість"
    },
    inventory: ["📜 Руфінів лист"],
    clues: {
        room: false,
        carver: false,
        tavern: false,
        witch: false
    },
    history: []
};

// База даних ігрових сцен
const GAME_SCENES = {
    start: {
        title: "Оберіть Доктрину Вартівника",
        text: `Ви прибуваєте до прикордонного містечка Грейфорд. Порожній Сезон розпочався, болота Хейзмуру насуваються на цивілізацію. У ваших руках запечатаний лист до картографа Руфіна, який мав передати вам карти болота.<br><br>Перш ніж увійти до міста, оберіть вашу <strong>Доктрину</strong>. Доктрина визначає ваші унікальні знання та відкриває особливі варіанти дій під час розслідування:`,
        choices: [
            { text: "🏹 Слідопит (Pathfinder) — розуміння боліт, слідів та фізичних доказів", action: () => setDoctrine("Слідопит", "arriving") },
            { text: "💡 Ліхтар (Lantern) — бачення магії, містичних знаків та потойбічного", action: () => setDoctrine("Ліхтар", "arriving") },
            { text: "🤝 Посередник (Mediator) — відчуття брехні, угоди та вигідний торг", action: () => setDoctrine("Посередник", "arriving") },
            { text: "⚖️ Суддя (Judge) — авторитет закону, офіційні повноваження", action: () => setDoctrine("Суддя", "arriving") },
            { text: "👤 Без доктрини (No Doctrine) — приземлений воїн, покладаєтесь на кмітливість", action: () => setDoctrine("Без доктрини", "arriving") }
        ]
    },
    arriving: {
        title: "Постоялий двір Грейфорда",
        text: `Ви входите у напівтемну таверну. За шинком стоїть Ерван — хазяїн закладу. Ви підходите і запитуєте про Руфіна. Ерван мовчки бере ваш лист, дивиться на дивну печатку (два перехрещені кинджали, коло і крапля), тримає його на мить довше, ніж варто звичайному паперу...<br><br>Потім піднімає на вас очі і запитує:<br><em>«І що він тобі був — друг, боржник, чи ти просто наймит-кур'єр?»</em>`,
        choices: [
            { 
                text: "«Ми домовились. Я приїхав виконати свою частину обов'язку.» (Шлях Ідеаліста)", 
                cost: "will:0",
                action: () => chooseMotivation("Ідеаліст", "Ерван киває з повагою: «Людина обов'язку в наші часи — рідкість.»", "investigation")
            },
            { 
                text: "«Він мав дещо, що мені потрібно. Це особиста справа.» (Особистий Інтерес)", 
                cost: "will:0",
                action: () => chooseMotivation("Особистий інтерес", "Ерван примружується: «У всіх тут свої інтереси. Сподіваюсь, твої не коштуватимуть тобі життя.»", "investigation")
            },
            { 
                text: "«Я просто доставляю листа. Що далі — моя проблема.» (Прагматик)", 
                cost: "will:0",
                action: () => chooseMotivation("Прагматик", "Ерван хмикає: «Просто наймит. Це безпечніше. Наймити довго не живуть, але й сплять спокійніше.»", "investigation")
            }
        ]
    },
    investigation: {
        title: "Розслідування у Грейфорді",
        text: `Ерван повідомляє, що Руфін зник три дні тому. Його кімната досі оплачена, а речі лежать всередині. Він відмикає двері кімнати для вас.<br><br>У вас є три головні нитки розслідування. Ви повинні дослідити принаймні дві, щоб скласти картину зникнення Руфіна:`,
        choices: [
            { 
                text: "🚪 Оглянути кімнату Руфіна на другому поверсі", 
                cost: "will:0",
                action: () => goThread("room") 
            },
            { 
                text: "🛠️ Відвідати квартал ремісників та поговорити з різьбярем", 
                cost: "will:0",
                action: () => goThread("carver") 
            },
            { 
                text: "🍻 Завітати у портову таверну та розпитати бармена про Руфіна", 
                cost: "will:0",
                action: () => goThread("tavern") 
            },
            { 
                text: "🧙‍♀️ Оглянути дивний слід захисних рун (Доступно після виявлення знаків)", 
                cost: "will:0",
                visible: () => playerState.clues.witch_hint === true,
                action: () => goThread("witch") 
            },
            { 
                text: "🚪 Іти до воріт міста та вирушати в Хейзмур (Потрібно знайти докази)", 
                cost: "will:0",
                visible: () => (Object.values(playerState.clues).filter(v => v === true).length >= 2),
                action: () => goScene("gates") 
            }
        ]
    },
    thread_room: {
        title: "Кімната Руфіна",
        text: `Ви заходите в порожню, порошну кімнату. Тут лежить зношений плащ картографа, дорожній посох та шкіряна сумка з незвичайним тавром у вигляді змії.<br><br>Що ви будете робити?`,
        choices: [
            {
                text: "🔍 Детально обшукати особисті речі (Звичайний пошук)",
                action: () => {
                    playerState.clues.room = true;
                    addToLog("Знайдено шкіряну сумку з тавром ремісничого кварталу.", "success");
                    addItem("🎒 Сумка Руфіна");
                    goScene("investigation");
                }
            },
            {
                text: "🏕️ [Слідопит] Дослідити сліди бруду на підлозі",
                visible: () => playerState.doctrine === "Слідопит",
                action: () => {
                    playerState.clues.room = true;
                    addToLog("Слідопит виявив: болотяна глина на підлозі — чорний торф'яний шар із глибин Хейзмуру. Руфін таємно ходив у болота ще до свого зникнення!", "success");
                    addItem("🎒 Сумка Руфіна");
                    addItem("🌱 Болотяний торф");
                    goScene("investigation");
                }
            },
            {
                text: "💡 [Ліхтар] Оглянути стіни та одвірки на наявність прихованої магії",
                visible: () => playerState.doctrine === "Ліхтар",
                action: () => {
                    playerState.clues.room = true;
                    playerState.clues.witch_hint = true;
                    addToLog("Ліхтар виявив: ледь помітні захисні руни над дверима. Руфін захищався не від людей, а від чогось, що притягнув із болота! Руни ведуть до чаклунки.", "success");
                    addItem("🎒 Сумка Руфіна");
                    goScene("investigation");
                }
            }
        ]
    },
    thread_carver: {
        title: "Квартал ремісників — Різьбяр",
        text: `Ви знаходите майстерню різьбяра по дереву. Старий майстер працює над дивною викривленою гілкою і неохоче реагує на ваші запитання про Руфіна. «Багато хто приходить і йде. Чому я маю допомагати кожному Вартівнику?»`,
        choices: [
            {
                text: "📜 Показати запечатаний лист Руфіна з дивною восковою печаткою",
                action: () => {
                    playerState.clues.carver = true;
                    addToLog("Різьбяр побачив печатку, здригнувся і сказав: «Руфін питав про дорогу до Тихого Шелесту. Шукав там когось.»", "success");
                    goScene("investigation");
                }
            },
            {
                text: "🏕️ [Слідопит] Заговорити про болотяне дерево, з яким він працює",
                visible: () => playerState.doctrine === "Слідопит",
                action: () => {
                    playerState.clues.carver = true;
                    addToLog("Ви впізнали корінь-вербу з глибин болота. Вражений різьбяр розповів більше: «Руфін ніс щось дуже важке перед виходом. Він ледве йшов.»", "success");
                    goScene("investigation");
                }
            },
            {
                text: "🤝 [Посередник] Запропонувати взаємовигідну угоду",
                visible: () => playerState.doctrine === "Посередник",
                action: () => {
                    playerState.clues.carver = true;
                    addToLog("Ви домовилися розізнати долю його боргів у порту. Різьбяр зізнався: «Руфін мав велику справу. Хтось оплатив йому цю подорож сріблом!»", "success");
                    goScene("investigation");
                }
            },
            {
                text: "💡 [Ліхтар] Вказати на болотяні захисні знаки над його дверима",
                visible: () => playerState.doctrine === "Ліхтар",
                action: () => {
                    playerState.clues.carver = true;
                    playerState.clues.witch_hint = true;
                    addToLog("Майстер бачить, що ви розумієте руни. Він шепоче: «Руфін був наляканий до смерті. Він ставив ці знаки перед виходом вночі.»", "success");
                    goScene("investigation");
                }
            }
        ]
    },
    thread_tavern: {
        title: "Портова таверна",
        text: `У брудному шинку біля причалу бармен протирає склянку. «Руфін? Так, сидів тут три дні тому. Спілкувався з однією дівчиною — куртизанкою на ім'я Міа. Вона зараз сидить за кутовим столиком.»<br><br>Міа дивиться на вас із підозрою і не поспішає відкривати душу першому ліпшому Вартівнику.`,
        choices: [
            {
                text: "🤝 [Посередник] Заговорити про гроші та срібло Руфіна",
                visible: () => playerState.doctrine === "Посередник",
                action: () => {
                    playerState.clues.tavern = true;
                    addToLog("Міа зізнається: «Він платив чистим сріблом, а не міддю. Хтось дуже багатий найняв його для цієї подорожі.»", "success");
                    goScene("investigation");
                }
            },
            {
                text: "🗣️ Спробувати розговорити її або показати рекомендацію Ервана",
                action: () => {
                    playerState.clues.tavern = true;
                    addToLog("Міа розповіла: «Руфін казав, що щось у Хейзмурі не чекає на людей. Він пішов наляканий, але цілеспрямовано.»", "success");
                    goScene("investigation");
                }
            }
        ]
    },
    thread_witch: {
        title: "Помешкання Чаклунки",
        text: `Ви знайшли прихований будинок на околиці міста, прикрашений оберегами від болотяних духів. Чаклунка зустрічає вас із посмішкою. Вона знає, чому ви прийшли.<br><br>«Руфін? Я бачила, як він ішов у болота вночі...»`,
        choices: [
            {
                text: "💡 [Ліхтар] Розпитати про магічне світіння його речей",
                visible: () => playerState.doctrine === "Lantern" || playerState.doctrine === "Ліхтар",
                action: () => {
                    playerState.clues.witch = true;
                    addToLog("Чаклунка шепоче: «Він ніс щось, що світилося в темряві зеленим вогнем. Це не ліхтар... Це древній артефакт боліт!»", "success");
                    addItem("🧿 Болотяний амулет");
                    goScene("investigation");
                }
            },
            {
                text: "🤝 [Посередник] Спробувати купити її знання",
                visible: () => playerState.doctrine === "Посередник",
                action: () => {
                    playerState.clues.witch = true;
                    addToLog("За жменю мідяків вона зізналася: «Він купив це світіння у когось дуже впливового в Грейфорді.»", "success");
                    goScene("investigation");
                }
            },
            {
                text: "🗣️ Просто запитати, що вона бачила тієї ночі",
                action: () => {
                    playerState.clues.witch = true;
                    addToLog("Вона каже: «Він ніс важку річ, яка горіла холодним світлом у темряві. Це було моторошно.»", "success");
                    goScene("investigation");
                }
            }
        ]
    },
    gates: {
        title: "Міські Ворота — Вихід у Хейзмур",
        text: `Ви зібрали достатньо доказів і підходите до важких дерев'яних воріт, що ведуть у туманні болота Хейзмуру. Сержант воріт перевіряє свої записи: «Так, Руфін вийшов три дні тому в напрямку Тихого Шелесту. Це там, де закінчується дорога і починається чуже.»<br><br>Він уважно дивиться на вас: <em>«Ти теж туди? З якого приводу Вартівник іде в болота?»</em>`,
        choices: [
            {
                text: "«Я шукаю людину. Руфін пішов і не повернувся, я маю його знайти.» (Правда)",
                action: () => finishQuest("Правда", "Сержант киває: «Благородна мета. Нехай закон світить тобі в тумані.»")
            },
            {
                text: "«Я маю перевірити маршрут. Є скарги на безпеку поселення.» (Напівправда)",
                action: () => finishQuest("Напівправда", "Сержант скептично хмикає: «Безпека? У Хейзмурі немає безпеки. Ну йди, раз це наказ.»")
            },
            {
                text: "«У мене офіційна робота. Лист — мій єдиний пропуск.» (Ухилення)",
                action: () => finishQuest("Ухилення", "Сержант примружується і записує щось у журнал: «Таємниці... Ну що ж, запишемо як офіційний візит.»")
            }
        ]
    },
    ending: {
        title: "Квест Завершено: Адресат відсутній",
        text: "", // Заповнюється динамічно у функції finishQuest
        choices: [
            {
                text: "🎮 Почати заново іншою Доктриною",
                action: () => resetGame()
            }
        ]
    }
};

// --- УПРАВЛІННЯ ІГРОВИМ ПРОЦЕСОМ ---
function startGame() {
    gameStarted = true;
    playerState = {
        hp: 100,
        will: 50,
        maxHp: 100,
        maxWill: 50,
        doctrine: "Без доктрини",
        reputation: {
            greyford: "Нейтралітет",
            knives: "Нейтралітет",
            hazemoor: "Невідомість"
        },
        inventory: ["📜 Руфінів лист"],
        clues: {
            room: false,
            carver: false,
            tavern: false,
            witch: false,
            witch_hint: false
        },
        history: []
    };
    updateUi();
    goScene("start");
    
    // Очищуємо лог та додаємо перше повідомлення
    const logDiv = document.getElementById("combat-log");
    logDiv.innerHTML = '<div class="log-msg system">Ви розпочали розслідування у Грейфорді. Оберіть доктрину.</div>';
}

function setDoctrine(doctrine, nextScene) {
    playerState.doctrine = doctrine;
    addToLog(`Обрано Доктрину: ${doctrine}`, "reputation");
    goScene(nextScene);
}

function chooseMotivation(motivation, dialogReply, nextScene) {
    playerState.history.push({ step: "motivation", choice: motivation });
    
    // Репутаційні наслідки
    if (motivation === "Ідеаліст") {
        playerState.reputation.greyford = "Повага";
    } else if (motivation === "Прагматик") {
        playerState.reputation.greyford = "Скепсис";
    }
    
    addToLog(`Мотивація: ${motivation}. ${dialogReply}`, "system");
    goScene(nextScene);
}

function goThread(thread) {
    goScene(`thread_${thread}`);
}

function goScene(sceneKey) {
    const scene = GAME_SCENES[sceneKey];
    if (!scene) return;

    // Встановлюємо заголовки та тексти
    document.getElementById("scene-title").textContent = scene.title;
    document.getElementById("scene-text").innerHTML = scene.text;

    // Малюємо кнопки вибору
    const choicesDiv = document.getElementById("scene-choices");
    choicesDiv.innerHTML = "";

    scene.choices.forEach(choice => {
        // Перевіряємо видимість кнопки (наприклад, для доктрин)
        if (choice.visible && !choice.visible()) {
            return;
        }

        const btn = document.createElement("button");
        btn.className = "choice-btn";
        btn.innerHTML = `<span>${choice.text}</span>`;
        btn.addEventListener("click", () => choice.action());
        choicesDiv.appendChild(btn);
    });

    updateUi();
}

function finishQuest(gateAnswer, sergeantReply) {
    playerState.history.push({ step: "gate_answer", choice: gateAnswer });
    addToLog(`Відповідь сержанту: ${gateAnswer}. ${sergeantReply}`, "system");

    // Визначаємо підсумок розслідування
    const cluesFound = Object.entries(playerState.clues).filter(([k, v]) => v === true && k !== "witch_hint").map(([k]) => k);
    let investigationGrade = "";
    let summaryText = "";

    if (cluesFound.length >= 3) {
        investigationGrade = "Блискуче розслідування";
        summaryText = `Ви провели **блискуче слідство**! Ви оглянули кімнату Руфіна, розговорили різьбяра та розкрили таємницю через куртизанку Міа. 
        <br><br>
        <strong>Ваші висновки:</strong>
        <ul>
            <li>Руфін пішов у Тихий Шелест цілеспрямовано. Він не тікав, а виконував чиєсь завдання.</li>
            <li>Його подорож була оплачена чистим сріблом впливової особи з Грейфорда.</li>
            <li>Він ніс із собою важкий таємничий артефакт, який випромінював магічне зелене світло.</li>
            <li>Він знав про небезпеки болота і заздалегідь ставив захисні знаки на дверях кімнати.</li>
        </ul>`;
    } else {
        investigationGrade = "Базове розслідування";
        summaryText = `Ви провели **базове слідство**, зібравши мінімально необхідні докази для продовження подорожі.
        <br><br>
        <strong>Ваші висновки:</strong>
        <ul>
            <li>Руфін зник три дні тому і вирушив у напрямку Тихого Шелесту на болотах Хейзмуру.</li>
            <li>Він знав, куди йде, і був сильно наляканий небезпеками Хейзмуру.</li>
            <li>Його речі та сумка вказують на ретельну підготовку до виходу.</li>
        </ul>`;
    }

    // Репутаційні зсуви за відповідь воротам
    if (gateAnswer === "Правда") {
        playerState.reputation.greyford = "Довіра";
        playerState.reputation.hazemoor = "Відомість";
    } else if (gateAnswer === "Ухилення") {
        playerState.reputation.greyford = "Підозра";
    }

    addToLog(`Квест завершено з результатом: ${investigationGrade}`, "success");

    // Рендеринг екрану фіналу
    const endingScene = GAME_SCENES.ending;
    endingScene.text = `
        <span class="quest-tag" style="color: var(--accent-gold);">РЕЗУЛЬТАТ: ${investigationGrade.toUpperCase()}</span>
        <h2 style="font-family: var(--font-gothic); color: var(--accent-gold); margin-top: 1rem; margin-bottom: 1rem;">⚖️ ВЕРДИКТ ВАРТІВНИКА</h2>
        ${summaryText}
        <hr style="border: 0; height: 1px; background: var(--border-color); margin: 1.5rem 0;">
        <h3 style="font-family: var(--font-gothic); color: var(--accent-gold); margin-bottom: 0.5rem;">📊 Наслідки ваших рішень:</h3>
        <p>• <strong>Мотивація:</strong> ви обрали шлях <em>"${playerState.history[0].choice}"</em>.</p>
        <p>• <strong>Відповідь воротам:</strong> ваша відповідь сержанту була записана як <em>"${gateAnswer}"</em>.</p>
        <p>• <strong>Репутація в Грейфорді:</strong> <span class="${playerState.reputation.greyford === 'Підозра' ? 'hostile' : 'friendly'}" style="color: ${playerState.reputation.greyford === 'Підозра' ? 'var(--accent-red)' : '#52b788'};">${playerState.reputation.greyford}</span>.</p>
        <br>
        <p class="gold-text" style="font-style: italic; font-weight: 600;">Шлях до Тихого Шелесту відкрито. Порожній Сезон чекає на вас на болотах Хейзмуру...</p>
    `;

    goScene("ending");
}

function resetGame() {
    startGame();
}

// --- ОНОВЛЕННЯ ЕЛЕМЕНТІВ UI ---
function updateUi() {
    // Оновлення смужок статусу
    document.getElementById("hp-value").textContent = `${playerState.hp}/${playerState.maxHp}`;
    document.getElementById("hp-bar").style.width = `${(playerState.hp / playerState.maxHp) * 100}%`;

    document.getElementById("will-value").textContent = `${playerState.will}/${playerState.maxWill}`;
    document.getElementById("will-bar").style.width = `${(playerState.will / playerState.maxWill) * 100}%`;

    // Оновлення інвентарю
    const invGrid = document.getElementById("inventory-list");
    invGrid.innerHTML = "";
    
    // Заповнюємо слоти предметами
    for (let i = 0; i < 4; i++) {
        const slot = document.createElement("div");
        slot.className = "inv-slot";
        
        if (playerState.inventory[i]) {
            slot.textContent = playerState.inventory[i].split(" ")[0]; // емодзі
            slot.title = playerState.inventory[i];
            slot.classList.add("active-item");
        } else {
            slot.textContent = "·";
            slot.classList.add("empty");
        }
        invGrid.appendChild(slot);
    }

    // Оновлення репутації
    const repList = document.getElementById("reputation-list");
    repList.innerHTML = `
        <li>
            <span>Грейфорд:</span>
            <span class="${playerState.reputation.greyford === 'Підозра' ? 'hostile' : (playerState.reputation.greyford === 'Нейтралітет' ? 'neutral' : 'friendly')}" 
                  style="color: ${playerState.reputation.greyford === 'Підозра' ? 'var(--accent-red)' : (playerState.reputation.greyford === 'Нейтралітет' ? 'var(--text-muted)' : '#52b788')}">
                ${playerState.reputation.greyford}
            </span>
        </li>
        <li>
            <span>Орден Кинджалів:</span>
            <span class="neutral" style="color: var(--text-muted);">${playerState.reputation.knives}</span>
        </li>
        <li>
            <span>Хейзмур:</span>
            <span class="neutral" style="color: var(--text-muted);">${playerState.reputation.hazemoor}</span>
        </li>
    `;
}

function addItem(item) {
    if (playerState.inventory.length < 4 && !playerState.inventory.includes(item)) {
        playerState.inventory.push(item);
        addToLog(`Знайдено предмет: ${item}`, "success");
        updateUi();
    }
}

function addToLog(message, type = "system") {
    const logDiv = document.getElementById("combat-log");
    const msgElement = document.createElement("div");
    msgElement.className = `log-msg ${type}`;
    msgElement.textContent = `[${new Date().toLocaleTimeString()}] ${message}`;
    logDiv.appendChild(msgElement);
    logDiv.scrollTop = logDiv.scrollHeight;
}

// Ініціалізація лору по дефолту при завантаженні сторінки
renderFileList("design");
