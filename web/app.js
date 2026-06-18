window.IS_DEV_TESTING = false;
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
        { name: "🗺️ Карта світу", path: "web/assets/world-map.webp", isMap: true },
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
        // ─── ЕПІЗОД 1: ТІНІ ГРЕЙФОРДА (12) ───
        { name: "1.  Адресат відсутній", path: "quests/ep1-01-greyford-adresat-vidsutniy.md" },
        { name: "2.  Сім уроків болота", path: "quests/ep1-02-muri-shlyakh-kriz-boloto.md" },
        { name: "3.  Таємниці Тихого Шелесту", path: "quests/ep1-03-tykhy-shelist-taiennytsi.md" },
        { name: "4.  Голод знизу", path: "quests/ep1-04-holod-znuzu.md" },
        { name: "5.  Матриця наслідків", path: "quests/ep1-05-holod-znuzu-naslidky.md" },
        { name: "6.  Сіль у книзі", path: "quests/ep1-06-sil-u-knyzi.md" },
        { name: "7.  Поромна присяга", path: "quests/ep1-07-poromna-prysyaga.md" },
        { name: "8.  Попіл під каплицею", path: "quests/ep1-08-popil-pid-kaplytseyu.md" },
        { name: "9.  Ніж квоти", path: "quests/ep1-09-nizh-kvoty.md" },
        { name: "10. Ланцюжок Хейзмуру", path: "quests/ep1-10-hazemoor-lantsyuzhok.md" },
        { name: "11. Шлях крізь болото", path: "quests/ep1-11-hazemoor-shlyakh-kriz-boloto.md" },
        { name: "12. Галявина і дух", path: "quests/ep1-12-hazemoor-halyna-i-mour.md" },
        // ─── ЕПІЗОД 2: ВАЛЬКОРН (5) ───
        { name: "13. Людина з болота", path: "quests/ep2-01-valkorn-lyudyna-z-bolota.md" },
        { name: "14. Дві версії правди", path: "quests/ep2-02-valkorn-dvi-versii-pravdy.md" },
        { name: "15. Правильна ціна", path: "quests/ep2-03-valkorn-pravylna-tsina.md" },
        { name: "16. Той, хто послав Руфіна", path: "quests/ep2-04-valkorn-poslanets-rufina.md" },
        { name: "17. Хранитель Першої Печатки", path: "quests/ep2-05-valkorn-khranitel-pechatky.md" },
        // ─── ЕПІЗОД 3: ГЛИБОКЕ БОЛОТО (3) ───
        { name: "18. Голос із туману", path: "quests/ep3-01-deep-bog-holos-iz-tumanu.md" },
        { name: "19. Шалений пором", path: "quests/ep3-02-deep-bog-shalyaniy-porom.md" },
        { name: "20. Затоплена обитель", path: "quests/ep3-03-deep-bog-zatoplena-obytel.md" },
        // ─── ЕПІЗОД 4: ДВА БЕРЕГИ (5) ───
        { name: "21. Повернення до Валькорна", path: "quests/ep4-01-povernennya-do-valkorna.md" },
        { name: "22. Кульмінація Валькорна", path: "quests/ep4-02-kulminatsiya-valkorna.md" },
        { name: "23. Хейзмур та Серце Моура", path: "quests/ep4-03-hazemoor-sertse-moura.md" },
        { name: "24. Велика розв'язка", path: "quests/ep4-04-final-rozvyazka.md" },
        { name: "25. Відхід Героя", path: "quests/ep4-05-vidhid-heroya.md" }
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
        btn.addEventListener("click", () => {
            if (file.isMap) {
                document.querySelectorAll(".file-btn").forEach(b => b.classList.remove("active"));
                btn.classList.add("active");
                showWorldMap();
            } else {
                loadMarkdownFile(file.path, btn);
            }
        });
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
    sanity: 100,
    corruption: 0,
    iliaAnchor: 50,
    sonkFerry: {
        medsStatus: null,
        ferryControl: null,
        chapelRitual: null,
        finalVerdict: null
    },
    completedQuests: {},
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
            window.playerState.completedQuests = {};
            window.playerState.history = [];
            
            // Episode 1 Hub - Sonk Ferry Metrics
            window.playerState.sanity = 100;
            window.playerState.corruption = 0;
            window.playerState.iliaAnchor = 50;
            window.playerState.sonkFerry = {
                medsStatus: null,
                ferryControl: null,
                chapelRitual: null,
                finalVerdict: null
            };
            window.playerState.reputation = { ...window.playerState.reputation, admin: window.playerState.reputation.greyford || 0, order: window.playerState.reputation.knives || 0 };

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
        
        // Atmosphere sounds disabled — only SFX (clicks/hits) remain
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
        if (this.droneGain) this.droneGain.gain.setValueAtTime(0.08 * vol, this.ctx.currentTime);
        if (this.rainGain) this.rainGain.gain.setValueAtTime(0.02 * vol, this.ctx.currentTime);
        if (this.windGain) this.windGain.gain.setValueAtTime(0.02 * vol, this.ctx.currentTime);
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
                const playPromise = this.trackAudio.play();
                if (playPromise !== undefined) {
                    playPromise.catch(() => {});
                }
            }
        }
        if (this.currentAtmosUrl !== atmosUrl) {
            this.currentAtmosUrl = atmosUrl;
            this.atmosAudio.src = atmosUrl;
            if (!this.isMuted) {
                const playPromise = this.atmosAudio.play();
                if (playPromise !== undefined) {
                    playPromise.catch(() => {});
                }
            }
        }
    }

    toggleMute() {
        this.isMuted = !this.isMuted;
        if (!this.isMuted) {
            if (this.currentTrackUrl) {
                this.trackAudio.src = this.currentTrackUrl;
                this.trackAudio.play().catch(() => {});
            }
            if (this.currentAtmosUrl) {
                this.atmosAudio.src = this.currentAtmosUrl;
                this.atmosAudio.play().catch(() => {});
            }
        } else {
            this.trackAudio.pause();
            this.atmosAudio.pause();
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
    const saveBtnEl = document.getElementById("save-game-btn");
    if (saveBtnEl) saveBtnEl.style.display = "inline-block";
    
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
    window.playerState.valkorn_path = path;
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
    
    let finalSceneId = `ep5_final_${way}`;
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
                text: "Перейти до фінальної сцени",
                nextSceneId: finalSceneId
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
    const prevSceneKey = currentSceneKey;
    currentSceneKey = sceneKey; window.currentSceneKey = sceneKey;
    const scene = window.GAME_SCENES[sceneKey];
    if (!scene) return;

    // --- ТІК ОТРУЄННЯ: −5 HP за кожен реальний перехід між сценами ---
    if (gameStarted && window.playerState && window.playerState.poisoned && sceneKey !== prevSceneKey && !scene.isAbsoluteFinal) {
        window.playerState.hp = Math.max(0, window.playerState.hp - 5);
        addToLog("☠️ Отрута розтікається тілом... Втрачено 5 HP. Потрібна 🧪 Протиотрута!", "damage");
        if (window.playerState.hp <= 0 && !window.IS_DEV_TESTING) {
            synth.playSfx('gameover');
            window.playerState.poisoned = false;
            goScene("death");
            return;
        }
    }



    const illContainer = document.getElementById("scene-illustration");
    const questTag = document.getElementById("quest-tag");
    
    if (scene.audioTrack && scene.audioAtmosphere) {
        audioMgr.playSceneAudio(scene.audioTrack, scene.audioAtmosphere);
    }

    // --- МАППІНГ: сцена → зображення персонажа/істоти ---
    const CHARACTER_IMAGES = {
        // ЕП1 — ГРЕЙФОРД
        'arriving':                  'assets/images/ervan.jpg',
        'thread_carver':             'assets/images/carver.jpg',
        'greyford_room_hub':         'assets/images/rufin-room.jpg',
        // ЕП1 — ШЛЯХ КРІЗЬ БОЛОТО
        'hazemoor_ep1':              'assets/images/reed-crawler.jpg',
        'hazemoor_ep2':              'assets/images/bloodsucker-swarm.jpg',
        'hazemoor_ep3':              'assets/images/drowned-corpse.jpg',
        'hazemoor_ep4':              'assets/images/murk-bog-creeper.jpg',
        // ЕП1 — ТИХИЙ ШЕЛЕСТ
        'tykhy_arrive':              'assets/images/sirra.jpg',
        'tykhy_rufin':               'assets/images/varrik.jpg',
        'tykhy_kaen':                'assets/images/kaen.jpg',
        'tykhy_mia':                 'assets/images/mia-mother.jpg',
        // ЕП1 — ГАЛЯВИНА МОУРА
        'glade_mour':                'assets/images/mour.jpg',
        // ЕП1 — СОНК-ФЕРРІ
        'popil_pid_kaplytseyu':      'assets/images/karos.jpg',
        'quest_ferry':               'assets/images/tovan-rid.jpg',
        'sil_u_knyzi':               'assets/images/gara-pike.jpg',
        'quest_verdict_kelm':        'assets/images/kelm.jpg',
        'nizh_kvoty':                'assets/images/iliya.jpg',
        // ЕП2 — ВАЛЬКОРН
        'valckorn_slums_district':   'assets/images/bres.jpg',
        'valckorn_entry_ghetto':     'assets/images/bres.jpg',
        'valckorn_palace_district':  'assets/images/stetson.jpg',
        'valckorn_02_odrin':         'assets/images/odrin.jpg',
        'valckorn_chapel_district':  'assets/images/tessa.jpg',
        'valckorn_03_damar':         'assets/images/damar.jpg',
        'valckorn_04_loen':          'assets/images/loen.jpg',
        'valckorn_05_iliya':         'assets/images/phipp-sebastian.jpg',
        'valckorn_epilogue':         'assets/images/iliya.jpg',
        // ЕП3
        'ep3_tykhy_tower':           'assets/images/lileya.jpg',
        'ep3_vapor_zone':            'assets/images/drowned-corpse.jpg',
        'ep3_murok_guardian':        'assets/images/murk-adult.jpg',
    };

    if (illContainer) {
        const charImg = CHARACTER_IMAGES[sceneKey];
        if (charImg) {
            illContainer.style.backgroundImage = `url('${charImg}')`;
            illContainer.style.backgroundSize = "cover";
            illContainer.style.backgroundPosition = "center top";
            illContainer.style.display = "block";
            if (sceneKey.startsWith("ep3_") || sceneKey.startsWith("hazemoor")) {
                if (questTag) questTag.textContent = "Епізод 3: Глибоке болото";
            } else if (sceneKey.startsWith("ep4_")) {
                if (questTag) questTag.textContent = "Епізод 4: Кам'яний Міст";
            } else if (sceneKey.startsWith("valckorn_") || sceneKey.startsWith("valkorn_")) {
                if (questTag) questTag.textContent = "Епізод 2: Валькорн";
            } else {
                if (questTag) questTag.textContent = "Епізод 1: Хейзмур";
            }
        } else if (sceneKey === "arriving" || sceneKey === "investigation" || sceneKey.startsWith("thread_") || sceneKey === "gates" || sceneKey.startsWith("ep1_")) {
            if (questTag) questTag.textContent = "Епізод 1: Хейзмур";
            illContainer.style.backgroundImage = "url('assets/episode1.png')";
            illContainer.style.backgroundSize = "";
            illContainer.style.backgroundPosition = "";
            illContainer.style.display = "block";
        } else if (sceneKey.startsWith("ep2_") || sceneKey.startsWith("valkorn_") || sceneKey.startsWith("valckorn_") || sceneKey.startsWith("clown_")) {
            if (questTag) questTag.textContent = "Епізод 2: Валькорн";
            illContainer.style.backgroundImage = "url('assets/episode2.png')";
            illContainer.style.backgroundSize = "";
            illContainer.style.backgroundPosition = "";
            illContainer.style.display = "block";
        } else if (sceneKey.startsWith("ep3_")) {
            if (questTag) questTag.textContent = "Епізод 3: Глибоке болото";
            illContainer.style.backgroundImage = "url('assets/episode3.png')";
            illContainer.style.backgroundSize = "";
            illContainer.style.backgroundPosition = "";
            illContainer.style.display = "block";
        } else if (sceneKey.startsWith("ep4_")) {
            if (questTag) questTag.textContent = "Епізод 4: Кам'яний Міст";
            illContainer.style.backgroundImage = "url('assets/episode4.png')";
            illContainer.style.backgroundSize = "";
            illContainer.style.backgroundPosition = "";
            illContainer.style.display = "block";
        } else if (sceneKey.startsWith("ep5_")) {
            if (questTag) questTag.textContent = "Епізод 5: Епілог";
            illContainer.style.backgroundImage = "none";
            illContainer.style.display = "none";
        } else {
            illContainer.style.display = "none";
        }
    }

    document.getElementById("scene-title").textContent = scene.title || "Невідома локація";
    window._currentSceneKey = sceneKey;
    document.getElementById("scene-text").innerHTML = scene.text || "Дані для цієї сцени не знайдені.";

    const choicesDiv = document.getElementById("scene-choices");
    choicesDiv.innerHTML = "";

    scene.choices.forEach(choice => {
        let isVisible = true;
        if (choice.visible) {
            try {
                isVisible = choice.visible();
            } catch (e) {
                console.error("Error evaluating visibility for choice:", choice.text, e);
                isVisible = false;
            }
        }
        if (!isVisible) return;

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

    if (scene.isAbsoluteFinal) {
        const restartBtn = document.createElement('button');
        restartBtn.className = 'choice-btn';
        restartBtn.textContent = '↩ Зіграти знову';
        restartBtn.addEventListener('click', function() {
            window.isChapterEnding = false;
            document.getElementById('main-simulator-interface').style.display = 'none';
            document.getElementById('character-creation').style.display = 'flex';
            resetGame();
        });
        choicesDiv.appendChild(restartBtn);
    }

    updateUi();
}

function finishQuest(gateAnswer, sergeantReply) {
    window.playerState.history.push({ step: "gate_answer", choice: gateAnswer });
    addToLog(`Відповідь сержанту: ${gateAnswer}. ${sergeantReply}`, "system");

    const completedQuests = window.playerState.completedQuests || {};
    let cluesFoundCount = 0;
    if (completedQuests['room_fully_cleared']) cluesFoundCount++;
    if (completedQuests['craftsmen_done']) cluesFoundCount++;
    if (completedQuests['tavern_done']) cluesFoundCount++;
    if (completedQuests['witch_done']) cluesFoundCount++;

    let investigationGrade = "";
    let summaryText = "";

    if (cluesFoundCount >= 3) {
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
    const factionAliases = {
        admin: "greyford",
        order: "knives",
        wanderers: "keepers"
    };
    if (factionAliases[faction]) {
        faction = factionAliases[faction];
    }
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

    const repData = window.playerState.reputation || {};
    const effectiveRep = {
        greyford: (repData.greyford||0)+(repData.admin||0),
        knives:   (repData.knives||0)+(repData.order||0),
        keepers:  (repData.keepers||0)+(repData.wanderers||0),
        muri:     (repData.muri||0)
    };
    const factions = ["greyford", "knives", "keepers", "muri"];
    factions.forEach(faction => {
        const val = effectiveRep[faction] || 0;
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
            curePoison(true);
            window.playerState.will = window.playerState.maxWill;
            addToLog("🧪 Ви випили Протиотруту в бою: отруту нейтралізовано, Рішучість відновлено!", "success");
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
            curePoison(true);
            window.playerState.will = window.playerState.maxWill;
            addToLog("🧪 Ви випили Протиотруту: отруту нейтралізовано, Рішучість відновлено!", "success");
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

// ===================================================================
// --- МОДУЛЬ: ОТРУЄННЯ, ЗАСІДКИ, ЗБЕРЕЖЕННЯ (ітерація "Небезпечне болото") ---
// ===================================================================

// --- СИСТЕМА ОТРУЄННЯ ---
function applyPoison(sourceText) {
    if (!window.playerState.poisoned) {
        window.playerState.poisoned = true;
        addToLog(`☠️ ${sourceText || "Отрута потрапила у вашу кров!"} Ви отруєні: −5 HP за кожен перехід, доки не вилікуєтесь.`, "damage");
        updateUi();
    }
}

function curePoison(silent) {
    if (window.playerState.poisoned) {
        window.playerState.poisoned = false;
        if (!silent) addToLog("✨ Отруту нейтралізовано. Кров знову чиста.", "success");
        updateUi();
    }
}

// --- ШАНСОВІ ЗАСІДКИ: болото карає за шум ---
function ambushOrGo(chance, enemyName, hp, atk, nextSceneKey, opts) {
    opts = opts || {};
    if (Math.random() < chance) {
        addToLog(`⚠️ ${opts.intro || "Болото відповідає на ваш шум — щось стрімко наближається крізь туман!"}`, "damage");
        startCombat(enemyName, hp, atk, () => {
            if (opts.poisonChance && Math.random() < opts.poisonChance) {
                applyPoison(opts.poisonText || "Рана від укусу почорніла — у кров потрапила болотна отрута!");
            }
            goScene(nextSceneKey);
        });
    } else {
        goScene(nextSceneKey);
    }
}

// --- СИСТЕМА ЗБЕРЕЖЕНЬ ---
const HZM_SAVE_KEY = "hazemoor_save_v1";

function saveGame(manual) {
    if (!gameStarted) return;
    if (combatState && combatState.inCombat) {
        if (manual) addToLog("💾 Неможливо зберегтися під час бою!", "system");
        return;
    }
    try {
        const save = {
            version: 1,
            ts: Date.now(),
            sceneKey: currentSceneKey,
            playerState: window.playerState
        };
        localStorage.setItem(HZM_SAVE_KEY, JSON.stringify(save));
        if (manual) addToLog("💾 Гру збережено.", "success");
    } catch (e) {
        if (manual) addToLog("💾 Не вдалося зберегти гру (сховище недоступне).", "damage");
    }
}

function loadSavedGame() {
    let save = null;
    try { save = JSON.parse(localStorage.getItem(HZM_SAVE_KEY)); } catch (e) { return false; }
    if (!save || !save.playerState || !save.sceneKey || !window.GAME_SCENES[save.sceneKey]) return false;

    window.playerState = save.playerState;
    gameStarted = true;

    const creation = document.getElementById("character-creation");
    if (creation) creation.style.display = "none";
    const sim = document.getElementById("main-simulator-interface");
    if (sim) sim.style.display = "flex";

    const heroName = document.getElementById("sidebar-hero-name");
    if (heroName) heroName.textContent = `⚖️ ${(window.playerState.name || "Вартовий").toUpperCase()}`;
    const heroGender = document.getElementById("sidebar-hero-gender");
    if (heroGender) heroGender.textContent = `${window.playerState.gender === 'Чоловік' ? '🙋‍♂️' : window.playerState.gender === 'Жінка' ? '🙋‍♀️' : '👤'} ${window.playerState.gender || ""}`;
    const heroBg = document.getElementById("sidebar-hero-bg");
    if (heroBg) heroBg.textContent = window.playerState.background || "";

    const audioBtn = document.getElementById("audio-toggle-btn");
    if (audioBtn) audioBtn.style.display = "inline-block";
    const saveBtn = document.getElementById("save-game-btn");
    if (saveBtn) saveBtn.style.display = "inline-block";

    const logDiv = document.getElementById("combat-log");
    if (logDiv) logDiv.innerHTML = "";
    addToLog(`💾 Збереження завантажено (${new Date(save.ts).toLocaleString("uk-UA")}). Подорож триває.`, "system");

    updateUi();
    goScene(save.sceneKey);
    return true;
}

// Автозбереження кожні 4 хвилини
setInterval(() => saveGame(false), 240000);

// Кнопка ручного збереження + кнопка "Продовжити" на екрані створення персонажа
document.addEventListener("DOMContentLoaded", () => {
    const saveBtn = document.getElementById("save-game-btn");
    if (saveBtn) saveBtn.addEventListener("click", () => saveGame(true));

    let hasSave = false;
    try { hasSave = !!localStorage.getItem(HZM_SAVE_KEY); } catch (e) {}
    if (hasSave) {
        const actions = document.querySelector(".creation-actions");
        const startBtn = document.getElementById("start-journey-btn");
        if (actions && startBtn) {
            const contBtn = document.createElement("button");
            contBtn.id = "continue-journey-btn";
            contBtn.className = "gothic-btn";
            contBtn.textContent = "⏳ ПРОДОВЖИТИ ЗБЕРЕЖЕНУ ПОДОРОЖ ⏳";
            contBtn.style.marginBottom = "0.6rem";
            contBtn.addEventListener("click", () => {
                if (!loadSavedGame()) {
                    addToLog("💾 Збереження пошкоджене — почніть нову подорож.", "damage");
                    contBtn.remove();
                }
            });
            actions.insertBefore(contBtn, startBtn);
        }
    }
});

// --- ІНТЕРАКТИВНА КАРТА СВІТУ ---
const MAP_LOCATIONS = {
    'arriving': {x: 63, y: 22, name: 'Грейфорд'},
    'greyford_room_hub': {x: 63, y: 22, name: 'Грейфорд'},
    'thread_carver': {x: 63, y: 22, name: 'Грейфорд'},
    'thread_tavern': {x: 63, y: 22, name: 'Грейфорд'},
    'thread_witch': {x: 63, y: 22, name: 'Грейфорд'},
    'sonk_ferry_hub': {x: 62, y: 38, name: 'Сонк-Феррі'},
    'holod_investigate': {x: 62, y: 38, name: 'Сонк-Феррі'},
    'popil_pid_kaplytseyu': {x: 28, y: 42, name: 'Затоплена Каплиця'},
    'quest_ferry': {x: 62, y: 38, name: 'Сонк-Феррі'},
    'sil_u_knyzi': {x: 62, y: 38, name: 'Сонк-Феррі'},
    'quest_verdict_kelm': {x: 62, y: 38, name: 'Сонк-Феррі'},
    'nizh_kvoty': {x: 62, y: 38, name: 'Сонк-Феррі'},
    'hazemoor_ep1': {x: 45, y: 52, name: 'Хейзмур'},
    'hazemoor_ep2': {x: 45, y: 55, name: 'Хейзмур'},
    'hazemoor_ep3': {x: 45, y: 60, name: 'Гнилі Поля'},
    'hazemoor_ep4': {x: 45, y: 63, name: 'Гнилі Поля'},
    'hazemoor_ep5': {x: 45, y: 63, name: 'Гнилі Поля'},
    'tykhy_arrive': {x: 68, y: 62, name: 'Тихий Шелест'},
    'tykhy_rufin': {x: 68, y: 62, name: 'Тихий Шелест'},
    'tykhy_kaen': {x: 68, y: 62, name: 'Тихий Шелест'},
    'tykhy_mia': {x: 68, y: 62, name: 'Тихий Шелест'},
    'mia_meeting': {x: 68, y: 62, name: 'Тихий Шелест'},
    'glade_mour': {x: 43, y: 82, name: 'Галявина Моура'},
    'valckorn_entry_ghetto': {x: 10, y: 14, name: 'Валькорн'},
    'valckorn_slums_district': {x: 10, y: 14, name: 'Валькорн'},
    'valckorn_palace_district': {x: 10, y: 14, name: 'Валькорн'},
    'valckorn_02_odrin': {x: 10, y: 14, name: 'Валькорн'},
    'valckorn_chapel_district': {x: 10, y: 14, name: 'Валькорн'},
    'valckorn_03_damar': {x: 10, y: 14, name: 'Валькорн'},
    'valckorn_04_loen': {x: 10, y: 14, name: 'Валькорн'},
    'valckorn_05_iliya': {x: 10, y: 14, name: 'Валькорн'},
    'valckorn_epilogue': {x: 10, y: 14, name: 'Валькорн'},
    'ep3_fog': {x: 45, y: 68, name: 'Хейзмур — глибина'},
    'ep3_vapor_zone': {x: 45, y: 68, name: 'Гнилі Поля'},
    'ep3_tykhy_tower': {x: 68, y: 62, name: 'Тихий Шелест'},
    'ep3_murok_guardian': {x: 73, y: 70, name: 'Затоплена Обитель'},
    'ep3_obitel': {x: 73, y: 70, name: 'Затоплена Обитель'},
    'ep3_altar': {x: 73, y: 70, name: 'Затоплена Обитель'},
    'ep3_ferry_crossing': {x: 48, y: 68, name: 'Шалена Річка'},
};

function showWorldMap() {
    const contentDiv = document.getElementById("bible-content");
    if (!contentDiv) return;

    const currentScene = window._currentSceneKey || null;
    const loc = currentScene ? MAP_LOCATIONS[currentScene] : null;

    const markerHtml = loc ? `
        <div style="
            position: absolute;
            left: ${loc.x}%;
            top: ${loc.y}%;
            transform: translate(-50%, -50%);
            z-index: 10;
            pointer-events: none;
        ">
            <div style="
                width: 18px; height: 18px;
                background: #d4af37;
                border: 2px solid #fff;
                border-radius: 50%;
                box-shadow: 0 0 0 3px rgba(212,175,55,0.5);
                animation: mapPulse 1.5s ease-in-out infinite;
            "></div>
            <div style="
                margin-top: 4px;
                background: rgba(0,0,0,0.8);
                color: #d4af37;
                font-size: 11px;
                font-weight: 700;
                padding: 2px 6px;
                border-radius: 3px;
                white-space: nowrap;
                text-align: center;
                transform: translateX(-35%);
                border: 1px solid rgba(212,175,55,0.4);
            ">⚔ ${loc.name}</div>
        </div>` : '';

    const noLocMsg = !loc && currentScene ?
        `<p style="color:var(--text-muted);font-size:0.85rem;margin-top:0.5rem">Локація "${currentScene}" не визначена на карті</p>` :
        !currentScene ? `<p style="color:var(--text-muted);font-size:0.85rem;margin-top:0.5rem">Розпочніть гру щоб побачити позицію Вартового</p>` : '';

    contentDiv.innerHTML = `
        <style>
            @keyframes mapPulse {
                0%,100% { box-shadow: 0 0 0 3px rgba(212,175,55,0.5); }
                50% { box-shadow: 0 0 0 8px rgba(212,175,55,0.15); }
            }
        </style>
        <div style="text-align:center;padding:0.5rem 0">
            <div style="position:relative;display:inline-block;max-width:100%">
                <img src="../web/assets/world-map.webp"
                     style="max-width:100%;border-radius:6px;border:1px solid var(--border-color);display:block"
                     alt="Карта світу Хейзмур">
                ${markerHtml}
            </div>
            ${noLocMsg}
        </div>`;
}

// ============================================================
// СИСТЕМА НАВІГАЦІЇ КАРТАМИ
// Ієрархія: world → location → interior
// ============================================================

const MAP_DATA = {
    world: {
        image: 'assets/maps/world.webp',
        title: 'Хейзмур та Околиці',
        back: null,
        hotspots: [
            { label: 'Валькорн',   x1:4,  y1:6,  x2:22, y2:32, target:'valkorn',    scene:['valckorn_entry_ghetto','valckorn_slums_district','valckorn_palace_district','valckorn_02_odrin','valckorn_chapel_district','valckorn_03_damar','valckorn_04_loen','valckorn_05_iliya','valckorn_epilogue'] },
            { label: 'Грейфорд',   x1:52, y1:12, x2:78, y2:34, target:'greyford',   scene:['arriving','greyford_room_hub','thread_carver','thread_tavern','thread_witch','gates'] },
            { label: 'Сонк-Феррі', x1:52, y1:34, x2:78, y2:52, target:'sonk-ferry', scene:['sonk_ferry_hub','holod_investigate','popil_pid_kaplytseyu','quest_ferry','sil_u_knyzi','quest_verdict_kelm','nizh_kvoty'] },
            { label: 'Тихий Шелест',x1:60,y1:55, x2:82, y2:75, target:'tykhy',      scene:['tykhy_arrive','tykhy_rufin','tykhy_kaen','tykhy_mia','mia_meeting'] },
            { label: 'Хейзмур',    x1:20, y1:44, x2:80, y2:98, target:'hazemoor',   scene:['hazemoor_ep1','hazemoor_ep2','hazemoor_ep3','hazemoor_ep4','hazemoor_ep5','glade_mour','ep3_vapor_zone','ep3_ferry_crossing','ep3_murok_guardian'] },
        ]
    },
    greyford: {
        image: 'assets/maps/greyford.webp',
        title: 'Грейфорд',
        back: 'world',
        hotspots: [
            { label: '① Таверна Ервана', x1:20, y1:38, x2:46, y2:72, target:'greyford-tavern', scene:['arriving','greyford_room_hub'] },
            { label: '③ Квартал ремісників', x1:52, y1:22, x2:74, y2:50, target:null, scene:['thread_carver'] },
            { label: '④ Портова таверна',   x1:56, y1:50, x2:74, y2:74, target:null, scene:['thread_tavern'] },
            { label: '⑤ Помешкання Чаклунки',x1:30, y1:10, x2:52, y2:36, target:null, scene:['thread_witch'] },
            { label: '⑥ Контора Келма',     x1:40, y1:38, x2:58, y2:58, target:null, scene:['quest_verdict_kelm'] },
            { label: '⑦ Залізні Ворота',    x1:38, y1:68, x2:56, y2:88, target:null, scene:['gates'] },
        ]
    },
    'greyford-tavern': {
        image: 'assets/maps/greyford-tavern.webp',
        title: 'Таверна Ервана — план',
        back: 'greyford',
        hotspots: [
            { label: 'Велика зала', x1:30, y1:5,  x2:65, y2:45, target:null, scene:['arriving'] },
            { label: '② Кімната Руфіна', x1:74, y1:52, x2:96, y2:88, target:null, scene:['greyford_room_hub'] },
            { label: 'Кабінет Ервана',   x1:64, y1:10, x2:84, y2:44, target:null, scene:[] },
        ]
    },
    valkorn: {
        image: 'assets/maps/valkorn.png',
        title: 'Валькорн',
        back: 'world',
        hotspots: [
            { label: '① Гетто',           x1:2,  y1:45, x2:30, y2:80, target:'valkorn-ghetto',   scene:['valckorn_entry_ghetto','valckorn_slums_district'] },
            { label: '③ Торговий квартал', x1:28, y1:20, x2:55, y2:55, target:null,               scene:['valckorn_03_damar','valckorn_04_loen'] },
            { label: '④ Монастирський клуатр', x1:28, y1:30, x2:55, y2:58, target:'valkorn-monastery', scene:['valckorn_chapel_district'] },
            { label: '⑤ Квартал палаців', x1:52, y1:10, x2:85, y2:45, target:null,               scene:['valckorn_palace_district'] },
            { label: '⑥ Палацовий архів', x1:55, y1:42, x2:78, y2:62, target:null,               scene:['valckorn_02_odrin'] },
            { label: '⑦ Чорний архів',    x1:60, y1:55, x2:80, y2:78, target:'valkorn-archive',  scene:['valckorn_05_iliya'] },
        ]
    },
    'valkorn-ghetto': {
        image: 'assets/maps/valkorn-ghetto.png',
        title: 'Затоплені Колектори — Неофіційна карта',
        back: 'valkorn',
        hotspots: [
            { label: 'Схованка Бреса', x1:22, y1:18, x2:48, y2:52, target:null, scene:['valckorn_entry_ghetto','valckorn_slums_district'] },
            { label: 'Підпільний ринок', x1:55, y1:45, x2:80, y2:75, target:null, scene:['valckorn_03_damar'] },
            { label: 'Покинутий колектор', x1:80, y1:55, x2:98, y2:85, target:null, scene:[] },
        ]
    },
    'valkorn-monastery': {
        image: 'assets/maps/valkorn-monastery.png',
        title: 'Монастирський Клуатр Семи Кинджалів',
        back: 'valkorn',
        hotspots: [
            { label: 'Тесина крамниця', x1:2, y1:25, x2:28, y2:75, target:null, scene:['valckorn_chapel_district'] },
            { label: 'Таємний хід', x1:22, y1:20, x2:40, y2:55, target:null, scene:['valckorn_04_loen'] },
            { label: 'Бібліотека Ордену', x1:68, y1:10, x2:92, y2:60, target:null, scene:['valckorn_05_iliya'] },
            { label: 'Ворота', x1:62, y1:72, x2:88, y2:95, target:null, scene:['valckorn_palace_district'] },
        ]
    },
    'valkorn-archive':   { image: null, title: 'Чорний Архів', back: 'valkorn', hotspots: [] },
    'sonk-ferry': {
        image: 'assets/maps/sonk-ferry.png',
        title: 'Сонк-Феррі — Остання Переправа',
        back: 'world',
        hotspots: [
            { label: 'Поромний причал — Тован Рід', x1:4,  y1:28, x2:28, y2:68, target:null, scene:['quest_ferry','sonk_ferry_hub'] },
            { label: 'Торговий майдан',             x1:25, y1:22, x2:52, y2:55, target:null, scene:['quest_verdict_kelm'] },
            { label: 'Оплот',                       x1:46, y1:22, x2:65, y2:55, target:null, scene:['sonk_ferry_hub','nizh_kvoty'] },
            { label: 'Каплиця Святої Вей — Карос',  x1:60, y1:28, x2:82, y2:62, target:null, scene:['holod_investigate'] },
            { label: 'Контрабандистський причал',   x1:74, y1:8,  x2:96, y2:40, target:null, scene:['sil_u_knyzi'] },
            { label: 'Затоплена Каплиця',           x1:74, y1:70, x2:98, y2:96, target:'sonk-ferry-chapel', scene:['popil_pid_kaplytseyu'] },
            { label: 'Нижній ярус',                 x1:4,  y1:58, x2:74, y2:90, target:null, scene:['valckorn_entry_ghetto'] },
        ]
    },
    'sonk-ferry-chapel': { image: null, title: 'Затоплена Каплиця', back: 'sonk-ferry', hotspots: [] },
    tykhy:      { image: null, title: 'Тихий Шелест', back: 'world', hotspots: [] },
    hazemoor:   { image: null, title: 'Хейзмур',      back: 'world', hotspots: [] },
};

let _mapHistory = [];

function showMapLevel(mapKey) {
    const contentDiv = document.getElementById('bible-content');
    if (!contentDiv) return;
    const map = MAP_DATA[mapKey];
    if (!map) return;

    const currentScene = window._currentSceneKey || null;

    // Знаходимо позицію вартового на цій карті
    const activeHotspot = map.hotspots.find(h => h.scene && h.scene.includes(currentScene));

    // Якщо карти ще немає — показуємо заглушку
    if (!map.image) {
        contentDiv.innerHTML = `
            <div style="text-align:center;padding:2rem;color:var(--text-muted)">
                <div style="font-size:3rem">🗺️</div>
                <h3 style="color:var(--accent-gold);margin:1rem 0">${map.title}</h3>
                <p>Карту ще не згенеровано</p>
                ${map.back ? `<button onclick="showMapLevel('${map.back}')" style="margin-top:1rem;padding:0.5rem 1.2rem;background:transparent;border:1px solid var(--accent-gold);color:var(--accent-gold);cursor:pointer;border-radius:4px">← Назад</button>` : ''}
            </div>`;
        return;
    }

    // Хотспоти — клікабельні зони
    const hotspotsHtml = map.hotspots.map((h, i) => {
        const isActive = h.scene && h.scene.includes(currentScene);
        const isClickable = h.target && MAP_DATA[h.target]?.image;
        return `<div 
            title="${h.label}"
            onclick="${isClickable ? `showMapLevel('${h.target}')` : ''}"
            style="
                position:absolute;
                left:${h.x1}%;top:${h.y1}%;
                width:${h.x2-h.x1}%;height:${h.y2-h.y1}%;
                border:${isActive ? '2px solid #d4af37' : (isClickable ? '1px dashed rgba(212,175,55,0.4)' : 'none')};
                background:${isActive ? 'rgba(212,175,55,0.08)' : 'transparent'};
                border-radius:4px;
                cursor:${isClickable ? 'pointer' : 'default'};
                z-index:5;
                transition: background 0.2s;
            "
            onmouseenter="this.style.background='rgba(212,175,55,0.12)'"
            onmouseleave="this.style.background='${isActive ? 'rgba(212,175,55,0.08)' : 'transparent'}'">
            ${isActive ? `<div style="
                position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);
                background:rgba(0,0,0,0.85);color:#d4af37;
                font-size:11px;font-weight:700;padding:3px 8px;border-radius:3px;
                border:1px solid rgba(212,175,55,0.5);white-space:nowrap;pointer-events:none;
            ">⚔ Вартовий тут</div>` : ''}
            ${isClickable ? `<div style="
                position:absolute;bottom:4px;right:4px;
                background:rgba(0,0,0,0.7);color:#d4af37;
                font-size:10px;padding:2px 5px;border-radius:2px;pointer-events:none;
            ">🔍 ${h.label}</div>` : ''}
        </div>`;
    }).join('');

    // Кнопка назад
    const backBtn = map.back ? `
        <button onclick="showMapLevel('${map.back}')" style="
            position:absolute;top:10px;left:10px;z-index:20;
            background:rgba(0,0,0,0.8);border:1px solid var(--accent-gold);
            color:var(--accent-gold);padding:6px 14px;border-radius:4px;
            cursor:pointer;font-size:0.85rem;font-weight:700;
        ">← ${MAP_DATA[map.back].title}</button>` : '';

    contentDiv.innerHTML = `
        <style>
            @keyframes mapPulse {
                0%,100% { box-shadow: 0 0 0 3px rgba(212,175,55,0.5); }
                50% { box-shadow: 0 0 0 8px rgba(212,175,55,0.15); }
            }
        </style>
        <div style="padding:0.5rem 0;text-align:center">
            <div style="position:relative;display:inline-block;max-width:100%">
                <img src="../${map.image}" 
                     style="max-width:100%;display:block;border-radius:6px;border:1px solid var(--border-color)"
                     alt="${map.title}">
                ${backBtn}
                ${hotspotsHtml}
            </div>
            ${!activeHotspot && currentScene ? 
                `<p style="color:var(--text-muted);font-size:0.8rem;margin-top:0.4rem">Вартовий зараз не на цій карті</p>` : ''}
        </div>`;
}

// Перевизначаємо showWorldMap щоб використовував нову систему
function showWorldMap() { showMapLevel('world'); }
