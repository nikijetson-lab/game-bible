// ==========================================
// ПОРТАЛ МАНДРУЮЧОГО ВАРТОВОГО — ЛОГІКА ТА ГРА
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
        { name: "Фракції (factions.md)", path: "design/factions.md" }
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
        { name: "Ілія (iliya.md)", path: "characters/iliya.md" },
        { name: "Міа / Касандра (mia.md)", path: "characters/mia.md" },
        { name: "Лілея (lileya.md)", path: "characters/lileya.md" },
        { name: "Тесса (tessa.md)", path: "characters/tessa.md" },
        { name: "Одрін (odrin.md)", path: "characters/odrin.md" },
        { name: "Блазень (jester.md)", path: "characters/jester.md" }
    ],
    quests: [
        { name: "1.  Адресат відсутній (greyford-01)", path: "quests/greyford-01-adresat-vidsutniy.md" },
        { name: "2.  Шлях крізь болото (hazemoor-01)", path: "quests/hazemoor-01-shlyakh-kriz-boloto.md" },
        { name: "3.  Сім уроків болота (muri-path-01)", path: "quests/muri-path-01-seven-lessons-old.md" },
        { name: "4.  Галявина і дух (hazemoor-02)", path: "quests/hazemoor-02-halyna-dusha.md" },
        { name: "5.  Квести Тихого Шелесту (tykhy-shelist)", path: "quests/tykhy-shelist-quests.md" },
        { name: "6.  Валькорн: Людина з болота", path: "quests/valkorn-01-lyudyna-z-bolota.md" },
        { name: "7.  Валькорн: Дві версії правди", path: "quests/valkorn-02-dvi-versii-pravdy.md" },
        { name: "8.  Валькорн: Правильна ціна", path: "quests/valkorn-03-pravylna-tsina.md" },
        { name: "9.  Валькорн: Людина, що послала", path: "quests/valkorn-04-lyudyna-shcho-poslala-rufina.md" },
        { name: "10. Валькорн: Хранитель Першої Печатки", path: "quests/valkorn-05-khranitel-pershoyi-pechatky.md" },
        { name: "11. Глибоке болото: Голос із туману", path: "quests/deep-bog-01-holos-iz-tumanu.md" },
        { name: "12. Глибоке болото: Шалений пором", path: "quests/deep-bog-02-shalyaniy-porom.md" },
        { name: "13. Глибоке болото: Затоплена обитель", path: "quests/deep-bog-03-zatoplena-obytel.md" },
        { name: "14. Обидва береги: Повернення до Валькорна", path: "quests/episode-4-01-povernennya-do-valkorna.md" },
        { name: "15. Обидва береги: Кульмінація Валькорна", path: "quests/episode-4-02-kulminatsiya-valkorna.md" },
        { name: "16. Обидва береги: Хейзмур та Серце Моура", path: "quests/episode-4-03-hazemoor-moura.md" },
        { name: "17. Обидва береги: Велика розв'язка", path: "quests/episode-4-04-final-rozvyazka.md" },
        { name: "18. Обидва береги: Відхід Героя", path: "quests/episode-4-05-vidhid-heroya.md" },
        { name: "19. Додатковий: Голод знизу", path: "quests/holod-znuzu.md" },
        { name: "20. Додатковий: Матриця наслідків", path: "quests/holod-znuzu-naslidky.md" },
        { name: "21. Додатковий: Сіль у книзі", path: "quests/sil-u-knyzi.md" },
        { name: "22. Додатковий: Поромна присяга", path: "quests/poromna-prysyaga.md" },
        { name: "23. Додатковий: Попіл під каплицею", path: "quests/popil-pid-kaplytseyu.md" },
        { name: "24. Додатковий: Ніж квоти", path: "quests/nizh-kvoty.md" },
        { name: "25. Додатковий: Ланцюжок Хейзмуру", path: "quests/hazemoor-lantsyuzhok.md" }
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
        
        if (!gameStarted) {
            // Показуємо вікно створення персонажа
            document.getElementById("character-creation").style.display = "flex";
            document.getElementById("main-simulator-interface").style.display = "none";
        }
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
    if (!fileListDiv) return;
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
    if (!contentDiv) return;
    contentDiv.innerHTML = '<div class="intro-screen"><p>Завантаження документа...</p></div>';

    // Завантажуємо файл відносно кореня репозиторію
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
                    <p style="font-size: 0.8rem; color: var(--text-muted);">Переконайтеся, що ви запустили локальний сервер за допомогою start-server.ps1 у папці репозиторію.</p>
                </div>
            `;
        });
}

// --- ЛЕГКИЙ КЛІЄНТСЬКИЙ MARKDOWN ПАРСЕР ---
function parseMarkdown(md) {
    if (!md) return "";
    let html = md;

    // Очищення frontmatter
    html = html.replace(/^---[\s\S]+?---/, '');

    // Екранування HTML
    html = html.replace(/</g, "&lt;").replace(/>/g, "&gt;");

    // Заголовки
    html = html.replace(/^# (.*$)/gim, '<h1>$1</h1>');
    html = html.replace(/^## (.*$)/gim, '<h2>$1</h2>');
    html = html.replace(/^### (.*$)/gim, '<h3>$1</h3>');

    // Списки
    html = html.replace(/^\s*-\s+(.*$)/gim, '<li>$1</li>');
    html = html.replace(/(<li>.*<\/li>)/gim, '<ul>$1</ul>');
    html = html.replace(/<\/ul>\s*<ul>/g, ''); 

    // Цитати
    html = html.replace(/^&gt;\s*(.*$)/gim, '<blockquote>$1</blockquote>');

    // Стилі тексту
    html = html.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>');
    html = html.replace(/\*(.*?)\*/g, '<em>$1</em>');

    // Розділювачі
    html = html.replace(/---/g, '<hr>');

    // Параграфи
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
    name: "Яромир",
    gender: "Чоловік",
    background: "Колишній засуджений",
    hp: 100,
    will: 50,
    maxHp: 100,
    maxWill: 50,
    doctrines: {
        pathfinder: 0,
        lantern: 0,
        judge: 0,
        mediator: 0
    },
    reputation: {
        greyford: 0,
        knives: 0,
        keepers: 0,
        muri: 0
    },
    resources: {
        henbane: 0,
        loosestrife: 0,
        peganum: 0,
        bogiron: 0,
        silver: 0,
        slate: 0,
        slime: 0,
        heart: 0,
        tendons: 0,
        water: 0,
        ash: 0
    },
    inventory: ["📜 Лист Руфіна"],
    clues: {
        room: false,
        carver: false,
        tavern: false,
        witch: false,
        witch_hint: false
    },
    history: []
};

// --- ДЕРЕВО ПЕРЕДІСТОРІЙ ---
const BACKGROUND_DETAILS = {
    "Колишній засуджений": {
        desc: "Ви провели роки в глибоких кам'яних шахтах або темних казематах Валькорна. Орден Семи Кинджалів забрав вас із ланцюгів у обмін на службу в багнюці.",
        resources: { bogiron: 1, tendons: 1 },
        rep: { greyford: -15, knives: 15, keepers: 0, muri: 0 }
    },
    "Втікач з Валькорна": {
        desc: "Ви втекли від боргів чи закону з блискучих палат Валькорна. Ваші манери видають у вас людину культури, яка змушена виживати серед покидьків.",
        resources: { silver: 1, water: 1 },
        rep: { greyford: 15, knives: 0, keepers: -10, muri: 0 }
    },
    "Втрачений учень": {
        desc: "Ви навчалися у великих академіях магії чи орденах, але були вигнані за заборонені дослідження. Болото — це ваше нове святилище та лабораторія.",
        resources: { ash: 1, water: 1, slate: 1 },
        rep: { greyford: 0, knives: 0, keepers: 20, muri: -10 }
    },
    "Місцевий мисливець": {
        desc: "Ви народилися під боком у болота. Кожен корінь, кожен шерех очерету вам знайомий. Для вас Хейзмур — не прокляття, а суворий дім.",
        resources: { loosestrife: 1, henbane: 1, slime: 1 },
        rep: { greyford: -10, knives: 0, keepers: 0, muri: 20 }
    }
};

let creationState = {
    name: "Яромир",
    gender: "Чоловік",
    background: "Колишній засуджений",
    pointsLeft: 5,
    doctrines: {
        pathfinder: 0,
        lantern: 0,
        judge: 0,
        mediator: 0
    }
};

// Ініціалізація створення персонажа
function initCharacterCreation() {
    // Ім'я
    const nameInput = document.getElementById("char-name");
    if (nameInput) {
        nameInput.addEventListener("input", (e) => {
            creationState.name = e.target.value.trim() || "Яромир";
        });
    }

    // Стать
    const genderBtns = document.querySelectorAll(".gender-btn");
    genderBtns.forEach(btn => {
        btn.addEventListener("click", (e) => {
            genderBtns.forEach(b => b.classList.remove("active"));
            const chosen = btn.getAttribute("data-gender");
            creationState.gender = chosen;
            btn.classList.add("active");
        });
    });

    // Передісторія
    const bgSelect = document.getElementById("char-background");
    const bgDescDiv = document.getElementById("background-description");
    if (bgSelect && bgDescDiv) {
        bgSelect.addEventListener("change", (e) => {
            const chosen = e.target.value;
            creationState.background = chosen;
            bgDescDiv.textContent = BACKGROUND_DETAILS[chosen].desc;
        });
    }

    // Розподіл очок доктрин
    const distBtns = document.querySelectorAll(".dist-btn");
    distBtns.forEach(btn => {
        btn.addEventListener("click", () => {
            const stat = btn.getAttribute("data-stat");
            const isPlus = btn.classList.contains("plus");
            
            if (isPlus) {
                if (creationState.pointsLeft > 0) {
                    creationState.doctrines[stat]++;
                    creationState.pointsLeft--;
                }
            } else {
                if (creationState.doctrines[stat] > 0) {
                    creationState.doctrines[stat]--;
                    creationState.pointsLeft++;
                }
            }
            
            // Оновлення DOM
            document.getElementById(`val-${stat}`).textContent = creationState.doctrines[stat];
            document.getElementById("creation-points-left").textContent = creationState.pointsLeft;
            
            // Оновлення доступності кнопок
            updateDistributorButtons();
        });
    });

    // Кнопка початку гри
    const startBtn = document.getElementById("start-journey-btn");
    if (startBtn) {
        startBtn.addEventListener("click", () => {
            if (creationState.pointsLeft > 0) {
                alert("Будь ласка, розподіліть усі 5 стартових очок між Доктринами!");
                return;
            }
            
            // Переносимо дані в playerState
            playerState.name = creationState.name;
            playerState.gender = creationState.gender;
            playerState.background = creationState.background;
            playerState.doctrines = { ...creationState.doctrines };
            
            // Задаємо ресурси та репутацію за бекграунд
            const bgData = BACKGROUND_DETAILS[playerState.background];
            playerState.resources = {
                henbane: 0, loosestrife: 0, peganum: 0, bogiron: 0, silver: 0,
                slate: 0, slime: 0, heart: 0, tendons: 0, water: 0, ash: 0
            };
            for (const [res, amt] of Object.entries(bgData.resources)) {
                playerState.resources[res] = amt;
            }
            playerState.reputation = { ...bgData.rep };
            
            playerState.inventory = ["📜 Лист Руфіна"];
            playerState.clues = {
                room: false,
                carver: false,
                tavern: false,
                witch: false,
                witch_hint: false
            };
            playerState.history = [];
            
            // Оновлюємо бічну панель статусу
            document.getElementById("sidebar-hero-name").textContent = `⚖️ ${playerState.name.toUpperCase()}`;
            document.getElementById("sidebar-hero-gender").textContent = `🙋‍♂️ ${playerState.gender}`;
            document.getElementById("sidebar-hero-bg").textContent = playerState.background;
            document.getElementById("sidebar-stat-pathfinder").textContent = playerState.doctrines.pathfinder;
            document.getElementById("sidebar-stat-lantern").textContent = playerState.doctrines.lantern;
            document.getElementById("sidebar-stat-judge").textContent = playerState.doctrines.judge;
            document.getElementById("sidebar-stat-mediator").textContent = playerState.doctrines.mediator;
            
            // Ховаємо створення, показуємо симулятор
            document.getElementById("character-creation").style.display = "none";
            document.getElementById("main-simulator-interface").style.display = "grid";
            
            startGameFlow();
        });
    }

    // Крафтинг кнопки
    document.getElementById("craft-ointment").addEventListener("click", () => craftItem("ointment"));
    document.getElementById("craft-antidote").addEventListener("click", () => craftItem("antidote"));
    document.getElementById("craft-amulet").addEventListener("click", () => craftItem("amulet"));
    document.getElementById("craft-trap").addEventListener("click", () => craftItem("trap"));

    updateDistributorButtons();
}

function updateDistributorButtons() {
    const stats = ["pathfinder", "lantern", "judge", "mediator"];
    stats.forEach(stat => {
        const val = creationState.doctrines[stat];
        const minusBtn = document.querySelector(`.dist-btn.minus[data-stat="${stat}"]`);
        const plusBtn = document.querySelector(`.dist-btn.plus[data-stat="${stat}"]`);
        
        if (minusBtn) minusBtn.disabled = (val === 0);
        if (plusBtn) plusBtn.disabled = (creationState.pointsLeft === 0);
    });
}

// --- БАЗА ДАНИХ ІГРОВИХ СЦЕН ---
const GAME_SCENES = {
    arriving: {
        title: "Постоялий двір Грейфорда",
        text: `Ви входите у напівтемну таверну. За шинком стоїть Ерван — хазяїн закладу. Ви підходите і запитуєте про Руфіна. Ерван мовчки бере ваш лист, дивиться на дивну печатку (два перехрещені кинджали, коло і крапля), тримає його на мить довше, ніж варто звичайному паперу...<br><br>Потім піднімає на вас очі і запитує:<br><em>«І що він тобі був — друг, боржник, чи ти просто наймит-кур'єр?»</em>`,
        choices: [
            { 
                text: "«Ми домовились. Я приїхав виконати свою частину обов'язку.» (Шлях Ідеаліста)", 
                cost: "will:0",
                action: () => chooseMotivation("Ідеаліст", "Ерван киває з повагою: «Людина обов'язку в наші часи — рідкість. Ось ключ від його кімнати нагорі.»", "investigation")
            },
            { 
                text: "«Він мав дещо, що мені потрібно. Це особиста справа.» (Особистий Інтерес)", 
                cost: "will:0",
                action: () => chooseMotivation("Особистий інтерес", "Ерван примружується: «У всіх тут свої інтереси. Тримай ключ, кімната на другому поверсі.»", "investigation")
            },
            { 
                text: "«Я просто доставляю листа. Що далі — моя проблема.» (Прагматик)", 
                cost: "will:0",
                action: () => chooseMotivation("Прагматик", "Ерван хмикає: «Просто наймит. Це безпечніше. Ключ твій, роби своє діло.»", "investigation")
            },
            {
                text: "⚖️ [Суддя] «Я представляю закон Грейфорда. Ти зобов'язаний співпрацювати зі слідством.»",
                cost: "will:0",
                visible: () => playerState.doctrines.judge >= 1,
                action: () => chooseMotivation("Суддя", "Ерван стримано киває: «Закон... Що ж, ми поважаємо закон міста, хоча болото його не чує. Ось ключ від кімнати Руфіна.»", "investigation")
            }
        ]
    },
    investigation: {
        title: "Розслідування у Грейфорді",
        text: `Ерван повідомив, що картограф Руфін зник три дні тому. Його кімната досі оплачена, речі лежать недоторканими на другому поверсі таверни.<br><br>У вас є три головні нитки розслідування у Грейфорді. Дослідіть принаймні дві, щоб зібрати достатньо доказів і рушити за його слідами:`,
        choices: [
            { 
                text: "🚪 Оглянути кімнату Руфіна на другому поверсі таверни", 
                cost: "will:0",
                action: () => goThread("room") 
            },
            { 
                text: "🛠️ Відвідати квартал ремісників та поговорити з різьбярем", 
                cost: "will:0",
                action: () => goThread("carver") 
            },
            { 
                text: "🍻 Завітати у портову таверну та розпитати куртизанку Касандру", 
                cost: "will:0",
                action: () => goThread("tavern") 
            },
            { 
                text: "🧙‍♀️ Оглянути будинок Чаклунки на околиці (Доступно після виявлення знаків)", 
                cost: "will:0",
                visible: () => playerState.clues.witch_hint === true,
                action: () => goThread("witch") 
            },
            { 
                text: "🚪 Іти до воріт міста та вирушати в Хейзмур (Потрібно знайти докази)", 
                cost: "will:0",
                visible: () => (Object.values(playerState.clues).filter(v => v === true && v !== "witch_hint").length >= 2),
                action: () => goScene("gates") 
            }
        ]
    },
    thread_room: {
        title: "Кімната Руфіна",
        text: `Ви заходите в порожню, пильну кімнату. Тут лежить зношений плащ картографа, дорожній посох та шкіряна сумка з незвичайним тавром у вигляді змії.<br><br>Що ви будете робити?`,
        choices: [
            {
                text: "🔍 Детально обшукати особисті речі (Звичайний пошук)",
                action: () => {
                    playerState.clues.room = true;
                    addToLog("Знайдено шкіряну сумку з тавром ремісничого кварталу.", "success");
                    addItem("🎒 Сумка Руфіна");
                    adjustResource("bogiron", 1);
                    adjustResource("water", 1);
                    goScene("investigation");
                }
            },
            {
                text: "🏕️ [Слідопит] Дослідити сліди бруду на підлозі",
                visible: () => playerState.doctrines.pathfinder >= 1,
                action: () => {
                    playerState.clues.room = true;
                    addToLog("Слідопит виявив: болотяна глина на підлозі — чорний торф з глибин Хейзмуру. Руфін таємно ходив у болота ще до свого зникнення!", "success");
                    addItem("🎒 Сумка Руфіна");
                    adjustResource("loosestrife", 2);
                    adjustResource("slate", 1);
                    adjustReputation("muri", 10);
                    goScene("investigation");
                }
            },
            {
                text: "💡 [Ліхтар] Оглянути стіни та одвірки на наявність прихованої магії",
                visible: () => playerState.doctrines.lantern >= 1,
                action: () => {
                    playerState.clues.room = true;
                    playerState.clues.witch_hint = true;
                    addToLog("Ліхтар виявив: leдь помітні захисні руни над дверима. Руфін захищався не від людей, а від чогось, що притягнув із болота! Знаки ведуть до чаклунки.", "success");
                    addItem("🎒 Сумка Руфіна");
                    adjustResource("ash", 1);
                    adjustResource("slate", 1);
                    adjustReputation("keepers", 10);
                    goScene("investigation");
                }
            }
        ]
    },
    thread_carver: {
        title: "Квартал ремісників — Різьбяр",
        text: `Ви знаходите майстерню різьбяра по дереву. Старий майстер працює над викривленою гілкою і неохоче реагує на ваші запитання про Руфіна. «Багато хто приходить і йде. Чому я маю допомагати кожному Вартовийу?»`,
        choices: [
            {
                text: "📜 Показати запечатаний лист Руфіна з дивною восковою печаткою",
                action: () => {
                    playerState.clues.carver = true;
                    addToLog("Різьбяр побачив печатку, здригнувся і сказав: «Руфін питав про дорогу до Тихого Шелесту. Шукав там когось.»", "success");
                    adjustResource("bogiron", 2);
                    adjustReputation("knives", 15);
                    goScene("investigation");
                }
            },
            {
                text: "🏕️ [Слідопит] Заговорити про болотяне дерево, з яким він працює",
                visible: () => playerState.doctrines.pathfinder >= 1,
                action: () => {
                    playerState.clues.carver = true;
                    addToLog("Ви впізнали корінь-вербу з глибин болота. Вражений різьбяр розповів більше: «Руфін ніс щось дуже важке перед виходом. Він ледве йшов.»", "success");
                    adjustResource("tendons", 2);
                    adjustResource("bogiron", 1);
                    adjustReputation("muri", 15);
                    goScene("investigation");
                }
            },
            {
                text: "🤝 [Посередник] Запропонувати взаємовигідну угоду",
                visible: () => playerState.doctrines.mediator >= 1,
                action: () => {
                    playerState.clues.carver = true;
                    addToLog("Ви домовилися розізнати долю його боргів у порту. Різьбяр зізнався: «Руфін мав велику справу. Хтось оплатив йому цю подорож сріблом!»", "success");
                    adjustResource("silver", 2);
                    adjustReputation("greyford", 15);
                    goScene("investigation");
                }
            },
            {
                text: "💡 [Ліхтар] Вказати на болотяні захисні знаки над його дверима",
                visible: () => playerState.doctrines.lantern >= 1,
                action: () => {
                    playerState.clues.carver = true;
                    playerState.clues.witch_hint = true;
                    addToLog("Майстер бачить, що ви розумієте руни. Він шепоче: «Руфін був наляканий до смерті. Він ставив ці знаки перед виходом вночі.»", "success");
                    adjustResource("slate", 2);
                    adjustReputation("keepers", 15);
                    goScene("investigation");
                }
            }
        ]
    },
    thread_tavern: {
        title: "Портова таверна",
        text: `У брудному шинку біля причалу бармен протирає склянку. «Руфін? Так, сидів тут три дні тому. Спілкувався з однією дівчиною — куртизанкою на ім'я Касандра. Вона зараз сидить за кутовим столиком.»<br><br>Касандра дивиться на вас із підозрою і не поспішає відкривати душу першому ліпшому Вартовийу.`,
        choices: [
            {
                text: "🗣️ Спробувати розговорити її або показати рекомендацію Ервана",
                action: () => {
                    playerState.clues.tavern = true;
                    addToLog("Касандра розповіла: «Руфін казав, що щось у Хейзмурі не чекає на людей. Він пішов наляканий, але цілеспрямовано.»", "success");
                    adjustResource("loosestrife", 2);
                    adjustReputation("greyford", 10);
                    goScene("investigation");
                }
            },
            {
                text: "🤝 [Посередник] Заговорити про гроші та срібло Руфіна",
                visible: () => playerState.doctrines.mediator >= 1,
                action: () => {
                    playerState.clues.tavern = true;
                    addToLog("Касандра зізнається: «Він платив чистим сріблом, а не міддю. Хтось дуже багатий найняв його для цієї подорожі.»", "success");
                    adjustResource("silver", 1);
                    adjustResource("peganum", 1);
                    adjustReputation("knives", 10);
                    goScene("investigation");
                }
            },
            {
                text: "⚖️ [Суддя] «Перешкоджання офіційному слідству Ордену карається суворо. Говори правду.»",
                visible: () => playerState.doctrines.judge >= 1,
                action: () => {
                    playerState.clues.tavern = true;
                    addToLog("Касандра злякано шепоче: «Не треба погроз! Він шукав старого провідника мурі. Заберіть цей слиз мурі, що він забув на столі, тільки не чіпайте мене!»", "success");
                    adjustResource("slime", 2);
                    adjustReputation("greyford", 20);
                    adjustReputation("knives", -10);
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
                text: "🗣️ Просто запитати, що вона бачила тієї ночі",
                action: () => {
                    playerState.clues.witch = true;
                    addToLog("Вона каже: «Він ніс важку річ, яка горіла холодним світлом у темряві. Це було моторошно.»", "success");
                    adjustResource("henbane", 1);
                    adjustReputation("muri", 10);
                    goScene("investigation");
                }
            },
            {
                text: "💡 [Ліхтар] Розпитати про магічне світіння його речей",
                visible: () => playerState.doctrines.lantern >= 1,
                action: () => {
                    playerState.clues.witch = true;
                    addToLog("Чаклунка шепоче: «Він ніс щось, що світилося в темряві зеленим вогнем. Це древній артефакт боліт!»", "success");
                    addItem("🧿 Болотяний амулет");
                    adjustResource("ash", 1);
                    adjustResource("heart", 1);
                    adjustResource("henbane", 2);
                    adjustReputation("keepers", 20);
                    goScene("investigation");
                }
            },
            {
                text: "🤝 [Посередник] Спробувати купити її знання",
                visible: () => playerState.doctrines.mediator >= 1,
                action: () => {
                    playerState.clues.witch = true;
                    addToLog("За жменю мідяків вона зізналася: «Він купив це світіння у когось дуже впливового в Грейфорді.»", "success");
                    adjustResource("henbane", 2);
                    adjustReputation("greyford", -10);
                    goScene("investigation");
                }
            }
        ]
    },
    gates: {
        title: "Міські Ворота — Вихід у Хейзмур",
        text: `Ви зібрали достатньо доказів і підходите до важких дерев'яних воріт, що ведуть у туманні болота Хейзмуру. Сержант воріт перевіряє свої записи: «Так, Руфін вийшов три дні тому в напрямку Тихого Шелесту. Це там, де закінчується дорога і починається чуже.»<br><br>Він уважно дивиться на вас: <em>«Ти теж туди? З якого приводу Вартовий іде в болота?»</em>`,
        choices: [
            {
                text: "«Я шукаю людину. Руфін пішов і не повернувся, я маю його знайти.» (Правда)",
                action: () => {
                    adjustReputation("greyford", 20);
                    adjustReputation("knives", 10);
                    finishQuest("Правда", "Сержант киває: «Благородна мета. Нехай закон світить тобі в тумані.»");
                }
            },
            {
                text: "«Я маю перевірити маршрут. Є скарги на безпеку поселення.» (Напівправда)",
                action: () => {
                    adjustReputation("greyford", 5);
                    adjustReputation("knives", -5);
                    finishQuest("Напівправда", "Сержант скептично хмикає: «Безпека? У Хейзмурі немає безпеки. Ну йди, раз це наказ.»");
                }
            },
            {
                text: "«У мене офіційна робота. Лист — мій єдиний пропуск.» (Ухилення)",
                action: () => {
                    adjustReputation("greyford", -20);
                    adjustReputation("knives", -10);
                    finishQuest("Ухилення", "Сержант примружується і записує щось у журнал: «Таємниці... Ну що ж, запишемо як офіційний візит.»");
                }
            },
            {
                text: "⚖️ [Суддя] «Я виконую офіційне доручення суду Грейфорда щодо зниклого картографа. Зареєструйте мій вихід.»",
                visible: () => playerState.doctrines.judge >= 1,
                action: () => {
                    adjustReputation("greyford", 30);
                    adjustReputation("knives", 15);
                    finishQuest("Судове доручення", "Сержант витягується струнко і віддає честь: «Зрозуміло, пане Суддя. Ваша подорож внесена до реєстру. Нехай закон допоможе вам подолати туман боліт.»");
                }
            }
        ]
    },
    ending: {
        title: "Квест Завершено: Адресат відсутній",
        text: "", // Заповнюється динамічно у функції finishQuest
        choices: [
            {
                text: "🎮 Почати подорож заново іншим Вартовийом",
                action: () => resetGame()
            }
        ]
    }
};

// --- УПРАВЛІННЯ ІГРОВИМ ПРОЦЕСОМ ---
function startGameFlow() {
    gameStarted = true;
    
    // Очищуємо лог та додаємо перше повідомлення
    const logDiv = document.getElementById("combat-log");
    logDiv.innerHTML = '<div class="log-msg system">Ви розпочали подорож Мандруючого Вартового. Порожній Сезон розпочався.</div>';
    addToLog(`Вартовий ${playerState.name} (Передісторія: ${playerState.background}) прибув до Грейфорда.`, "system");
    
    updateUi();
    goScene("arriving");
}

function chooseMotivation(motivation, dialogReply, nextScene) {
    playerState.history.push({ step: "motivation", choice: motivation });
    
    // Репутаційні наслідки
    if (motivation === "Ідеаліст") {
        adjustReputation("greyford", 15);
        adjustReputation("knives", 5);
    } else if (motivation === "Особистий інтерес") {
        adjustReputation("greyford", -5);
        adjustReputation("knives", 10);
    } else if (motivation === "Суддя") {
        adjustReputation("greyford", 20);
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
        summaryText = `Ви провели **блискуче слідство**! Ви оглянули кімнату Руфіна, розговорили різьбяра та розкрили таємницю через куртизанку Касандру. 
        <br><br>
        <strong>Ваші висновки:</strong>
        <ul>
            <li>Руфін пішов у Тихий Шелест цілеспрямовано. Він не тікав, а виконував чиєсь завдання.</li>
            <li>Його подорож була оплачена чистим сріблом впливової особи з Грейфорда (можливо, Ордену).</li>
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

    addToLog(`Квест завершено з результатом: ${investigationGrade}`, "success");

    // Визначаємо репутаційні фінали
    const repDetails = [];
    ["greyford", "knives", "keepers", "muri"].forEach(faction => {
        const val = playerState.reputation[faction];
        const status = getReputationStatus(val);
        const fNames = {
            greyford: "Адміністрація Грейфорда",
            knives: "Орден Семи Кинджалів",
            keepers: "Хранителі Святої Вей",
            muri: "Мурі (Жаболюди)"
        };
        repDetails.push(`<p>• ${fNames[faction]}: <strong>${val > 0 ? '+' : ''}${val}</strong> (${status.text})</p>`);
    });

    // Рендеринг екрану фіналу
    const endingScene = GAME_SCENES.ending;
    endingScene.text = `
        <span class="quest-tag" style="color: var(--accent-gold);">РЕЗУЛЬТАТ: ${investigationGrade.toUpperCase()}</span>
        <h2 style="font-family: var(--font-gothic); color: var(--accent-gold); margin-top: 1rem; margin-bottom: 1rem;">⚖️ ВЕРДИКТ ВАРТОВОГО</h2>
        ${summaryText}
        <hr style="border: 0; height: 1px; background: var(--border-color); margin: 1.5rem 0;">
        <h3 style="font-family: var(--font-gothic); color: var(--accent-gold); margin-bottom: 0.5rem;">📊 Наслідки ваших рішень:</h3>
        <p>• <strong>Мотивація Вартовийа:</strong> ви обрали шлях <em>"${playerState.history[0].choice}"</em>.</p>
        <p>• <strong>Відповідь воротам:</strong> ваша відповідь сержанту була записана як <em>"${gateAnswer}"</em>.</p>
        <br>
        <h4 style="font-family: var(--font-gothic); color: var(--accent-gold); margin-bottom: 0.3rem;">👑 Ваша підсумкова репутація фракцій:</h4>
        ${repDetails.join("")}
        <br>
        <p class="gold-text" style="font-style: italic; font-weight: 600;">Шлях до поселення Тихий Шелест відкрито. Порожній Сезон чекає на Мандруючого Вартового у глибинах Хейзмуру...</p>
    `;

    goScene("ending");
}

function resetGame() {
    gameStarted = false;
    creationState = {
        name: "Яромир",
        gender: "Чоловік",
        background: "Колишній засуджений",
        pointsLeft: 5,
        doctrines: {
            pathfinder: 0,
            lantern: 0,
            judge: 0,
            mediator: 0
        }
    };
    
    // Скидаємо поля в DOM
    document.getElementById("char-name").value = "Яромир";
    document.getElementById("char-background").value = "Колишній засуджений";
    document.getElementById("background-description").textContent = BACKGROUND_DETAILS["Колишній засуджений"].desc;
    
    document.querySelectorAll(".gender-btn").forEach(btn => btn.classList.remove("active"));
    const maleBtn = document.querySelector('.gender-btn[data-gender="Чоловік"]');
    if (maleBtn) maleBtn.classList.add("active");
    
    const stats = ["pathfinder", "lantern", "judge", "mediator"];
    stats.forEach(stat => {
        document.getElementById(`val-${stat}`).textContent = 0;
    });
    document.getElementById("creation-points-left").textContent = 5;
    
    updateDistributorButtons();
    
    document.getElementById("character-creation").style.display = "flex";
    document.getElementById("main-simulator-interface").style.display = "none";
}

// --- УПРАВЛІННЯ РЕСУРСАМИ ---
function adjustResource(name, amount) {
    if (playerState.resources[name] !== undefined) {
        playerState.resources[name] = Math.max(0, playerState.resources[name] + amount);
        
        const ukNames = {
            henbane: "Блекота",
            loosestrife: "Плакун-трава",
            peganum: "Могильник",
            bogiron: "Болотяна руда",
            silver: "Біле срібло",
            slate: "Чорний сланець",
            slime: "Слиз мурі",
            heart: "Серце болотяника",
            tendons: "Сухі сухожилля",
            water: "Прадавня вода",
            ash: "Духовний попіл"
        };
        
        if (amount > 0) {
            addToLog(`Отримано ресурс: ${ukNames[name]} (+${amount})`, "success");
        } else if (amount < 0) {
            addToLog(`Витрачено ресурс: ${ukNames[name]} (${amount})`, "system");
        }
        
        updateUi();
    }
}

// --- КРАФТИНГ АЛГЕБРА ---
function craftItem(recipeName) {
    if (playerState.inventory.length >= 4) {
        addToLog("Сумка переповнена! Максимальний ліміт інвентарю — 4 активні предмети.", "damage");
        return;
    }

    let success = false;
    let craftedItemName = "";
    
    if (recipeName === "ointment") {
        if (playerState.resources.henbane >= 1 && playerState.resources.slime >= 1) {
            playerState.resources.henbane -= 1;
            playerState.resources.slime -= 1;
            craftedItemName = "🍯 Болотяна мазь";
            success = true;
        }
    } else if (recipeName === "antidote") {
        if (playerState.resources.loosestrife >= 1 && playerState.resources.water >= 1) {
            playerState.resources.loosestrife -= 1;
            playerState.resources.water -= 1;
            craftedItemName = "🧪 Протиотрута";
            success = true;
        }
    } else if (recipeName === "amulet") {
        if (playerState.resources.ash >= 1 && playerState.resources.silver >= 1) {
            playerState.resources.ash -= 1;
            playerState.resources.silver -= 1;
            craftedItemName = "🧿 Містичний оберіг";
            success = true;
        }
    } else if (recipeName === "trap") {
        if (playerState.resources.bogiron >= 1 && playerState.resources.tendons >= 1) {
            playerState.resources.bogiron -= 1;
            playerState.resources.tendons -= 1;
            craftedItemName = "🪤 Капкан";
            success = true;
        }
    }
    
    if (success) {
        addToLog(`Зкрафчено предмет: ${craftedItemName}!`, "success");
        addItem(craftedItemName);
        updateUi();
    } else {
        addToLog(`Недостатньо ресурсів для створення предмету!`, "damage");
    }
}

// --- РЕПУТАЦІЙНА ШКАЛА (-100 до +100) ---
function adjustReputation(faction, delta) {
    if (playerState.reputation[faction] !== undefined) {
        playerState.reputation[faction] = Math.max(-100, Math.min(100, playerState.reputation[faction] + delta));
        
        const factionNames = {
            greyford: "Адміністрація Грейфорда",
            knives: "Орден Семи Кинджалів",
            keepers: "Хранителі Святої Вей",
            muri: "Мурі (Жаболюди)"
        };
        
        if (delta > 0) {
            addToLog(`Репутація з [${factionNames[faction]}] зросла (+${delta})`, "reputation");
        } else if (delta < 0) {
            addToLog(`Репутація з [${factionNames[faction]}] впала (${delta})`, "damage");
        }
        
        updateUi();
    }
}

function getReputationStatus(value) {
    if (value <= -61) {
        return { text: "Ворог народу", class: "enemy-of-people" };
    } else if (value <= -21) {
        return { text: "Зневажений", class: "despised" };
    } else if (value <= 20) {
        return { text: "Нейтральний", class: "neutral" };
    } else if (value <= 60) {
        return { text: "Шанований", class: "respected" };
    } else {
        return { text: "Герой Боліт", class: "hero-of-swamps" };
    }
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
    if (invGrid) {
        invGrid.innerHTML = "";
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
    }

    // Оновлення ресурсів виживання
    const resources = ["henbane", "loosestrife", "peganum", "bogiron", "silver", "slate", "slime", "heart", "tendons", "water", "ash"];
    resources.forEach(res => {
        const el = document.getElementById(`res-${res}`);
        if (el) el.textContent = playerState.resources[res];
    });

    // Оновлення доступності крафтингу
    const craftOintment = document.getElementById("craft-ointment");
    if (craftOintment) craftOintment.disabled = !(playerState.resources.henbane >= 1 && playerState.resources.slime >= 1);
    
    const craftAntidote = document.getElementById("craft-antidote");
    if (craftAntidote) craftAntidote.disabled = !(playerState.resources.loosestrife >= 1 && playerState.resources.water >= 1);
    
    const craftAmulet = document.getElementById("craft-amulet");
    if (craftAmulet) craftAmulet.disabled = !(playerState.resources.ash >= 1 && playerState.resources.silver >= 1);
    
    const craftTrap = document.getElementById("craft-trap");
    if (craftTrap) craftTrap.disabled = !(playerState.resources.bogiron >= 1 && playerState.resources.tendons >= 1);

    // Оновлення числової репутації
    const factions = ["greyford", "knives", "keepers", "muri"];
    factions.forEach(faction => {
        const val = playerState.reputation[faction];
        const status = getReputationStatus(val);
        
        const valEl = document.getElementById(`rep-val-${faction}`);
        if (valEl) {
            valEl.textContent = `${val > 0 ? '+' : ''}${val} / 100`;
            valEl.className = `faction-val ${status.class}`;
        }
        
        const barEl = document.getElementById(`rep-bar-${faction}`);
        if (barEl) {
            const pct = ((val + 100) / 2);
            barEl.style.width = `${pct}%`;
            barEl.className = `rep-bar-fill ${status.class}`;
        }
        
        const statusEl = document.getElementById(`rep-status-${faction}`);
        if (statusEl) {
            statusEl.textContent = status.text;
            statusEl.className = `faction-status ${status.class}`;
        }
    });
}

function addItem(item) {
    if (playerState.inventory.length < 4 && !playerState.inventory.includes(item)) {
        playerState.inventory.push(item);
        addToLog(`Отримано предмет в сумку: ${item}`, "success");
        updateUi();
    }
}

function addToLog(message, type = "system") {
    const logDiv = document.getElementById("combat-log");
    if (!logDiv) return;
    const msgElement = document.createElement("div");
    msgElement.className = `log-msg ${type}`;
    msgElement.textContent = `[${new Date().toLocaleTimeString()}] ${message}`;
    logDiv.appendChild(msgElement);
    logDiv.scrollTop = logDiv.scrollHeight;
}

// Перевантаження перемикання вкладок під створення персонажа
function switchTab(tab) {
    document.querySelectorAll("header nav button").forEach(btn => btn.classList.remove("active"));
    document.querySelectorAll(".view-section").forEach(sec => sec.classList.remove("active"));

    if (tab === "bible") {
        document.getElementById("nav-bible").classList.add("active");
        document.getElementById("section-bible").classList.add("active");
    } else {
        document.getElementById("nav-simulator").classList.add("active");
        document.getElementById("section-simulator").classList.add("active");
        
        if (!gameStarted) {
            document.getElementById("character-creation").style.display = "flex";
            document.getElementById("main-simulator-interface").style.display = "none";
        }
    }
}

// Ініціалізація лору по дефолту при завантаженні сторінки
renderFileList("design");
initCharacterCreation();
