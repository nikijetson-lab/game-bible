window.IS_DEV_TESTING = true;
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
    const audioToggle = document.getElementById("audio-toggle-btn");

    if (tab === "bible") {
        document.getElementById("nav-bible").classList.add("active");
        document.getElementById("section-bible").classList.add("active");
        if (audioToggle) audioToggle.style.display = "none";
    } else {
        document.getElementById("nav-simulator").classList.add("active");
        document.getElementById("section-simulator").classList.add("active");
        if (audioToggle) audioToggle.style.display = "inline-block";
        
        if (!gameStarted) {
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
// ⚔️ СИМУЛЯТОР ГРИ: АКТИВНИЙ СТАН ГЕРОЯ
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
    const nameInput = document.getElementById("char-name");
    if (nameInput) {
        nameInput.addEventListener("input", (e) => {
            creationState.name = e.target.value.trim() || "Яромир";
        });
    }

    const genderBtns = document.querySelectorAll(".gender-btn");
    genderBtns.forEach(btn => {
        btn.addEventListener("click", (e) => {
            genderBtns.forEach(b => b.classList.remove("active"));
            const chosen = btn.getAttribute("data-gender");
            creationState.gender = chosen;
            btn.classList.add("active");
        });
    });

    const bgSelect = document.getElementById("char-background");
    const bgDescDiv = document.getElementById("background-description");
    if (bgSelect && bgDescDiv) {
        bgSelect.addEventListener("change", (e) => {
            const chosen = e.target.value;
            creationState.background = chosen;
            bgDescDiv.textContent = BACKGROUND_DETAILS[chosen].desc;
        });
    }

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
            
            document.getElementById(`val-${stat}`).textContent = creationState.doctrines[stat];
            document.getElementById("creation-points-left").textContent = creationState.pointsLeft;
            
            updateDistributorButtons();
        });
    });

    const startBtn = document.getElementById("start-journey-btn");
    if (startBtn) {
        startBtn.addEventListener("click", () => {
            if (creationState.pointsLeft > 0) {
                alert("Будь ласка, розподіліть усі 5 стартових очок між Доктринами!");
                return;
            }
            
            window.playerState.name = creationState.name;
            window.playerState.gender = creationState.gender;
            window.playerState.background = creationState.background;
            window.playerState.doctrines = { ...creationState.doctrines };
            window.playerState.maxHp = 100;
            window.playerState.hp = 100;
            window.playerState.maxWill = 50;
            window.playerState.will = 50;
            
            const bgData = BACKGROUND_DETAILS[window.playerState.background];
            window.playerState.resources = {
                henbane: 0, loosestrife: 0, peganum: 0, bogiron: 0, silver: 0,
                slate: 0, slime: 0, heart: 0, tendons: 0, water: 0, ash: 0
            };
            for (const [res, amt] of Object.entries(bgData.resources)) {
                window.playerState.resources[res] = amt;
            }
            window.playerState.reputation = { ...bgData.rep };
            
            window.playerState.inventory = ["📜 Лист Руфіна"];
            window.playerState.clues = {
                room: false,
                carver: false,
                tavern: false,
                witch: false,
                witch_hint: false
            };
            window.playerState.history = [];
            
            document.getElementById("character-creation").style.display = "none";
            document.getElementById("main-simulator-interface").style.display = "flex";
            
            document.getElementById("sidebar-hero-name").textContent = `⚖️ ${window.playerState.name.toUpperCase()}`;
            document.getElementById("sidebar-hero-gender").textContent = `${window.playerState.gender === 'Чоловік' ? '🙋‍♂️' : window.playerState.gender === 'Жінка' ? '🙋‍♀️' : '👤'} ${window.playerState.gender}`;
            document.getElementById("sidebar-hero-bg").textContent = window.playerState.background;
            
            document.getElementById("sidebar-stat-pathfinder").textContent = window.playerState.doctrines.pathfinder;
            document.getElementById("sidebar-stat-lantern").textContent = window.playerState.doctrines.lantern;
            document.getElementById("sidebar-stat-judge").textContent = window.playerState.doctrines.judge;
            document.getElementById("sidebar-stat-mediator").textContent = window.playerState.doctrines.mediator;
            
            startGameFlow();
        });
    }
}

function updateDistributorButtons() {
    const plusBtns = document.querySelectorAll(".dist-btn.plus");
    const minusBtns = document.querySelectorAll(".dist-btn.minus");
    
    plusBtns.forEach(btn => {
        btn.disabled = creationState.pointsLeft <= 0;
    });
    
    minusBtns.forEach(btn => {
        const stat = btn.getAttribute("data-stat");
        btn.disabled = creationState.doctrines[stat] <= 0;
    });
}

// --- СИНТЕЗАТОР ГОТИЧНОЇ АТМОСФЕРИ (WEB AUDIO API) ---
class AtmosphereSynth {
    constructor() {
        this.ctx = null;
        this.droneGain = null;
        this.rainGain = null;
        this.windGain = null;
        this.isMuted = true;
    }
    
    init() {
        if (this.ctx) return;
        const AudioContext = window.AudioContext || window.webkitAudioContext;
        this.ctx = new AudioContext();
        
        this.createDrone();
        this.createRain();
        this.createWind();
        this.updateVolumes();
    }
    
    createDrone() {
        const osc1 = this.ctx.createOscillator();
        const osc2 = this.ctx.createOscillator();
        const filter = this.ctx.createBiquadFilter();
        this.droneGain = this.ctx.createGain();
        
        osc1.type = 'triangle';
        osc1.frequency.setValueAtTime(55, this.ctx.currentTime); // A1
        
        osc2.type = 'sawtooth';
        osc2.frequency.setValueAtTime(55.5, this.ctx.currentTime);
        
        filter.type = 'lowpass';
        filter.frequency.setValueAtTime(90, this.ctx.currentTime);
        
        this.droneGain.gain.setValueAtTime(0.08, this.ctx.currentTime);
        
        osc1.connect(filter);
        osc2.connect(filter);
        filter.connect(this.droneGain);
        this.droneGain.connect(this.ctx.destination);
        
        osc1.start();
        osc2.start();
    }
    
    createRain() {
        const bufferSize = this.ctx.sampleRate * 2;
        const noiseBuffer = this.ctx.createBuffer(1, bufferSize, this.ctx.sampleRate);
        const output = noiseBuffer.getChannelData(0);
        for (let i = 0; i < bufferSize; i++) {
            output[i] = Math.random() * 2 - 1;
        }
        
        const whiteNoise = this.ctx.createBufferSource();
        whiteNoise.buffer = noiseBuffer;
        whiteNoise.loop = true;
        
        const filter = this.ctx.createBiquadFilter();
        filter.type = 'bandpass';
        filter.frequency.setValueAtTime(1000, this.ctx.currentTime);
        filter.Q.setValueAtTime(1, this.ctx.currentTime);
        
        this.rainGain = this.ctx.createGain();
        this.rainGain.gain.setValueAtTime(0.02, this.ctx.currentTime);
        
        whiteNoise.connect(filter);
        filter.connect(this.rainGain);
        this.rainGain.connect(this.ctx.destination);
        
        whiteNoise.start();
    }
    
    createWind() {
        const bufferSize = this.ctx.sampleRate * 2;
        const noiseBuffer = this.ctx.createBuffer(1, bufferSize, this.ctx.sampleRate);
        const output = noiseBuffer.getChannelData(0);
        for (let i = 0; i < bufferSize; i++) {
            output[i] = Math.random() * 2 - 1;
        }
        
        const whiteNoise = this.ctx.createBufferSource();
        whiteNoise.buffer = noiseBuffer;
        whiteNoise.loop = true;
        
        const filter = this.ctx.createBiquadFilter();
        filter.type = 'bandpass';
        filter.frequency.setValueAtTime(400, this.ctx.currentTime);
        filter.Q.setValueAtTime(2, this.ctx.currentTime);
        
        const lfo = this.ctx.createOscillator();
        lfo.type = 'sine';
        lfo.frequency.setValueAtTime(0.1, this.ctx.currentTime);
        
        const lfoGain = this.ctx.createGain();
        lfoGain.gain.setValueAtTime(200, this.ctx.currentTime);
        
        lfo.connect(lfoGain);
        lfoGain.connect(filter.frequency);
        
        this.windGain = this.ctx.createGain();
        this.windGain.gain.setValueAtTime(0.02, this.ctx.currentTime);
        
        whiteNoise.connect(filter);
        filter.connect(this.windGain);
        this.windGain.connect(this.ctx.destination);
        
        lfo.start();
        whiteNoise.start();
    }
    
    playSfx(type) {
        if (this.isMuted || !this.ctx) return;
        
        const osc = this.ctx.createOscillator();
        const gain = this.ctx.createGain();
        osc.connect(gain);
        gain.connect(this.ctx.destination);
        
        const now = this.ctx.currentTime;
        
        if (type === 'click') {
            osc.frequency.setValueAtTime(150, now);
            osc.frequency.exponentialRampToValueAtTime(80, now + 0.05);
            gain.gain.setValueAtTime(0.15, now);
            gain.gain.exponentialRampToValueAtTime(0.01, now + 0.05);
            osc.start();
            osc.stop(now + 0.06);
        } else if (type === 'hit') {
            osc.type = 'triangle';
            osc.frequency.setValueAtTime(100, now);
            osc.frequency.exponentialRampToValueAtTime(40, now + 0.15);
            gain.gain.setValueAtTime(0.4, now);
            gain.gain.exponentialRampToValueAtTime(0.01, now + 0.15);
            osc.start();
            osc.stop(now + 0.16);
        } else if (type === 'chime') {
            osc.type = 'sine';
            osc.frequency.setValueAtTime(880, now);
            gain.gain.setValueAtTime(0.12, now);
            gain.gain.exponentialRampToValueAtTime(0.01, now + 0.3);
            
            const osc2 = this.ctx.createOscillator();
            const gain2 = this.ctx.createGain();
            osc2.type = 'sine';
            osc2.frequency.setValueAtTime(1320, now + 0.08);
            gain2.gain.setValueAtTime(0.1, now + 0.08);
            gain2.gain.exponentialRampToValueAtTime(0.01, now + 0.38);
            
            osc2.connect(gain2);
            gain2.connect(this.ctx.destination);
            
            osc.start();
            osc.stop(now + 0.35);
            osc2.start(now + 0.08);
            osc2.stop(now + 0.4);
        } else if (type === 'gameover') {
            osc.type = 'sawtooth';
            osc.frequency.setValueAtTime(220, now);
            osc.frequency.linearRampToValueAtTime(55, now + 1.0);
            gain.gain.setValueAtTime(0.2, now);
            gain.gain.linearRampToValueAtTime(0.01, now + 1.0);
            osc.start();
            osc.stop(now + 1.1);
        }
    }
    
    updateVolumes() {
        if (!this.ctx) return;
        const vol = this.isMuted ? 0 : 1;
        this.droneGain.gain.setValueAtTime(0.08 * vol, this.ctx.currentTime);
        this.rainGain.gain.setValueAtTime(0.02 * vol, this.ctx.currentTime);
        this.windGain.gain.setValueAtTime(0.02 * vol, this.ctx.currentTime);
    }
    
    toggleMute() {
        this.isMuted = !this.isMuted;
        if (!this.isMuted) {
            this.init();
            if (this.ctx.state === 'suspended') {
                this.ctx.resume();
            }
        }
        this.updateVolumes();
        return this.isMuted;
    }
}


class AudioManager {
    constructor() {
        this.trackAudio = new Audio();
        this.trackAudio.loop = true;
        this.trackAudio.volume = 0.12;

        this.atmosAudio = new Audio();
        this.atmosAudio.loop = true;
        this.atmosAudio.volume = 0.08;

        this.isMuted = true;
        this.currentTrackUrl = null;
        this.currentAtmosUrl = null;
    }

    playSceneAudio(trackUrl, atmosUrl) {
        if (!trackUrl || !atmosUrl) return;

        if (this.currentTrackUrl !== trackUrl) {
            this.currentTrackUrl = trackUrl;
            this.trackAudio.src = trackUrl;
            if (!this.isMuted) {
                this.trackAudio.play().catch(e => console.warn("Track play prevented:", e));
            }
        }

        if (this.currentAtmosUrl !== atmosUrl) {
            this.currentAtmosUrl = atmosUrl;
            this.atmosAudio.src = atmosUrl;
            if (!this.isMuted) {
                this.atmosAudio.play().catch(e => console.warn("Atmos play prevented:", e));
            }
        }
    }

    toggleMute() {
        this.isMuted = !this.isMuted;
        if (this.isMuted) {
            this.trackAudio.pause();
            this.atmosAudio.pause();
        } else {
            if (this.currentTrackUrl) this.trackAudio.play().catch(e => console.warn("Track play prevented:", e));
            if (this.currentAtmosUrl) this.atmosAudio.play().catch(e => console.warn("Atmos play prevented:", e));
        }
        return this.isMuted;
    }

    playSfx(type) {
        // Fallback or placeholder for UI sounds
        // Real implementation depends on if we keep AtmosphereSynth or not
    }
}

const audioMgr = new AudioManager();

const synth = new AtmosphereSynth();

// --- БОЙОВА СИСТЕМА СИМУЛЯТОРА ---
let combatState = {
    inCombat: false,
    enemyName: "",
    enemyHp: 0,
    enemyMaxHp: 0,
    enemyAtk: 0,
    onWin: null,
    onLose: null
};

function startCombat(enemyName, maxHp, atk, onWin, onLose) {
    combatState.inCombat = true;
    combatState.enemyName = enemyName;
    combatState.enemyHp = maxHp;
    combatState.enemyMaxHp = maxHp;
    combatState.enemyAtk = atk;
    combatState.onWin = onWin;
    combatState.onLose = onLose;
    
    const container = document.getElementById("enemy-hp-container");
    if (container) {
        container.style.display = "block";
        document.getElementById("enemy-hp-value").textContent = `${maxHp}/${maxHp}`;
        document.getElementById("enemy-hp-bar").style.width = "100%";
    }
    
    addToLog(`⚔️ ПОЧАВСЯ БІЙ З [${enemyName.toUpperCase()}]!`, "damage");
    renderCombatRound();
}

function renderCombatRound() {
    if (!combatState.inCombat) return;
    
    document.getElementById("scene-title").textContent = `⚔️ Бій: ${combatState.enemyName}`;
    document.getElementById("scene-text").innerHTML = `На вас напав ${combatState.enemyName}! Він готовий завдати удару. Оберіть вашу бойову тактику:<br><br><strong>Ваш стан:</strong> Здоров'я: ${window.playerState.hp}/${window.playerState.maxHp} | Рішучість: ${window.playerState.will}/${window.playerState.maxWill}`;
    
    const choicesDiv = document.getElementById("scene-choices");
    choicesDiv.innerHTML = "";
    
    const btnAtk = document.createElement("button");
    btnAtk.className = "choice-btn";
    btnAtk.innerHTML = `<span>🗡️ Атакувати мечем</span>`;
    btnAtk.addEventListener("click", () => {
        synth.playSfx('hit');
        resolveCombatRound("attack");
    });
    choicesDiv.appendChild(btnAtk);
    
    const btnDodge = document.createElement("button");
    btnDodge.className = "choice-btn";
    btnDodge.innerHTML = `<span>🛡️ Ухилення та захист</span>`;
    btnDodge.addEventListener("click", () => {
        synth.playSfx('click');
        resolveCombatRound("dodge");
    });
    choicesDiv.appendChild(btnDodge);
    
    if (window.playerState.doctrines.pathfinder >= 1) {
        const btnPath = document.createElement("button");
        btnPath.className = "choice-btn";
        btnPath.innerHTML = `<span>🏹 [Слідопит] Знайти укриття в очереті (15 Рішучості)</span>`;
        btnPath.addEventListener("click", () => {
            if (window.playerState.will >= 15) {
                synth.playSfx('click');
                resolveCombatRound("pathfinder");
            } else {
                addToLog("Недостатньо рішучості!", "damage");
            }
        });
        choicesDiv.appendChild(btnPath);
    }
    
    if (window.playerState.doctrines.judge >= 1) {
        const btnJudge = document.createElement("button");
        btnJudge.className = "choice-btn";
        btnJudge.innerHTML = `<span>⚖️ [Суддя] Заборонити атаку Вердиктом (20 Рішучості)</span>`;
        btnJudge.addEventListener("click", () => {
            if (window.playerState.will >= 20) {
                synth.playSfx('click');
                resolveCombatRound("judge");
            } else {
                addToLog("Недостатньо рішучості!", "damage");
            }
        });
        choicesDiv.appendChild(btnJudge);
    }
    
    if (window.playerState.inventory.includes("🪤 Капкан")) {
        const btnTrap = document.createElement("button");
        btnTrap.className = "choice-btn";
        btnTrap.innerHTML = `<span>🪤 Встановити капкан (Витратить капкан)</span>`;
        btnTrap.addEventListener("click", () => {
            synth.playSfx('click');
            resolveCombatRound("use_trap");
        });
        choicesDiv.appendChild(btnTrap);
    }

    updateUi();
}

function resolveCombatRound(action) {
    let playerDmg = 0;
    let enemyDmg = 0;
    
    if (action === "attack") {
        playerDmg = 10 + Math.floor(Math.random() * 6);
        enemyDmg = combatState.enemyAtk + Math.floor(Math.random() * 5);
        
        if (window.playerState.inventory.includes("🧿 Містичний оберіг")) {
            enemyDmg = Math.max(1, enemyDmg - 5);
            addToLog("🧿 Містичний оберіг поглинає 5 пошкоджень!", "success");
        }
        
        combatState.enemyHp = Math.max(0, combatState.enemyHp - playerDmg);
        window.playerState.hp = Math.max(0, window.playerState.hp - enemyDmg);
        
        addToLog(`Ви вдарили мечем на ${playerDmg} пошкоджень!`, "success");
        addToLog(`${combatState.enemyName} атакує вас на ${enemyDmg} пошкоджень!`, "damage");
    } 
    else if (action === "dodge") {
        enemyDmg = Math.max(0, Math.floor((combatState.enemyAtk + Math.floor(Math.random() * 5)) / 3));
        window.playerState.hp = Math.max(0, window.playerState.hp - enemyDmg);
        window.playerState.will = Math.min(window.playerState.maxWill, window.playerState.will + 10);
        
        addToLog(`Ви вдало ухилилися! Отримано лише ${enemyDmg} пошкоджень, +10 Рішучості!`, "success");
    }
    else if (action === "pathfinder") {
        window.playerState.will -= 15;
        playerDmg = 12 + Math.floor(Math.random() * 4);
        enemyDmg = 0;
        combatState.enemyHp = Math.max(0, combatState.enemyHp - playerDmg);
        
        addToLog(`🏹 Слідопит зник у тумані та завдав несподіваного удару з очерету на ${playerDmg} пошкоджень!`, "success");
    }
    else if (action === "judge") {
        window.playerState.will -= 20;
        playerDmg = 5;
        enemyDmg = 0;
        combatState.enemyHp = Math.max(0, combatState.enemyHp - playerDmg);
        
        addToLog(`⚖️ Суддя виголосив вердикт знерухомлення! Ворог паралізований і отримує 5 пошкоджень!`, "success");
    }
    else if (action === "use_trap") {
        const idx = window.playerState.inventory.indexOf("🪤 Капкан");
        if (idx !== -1) window.playerState.inventory.splice(idx, 1);
        
        playerDmg = 25;
        enemyDmg = Math.max(0, Math.floor(combatState.enemyAtk / 2));
        combatState.enemyHp = Math.max(0, combatState.enemyHp - playerDmg);
        window.playerState.hp = Math.max(0, window.playerState.hp - enemyDmg);
        
        addToLog(`🪤 Ви заманили ворога в капкан! Ворог отримав ${playerDmg} пошкоджень. Його атака послаблена до ${enemyDmg}!`, "success");
    }
    
    document.getElementById("enemy-hp-value").textContent = `${combatState.enemyHp}/${combatState.enemyMaxHp}`;
    document.getElementById("enemy-hp-bar").style.width = `${(combatState.enemyHp / combatState.enemyMaxHp) * 100}%`;
    
    if (window.playerState.hp <= 0 && !window.IS_DEV_TESTING) {
        synth.playSfx('gameover');
        endCombat(false);
    } else if (combatState.enemyHp <= 0) {
        synth.playSfx('chime');
        endCombat(true);
    } else {
        renderCombatRound();
    }
}

function endCombat(playerWon) {
    combatState.inCombat = false;
    document.getElementById("enemy-hp-container").style.display = "none";
    
    if (playerWon) {
        addToLog(`🏆 Перемога над [${combatState.enemyName.toUpperCase()}]!`, "success");
        if (combatState.onWin) combatState.onWin();
    } else {
        addToLog(`💀 Ви загинули в бою з [${combatState.enemyName.toUpperCase()}]...`, "damage");
        if (combatState.onLose) {
            combatState.onLose();
        } else {
            goScene("death");
        }
    }
}

// --- БАЗА ДАНИХ ІГРОВИХ СЦЕН (ЕПІЗОДИ 1-4) ---

// window.GAME_SCENES moved to quests-data.js


let currentSceneKey = "arriving";

// --- УПРАВЛІННЯ ІГРОВИМ ПРОЦЕСОМ ---
function startGameFlow() {
    gameStarted = true;
    
    const logDiv = document.getElementById("combat-log");
    if (logDiv) {
        logDiv.innerHTML = '<div class="log-msg system">Ви розпочали подорож Мандруючого Вартового. Порожній Сезон розпочався.</div>';
    }
    addToLog(`Вартовий ${window.playerState.name} (Передісторія: ${window.playerState.background}) прибув до Грейфорда.`, "system");
    
    updateUi();
    goScene("arriving");
}

function chooseMotivation(motivation, dialogReply, nextScene) {
    window.playerState.history.push({ step: "motivation", choice: motivation });
    
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

function chooseValkornPath(path, reply, nextScene) {
    window.playerState.history.push({ step: "valkorn_path", choice: path });
    addToLog(`Обрано Шлях ${path}: ${reply}`, "system");
    
    if (path === "A") {
        adjustReputation("greyford", 30);
        adjustReputation("knives", 20);
        adjustReputation("muri", -30);
    } else if (path === "B") {
        adjustReputation("greyford", -30);
        adjustReputation("muri", 30);
    } else {
        adjustReputation("greyford", 10);
        adjustReputation("muri", 10);
    }
    
    goScene(nextScene);
}

function consumeAntidoteForPoison() {
    const idx = window.playerState.inventory.indexOf("🧪 Протиотрута");
    if (idx !== -1) window.playerState.inventory.splice(idx, 1);
    addToLog("🧪 Ви вчасно випили Протиотруту і нейтралізували отруйні випари болота!", "success");
    synth.playSfx('chime');
    goScene("ep3_dry_mound");
}

function takePoisonDamage() {
    window.playerState.hp = Math.max(0, window.playerState.hp - 30);
    window.playerState.will = Math.max(0, window.playerState.will - 15);
    addToLog("💨 Ви надихалися отруйними газами болота! Втрачено 30 HP та 15 Рішучості!", "damage");
    
    if (window.playerState.hp <= 0 && !window.IS_DEV_TESTING) {
        synth.playSfx('gameover');
        goScene("death");
    } else {
        goScene("ep3_dry_mound");
    }
}

function resolveFinalWay(way) {
    let title = "";
    let finalDesc = "";
    
    if (way === "A") {
        title = "ШЛЯХ А: ВЕРДИКТ ЗАЛІЗА";
        finalDesc = `
        Ви йдете по сухій залізній дорозі. Ваші руки одягнені в товсті шкіряні рукавиці, що приховують скам'янілу шкіру. За вашою спиною залишається залізне місто Валькорн, його високі труби та залізні ліхтарі Ордену. Болото висихає, перетворюючись на мертву глину.
        <br><br>
        Тесса очолила реформований Орден Залізних Кинджалів, підкоривши прикордоння закону заліза. Себастьян Марр загинув у повстанні, а Руфін назавжди залишився Порожнім німим пам'ятником.
        <br><br>
        Голос Ілії у вашій голові звучить втомлено й здалеку, наче вітер у руїнах: <em>«Я звучатиму десь позаду... Наче вітер у руїнах.»</em> Ви йдете далі в інші землі, залишаючи Хейзмуру у залізних ланцюгах.`;
        
        adjustReputation("greyford", 40);
        adjustReputation("knives", 30);
        adjustReputation("muri", -50);
    } 
    else if (way === "B") {
        title = "ШЛЯХ Б: ВЕРДИКТ ОЧЕРЕТУ";
        finalDesc = `
        Ви йдете босоніж по теплому болотяному мулу. Рубці на ваших руках схожі на кору верби, а постать розчиняється в густому тумані без жодних слів. За вашою спиною шумить очерет, поглинаючи залишки Грейфорда.
        <br><br>
        Себастьян Марр згинув у глибокій трясовині, намагаючись спалити болото. Тесса згуртувала залишки Ордену на межі дикої природи. Руфін лишився безмовною тінню очерету.
        <br><br>
        Зелений туман лоскоче ваше обличчя. Ви йдете далі, ставши частиною самого Хейзмуру, вільного та небезпечного.`;
        
        adjustReputation("muri", 50);
        adjustReputation("greyford", -50);
    } 
    else {
        title = "ШЛЯХ В: ПАКТ КЛЮЧНИКА";
        finalDesc = `
        Ви зупиняєтесь посеред мосту, що не належить жодному берегу. Ви дивитесь на обидва боки, забираючи обидва Ключі Печаток. За вашою спиною — хиткий нейтралітет, де торгівля йде під стінами залізних ліхтарів.
        <br><br>
        Себастьян Марр підписав мирний Пакт, змирившись із силами болота. Тесса пильно стежить за виконанням законів рівноваги. Руфін стоїть мовчазним вартовим кордону.
        <br><br>
        Ви тримаєте баланс сил і йдете далі у незвідані землі. Голос Ілії шепоче з теплою посмішкою: <em>«Ми впоралися. Світ зберіг свою душу.»</em>`;
        
        adjustReputation("greyford", 20);
        adjustReputation("muri", 20);
    }
    
    const sceneId = `ep4_bridge_ending_${way.toLowerCase()}`;
    window.GAME_SCENES[sceneId] = {
        title: `🏆 ЕПІЛОГ: ${title}`,
        isChapterEnding: true,
        text: `
        <span class="quest-tag" style="color: var(--accent-gold);">ЕПІЗОД 4 ЗАВЕРШЕНО</span>
        <h2 style="font-family: var(--font-gothic); color: var(--accent-gold); margin-top: 1rem; margin-bottom: 1.5rem;">⚖️ ${title}</h2>
        <p>${finalDesc}</p>
        <hr style="border: 0; height: 1px; background: var(--border-color); margin: 2rem 0;">
        <h3 style="font-family: var(--font-gothic); color: var(--accent-gold); margin-bottom: 0.8rem;">👑 Ваші підсумкові фракційні зв'язки:</h3>
        <p>• Адміністрація Грейфорда: <strong>${window.playerState.reputation.greyford > 0 ? '+' : ''}${window.playerState.reputation.greyford}</strong></p>
        <p>• Орден Семи Кинджалів: <strong>${window.playerState.reputation.knives > 0 ? '+' : ''}${window.playerState.reputation.knives}</strong></p>
        <p>• Хранителі Святої Вей: <strong>${window.playerState.reputation.keepers > 0 ? '+' : ''}${window.playerState.reputation.keepers}</strong></p>
        <p>• Мурі (Жаболюди): <strong>${window.playerState.reputation.muri > 0 ? '+' : ''}${window.playerState.reputation.muri}</strong></p>
        `,
        choices: [
            {
                text: "Вирушити у Початок Зими (Епізод 5)",
                nextSceneId: "ep5_beginning_of_winter"
            }
        ]
    };
    
    goScene(sceneId);
}

function goThread(thread) {
    console.log(`Transitioning from thread to thread_${thread}`);
    goScene(`thread_${thread}`);
}

function goScene(sceneKey) {
    console.log(`Transitioning from scene ${currentSceneKey} to scene ${sceneKey}`);
    currentSceneKey = sceneKey; window.currentSceneKey = sceneKey;
    const scene = window.GAME_SCENES[sceneKey];
    if (!scene) return;

    const illContainer = document.getElementById("scene-illustration");
    const questTag = document.getElementById("quest-tag");
    
    if (scene.audioTrack && scene.audioAtmosphere) {
        audioMgr.playSceneAudio(scene.audioTrack, scene.audioAtmosphere);
    }

    if (illContainer) {
        if (sceneKey === "arriving" || sceneKey === "investigation" || sceneKey.startsWith("thread_") || sceneKey === "gates" || sceneKey.startsWith("ep1_")) {
            if (questTag) questTag.textContent = "Епізод 1: Хейзмур";
            illContainer.style.backgroundImage = "url('assets/episode1.png')";
            illContainer.style.display = "block";
        } else if (sceneKey.startsWith("ep2_") || sceneKey.startsWith("valkorn_")) {
            if (questTag) questTag.textContent = "Епізод 2: Валькорн";
            illContainer.style.backgroundImage = "url('assets/episode2.png')";
            illContainer.style.display = "block";
        } else if (sceneKey.startsWith("ep3_")) {
            if (questTag) questTag.textContent = "Епізод 3: Глибоке болото";
            illContainer.style.backgroundImage = "url('assets/episode3.png')";
            illContainer.style.display = "block";
        } else if (sceneKey.startsWith("ep4_")) {
            if (questTag) questTag.textContent = "Епізод 4: Кам'яний Міст";
            illContainer.style.backgroundImage = "url('assets/episode4.png')";
            illContainer.style.display = "block";
        } else if (sceneKey.startsWith("ep5_")) {
            if (questTag) questTag.textContent = "Епізод 5: Епілог";
            illContainer.style.backgroundImage = "none";
            illContainer.style.display = "none";
        } else {
            illContainer.style.display = "none";
        }
    }

    document.getElementById("scene-title").textContent = scene.title;
    document.getElementById("scene-text").innerHTML = scene.text;

    const choicesDiv = document.getElementById("scene-choices");
    choicesDiv.innerHTML = "";

    scene.choices.forEach(choice => {
        if (choice.visible && !choice.visible()) {
            return;
        }

        const btn = document.createElement("button");
        btn.className = "choice-btn";
        btn.innerHTML = `<span>${choice.text}</span>`;
        btn.addEventListener("click", () => {
            synth.playSfx("click");
            if (choice.action) choice.action();
            if (choice.nextSceneId) goScene(choice.nextSceneId);
        });
        choicesDiv.appendChild(btn);
    });

    updateUi();
}

function finishQuest(gateAnswer, sergeantReply) {
    window.playerState.history.push({ step: "gate_answer", choice: gateAnswer });
    addToLog(`Відповідь сержанту: ${gateAnswer}. ${sergeantReply}`, "system");

    const cluesFound = Object.entries(window.playerState.clues).filter(([k, v]) => v === true && k !== "witch_hint").map(([k]) => k);
    let investigationGrade = "";
    let summaryText = "";

    if (cluesFound.length >= 3) {
        investigationGrade = "Блискуче розслідування";
        summaryText = `Ви провели **блискуче слідство**! Ви оглянули кімнату Руфіна, розговорили різьбяра та розкрили таємницю через куртизанку Касандру. 
        <br><br>
        <strong>Ваші висновки:</strong>
        <ul>
            <li>Руфін пішов у Тихий Шелест цілеспрямовано. Він виконував чиєсь завдання.</li>
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

    const repDetails = [];
    ["greyford", "knives", "keepers", "muri"].forEach(faction => {
        const val = window.playerState.reputation[faction];
        const status = getReputationStatus(val);
        const fNames = {
            greyford: "Адміністрація Грейфорда",
            knives: "Орден Семи Кинджалів",
            keepers: "Хранителі Святої Вей",
            muri: "Мурі (Амфібії)"
        };
        repDetails.push(`<p>• ${fNames[faction]}: <strong>${val > 0 ? '+' : ''}${val}</strong> (${status.text})</p>`);
    });

    const endingScene = window.GAME_SCENES.ending_episode1;
    endingScene.text = `
        <span class="quest-tag" style="color: var(--accent-gold);">РЕЗУЛЬТАТ: ${investigationGrade.toUpperCase()}</span>
        <h2 style="font-family: var(--font-gothic); color: var(--accent-gold); margin-top: 1rem; margin-bottom: 1rem;">⚖️ ВЕРДИКТ ВАРТОВОГО</h2>
        ${summaryText}
        <hr style="border: 0; height: 1px; background: var(--border-color); margin: 1.5rem 0;">
        <h4 style="font-family: var(--font-gothic); color: var(--accent-gold); margin-bottom: 0.3rem;">👑 Ваша підсумкова репутація фракцій:</h4>
        ${repDetails.join("")}
        <br>
        <p class="gold-text" style="font-style: italic; font-weight: 600;">Шлях до поселення Тихий Шелест відкрито. Порожній Сезон чекає на Мандруючого Вартового у глибинах Хейзмуру...</p>
    `;

    goScene("ending_episode1");
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
    if (window.playerState.resources[name] !== undefined) {
        window.playerState.resources[name] = Math.max(0, window.playerState.resources[name] + amount);
        
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
    if (window.playerState.inventory.length >= 4) {
        addToLog("Сумка переповнена! Максимальний ліміт інвентарю — 4 активні предмети.", "damage");
        return;
    }

    let success = false;
    let craftedItemName = "";
    
    if (recipeName === "ointment") {
        if (window.playerState.resources.henbane >= 1 && window.playerState.resources.slime >= 1) {
            window.playerState.resources.henbane -= 1;
            window.playerState.resources.slime -= 1;
            craftedItemName = "🍯 Болотяна мазь";
            success = true;
        }
    } else if (recipeName === "antidote") {
        if (window.playerState.resources.loosestrife >= 1 && window.playerState.resources.water >= 1) {
            window.playerState.resources.loosestrife -= 1;
            window.playerState.resources.water -= 1;
            craftedItemName = "🧪 Протиотрута";
            success = true;
        }
    } else if (recipeName === "amulet") {
        if (window.playerState.resources.ash >= 1 && window.playerState.resources.silver >= 1) {
            window.playerState.resources.ash -= 1;
            window.playerState.resources.silver -= 1;
            craftedItemName = "🧿 Містичний оберіг";
            success = true;
        }
    } else if (recipeName === "trap") {
        if (window.playerState.resources.bogiron >= 1 && window.playerState.resources.tendons >= 1) {
            window.playerState.resources.bogiron -= 1;
            window.playerState.resources.tendons -= 1;
            craftedItemName = "🪤 Капкан";
            success = true;
        }
    }
    
    if (success) {
        addToLog(`Зкрафчено предмет: ${craftedItemName}!`, "success");
        synth.playSfx('chime');
        addItem(craftedItemName);
        updateUi();
    } else {
        addToLog(`Недостатньо ресурсів для створення предмету!`, "damage");
    }
}

// --- РЕПУТАЦІЙНА ШКАЛА (-100 до +100) ---
function adjustReputation(faction, delta) {
    if (window.playerState.reputation[faction] !== undefined) {
        window.playerState.reputation[faction] = Math.max(-100, Math.min(100, window.playerState.reputation[faction] + delta));
        
        const factionNames = {
            greyford: "Адміністрація Грейфорда",
            knives: "Орден Семи Кинджалів",
            keepers: "Хранителі Святої Вей",
            muri: "Мурі (Амфібії)"
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
    if (window.IS_DEV_TESTING) {
        window.playerState.hp = 999;
        window.playerState.will = 999;
    }
    document.getElementById("hp-value").textContent = `${window.playerState.hp}/${window.playerState.maxHp}`;
    document.getElementById("hp-bar").style.width = `${(window.playerState.hp / window.playerState.maxHp) * 100}%`;

    document.getElementById("will-value").textContent = `${window.playerState.will}/${window.playerState.maxWill}`;
    document.getElementById("will-bar").style.width = `${(window.playerState.will / window.playerState.maxWill) * 100}%`;

    const invGrid = document.getElementById("inventory-list");
    if (invGrid) {
        invGrid.innerHTML = "";
        for (let i = 0; i < 4; i++) {
            const slot = document.createElement("div");
            slot.className = "inv-slot";
            
            if (window.playerState.inventory[i]) {
                slot.textContent = window.playerState.inventory[i].split(" ")[0]; // emoji
                slot.title = `${window.playerState.inventory[i]} (Клікніть, щоб застосувати)`;
                slot.classList.add("active-item");
            } else {
                slot.textContent = "·";
                slot.classList.add("empty");
            }
            invGrid.appendChild(slot);
        }
    }

    const resources = ["henbane", "loosestrife", "peganum", "bogiron", "silver", "slate", "slime", "heart", "tendons", "water", "ash"];
    resources.forEach(res => {
        const el = document.getElementById(`res-${res}`);
        if (el) el.textContent = window.playerState.resources[res];
    });

    const craftOintment = document.getElementById("craft-ointment");
    if (craftOintment) craftOintment.disabled = !(window.playerState.resources.henbane >= 1 && window.playerState.resources.slime >= 1);
    
    const craftAntidote = document.getElementById("craft-antidote");
    if (craftAntidote) craftAntidote.disabled = !(window.playerState.resources.loosestrife >= 1 && window.playerState.resources.water >= 1);
    
    const craftAmulet = document.getElementById("craft-amulet");
    if (craftAmulet) craftAmulet.disabled = !(window.playerState.resources.ash >= 1 && window.playerState.resources.silver >= 1);
    
    const craftTrap = document.getElementById("craft-trap");
    if (craftTrap) craftTrap.disabled = !(window.playerState.resources.bogiron >= 1 && window.playerState.resources.tendons >= 1);

    const factions = ["greyford", "knives", "keepers", "muri"];
    factions.forEach(faction => {
        const val = window.playerState.reputation[faction];
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
    if (window.playerState.inventory.length < 4 && !window.playerState.inventory.includes(item)) {
        window.playerState.inventory.push(item);
        addToLog(`Отримано предмет: ${item}`, "success");
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

// --- СПОЖИВАННЯ ПРЕДМЕТІВ З ІНВЕНТАРЮ ---
function initItemUsage() {
    const invGrid = document.getElementById("inventory-list");
    if (!invGrid) return;
    
    invGrid.addEventListener("click", (e) => {
        const slot = e.target.closest(".inv-slot");
        if (!slot || slot.classList.contains("empty")) return;
        
        const slotIdx = Array.from(invGrid.children).indexOf(slot);
        const itemName = window.playerState.inventory[slotIdx];
        if (!itemName) return;
        
        useBagItem(itemName, slotIdx);
    });
}

function useBagItem(itemName, idx) {
    if (combatState.inCombat) {
        if (itemName.includes("🍯 Болотяна мазь")) {
            window.playerState.inventory.splice(idx, 1);
            window.playerState.hp = Math.min(window.playerState.maxHp, window.playerState.hp + 40);
            addToLog("🍯 Ви використали Болотяну мазь у бою та відновили 40 HP!", "success");
            synth.playSfx('chime');
            renderCombatRound();
        } else if (itemName.includes("🧪 Протиотрута")) {
            window.playerState.inventory.splice(idx, 1);
            window.playerState.will = window.playerState.maxWill;
            addToLog("🧪 Ви випили Протиотруту в бою та відновили Рішучість!", "success");
            synth.playSfx('chime');
            renderCombatRound();
        } else if (itemName.includes("🧿 Містичний оберіг")) {
            addToLog("🧿 Містичний оберіг автоматично поглинає пошкодження у бою!", "reputation");
        } else {
            addToLog("Цей предмет неможливо використати у бою.", "system");
        }
    } else {
        if (itemName.includes("🍯 Болотяна мазь")) {
            window.playerState.inventory.splice(idx, 1);
            window.playerState.hp = Math.min(window.playerState.maxHp, window.playerState.hp + 40);
            addToLog("🍯 Ви використали Болотяну мазь та відновили 40 HP!", "success");
            synth.playSfx('chime');
            goScene(currentSceneKey);
        } else if (itemName.includes("🧪 Протиотрута")) {
            window.playerState.inventory.splice(idx, 1);
            window.playerState.will = window.playerState.maxWill;
            addToLog("🧪 Ви випили Протиотруту та повністю відновили Рішучість!", "success");
            synth.playSfx('chime');
            goScene(currentSceneKey);
        } else {
            addToLog(`🎒 Ви розглядаєте [${itemName}]. Його неможливо застосувати зараз.`, "system");
        }
    }
}

// --- ІНІЦІАЛІЗАЦІЯ КРАФТИНГУ ---
function initCrafting() {
    const craftOintment = document.getElementById("craft-ointment");
    if (craftOintment) craftOintment.addEventListener("click", () => craftItem("ointment"));
    
    const craftAntidote = document.getElementById("craft-antidote");
    if (craftAntidote) craftAntidote.addEventListener("click", () => craftItem("antidote"));
    
    const craftAmulet = document.getElementById("craft-amulet");
    if (craftAmulet) craftAmulet.addEventListener("click", () => craftItem("amulet"));
    
    const craftTrap = document.getElementById("craft-trap");
    if (craftTrap) craftTrap.addEventListener("click", () => craftItem("trap"));
}

// Ініціалізація звукового перемикача
document.getElementById("audio-toggle-btn").addEventListener("click", () => {
    const isMuted = synth.toggleMute();
    audioMgr.toggleMute();
    const btn = document.getElementById("audio-toggle-btn");
    if (btn) {
        btn.textContent = isMuted ? "🔇 Звук" : "🔊 Звук";
        btn.classList.toggle("audio-btn", isMuted);
    }
});

// --- ІНІЦІАЛІЗАЦІЯ ПРИ ЗАВАНТАЖЕННІ ---
renderFileList("design");
initCharacterCreation();
initItemUsage();
initCrafting();
