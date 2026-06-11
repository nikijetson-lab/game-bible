window.playerState = window.playerState || {};
window.EPISODE_1_QUESTS = window.EPISODE_1_QUESTS || [];
window.GAME_SCENES = {
    // --- ЕПІЗОД 1: ГРЕЙФОРД ТА СONK-FERRY ---
    arriving: {
        audioTrack: "assets/audio/ep1_tavern_music.mp3",
        audioAtmosphere: "assets/audio/ep1_tavern_crowd_loop.mp3",
        title: "Постоялий двір Грейфорда",
        get text() {
            const state = window.playerState || {};
            const q = state.completedQuests || {};
            if (q['erwan_choice_A'] && q['erwan_choice_B'] && q['erwan_choice_C'] && (!state.doctrines || state.doctrines.judge < 1 || q['erwan_choice_D'])) {
                return `Ерван мовчки протирає шинк важкою брудною ганчіркою, зрідка позираючи на вас із кутка.`;
            }
            return `Ви входите у напівтемну таверну Грейфорда. За шинком стоїть Ерван — похмурий хазяїн закладу. Він мовчки бере ваш лист, довго дивиться на стару сургучну печатку, тримає його на мить довше, ніж варто було б. Потім повільно піднімає очі на вас:<br><br><em>«І що він тобі був — друг, боржник, чи ти просто наймит-кур'єр, який шукає пригод на свою голову?»</em>`;
        },
        choices: [
            {
                text: "А. «Ми домовились із ним. Я приїхав сюди виконати свою частину угоди.»",
                visible: () => window.playerState && (!window.playerState.completedQuests || !window.playerState.completedQuests['erwan_choice_A']),
                action: () => {
                    window.playerState.completedQuests = window.playerState.completedQuests || {};
                    window.playerState.completedQuests['erwan_choice_A'] = true;
                    addToLog("Ерван киває: «Людина обов'язку — велика рідкість у наших краях. Ось ключ від його кімнати нагорі.»", "system");
                    goScene("arriving");
                }
            },
            {
                text: "Б. «Він мав щось, що мені дуже потрібне. Це виключно особиста справа.»",
                visible: () => window.playerState && (!window.playerState.completedQuests || !window.playerState.completedQuests['erwan_choice_B']),
                action: () => {
                    window.playerState.completedQuests = window.playerState.completedQuests || {};
                    window.playerState.completedQuests['erwan_choice_B'] = true;
                    addToLog("Ерван примружується: «У всіх тут свої приховані інтереси. Мені байдуже. Тримай ключ.»", "system");
                    goScene("arriving");
                }
            },
            {
                text: "В. «Я просто доставляю листа. Що буде далі — не моя проблема.»",
                visible: () => window.playerState && (!window.playerState.completedQuests || !window.playerState.completedQuests['erwan_choice_C']),
                action: () => {
                    window.playerState.completedQuests = window.playerState.completedQuests || {};
                    window.playerState.completedQuests['erwan_choice_C'] = true;
                    addToLog("Ерван хмикає: «Просто наймит. Це значно безпечніше для твого здоров'я. Забирай ключ.»", "system");
                    goScene("arriving");
                }
            },
            {
                text: "Г. [Доктрина Судді] «Я представлю офіційний закон Грейфорда. Ти зобов'язаний співпрацювати зі слідством.»",
                visible: () => window.playerState && window.playerState.doctrines && window.playerState.doctrines.judge >= 1 && (!window.playerState.completedQuests || !window.playerState.completedQuests['erwan_choice_D']),
                action: () => {
                    window.playerState.completedQuests = window.playerState.completedQuests || {};
                    window.playerState.completedQuests['erwan_choice_D'] = true;
                    addToLog("Ерван: «Закон... Що ж, ми поважаємо закон міста, хоча гниле болото Хейзмуру його ніколи не чуло. Візьми ключ.»", "system");
                    goScene("arriving");
                }
            },
            {
                text: "🚪 Піднятися на другий поверх до кімнати Руфіна",
                visible: () => true,
                action: () => goScene("greyford_room_hub")
            }
        ]
    },

    greyford_room_hub: {
        audioTrack: "assets/audio/ep1_tavern_music.mp3",
        audioAtmosphere: "assets/audio/ep1_tavern_crowd_loop.mp3",
        title: "Кімната Руфіна",
        text: `Ви заходите в порожню, порослу пилом кімнату зниклого картографа Руфіна. На старому дерев'яному ліжку лежить зношений плащ, дорожній посох та важка шкіряна сумка з незвичайним випаленим тавром у вигляді змії.<br><br>Огляньте приміщення ретельно:`,
        choices: [
            {
                text: "Провести стандартний ретельний обшук кімнати",
                visible: () => window.playerState && (!window.playerState.completedQuests || !window.playerState.completedQuests['room_standard']),
                action: () => {
                    window.playerState.completedQuests = window.playerState.completedQuests || {};
                    window.playerState.completedQuests['room_standard'] = true;
                    addToLog("Ви знайдете клеймо ремісничого кварталу. Це прямий привід відвідати місцевого різьбяра.", "success");
                    addItem("🎒 Сумка Руфіна з клеймом змії");
                    window.playerState.completedQuests['room'] = true;
                    if (window.playerState.completedQuests['room_standard'] && (!window.playerState.doctrines || window.playerState.doctrines.pathfinder < 1 || window.playerState.completedQuests['room_tracker']) && (!window.playerState.doctrines || window.playerState.doctrines.lantern < 1 || window.playerState.completedQuests['room_lantern'])) {
                        window.playerState.completedQuests['room_fully_cleared'] = true;
                    }
                    goScene("greyford_room_hub");
                }
            },
            {
                text: "[Слідопит] Шукати приховані сліди та торф'яний пил",
                visible: () => window.playerState && window.playerState.doctrines && window.playerState.doctrines.pathfinder >= 1 && (!window.playerState.completedQuests || !window.playerState.completedQuests['room_tracker']),
                action: () => {
                    window.playerState.completedQuests = window.playerState.completedQuests || {};
                    window.playerState.completedQuests['room_tracker'] = true;
                    addToLog("На підлозі виявлено чорний торф із глибокого Хейзмуру. Руфін точно ходив туди раніше і знав маршрут.", "success");
                    window.playerState.reputation = window.playerState.reputation || {};
                    window.playerState.reputation.muri = (window.playerState.reputation.muri || 0) + 10;
                    if (window.playerState.completedQuests['room_standard'] && (!window.playerState.doctrines || window.playerState.doctrines.pathfinder < 1 || window.playerState.completedQuests['room_tracker']) && (!window.playerState.doctrines || window.playerState.doctrines.lantern < 1 || window.playerState.completedQuests['room_lantern'])) {
                        window.playerState.completedQuests['room_fully_cleared'] = true;
                    }
                    goScene("greyford_room_hub");
                }
            },
            {
                text: "[Ліхтар] Оглянути стіни на наявність прихованих захисних рун",
                visible: () => window.playerState && window.playerState.doctrines && window.playerState.doctrines.lantern >= 1 && (!window.playerState.completedQuests || !window.playerState.completedQuests['room_lantern']),
                action: () => {
                    window.playerState.completedQuests = window.playerState.completedQuests || {};
                    window.playerState.completedQuests['room_lantern'] = true;
                    window.playerState.completedQuests['witch_unlocked'] = true;
                    addToLog("Виявили свіжі захисні руни над дверима. Руфін ставив захист не від людей, а від істот. Це відкриває підказку про Чаклунку.", "success");
                    window.playerState.reputation = window.playerState.reputation || {};
                    window.playerState.reputation.keepers = (window.playerState.reputation.keepers || 0) + 10;
                    if (window.playerState.completedQuests['room_standard'] && (!window.playerState.doctrines || window.playerState.doctrines.pathfinder < 1 || window.playerState.completedQuests['room_tracker']) && (!window.playerState.doctrines || window.playerState.doctrines.lantern < 1 || window.playerState.completedQuests['room_lantern'])) {
                        window.playerState.completedQuests['room_fully_cleared'] = true;
                    }
                    goScene("greyford_room_hub");
                }
            },
            {
                text: "Вийти на вулиці Грейфорда (ХАБ розслідування)",
                visible: () => true,
                action: () => {
                    if (window.playerState.completedQuests && window.playerState.completedQuests['room_standard']) {
                        window.playerState.completedQuests['room_fully_cleared'] = true;
                    }
                    goScene("greyford_01");
                }
            }
        ]
    },

    greyford_01: {
        audioTrack: "assets/audio/ep1_city_music.mp3",
        audioAtmosphere: "assets/audio/ep1_city_ambient.mp3",
        title: "Вулиці Грейфорда (ХАБ)",
        text: `Ви перебуваєте на брудних, оповитих легким туманом вулицях Грейфорда. Звідси ви можете дістатися до різних ремісничих та портових кварталів міста, щоб завершити розслідування справи Руфіна.`,
        choices: [
            {
                text: "🛠️ Відвідати квартал ремісників та розпитати старого Різьбяра",
                visible: () => window.playerState && window.playerState.completedQuests && window.playerState.completedQuests['room_fully_cleared'] && !window.playerState.completedQuests['craftsmen_done'],
                action: () => goScene("thread_carver")
            },
            {
                text: "🍻 Завітати у портову таверну та знайти куртизанку Касандру",
                visible: () => window.playerState && window.playerState.completedQuests && window.playerState.completedQuests['room_fully_cleared'] && !window.playerState.completedQuests['tavern_done'],
                action: () => goScene("thread_tavern")
            },
            {
                text: "🧙‍♀️ Оглянути будинок Чаклунки на околиці міста",
                visible: () => window.playerState && window.playerState.completedQuests && window.playerState.completedQuests['room_fully_cleared'] && window.playerState.completedQuests['witch_unlocked'] && !window.playerState.completedQuests['witch_done'],
                action: () => goScene("thread_witch")
            },
            {
                text: "🚧 Перейти до Міських воріт для підведення підсумків",
                visible: () => {
                    if (!window.playerState || !window.playerState.completedQuests) return false;
                    const baseCityDone = window.playerState.completedQuests['craftsmen_done'] && window.playerState.completedQuests['tavern_done'];
                    return window.playerState.completedQuests['witch_unlocked'] ? (baseCityDone && window.playerState.completedQuests['witch_done']) : baseCityDone;
                },
                action: () => goScene("greyford_summary")
            },
            {
                text: "Повернутися до кімнати Руфіна",
                visible: () => true,
                action: () => goScene("greyford_room_hub")
            }
        ]
    },

    thread_carver: {
        audioTrack: "assets/audio/ep1_city_music.mp3",
        audioAtmosphere: "assets/audio/ep1_city_ambient.mp3",
        title: "Квартал ремісників — Різьбяр",
        text: `Ви знаходите похмуру майстерню різьбяра по дереву. Старий майстер зосереджено працює над викривленою болотяною гілкою і вкрай неохоче реагує на ваші запитання про зниклого картографа: «Багато хто тут приходить і йде в імлу. Чому я маю допомагати кожному зустрічному Вартовому?»`,
        choices: [
            {
                text: "Показати йому лист Руфіна з таємничою сургучною печаткою",
                visible: () => window.playerState && window.playerState.completedQuests && !window.playerState.completedQuests['carver_seal'],
                action: () => {
                    window.playerState.completedQuests['carver_seal'] = true;
                    addToLog("Різьбяр помітно здригується від вигляду символу: «Руфін детально питав про стару дорогу до Тихого Шелесту.»", "success");
                    window.playerState.reputation.order = (window.playerState.reputation.order || 0) + 15;
                    window.playerState.completedQuests['craftsmen_done'] = true;
                    goScene("greyford_01");
                }
            },
            {
                text: "[Слідопит] Ретельно оглянути корінь-вербу на його верстаті",
                visible: () => window.playerState && window.playerState.doctrines && window.playerState.doctrines.pathfinder >= 1 && !window.playerState.completedQuests['carver_pathfinder'],
                action: () => {
                    window.playerState.completedQuests['carver_pathfinder'] = true;
                    addToLog("Ви помічаєте специфічні зрізи. Різьбяр зізнається: «Руфін ніс із собою щось дуже важке в мішку.»", "success");
                    window.playerState.reputation.muri = (window.playerState.reputation.muri || 0) + 15;
                    window.playerState.completedQuests['craftsmen_done'] = true;
                    goScene("greyford_01");
                }
            },
            {
                text: "Повернутися назад на вулиці міста",
                visible: () => true,
                action: () => goScene("greyford_01")
            }
        ]
    },

    thread_tavern: {
        audioTrack: "assets/audio/ep1_tavern_music.mp3",
        audioAtmosphere: "assets/audio/ep1_tavern_crowd_loop.mp3",
        title: "Портова таверна",
        text: `У брудному та галасливому портовому шинку бармен ліниво протирає склянку: «Руфін часто спілкувався з нашою куртизанкою на ім'я Касандра. Вона он сиділа за кутовим столиком.»<br><br>Касандра дивиться на ваш обладунок із глибокою підозрою.`,
        choices: [
            {
                text: "Запитати її напряму про останні години Руфіна в місті",
                visible: () => window.playerState && window.playerState.completedQuests && !window.playerState.completedQuests['tavern_speak'],
                action: () => {
                    window.playerState.completedQuests['tavern_speak'] = true;
                    addToLog("Касандра шепоче: «Руфін був смертельно наляканий чимось... Він поспіхом пішов наступного ранку через браму.»", "success");
                    window.playerState.reputation.admin = (window.playerState.reputation.admin || 0) + 10;
                    window.playerState.completedQuests['tavern_done'] = true;
                    goScene("greyford_01");
                }
            },
            {
                text: "[Посередник] Запитати про розрахунок сріблом",
                visible: () => window.playerState && window.playerState.doctrines && window.playerState.doctrines.mediator >= 1 && !window.playerState.completedQuests['tavern_mediator'],
                action: () => {
                    window.playerState.completedQuests['tavern_mediator'] = true;
                    addToLog("Касандра здається: «Він платив чистим урядовим сріблом. Хтось із Валькорна дуже добре проспонсорував його похід.»", "success");
                    window.playerState.reputation.order = (window.playerState.reputation.order || 0) + 10;
                    window.playerState.completedQuests['tavern_done'] = true;
                    goScene("greyford_01");
                }
            },
            {
                text: "Повернутися на вулиці Грейфорда",
                visible: () => true,
                action: () => goScene("greyford_01")
            }
        ]
    },

    thread_witch: {
        audioTrack: "assets/audio/ep1_city_music.mp3",
        audioAtmosphere: "assets/audio/ep1_city_ambient.mp3",
        title: "Помешкання Чаклунки",
        text: `Ви знайшли прихований, зарослий мохом будинок на самій околиці міста, рясно прикрашений оберегами від болотяних духів Хейзмуру. Чаклунка зустрічає вас із загадковою посмішкою: «Руфін? О так, я бачила, як він поспіхом ішов у болота посеред ночі...»`,
        choices: [
            {
                text: "Розпитати її про стан картографа",
                visible: () => window.playerState && window.playerState.completedQuests && !window.playerState.completedQuests['witch_speak'],
                action: () => {
                    window.playerState.completedQuests['witch_speak'] = true;
                    addToLog("Чаклунка киває: «Він ніс якусь дуже стару, важку річ, яка горіла зсередини неземним холодним світлом.»", "success");
                    window.playerState.reputation.muri = (window.playerState.reputation.muri || 0) + 10;
                    window.playerState.completedQuests['witch_done'] = true;
                    goScene("greyford_01");
                }
            },
            {
                text: "[Ліхтар] Уважно оглянути залишкове світіння в кутку її кімнати",
                visible: () => window.playerState && window.playerState.doctrines && window.playerState.doctrines.lantern >= 1 && !window.playerState.completedQuests['witch_lantern'],
                action: () => {
                    window.playerState.completedQuests['witch_lantern'] = true;
                    addToLog("Ви чітко розпізнаєте зелений вогонь артефакту Моура. Чаклунка дає вам захисний амулет.", "success");
                    window.playerState.inventory = window.playerState.inventory || [];
                    window.playerState.inventory.push("🧿 Болотяний амулет");
                    window.playerState.reputation.keepers = (window.playerState.reputation.keepers || 0) + 20;
                    window.playerState.completedQuests['witch_done'] = true;
                    goScene("greyford_01");
                }
            },
            {
                text: "Повернутися до міського хабу",
                visible: () => true,
                action: () => goScene("greyford_01")
            }
        ]
    },

    greyford_summary: {
        audioTrack: "assets/audio/ep1_city_music.mp3",
        audioAtmosphere: "assets/audio/ep1_city_ambient.mp3",
        title: "Що відомо після Грейфорда",
        text: `Ви зібрали всі можливі сліди, залишлені Руфіном у місті Грейфорд. Ваші остаточні висновки підтверджують:<br><br>
        <ul>
            <li>Руфін пішов у небезпечний район Тихий Шелест абсолютно цілеспрямовано.</li>
            <li>Він панічно боявся того, що міг знайти в глибинах, а не переслідувачів з міста.</li>
            <li>Він ніс із собою древній важкий вантаж, що світився холодним зеленим світлом.</li>
            <li>Хтось впливовий з Валькорна заплатив йому за цей похід чистим сріблом.</li>
        </ul><br>
        Час остаточно покинути стіни міста і вирушити крізь браму в туманні болота Хейзмуру.`,
        choices: [
            {
                text: "Підійти до Міської брами для виходу",
                action: () => goScene('greyford_gates')
            }
        ]
    },

    greyford_gates: {
        audioTrack: "assets/audio/ep1_city_music.mp3",
        audioAtmosphere: "assets/audio/ep1_city_ambient.mp3",
        title: "Міська брама Грейфорда — Вихід",
        text: `Ви підходите до масивних дерев'яних воріт. Сержант міської варти суворо оглядає вас з ніг до голови і зупиняє своїм залізним списом: <br><br><em>«Картограф Руфін офіційно вийшов три дні тому в напрямку Тихого Шелесту. З якого приводу озброєний Вартовий іде в ці прокляті болота Хейзмуру?»</em>`,
        choices: [
            {
                text: "«Я шукаю людину. Руфін пішов і не повернувся, я зобов'язаний його повернути.» (Правда)",
                action: () => {
                    window.playerState.reputation = window.playerState.reputation || {};
                    window.playerState.reputation.admin = (window.playerState.reputation.admin || 0) + 20;
                    window.playerState.reputation.order = (window.playerState.reputation.order || 0) + 10;
                    addToLog("Сержант киває: «Нехай чистий закон світить тобі в цьому клятому тумані.»", "success");
                    goScene("ending_episode1");
                }
            },
            {
                text: "«Я маю перевірити безпеку торгового маршруту. Є скарги на поромників.» (Напівправда)",
                action: () => {
                    window.playerState.reputation = window.playerState.reputation || {};
                    window.playerState.reputation.admin = (window.playerState.reputation.admin || 0) + 5;
                    window.playerState.reputation.order = (window.playerState.reputation.order || 0) - 5;
                    addToLog("Сержант скептично хмикає: «У Хейзмурі ніколи не було й не буде безпеки. Ну йди, якщо життя не миле.»", "success");
                    goScene("ending_episode1");
                }
            },
            {
                text: "⚖️ [Доктрина Судді] «Я виконую офіційне таємне доручення суду Грейфорда. Зареєструйте мій вихід негайно.»",
                visible: () => window.playerState && window.playerState.doctrines && window.playerState.doctrines.judge >= 1,
                action: () => {
                    window.playerState.reputation = window.playerState.reputation || {};
                    window.playerState.reputation.admin = (window.playerState.reputation.admin || 0) + 30;
                    window.playerState.reputation.order = (window.playerState.reputation.order || 0) + 15;
                    addToLog("Сержант миттєво витягується струнко: «Зрозуміло, пане Суддя. Ваша подорож внесена до спеціального реєстру Корони.»", "success");
                    goScene("ending_episode1");
                }
            }
        ]
    },

    ending_episode1: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Перехідний етап: На межі імли",
        text: `Брама з гуркотом зачиняється за вашою спиною. Ви залишаєте безпечні зони порядку Грейфорда. Попереду розстилається зелена отруйна ковдра Туману. Настав час обрати точку входу в Сонк-Феррі.`,
        choices: [
            {
                text: "Вирушити безпосередньо до Сонк-Феррі через Смердючі Багнюки",
                action: () => goScene("sonk_ferry_hub")
            }
        ]
    },

    sonk_ferry_hub: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Сонк-Феррі: Оплот на Болоті",
        text: `Ви прибули до затопленого поромного поселення Сонк-Феррі. Повітря тут неймовірно густе від болотного туману, а нечисленні місцеві жителі дивляться на ваш обладунок із глибокою недовірою. Напруга між силами Адміністрації та фракцією Мурів відчувається в кожному провулку. Ви повинні закрити три ключові справи, перш ніж з'явиться урядовий чиновник.`,
        choices: [
            {
                text: "📦 Дослідити справу «Сіль у книзі» (Контрабанда ліків Мурів)",
                visible: () => !window.playerState.sonkFerry || window.playerState.sonkFerry.medsStatus === null,
                action: () => goScene("quest_meds")
            },
            {
                text: "🛶 Розібратися в «Поромній присязі» (Контроль над річкою)",
                visible: () => !window.playerState.sonkFerry || window.playerState.sonkFerry.ferryControl === null,
                action: () => goScene("quest_ferry")
            },
            {
                text: "🕯️ Оглянути «Попіл під каплицею» (Заборонений ритуал)",
                visible: () => !window.playerState.sonkFerry || window.playerState.sonkFerry.chapelRitual === null,
                action: () => goScene("quest_chapel")
            },
            {
                text: "⚖️ Очікувати на прибуття Верховного чиновника (Маршал Серіт Келм)",
                visible: () => window.playerState.sonkFerry && window.playerState.sonkFerry.medsStatus !== null && window.playerState.sonkFerry.ferryControl !== null && window.playerState.sonkFerry.chapelRitual !== null,
                action: () => goScene("quest_verdict_kelm")
            }
        ]
    },

    quest_meds: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Сіль у книзі",
        text: `Ви успішно виявили таємну схованку з рідкісними медикаментами, які народ Мурі намагається таємно провести в обхід жорстких квот людської Адміністрації для порятунку своїх хворих дітей від болотяної лихоманки. Яке рішення ви приймете як представник закону?`,
        choices: [
            {
                text: "Дозволити контрабанду ліків та допомогти приховати сліди для Мурі",
                action: () => {
                    window.playerState.sonkFerry = window.playerState.sonkFerry || { medsStatus: null, ferryControl: null, chapelRitual: null, finalVerdict: null };
                    window.playerState.sonkFerry.medsStatus = "smuggled";
                    window.playerState.reputation = window.playerState.reputation || {};
                    window.playerState.reputation.muri = (window.playerState.reputation.muri || 0) + 15;
                    window.playerState.reputation.admin = (window.playerState.reputation.admin || 0) - -10;
                    addToLog("Ви допомогли Мурі. Повага Амфібій зросла, але Адміністрація вас підозрює.", "success");
                    goScene("sonk_ferry_hub");
                }
            },
            {
                text: "Конфіскувати нелегальний товар на користь складів людського міста",
                action: () => {
                    window.playerState.sonkFerry = window.playerState.sonkFerry || { medsStatus: null, ferryControl: null, chapelRitual: null, finalVerdict: null };
                    window.playerState.sonkFerry.medsStatus = "confiscated";
                    window.playerState.reputation = window.playerState.reputation || {};
                    window.playerState.reputation.admin = (window.playerState.reputation.admin || 0) + 15;
                    window.playerState.reputation.muri = (window.playerState.reputation.muri || 0) - 10;
                    addToLog("Товар повністю конфісковано. Чиновники задоволені вашою старанністю.", "system");
                    goScene("sonk_ferry_hub");
                }
            }
        ]
    },

    quest_ferry: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Поромна присяга",
        text: `На головній пристані розгортається небезпечна суперечка за контроль над єдиним безпечним поромним плотом. Представник Адміністрації Тован Рід вимагає конфіскувати його під військові потреби, а Нера Вейл з корінного народу Мурі заявляє, що пором належить їхній громаді за правом першопрохідців.`,
        choices: [
            {
                text: "«Я вже повністю закрив квоту міста по ліках. Пором має справедливо залишитися за Нерою.»",
                visible: () => window.playerState && window.playerState.sonkFerry && window.playerState.sonkFerry.medsStatus === "confiscated",
                action: () => {
                    window.playerState.sonkFerry.ferryControl = "vale";
                    window.playerState.reputation.muri = (window.playerState.reputation.muri || 0) + 15;
                    addToLog("Ви використали конфісковані ліки як дипломатичний важіль. Пором залишається у Мурі.", "success");
                    goScene("sonk_ferry_hub");
                }
            },
            {
                text: "Підтримати вимоги Тована Ріда (Передати контроль Адміністрації)",
                action: () => {
                    window.playerState.sonkFerry = window.playerState.sonkFerry || { medsStatus: null, ferryControl: null, chapelRitual: null, finalVerdict: null };
                    window.playerState.sonkFerry.ferryControl = "reed";
                    window.playerState.reputation = window.playerState.reputation || {};
                    window.playerState.reputation.admin = (window.playerState.reputation.admin || 0) + 15;
                    window.playerState.reputation.muri = (window.playerState.reputation.muri || 0) - 5;
                    addToLog("Пором заблоковано військовими. Лояльність Адміністрації зросла.", "system");
                    goScene("sonk_ferry_hub");
                }
            },
            {
                text: "Підтримати Неру Вейл (Залишити пором у власності Амфібій)",
                action: () => {
                    window.playerState.sonkFerry = window.playerState.sonkFerry || { medsStatus: null, ferryControl: null, chapelRitual: null, finalVerdict: null };
                    window.playerState.sonkFerry.ferryControl = "vale";
                    window.playerState.reputation = window.playerState.reputation || {};
                    window.playerState.reputation.muri = (window.playerState.reputation.muri || 0) + 15;
                    window.playerState.reputation.keepers = (window.playerState.reputation.keepers || 0) + 5;
                    addToLog("Пором захищено від конфіскації. Народ Мурі вдячний за справедливість.", "success");
                    goScene("sonk_ferry_hub");
                }
            }
        ]
    },

    quest_chapel: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Попіл під каплицею",
        text: `Під напівзатопленою старою каплицею група релігійних відступників намагається провести заборонену імітацію стародавнього ритуалу Святої Вей. Це вкрай небезпечно і за офіційними даними може привернути увагу сутностей з глибокої Темряви болота.`,
        choices: [
            {
                text: "Жорстко зупинити імітацію небезпечного ритуалу Ключників",
                action: () => {
                    window.playerState.sonkFerry = window.playerState.sonkFerry || { medsStatus: null, ferryControl: null, chapelRitual: null, finalVerdict: null };
                    window.playerState.sonkFerry.chapelRitual = "stopped";
                    window.playerState.reputation = window.playerState.reputation || {};
                    window.playerState.reputation.keepers = (window.playerState.reputation.keepers || 0) + 20;
                    addToLog("Ритуал повністю перервано. Хранителі ліхтарів висловлюють вам свою повагу.", "system");
                    goScene("sonk_ferry_hub");
                }
            },
            {
                text: "Проігнорувати єретичне збіговисько заради отримання власної вигоди",
                action: () => {
                    window.playerState.sonkFerry = window.playerState.sonkFerry || { medsStatus: null, ferryControl: null, chapelRitual: null, finalVerdict: null };
                    window.playerState.sonkFerry.chapelRitual = "ignored";
                    window.playerState.reputation = window.playerState.reputation || {};
                    window.playerState.reputation.keepers = (window.playerState.reputation.keepers || 0) - 10;
                    window.playerState.corruption = (window.playerState.corruption || 0) + 5;
                    addToLog("Ви закрили очі на єресь. Ваша корупція зросла на 5 одиниць від впливу Туману.", "damage");
                    goScene("sonk_ferry_hub");
                }
            }
        ]
    },

    quest_verdict_kelm: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Прибуття Маршала-Реєстратора",
        text: `Маршал-Реєстратор Серіт Келм офіційно прибув до Сонк-Феррі під охороною гвардії. Настав вирішальний момент — ви повинні винести свій остаточний вердикт щодо майбутнього статусу цього прикордонного поселення на основі зібраних доказів.`,
        choices: [
            {
                text: "Вердикт А: Пристосування (Підписати жорсткий урядовий звіт Адміністрації)",
                visible: () => {
                    const r = window.playerState.reputation || { admin: 0, order: 0, muri: 0, keepers: 0 };
                    return (r.admin || 0) >= 10 || ((r.admin || 0) < 10 && (r.order || 0) < 5 && (r.muri || 0) < 15 && (r.keepers || 0) < 15);
                },
                action: () => {
                    window.playerState.sonkFerry.finalVerdict = "adaptation";
                    window.playerState.reputation.admin = (window.playerState.reputation.admin || 0) + 30;
                    addToLog("Звіт підписано. Ви вирушаєте вглиб Хейзмуру за лінію очерету.", "system");
                    goScene("mia_rescue");
                }
            },
            {
                text: "Вердикт Б: Контрольоване стримування (Передати повноваження Ордену)",
                visible: () => window.playerState && window.playerState.reputation && (window.playerState.reputation.order || 0) >= 5,
                action: () => {
                    window.playerState.sonkFerry.finalVerdict = "containment";
                    window.playerState.reputation.admin = (window.playerState.reputation.admin || 0) + 20;
                    window.playerState.reputation.order = (window.playerState.reputation.order || 0) + 10;
                    addToLog("Орден бере поселення під залізний контроль. Ви йдете далі за слідом Руфіна.", "system");
                    goScene("mia_rescue");
                }
            },
            {
                text: "Вердикт В: Місцева угода (Укласти канонічний пакт із вождем Мурі)",
                visible: () => window.playerState && window.playerState.reputation && (window.playerState.reputation.muri || 0) >= 15,
                action: () => {
                    window.playerState.sonkFerry.finalVerdict = "pact";
                    window.playerState.reputation.muri = (window.playerState.reputation.muri || 0) + 30;
                    window.playerState.reputation.admin = (window.playerState.reputation.admin || 0) - 15;
                    addToLog("Пакт підписано на користь автономії Амфібій. Ви вирушаєте до болотяних очеретів.", "success");
                    goScene("mia_rescue");
                }
            },
            {
                text: "Вердикт Г: Ритуальне милосердя (Віддати владу Хранителям Ліхтарів)",
                visible: () => window.playerState && window.playerState.reputation && (window.playerState.reputation.keepers || 0) >= 15,
                action: () => {
                    window.playerState.sonkFerry.finalVerdict = "mercy";
                    window.playerState.reputation.keepers = (window.playerState.reputation.keepers || 0) + 30;
                    window.playerState.reputation.muri = (window.playerState.reputation.muri || 0) + 15;
                    addToLog("Владу передано духовній громаді Ключників. Попереду — великий Туман.", "success");
                    goScene("mia_rescue");
                }
            }
        ]
    },

    // --- ЗУСТРІЧ З МІА: ПОРЯТУНОК ВІД БОЛОТНОЇ ТВАРЮКИ ---

    mia_rescue: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Крик за лінією очерету",
        text: `Сонк-Феррі залишається за спиною. Ви перетинаєте лінію очерету — невидимий кордон, за яким закінчується влада Адміністрації і починається справжній Хейзмур. Перші ж сто кроків забирають у вас відчуття твердої землі: стежка тоне, туман густішає, повітря пахне гниллю та залізом.<br><br>Раптом тишу розриває короткий, відчайдушний крик. За стіною очерету, у мілкій чорній заводі, ви бачите дівчину з народу Мурі — вона притиснута до напівзатопленої корчаги. Над нею здіймається <strong>болотна тварюка</strong>: слизька гора м'язів і твані, вкрита плівкою ряски, з пащею, повною голчастих зубів. Хвіст істоти вже обвив ногу дівчини і повільно тягне її під воду. У її руці — лише короткий кістяний ніж, яким вона марно б'є по панцирній шкурі.<br><br>У вас є лічені секунди.`,
        choices: [
            {
                text: "Вихопити меч і кинутися в лобову атаку, відволікаючи тварюку на себе.",
                action: () => {
                    window.playerState.mia_trust = (window.playerState.mia_trust || 0) + 1;
                    addToLog("Ви з ревом врізаєтеся у воду. Тварюка випускає здобич і розвертається до нового, більшого ворога — до вас.", "damage");
                    startCombat("Болотна тварюка", 55, 12, () => {
                        window.playerState.completedQuests = window.playerState.completedQuests || {};
                        window.playerState.completedQuests['mia_rescued'] = true;
                        goScene("mia_meeting");
                    });
                }
            },
            {
                text: "Метнути камінь у голову істоти, а коли вона відволічеться — вдарити збоку, у незахищене черево.",
                action: () => {
                    window.playerState.mia_trust = (window.playerState.mia_trust || 0) + 1;
                    addToLog("Камінь влучає точно в око. Тварюка сахається, послаблює хватку — і ваш клинок входить у м'яке черево збоку. Перша кров за вами.", "success");
                    startCombat("Поранена болотна тварюка", 40, 12, () => {
                        window.playerState.completedQuests = window.playerState.completedQuests || {};
                        window.playerState.completedQuests['mia_rescued'] = true;
                        goScene("mia_meeting");
                    });
                }
            },
            {
                text: "Завмерти на мить і оцінити противника, перш ніж атакувати.",
                action: () => {
                    window.playerState.mia_trust = (window.playerState.mia_trust || 0) - 1;
                    addToLog("Поки ви вагаєтеся, хвіст тварюки встигає затягнути дівчину по пояс у трясовину. Її погляд на мить зустрічається з вашим — і ви читаєте в ньому не страх, а холодний осуд. Ви нарешті атакуєте.", "damage");
                    startCombat("Болотна тварюка", 55, 14, () => {
                        window.playerState.completedQuests = window.playerState.completedQuests || {};
                        window.playerState.completedQuests['mia_rescued'] = true;
                        goScene("mia_meeting");
                    });
                }
            }
        ]
    },

    mia_meeting: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Міа з народу Мурі",
        text: `Тварюка, залишаючи за собою шлейф темної крові, з низьким булькотінням занурюється у глибину заводі — болото забирає поранене дитя назад. Западає тиша, яку порушує лише ваше важке дихання.<br><br>Дівчина вибирається на кочку — і ви вперше бачите Мурі зблизька. Вона молода й жилава, її майже чорна шкіра відливає глибокою зеленню там, де торкається світло, а на шиї помітні тонкі лінії зябер. Великі жовто-зелені очі з вертикальними зіницями дивляться на вас прямо і довго, не кліпаючи. На зап'ястках і ключицях — свіжі захисні знаки болотяною фарбою: вона знала, що йде туди, де небезпечно. Кістяний ніж зникає у піхвах на стегні так швидко, наче його й не було. Вона довго мовчки роздивляється вас — ваше залізо, ваш меч, печатку Вартового.<br><br><em>«Чужинці в залізі не лізуть у воду за Мурі. Ніколи. Ти — перший,»</em> — нарешті каже вона. — <em>«Мене звати Міа. Ти йдеш углиб, до Тихого Шелесту — я чула, як ти питав дорогу на поромі. Сам ти туди не дійдеш: болото з'їсть тебе ще до другого світанку. Я проведу. Три дні шляху. Але затям одне, людино заліза: тут командую я. Роби, як я кажу, став ноги, куди я ставлю, — і, можливо, дійдеш живим.»</em>`,
        choices: [
            {
                text: "«Я приймаю твої правила, провіднице. Болото — твій дім, і я в ньому гість.»",
                action: () => {
                    window.playerState.mia_trust = (window.playerState.mia_trust || 0) + 1;
                    window.playerState.reputation = window.playerState.reputation || {};
                    window.playerState.reputation.muri = (window.playerState.reputation.muri || 0) + 5;
                    addToLog("Міа схвально киває: «Гість, який вміє слухати. Рідкість.» Вона розвертається і безшумно рушає у туман.", "success");
                    goScene("hazemoor_ep1");
                }
            },
            {
                text: "«Веди. Але я Вартовий, і моя місія важливіша за твої правила.»",
                action: () => {
                    addToLog("Міа коротко хмикає: «Болоту байдуже до твоїх місій. Побачимо, чого вартує твоє залізо.» Вона рушає вперед, не озираючись.", "system");
                    goScene("hazemoor_ep1");
                }
            },
            {
                text: "Мовчки кивнути й запитати, що це була за істота.",
                action: () => {
                    addToLog("Міа дивиться на темну воду: «Молодий мурок-трясовик. Дитя Моура. Запам'ятай його запах — дорослого ти вже не переживеш.» Вона жестом кличе вас за собою.", "system");
                    goScene("hazemoor_ep1");
                }
            }
        ]
    },

    // --- СЦЕНА СМЕРТІ (ГЛОБАЛЬНА) ---

    death: {
        audioTrack: "assets/audio/death_music.mp3",
        audioAtmosphere: "assets/audio/death_ambient.mp3",
        title: "💀 Кінець шляху",
        text: `Холод приходить раніше за біль. Світ звужується до сірої плями туману над головою, і остання думка тоне разом із вами у чорній воді Хейзмуру.<br><br>Болото не знає імен. Воно не пам'ятає ні Вартових, ні їхніх печаток, ні вердиктів, які вони не встигли винести. За кілька днів ряска зімкнеться над цим місцем, і лише Хранителі Ліхтарів, проходячи повз, запалять тонку свічку — за ще одного чужинця, який вважав, що залізо сильніше за твань.<br><br><em>Ваша історія обірвалася. Але Хейзмур чекає на нового мандрівника.</em>`,
        isAbsoluteFinal: true,
        choices: []
    },

    // --- ПОВНИЙ ТРИДЕННИЙ ШЛЯХ КРІЗЬ БОЛОТА З МІЄЮ (АКТ I ПРОДОВЖЕННЯ) ---
    hazemoor_ep1: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Шум на воді — День перший",
        text: `Перед світанком, перший день вашої подорожі вглиб невідомого Хейзмуру. Ви йдете по коліно в холодній смердючій воді через неймовірно вузьку та темну протоку в гнилому очереті. Ваша супутниця Міа — загадкова дівчина з народу Мурі — рухається абсолютно безшумно, наче ковзає над тванню. Ви ж у своєму важкому залізному обладунку Вартового створюєте колосальний гуркіт. Болото навколо буквально оживає: чути, як якісь істоти миттєво реагують на ваші важкі кроки, завмираючи або з шелестом віддаляючись від протоки. Міа різко зупиняється і обертається до вас. Без слів. Вона просто мовчки чекає, поки ви зрозумієте, що такий спосіб руху прирікає вас на смерть.`,
        choices: [
            {
                text: "Сповільнити свій темп, намагатись ступати якомога м'якше на мулисте дно.",
                action: () => {
                    window.playerState.mia_trust = (window.playerState.mia_trust || 0) + 1;
                    addToLog("Міа мовчки помічає ваші старання і схвально киває головою.", "success");
                    goScene("hazemoor_ep2");
                }
            },
            {
                text: "Зупинитись на мить і уважно подивитись, як саме вона ставить свої ступні.",
                action: () => {
                    window.playerState.mia_trust = (window.playerState.mia_trust || 0) + 1;
                    addToLog("Ви переймаєте її техніку пересування. Довіра провідниці зростає.", "success");
                    goScene("hazemoor_ep2");
                }
            },
            {
                text: "Ігнорувати тишу і впевнено продовжити свій рух у колишньому важкому темпі.",
                action: () => {
                    addToLog("Ви йдете напролом. Для виживання на відкритій ділянці цього поки що достатньо.", "system");
                    goScene("hazemoor_ep2");
                }
            },
            {
                text: "Тривожно озиратись по сторонах, створюючи своїми рухами ще більше шуму та бризок.",
                action: () => {
                    window.playerState.mia_trust = (window.playerState.mia_trust || 0) - 1;
                    addToLog("Ваша паніка створює занадто багато шуму. Міа роздратована.", "damage");
                    ambushOrGo(0.5, "Очеретяний повзун", 30, 8, "hazemoor_ep2", {
                        intro: "Очерет за вашою спиною розсувається — на шум приповз тонкий лускатий хижак з голчастою пащею!",
                        poisonChance: 0.35,
                        poisonText: "Укус повзуна пече вогнем — його слина отруйна!"
                    });
                }
            }
        ]
    },

    hazemoor_ep2: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Нічліг і світло в темряві — Ніч перша",
        text: `Вечір першого дня. Міа зупиняється на нічліг на крихітному болотяному острівці сухої землі навколо старого, повністю висушеного дерева — це місце вона явно знає і використовує не вперше. Вона майстерно розкладає багаття так, щоб його яскраве полум'я не було видно здалеку: використовує вологе коріння, завдяки чому важкий білий дим утворює низький, щільний шар безпосередньо над водою, маскуючи табір. Глибокої ночі з болота долинають лякаючі звуки. Щось колосальне повільно рухається поряд у воді. Крізь сизу імлу ви раптово помічаєте в темряві десятки рухомих жовтих цяток, що невідривно стежать за вогнем.`,
        choices: [
            {
                text: "Допомогти мовчки підкинути вологе коріння, а потім спокійно запитати Міа про природу цих вогнів.",
                action: () => {
                    window.playerState.mia_trust = (window.playerState.mia_trust || 0) + 1;
                    addToLog("Вона відповідає: «Це Спостерігачі Туману. Вони просто перевіряють — чи варто боятись нашого заліза.»", "success");
                    goScene("hazemoor_ep3");
                }
            },
            {
                text: "Запитати коротко, чи все під контролем, а потім мовчки спостерігати за вогнем, не ворушачись.",
                action: () => {
                    addToLog("Міа лише коротко хмикає у відповідь, не відводячи погляду від диму багаття.", "system");
                    goScene("hazemoor_ep3");
                }
            },
            {
                text: "Миттєво підняти свою важку зброю на світло вогнів, готуючись прийняти ближній бій.",
                action: () => {
                    window.playerState.mia_trust = (window.playerState.mia_trust || 0) - 1;
                    addToLog("Міа заспокійливо кладе свою холодну руку на ваше зап'ясток: «Не змушуй його зацікавитись нами.»", "damage");
                    ambushOrGo(0.5, "Рій туманних кровососів", 25, 6, "hazemoor_ep3", {
                        intro: "Ваше тяжіння до вогника не лишилося непоміченим — з імли на тепло вашої крові злітається дзижчачий рій!"
                    });
                }
            }
        ]
    },

    hazemoor_ep3: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Глибока вода і слід Руфіна — День другий",
        text: `Ранок другого дня вашої експедиції. Ви виходите до широкої, абсолютно чорної гладі води — стара річкова заводь без видимого дна. Міа без жодного попередження пірнає вглиб і повністю зникає з очей. Її немає занадто довго. Коли ви вже починаєте панікувати, вона виринає на протилежному боці багнюки і знаходить чіткий слід. На вологому торф'яному березі видно глибокий відбиток армійського чобота і свіжий вирізаний знак на корі дерева — умовне скорочення загальної мови, яке міг залишити виключно картограф Руфін. Міа пильно дивиться на вас і питає: «Ти знаєш, що означає цей знак?»`,
        choices: [
            {
                text: "Уважно вивчити контури і чесно розповісти про значення знаку Руфіна.",
                action: () => {
                    window.playerState.mia_trust = (window.playerState.mia_trust || 0) + 1;
                    addToLog("Міа тихо киває: «Він живий, але болото забрало його спокій. Тобі справді так важливо знайти його?»", "success");
                    goScene("hazemoor_ep4");
                }
            },
            {
                text: "Спробувати пірнати у воду біля берега, намагаючись вгадати прихований сенс символу.",
                action: () => {
                    addToLog("Міа мовчки спостерігає за вашими хаотичними діями. Вона бачить нещирість чужинця.", "system");
                    goScene("hazemoor_ep4");
                }
            },
            {
                text: "Почати гучно кричати та кликати Руфіна, а потім збрехати Мії про походження мітки.",
                action: () => {
                    window.playerState.mia_trust = (window.playerState.mia_trust || 0) - 1;
                    addToLog("Звук вашого крику луною розноситься по воді. Ви порушуєте головне правило імли — тишу.", "damage");
                    ambushOrGo(0.5, "Гнилий потопельник", 45, 10, "hazemoor_ep4", {
                        intro: "Чорна вода розступається — на ваш голос з мулу повільно підводиться те, що болото колись забрало і не віддало."
                    });
                }
            }
        ]
    },

    hazemoor_ep4: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Болотяна істота під ногами — Післяполудень другого дня",
        text: `Сонце заходить за хмари, настає глибокий післяполудень другого дня. Ви виходите на широку ділянку відкритої, абсолютно стоячої води. Міа входить у неї першою без найменших вагань. Посередині протоки вона раптом різко завмирає, стає блідою і обережно торкається кінчиками пальців водяного дзеркала. «Тихо. Не рухайся взагалі,» — ледь чутно шепоче вона. Прямо під водою піднімається величезна тінь. Слідом за цим якась колосальна, слизька і неймовірно холодна жива маса повільно торкається підошви вашого чобота знизу, обережно вивчаючи чужинця у залізі.`,
        choices: [
            {
                text: "Завмерти на місці, повністю затамувати подих і не ворушити жодним м'язом обладунку.",
                action: () => {
                    window.playerState.mia_trust = (window.playerState.mia_trust || 0) + 1;
                    addToLog("Істота обнюхує ваше залізо, втрачає інтерес і пливе далі. Міа: «Тобі пощастило, воно сите.»", "success");
                    goScene("hazemoor_ep5");
                }
            },
            {
                text: "Повільно, без різких рухів спробувати зробити крок назад на мілководдя.",
                action: () => {
                    addToLog("Ви акуратно відступаєте назад. Величезна тінь під водою повільно занурюється на дно.", "system");
                    goScene("hazemoor_ep5");
                }
            },
            {
                text: "Різко вихопити свій меч і спробувати завдати удару наосліп під воду.",
                action: () => {
                    window.playerState.mia_trust = (window.playerState.mia_trust || 0) - 1;
                    addToLog("Тінь під водою більше не ховається — мурок-трясовик атакує! Міа з криком відштовхує вас від першого удару хвоста.", "damage");
                    startCombat("Мурок-трясовик", 50, 12, () => {
                        addToLog("Поранена істота з булькотінням ретирується у глибину. Міа важко дихає: «Тепер ти бачив, чому тут не можна торкатися води без дозволу.»", "success");
                        goScene("hazemoor_ep5");
                    });
                }
            }
        ]
    },

    hazemoor_ep5: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Нічна варта — Ніч друга",
        text: `Ніч другого дня подорожі. Другий нічліг на крихітній, зарослій мохом купині. Міа сідає біля самого краю води і дивиться вглиб абсолютно нерухомо протягом кількох годин. Вона виглядає виснаженою, її плечі опущені під вагою втоми, а дихання стає уривчастим від сирості. Болотні випари починають отруювати повітря навколо табору, викликаючи легкі галюцинації.`,
        choices: [
            {
                text: "Взяти нічну варту замість неї без зайвих слів і чесно запитати її про прадавнього духа Моура.",
                action: () => {
                    window.playerState.mia_trust = (window.playerState.mia_trust || 0) + 1;
                    addToLog("Міа вдячно заплющує очі: «Не питай про Моура зараз. Земля ще не готова відкрити тобі цей секрет.»", "success");
                    goScene("hazemoor_ep6");
                }
            },
            {
                text: "Запитати сухо, чи все гаразд із її здоров'ям, а потім просто мовчки сісти поруч.",
                action: () => {
                    addToLog("Вона коротко відрізає: «Все в порядку.» Після цього розмова повністю згасає до самого світанку.", "system");
                    goScene("hazemoor_ep6");
                }
            },
            {
                text: "Лягти спати першим, вимагаючи від неї розбудити вас на світанку для жорсткої розмови.",
                action: () => {
                    window.playerState.mia_trust = (window.playerState.mia_trust || 0) - 1;
                    addToLog("Ваш егоїзм сильно зачіпає провідницю. Довіра Мії стрімко падає.", "damage");
                    goScene("hazemoor_ep6");
                }
            }
        ]
    },

    hazemoor_ep6: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Заборонене місце — День третій",
        text: `Настає третій день вашої виснажливої подорожі. Міа різко зупиняється перед величезною відкритою галявиною. Тут вода дивно чиста, туман стоїть ідеальним стовпом, а в самому центрі під дзеркальною поверхнею вгадуються контури колосальної кам'яної брами. Провідниця категорично відмовляється йти туди напряму. Вона починає обходити цю зону по гігантському колу крізь найгустіші й найнебезпечніші хащі гнилого очерету.`,
        choices: [
            {
                text: "Без зайвих запитань і сумнівів рушити слідом за нею по далекому обхідному маршруту.",
                action: () => {
                    window.playerState.mia_trust = (window.playerState.mia_trust || 0) + 1;
                    addToLog("Міа сповільнює свій крок — вона більше не біжить попереду, тепер вона крокує пліч-о-пліч з вами.", "success");
                    goScene("hazemoor_ep7");
                }
            },
            {
                text: "Запитати її на ходу, чому саме ми витрачаємо стільки сил на обхід цієї чистої галявини.",
                action: () => {
                    addToLog("Вона кидає важкий погляд назад: «Там лежать кістки тих, хто намагався підкорити Туман залізом.»", "system");
                    goScene("hazemoor_ep7");
                }
            },
            {
                text: "Проігнорувати її застереження і впевнено рушити напряму через чисту воду до кам'яної структури.",
                action: () => {
                    window.playerState.mia_trust = (window.playerState.mia_trust || 0) - 1;
                    addToLog("Міа не зупиняє вас, але її погляд стає крижаним. Потім вона довго ігнорує ваші репліки.", "damage");
                    goScene("hazemoor_ep7");
                }
            }
        ]
    },

    hazemoor_ep7: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Останній перехід і фінальне питання — Вечір третього дня",
        text: `Вечір третього дня. До заповітного поселення Тихий Шелест залишається буквально пара годин ходу. На вузькій, повністю затопленій стежці старий гнилий дерев'яний настил з тріском ламається під ногами Мії. Вона раптово провалюється по самі груди в чорну смердючу трясовину. Ви блискавично реагуєте, хапаєте її за холодну руку і з колосальним зусиллям витягуєте на тверду кочку очерету. Попереду вже чітко видно перші будівлі на палях. Міа зупиняється на самому кордоні, повертається до вас і запитує: «Я повинна знати перед тим, як ми увійдемо туди. Навіщо ти прийшов сюди насправді? Яка твоя справжня мета щодо Хейзмуру?»`,
        choices: [
            {
                text: "Дати їй можливість заспокоїтися і чесно розповісти про свій обов'язок Вартового.",
                action: () => {
                    window.playerState.mia_trust = (window.playerState.mia_trust || 0) + 1;
                    addToLog("Міа довго вивчає ваше обличчя: «Я приймаю твою відповідь. Шлях відкрито.»", "success");
                    if ((window.playerState.mia_trust || 0) >= 5) {
                        goScene("hazemoor_result_good");
                    } else {
                        goScene("hazemoor_result_bad");
                    }
                }
            },
            {
                text: "Спробувати пожартувати, уникнути прямої відповіді або збрехати про свої мотиви.",
                action: () => {
                    window.playerState.mia_trust = (window.playerState.mia_trust || 0) - 1;
                    addToLog("Міа хмуриться від вашої нещирості: «Ти кажеш лише красиві слова. Але нехай буде так.»", "damage");
                    if ((window.playerState.mia_trust || 0) >= 5) {
                        goScene("hazemoor_result_good");
                    } else {
                        goScene("hazemoor_result_bad");
                    }
                }
            }
        ]
    },

    hazemoor_result_good: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Шлях відкрито — Довіра завойована",
        text: `Завдяки вашій високій повазі до законів болота та допомозі під час подорожі, Міа офіційно бере вас під свій особистий повний захист. Народ Мурі зустрічає вас у Тихому Шелесті без колишньої агресії.`,
        choices: [
            {
                text: "Увійти на територію поселення Тихий Шелест як бажаний гість",
                action: () => {
                    window.playerState.flags = window.playerState.flags || {};
                    window.playerState.flags.mia_with_hero = true;
                    goScene("tykhy_arrive");
                }
            }
        ]
    },

    hazemoor_result_bad: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Запасний маршрут — Самотній чужинець",
        text: `Міа раптово зникає серед очерету, залишаючи вас наодинці. Через брак досвіду ви наступаєте на помилкову кочку, падаєте у воду під вагою обладунку і потрапляєте у міцні плетені сітки Амфібій. Вас витягують у Тихий Шелест не як гостя, а як небезпечну знахідку.`,
        choices: [
            {
                text: "Спробувати спокійно вибратися з сіток Мурі та розпочати діалог",
                action: () => {
                    window.playerState.flags = window.playerState.flags || {};
                    window.playerState.flags.mia_with_hero = false;
                    goScene("tykhy_arrive");
                }
            }
        ]
    },

    tykhy_arrive: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Поселення Тихий Шелест",
        text: `Ви перебуваєте всередині Тихого Шелесту. Традиційні напівзатоплені будинки Мурів стоять на високих палях серед імли. Тут перетинаються кілька важливих ниток вашого розслідування долі Руфіна. Оберіть свій наступний крок:`,
        choices: [
            {
                text: "🔍 Знайти старшого мисливця Варріка та розпитати його про картографа",
                action: () => goScene("tykhy_rufin")
            },
            {
                text: "🧬 Відшукати старого шамана Каена (батька Мії) та дізнатись таємницю походження",
                action: () => goScene("tykhy_kaen")
            },
            {
                text: "🌿 Обговорити з Мією її подальші рішення щодо експедиції",
                visible: () => window.playerState.flags && window.playerState.flags.mia_with_hero === true,
                action: () => goScene("tykhy_mia")
            },
            {
                text: "🛠️ Заробити довіру громади, допомагаючи з латанням важких рибальських сітей",
                visible: () => window.playerState.flags && window.playerState.flags.mia_with_hero === false,
                action: () => goScene("tykhy_status")
            },
            {
                text: "🚪 Завершити справи в селищі та висунутись до забороненої Галявини Моура",
                action: () => goScene("tykhy_exit")
            }
        ]
    },

    tykhy_rufin: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Той, хто знав дорогу крізь імлу",
        text: `Варрік — досвідчений старший мисливець громади — довго і суворо дивиться на ваше клеймо Вартового: «Картограф Руфін? О так, він приходив сюди. Ніс із собою щось дуже дивне у важкому шкіряному мішку — воно буквально світилось зеленим вогнем крізь усі шви. Це був не звичайний ліхтар, а щось набагато старіше за наше поселення. Він детально розпитував про Галявину Моура. Ми благали його не ходити туди, але він пішов самотужки.»`,
        choices: [
            {
                text: "Вимагати показати точне місце, де Руфін перебуває зараз",
                action: () => goScene("tykhy_rufin_found")
            }
        ]
    },

    tykhy_rufin_found: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Жива тінь картографа",
        text: `Варрік мовчки веде вас до ізольованої хатини на самому краю поселення: «Три дні тому він повернувся звідти абсолютно сам. Без свого мішка. Його очі тепер порожні й безживні, як вода в мертвій заводі. Він повністю онімів і більше не говорить жодного слова.» Ви відчиняєте двері — у кутку на підлозі сиділа жива, але абсолютно порожня тінь Руфіна. Навколо нього на дошках видно коло випаленої трави і шматок темного, неймовірно холодного залізничного каменю.`,
        choices: [
            {
                text: "Повернутися до центральної частини поселення",
                action: () => goScene("tykhy_arrive")
            }
        ]
    },

    tykhy_kaen: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Правда старого шамана",
        text: `Каен — поважний старий шаман Амфібій — довго мовчить, дивлячись на священне багаття: «Двадцять років тому я знайшов Мію в самому серці глибокого болота. Вона була зовсім крихітним немовлям, що лежало на очеретяній купині. Абсолютно живе й неушкоджене під отруйним Туманом.» Він важко зітхає. «Я відразу зрозумів, звідки вона з'явилася на світ за законами Моура. Але я взяв її до себе з чистої батьківської любові. Благаю тебе, Вартовий — розкрий їй цю правду на Галявині. Моє серце вже не витримає її погляду.»`,
        choices: [
            {
                text: "Пообіцяти зберегти таємницю та повернутися назад",
                action: () => goScene("tykhy_arrive")
            }
        ]
    },

    tykhy_mia: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Друге рішення Мії",
        text: `Ви бачите Міа та її названого батька Каена здалеку — вони тихо і емоційно розмовляють біля старого воронячого дерева. Каен обережно кладе свою стару руку їй на плече. Після цього Міа рішучим кроком підходить безпосередньо до вас: «Я прийняла остаточне рішення. Я йду з тобою на Галявину Моура. Це більше не обговорюється. Те, що там міститься, стосується моєї долі набагато більше, ніж твоєї місії.»`,
        choices: [
            {
                text: "Прийняти її компанію та підготуватися до виходу",
                action: () => goScene("tykhy_arrive")
            }
        ]
    },

    tykhy_status: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Чужинець за роботою",
        text: `Без прямої протекції Мії ви залишаєтесь під постійним підозрілим наглядом охорони. Ви вирішуєте довести свої мирні наміри справою: годинами мовчки допомагаєте рибалкам латати їхні важкі сіті та переносите важкі блоки паливного торфу для ліхтарів. Через деякий час Міа повертається в табір, бачить вас за цією брудною роботою і на мить зупиняється. Вона нічого не каже, але її погляд пом'якшується. Тепер вона офіційно крокує поруч із вами.`,
        choices: [
            {
                text: "Завершити роботу та повернутися до хабу",
                action: () => {
                    window.playerState.flags.mia_with_hero = true;
                    goScene("tykhy_arrive");
                }
            }
        ]
    },

    tykhy_exit: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Вихід на Галявину Моура",
        text: `Усі нитки розслідування долі Руфіна в селищі успішно зібрані або остаточно відкинуті. Ви залишаєте палі Тихого Шелесту і висуваєтесь разом із Мією до епіцентру болотяної магії Хейзмуру, де повітря починає буквально іскритися від накопиченої стародавньої енергії.`,
        choices: [
            {
                text: "Увійти в містичну зону Галявини",
                action: () => goScene("glade_explore")
            }
        ]
    },

    glade_explore: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Розвідка Галявини",
        text: `Галявина Моура зустрічає вас абсолютною, мертвою тишею. На перший погляд вона виглядає як звичайна болотяна заводь, але вода тут має дзеркальний фіолетовий відтінок і випромінює дивне, пульсуюче зелене світло знизу. Тут виразно відчуваються залишкові сліди розуму картографа Руфіна, який залишив свій мішок саме в цій точці.`,
        choices: [
            {
                text: "Активно шукати зустріч із сутністю та підійти до самого краю води",
                action: () => goScene("glade_enter")
            }
        ]
    },

    glade_enter: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Вхід до Галявини — Занурення",
        text: `Міа підходить до краю води, закриває очі та своєю присутністю буквально розсуває пасма отруйного щільного туману, відкриваючи прохід. «Вхід до справжнього сховища міститься внизу, прямо під водою. Нам потрібно пірнути на саму глибину цієї заводи, якщо твій розум готовий витримати це,» — шепоче вона.`,
        choices: [
            {
                text: "Без вагань пірнути в чорну глибину заводи разом із Мією",
                visible: () => (window.playerState.mia_trust || 0) >= 0,
                action: () => goScene("glade_mour")
            },
            {
                text: "Піддатися паніці, відступити назад і спробувати виринути на поверхню",
                visible: () => (window.playerState.mia_trust || 0) < 0,
                action: () => goScene("glade_explore")
            }
        ]
    },

    glade_mour: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Зустріч з прадавнім Моуром",
        text: `Під водою ви виявляєте циклопічну кам'яну основу стародавнього артефакту Ключників. Раптом з поверхні дна злітають мільйони крихітних біолюмінесцентних комах, утворюючи у воді гігантську рухому голову Моура — колективного розуму всього Хейзмуру. Цей гігантський лік завмирає прямо перед Мією, пульсуючи в такт биттю її серця.`,
        choices: [
            {
                text: "Дозволити Моуру розпочати ментальний діалог",
                action: () => goScene("glade_mia_truth")
            }
        ]
    },

    glade_mia_truth: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Правда Мії та видіння прадавньої війни",
        text: `Міа зі сльозами на очах торкається ліку комах: «Я завжди думала, що просто добре чую шепіт болота... але я чула його тому, що це болото — це і є я. Я його частина.» Моур миттєво транслює у ваш розум спалах видіння: фрагменти жахливої Прадавньої війни фронтиру, руйнування перших стін та чіткий залізний символ Ордену Семи Кинджалів, який намагався поневолити цю силу.`,
        choices: [
            {
                text: "Запитати Моура про приховану роль Ордену Семи Кинджалів",
                action: () => goScene("glade_mount")
            }
        ]
    },

    glade_mount: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Болотяний маунт",
        text: `Видіння гасне. З глибокого мулистого дна піднімається колосальна, покрита стародавнім мохом і папороттю істота — Болотяний маунт, прадавній живий транспорт Ключників. Він покірно схиляє свою голову перед вами та Мією, пропонуючи швидко доставити вас крізь багнюку назад до цивілізації Сонк-Феррі.`,
        choices: [
            {
                text: "Осідлати істоту та назавжди покинути святу Галявину",
                action: () => goScene("glade_result")
            }
        ]
    },

    glade_result: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Повернення з Галявини — Знання в руках",
        text: `Ви успішно повернулися з глибин заводи. Тепер ви володієте повною правдою про природу появи отруйного Туману Хейзмуру та знаєте, що Руфін викрав артефакт під назвою Перша Печатка. Ви прямуєте на болотяному маунті назад до Сонк-Феррі, щоб вирішити кризу з конвоєм.`,
        choices: [
            {
                text: "Прибути в Сонк-Феррі для вирішення продовольчої кризи",
                action: () => goScene("sunkferry_arrive")
            }
        ]
    },

    sunkferry_arrive: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Криза в Сонк-Феррі — Зникнення конвою",
        text: `Повернувшись до Сонк-Феррі, ви застаєте поселення на межі кривавого бунту. Черги місцевих жителів за щоденним скромним раціоном стають дедалі агресивнішими. Головний зерновий конвой Адміністрації безслідно зник. Напруга зростає з кожною хвилиною.`,
        choices: [
            {
                text: "Розпочати негайне розслідування справи «Голод знизу»",
                action: () => goScene("holod_investigate")
            }
        ]
    },

    holod_investigate: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Голод знизу — Пошук доказів",
        text: `Ваше розслідування показує, що конвой зник біля Затонулої Сторожової Дороги. Стає очевидно: значну частину зерна навмисно таємно відвели корумповані місцеві чиновники урядового апарату, а контрабандисти Мурів допомогли їм сховати мішки на своїх дальніх болотяних базах. Які заходи ви вживете?`,
        choices: [
            {
                text: "Публічно викрити масштабну корупцію урядовців на головній площі",
                action: () => goScene("holod_result_A")
            },
            {
                text: "Провести жорстке, контрольоване придушення корумпованого чиновника наодинці",
                action: () => goScene("holod_result_B")
            },
            {
                text: "Укласти взаємовигідну Місцеву угоду з контрабандистами Амфібій напряму",
                action: () => {
                    window.playerState.reputation = window.playerState.reputation || {};
                    window.playerState.reputation.muri = (window.playerState.reputation.muri || 0) + 30;
                    window.playerState.reputation.admin = (window.playerState.reputation.admin || 0) - 20;
                    goScene("holod_result_C");
                }
            },
            {
                text: "[Ліхтар] Застосувати силу Ритуального милосердя Ключників над порожніми коморами",
                visible: () => window.playerState && window.playerState.doctrines && window.playerState.doctrines.lantern >= 1,
                action: () => goScene("holod_result_D")
            }
        ]
    },

    holod_result_A: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Результат: Публічне викриття корупції",
        text: `Ви виходите на центральну площу Сонк-Феррі і привселюдно називаєте імена зажраних чиновників Адміністрації. Розгніваний натовп жителів миттєво вибухає люттю. Міська варта повністю розгублена. Частину зерна повертають людям, а перелякані корумповані урядовці ганебно тікають під конвоєм до Валькорна. Громада вдячна вам, але Адміністрація запам'ятає цей акт непокори.`,
        choices: [{ text: "Перейти до наступної фази кризи — Сіль у книзі", action: () => goScene("sil_u_knyzi") }]
    },
    
    holod_result_B: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Результат: Контрольоване таємне придушення",
        text: `Ви знаходите старшого урядового чиновника наодинці в його кабінеті і мовчки кладете неспростовні докази корупції на стіл. «Зерно повністю повертається на склади сьогодні вночі. Абсолютно тихо. Або ці папери негайно підуть до Вищого Суду Валькорна,» — жорстко кажете ви. Чиновник блідне і погоджується. Зерно повернуто без публічного галасу. Порядок збережено.`,
        choices: [{ text: "Перейти далі до розслідування «Сіль у книзі»", action: () => goScene("sil_u_knyzi") }]
    },
    
    holod_result_C: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Результат: Таємна місцева угода з контрабандистами",
        text: `Ви йдете на прямі конфіденційні перемовини з контрабандистами Мурів — вони без зайвих слів повертають більшу частину зерна людям в обмін на те, що ви назавжди закриваєте очі на їхні нелегальні торгові маршрути блекотою. Голод відступає. Проте ця угода залишає важкий слід: тепер криміналітет знає, що Вартового можна купити мовчанням.`,
        choices: [{ text: "Рухатися далі по сюжетній лінії", action: () => goScene("sil_u_knyzi") }]
    },
    
    holod_result_D: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Результат: Ритуальне духовне милосердя",
        text: `Брат Карос проводить стародавній священний ритуал Святої Вей над порожніми, виснаженими коморами селища. Ви стоїте поруч у мовчанні і високо тримаєте свій Ліхтар Ключника. Наступного ранку рибалки несподівано приносять колосальний, небачений раніше улов риби. Збіг це чи ні, але люди починають говорити про справжнє божественне диво Туману. Громада знову єдина й сильна.`,
        choices: [{ text: "Продовжити рух за сюжетом епізоду", action: () => goScene("sil_u_knyzi") }]
    },

    sil_u_knyzi: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Справа: Сіль у книзі",
        text: `Відразу після продовольчої кризи виявляється нова біда: таємна партія життєво важливих ліків для Сонк-Феррі була навмисно розведена отруйною болотяною водою задля наживи. Це прямий і жахливий наслідок минулих брудних махінацій поромників на річці. Ви повинні негайно втрутитися в конфлікт лідерів.`,
        choices: [
            {
                text: "Негайно розібратися з лідерами переправи на річці",
                action: () => goScene("poromna_prysyaga")
            }
        ]
    },

    poromna_prysyaga: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Поромна присяга — Конфлікт на річці",
        text: `На річковій станції спалахує запеклий конфлікт між капітаном Адміністрації Тованом Рідом та лідеркою Мурів Нерою Вейл за повний стратегічний контроль над усіма водними шляхами фронтиру. Ситуація патова, зброя вже оголена з обох боків.`,
        choices: [
            {
                text: "Беззастережно підтримати позицію капітана Тована Ріда (Влада закону Людини)",
                action: () => {
                    window.playerState.flags = window.playerState.flags || {};
                    window.playerState.flags.ferry = 'tovan';
                    window.playerState.reputation = window.playerState.reputation || {};
                    window.playerState.reputation.admin = (window.playerState.reputation.admin || 0) + 10;
                    goScene("poromna_result_tovan");
                }
            },
            {
                text: "Підтримати позицію Нери Вейл (Передати річку під контроль народу Мурі)",
                action: () => {
                    window.playerState.flags = window.playerState.flags || {};
                    window.playerState.flags.ferry = 'nera';
                    window.playerState.reputation = window.playerState.reputation || {};
                    window.playerState.reputation.muri = (window.playerState.reputation.muri || 0) + 15;
                    goScene("poromna_result_nera");
                }
            },
            {
                text: "[Посередник] Знайти компромісний третій шлях спільного комерційного використання переправи",
                visible: () => window.playerState && window.playerState.doctrines && window.playerState.doctrines.mediator >= 1,
                action: () => goScene("poromna_result_third")
            }
        ]
    },

    poromna_result_tovan: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Тован повністю контролює пороми",
        text: `Жорстке рішення ухвалено на користь Адміністрації Валькорна. Солдати беруть причали під охорону, Нера Вейл відступає з прокльонами на вустах. Шлях залізом зафіксовано.`,
        choices: [{ text: "Перейти до наступної справи — Попіл під каплицею", action: () => goScene("popil_pid_kaplytseyu") }]
    },
    poromna_result_nera: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Нера повністю контролює пороми",
        text: `Рішення прийнято на користь корінного народу Амфібій. Тован Рід змушений відкликати своїх гвардійців з набережної. Контроль над водою залишається за очеретяним народом.`,
        choices: [{ text: "Рухатися далі за сюжетом епізоду", action: () => goScene("popil_pid_kaplytseyu") }]
    },
    poromna_result_third: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Тристороннє перемир'я поромників",
        text: `Завдяки вашій висококласній дипломатії Посередника сторони підписують пакт про спільні патрулі та рівний розподіл мита. Конфлікт вичерпано без пролиття крові.`,
        choices: [{ text: "Продовжити квестову лінію", action: () => goScene("popil_pid_kaplytseyu") }]
    },

    popil_pid_kaplytseyu: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Попіл під каплицею — Розслідування єресі",
        text: `Брат Карос офіційно виявляє масштабну підпільну імітацію сакральних ритуалів на старому поховальному місці Ключників. Потрібно терміново винести вердикт щодо релігійної кримінальної справи:`,
        choices: [
            {
                text: "Повністю сховати страшну правду від вищого урядового керівництва",
                action: () => {
                    window.playerState.reputation = window.playerState.reputation || {};
                    window.playerState.reputation.keepers = (window.playerState.reputation.keepers || 0) - 10;
                    goScene("popil_secret");
                }
            },
            {
                text: "Публічно викрити імітацію і закрити крипту на переосвячення",
                action: () => {
                    window.playerState.reputation = window.playerState.reputation || {};
                    window.playerState.reputation.keepers = (window.playerState.reputation.keepers || 0) + 10;
                    window.playerState.reputation.admin = (window.playerState.reputation.admin || 0) - 5;
                    goScene("popil_expose");
                }
            },
            {
                text: "[Ліхтар 2] Самостійно формалізувати та провести чистий канонічний ритуал Ключників",
                visible: () => window.playerState && window.playerState.doctrines && window.playerState.doctrines.lantern >= 2,
                action: () => {
                    window.playerState.reputation = window.playerState.reputation || {};
                    window.playerState.reputation.keepers = (window.playerState.reputation.keepers || 0) + 20;
                    goScene("popil_ritual");
                }
            }
        ]
    },

    popil_secret: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Правда успішно прихована",
        text: `Ви вирішуєте промовчати. Брат Карос довго і важко дивиться на вас, потім повільно опускає голову: «Розумію твою прагматику, Вартовий.» Фальшиві ритуали продовжуються, мертві лежать без справжніх слів упокоєння, але живі перебувають у спокої, і це теж свого роду милосердя.`,
        choices: [{ text: "Перейти до фінальних квот Маршала Келма", action: () => goScene("nizh_kvoty") }]
    },
    popil_expose: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Єретична правда повністю відкрита",
        text: `Ви вимовляєте сувору правду вголос. Брат Карос спочатку шаленіє від гніву, але потім безсило замовкає: «Я робив усе, що міг, з тими мізерними знаннями, що у мене залишилися.» Поховальний сектор повністю закривають на тривалий карантин. Кілька впливових родин глибоко ображені на вас, але закон тріумфує.`,
        choices: [{ text: "Рухатися далі до звіту", action: () => goScene("nizh_kvoty") }]
    },
    popil_ritual: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Праведний ритуал успішно проведено",
        text: `Ви особисто проводите чистий, автентичний ритуал упокоєння стародавніх Ключників над поховальними плитами каплиці. Брат Карос шокований: «Звідки звичайний Вартовий знає ці втрачені сакральні слова?» Ваш Ліхтар яскраво спалахує чистим зеленим вогнем. Болото навколо будівлі миттєво затихает. Мертві нарешті спочивають правильно.`,
        choices: [{ text: "Продовжити рух до Маршала Келма", action: () => goScene("nizh_kvoty") }]
    },

    nizh_kvoty: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Ніж квоти — Фінальний звіт Маршала Серіта Келма",
        text: `Маршал-Реєстратор Серіт Келм викладає на стіл фінальні документи і вимагає негайно відновити повну залізну дисципліну Адміністрації в Сонк-Феррі. Ваша підписана резолюція вирішить усе.`,
        choices: [
            {
                text: "Беззастережно підписати офіційний урядовий звіт (Sign report)",
                action: () => goScene("nizh_result_A")
            },
            {
                text: "Висловити частковий супротив та внести три рядки від себе (Partial resist)",
                action: () => goScene("nizh_result_B")
            },
            {
                text: "[Доктрина Судді 2] Оформити Повний суровий розрахунок та висунути зустрічні звинувачення (Full reckoning)",
                visible: () => window.playerState && window.playerState.doctrines && window.playerState.doctrines.judge >= 2,
                action: () => {
                    window.playerState.reputation = window.playerState.reputation || {};
                    window.playerState.reputation.wanderers = (window.playerState.reputation.wanderers || 0) + 20;
                    window.playerState.reputation.admin = (window.playerState.reputation.admin || 0) - -30;
                    goScene("nizh_result_C");
                }
            },
            {
                text: "[Доктрина Посередника 2] Запропонувати Спільний паритетний контроль над квотами (Co-control)",
                visible: () => window.playerState && window.playerState.doctrines && window.playerState.doctrines.mediator >= 2,
                action: () => goScene("nizh_result_D")
            }
        ]
    },

    nizh_result_A: {
        audioTrack: "assets/audio/ep2_city_music.mp3",
        audioAtmosphere: "assets/audio/ep2_city_ambient.mp3",
        title: "Результат: Звіт підписано повністю",
        text: `Ви беззастережно підписуєте урядовий звіт Серіта Келма. Сухі цифри тепер у повному порядку, але реальний контекст страждань людей повністю стерто. Келм забирає папери з тонкою задоволеною посмішкою: «Мудре та прагматичне рішення, Вартовий. Столиця вміє винагороджувати лояльність.» Ви виходите з кабінету з важким відчуттям, що щойно дали тиранам легальну зброю проти бідняків фронтиру. Ви збираєте речі та офіційно вирушаєте до столиці.`,
        choices: [{ text: "Вирушити до великого Валькорна разом з Ілією Марр", action: () => goScene("valckorn_traversal_hub") }]
    },
    nizh_result_B: {
        audioTrack: "assets/audio/ep2_city_music.mp3",
        audioAtmosphere: "assets/audio/ep2_city_ambient.mp3",
        title: "Результат: Частковий бюрократичний супротив",
        text: `Ви підписуєте звіт, але залізним пером дописуєте три розмашисті рядки від себе — ваші особисті суворі спостереження про зловживання урядових гвардійців. Келм миттєво помічає дописку: «Це порушує стандартну імперську форму звітності.» «Проте це чиста правда,» — холодно відповідаєте ви. Він забирає документ у повному мовчанні. Цей дописо може нічого не змінити в системі, але він назавжди зафіксований в архівах Корони. Попереду — залізна столиця фронтиру.`,
        choices: [{ text: "Рухатися до стін великого Валькорна", action: () => goScene("valckorn_traversal_hub") }]
    },
    nizh_result_C: {
        audioTrack: "assets/audio/ep2_city_music.mp3",
        audioAtmosphere: "assets/audio/ep2_city_ambient.mp3",
        title: "Результат: Повний суровий розрахунок Судді",
        text: `Ви категорично відмовляєтесь підписувати папери Келма і впевнено кладете на стіл власний офіційний рапорт із зафіксованими іменами, точними датами та сумами розкрадань Адміністрації: «Цей документ піде безпосередньо до Вищого Трибуналу Корони Валькорна.» Маршал Келм повільно встає, його очі горять люттю: «Ви чудово розумієте, що щойно скоїли кар'єрне самогубство, Вартовий?» «Так,» — спокійно кажете ви. Він іде геть. Ви залишаєтеся з чистою совістю, але з новим смертельним ворогом. Час їхати до столиці.`,
        choices: [{ text: "Вирушити назустріч небезпекам Валькорна", action: () => goScene("valckorn_traversal_hub") }]
    },
    nizh_result_D: {
        audioTrack: "assets/audio/ep2_city_music.mp3",
        audioAtmosphere: "assets/audio/ep2_city_ambient.mp3",
        title: "Результат: Тристоронній спільний контроль",
        text: `Ви пропонуєте Келму систему спільного паритетного контролю — його канцелярія веде фінансовий облік, але ви особисто підписуєте виключно перевірені на місцях факти. Келм довго зважує ризики: «Незвично для фронтиру. Проте цілком прийнятно.» Угоду укладено. Бюрократична машина сильно сповільнюється, але корупційні дірки закриваються надійно. Ви згортаєте табір і висуваєтесь до Валькорна.`,
        choices: [{ text: "Рухатися до урядових секторів столиці", action: () => goScene("valckorn_traversal_hub") }]
    },

    // --- ЕПІЗОД 2: ВЕЛИКИЙ ВАЛЬКОРН — РОЗШИРЕННЯ КВАРТАЛІВ (АКТ II ПОЛНОЦІННИЙ) ---
    valckorn_traversal_hub: {
        audioTrack: "assets/audio/ep2_city_music.mp3",
        audioAtmosphere: "assets/audio/ep2_city_ambient.mp3",
        title: "Шляхи до Валькорна — Велика Брама",
        text: `Перед вами постають колосальні кам'яні та залізні вежі Валькорна — залізної столиці всього фронтиру Хейзмуру. Залежно від вашого фінального вердикту, який ви винесли маршалу в Сонк-Феррі, перед вами відкриваються абсолютно різні стратегічні шляхи доступу до серця міста. Кожне ухвалене раніше рішення тепер безпосередньо визначає, як саме столиця зустріне самотнього Вартового.`,
        choices: [
            {
                text: "Підійти до Палацової Брами (Потрібен Вердикт: Пристосування / Контрольоване стримування)",
                visible: () => window.playerState && window.playerState.sonkFerry && (window.playerState.sonkFerry.finalVerdict === "adaptation" || window.playerState.sonkFerry.finalVerdict === "containment"),
                action: () => goScene("valckorn_entry_palace")
            },
            {
                text: "Пробратися через Затоплені Колектори Нетрів (Потрібен Вердикт: Місцева угода / Пакт)",
                visible: () => window.playerState && window.playerState.sonkFerry && window.playerState.sonkFerry.finalVerdict === "pact",
                action: () => goScene("valckorn_entry_ghetto")
            },
            {
                text: "Увійти через Секретну Крипту Каплиці (Потрібен Вердикт: Ритуальне милосердя)",
                visible: () => window.playerState && window.playerState.sonkFerry && window.playerState.sonkFerry.finalVerdict === "mercy",
                action: () => goScene("valckorn_entry_chapel")
            },
            {
                text: "[Аварійний шлях] Спробувати пройти через Головну Палацову Браму без перепустки",
                visible: () => !window.playerState || !window.playerState.sonkFerry || !window.playerState.sonkFerry.finalVerdict,
                action: () => goScene("valckorn_entry_palace")
            }
        ]
    },

    valckorn_entry_palace: {
        audioTrack: "assets/audio/ep2_city_music.mp3",
        audioAtmosphere: "assets/audio/ep2_city_ambient.mp3",
        title: "Залізний Тріумф — Брама Палацу",
        text: `Величні ковані ворота столиці зустрічають вас гучним брязканням сталі та суворими поглядами вартових слідчого Стетсона. Завдяки вашому лояльному рішенню щодо урядового звіту в Сонк-Феррі, вас пропускають через периметр як офіційного представника міської Адміністрації. Навколо виблискують чисті бруковані вулиці та штандарти Верховної Ради фронтиру, але кожен ваш крок тепер перебуває під пильним наглядом шукачів Ордена.`,
        choices: [
            {
                text: "Пройти офіційний митний контроль та зайти в урядовий Квартал Верховних Палаців",
                action: () => goScene("valckorn_palace_district")
            }
        ]
    },

    valckorn_palace_district: {
        audioTrack: "assets/audio/ep2_city_music.mp3",
        audioAtmosphere: "assets/audio/ep2_city_ambient.mp3",
        title: "Квартал Верховних Палаців — Слідчий Стетсон",
        text: `Тут живуть ті, хто керує виснаженням ресурсів Хейзмуру та жорстко розподіляє квоти на ліки для фронтиру. Високі білі мармурові колони, регулярні патрулі у важких гвардійських обладунках і повна відсутність болотного Туману завдяки системі ліхтарів Ключників. Канцелярія Адміністрації видає перепустку, але ви зустрічаєте слідчого Стетсона у вузькому кабінеті без вікон: «Ти з болота, я бачу по бруду на обладунках. Три роки я збираю докази проти Ордену Семи Кинджалів для повної чистки Палацу. Мені терміново потрібен свідок зсередини — хтось, хто бачив артефакт Руфіна особисто. Стань моїм союзником.»`,
        choices: [
            {
                text: "Погодитися на пропозицію Стетсона, сплутати сліди шпигунів та підійти до архівів Одріна",
                action: () => goScene("valckorn_02_odrin")
            }
        ]
    },

    valckorn_entry_ghetto: {
        audioTrack: "assets/audio/ep2_city_music.mp3",
        audioAtmosphere: "assets/audio/ep2_city_ambient.mp3",
        title: "Затоплені Колектори Гетто",
        text: `Ви пролазите крізь іржаві, заклинені залізні решітки стічних тунелів Нижнього Міста Валькорна. Тут жахливо тхне гниллю, отруйними випарами та застояною болотяною водою, яка сочиться крізь тріщини старої міської кладки. Тіньовий лідер Брес подбала про провідників із числа поромників, але токсична атмосфера підземелля залишає важкий слід на вашому тілі. Ваші вени помітно темнішають від торф'яного соку, коли ви нарешті вибираєтеся на поверхню всередині брудного, темного провулка.`,
        choices: [
            {
                text: "Витерти бруд з обличчя і обережно увійти в Квартал Ремісників і Знедолених під опікою Брес",
                action: () => {
                    window.playerState.corruption = (window.playerState.corruption || 0) + 15;
                    addToLog("Ваш рівень Корупції/Розпаду зріс на 15 одиниць через отруйні випари колекторів столиці.", "damage");
                    goScene("valckorn_slums_district");
                }
            }
        ]
    },

    valckorn_slums_district: {
        audioTrack: "assets/audio/ep2_city_music.mp3",
        audioAtmosphere: "assets/audio/ep2_city_ambient.mp3",
        title: "Кримінальні Нетрі Валькорна — Сліди Брес",
        text: `Нижнє місто залізного Валькорна повністю кишить бідністю, відчаєм, нелегальними торговцями блекотою та контрабандистами всіх мастей. Сюди постійно прориваються пасма отруйного болотного туману Хейзмуру, а люди ховають обличчя під вологими ганчірками. Ви зустрічаєте Брес, втікачку із Сонк-Феррі: «Болото не відмивається за один день, Вартовий. Але у мене є рішення. Наші агенти знайшли пакунок з артефактом на складі в портовому кварталі, який контролює торгова гільдія Дамара. Вони передають тобі зламаний залізничний ключ від підвалів урядового сектору.»`,
        choices: [
            {
                text: "Взяти залізничний ключ Брес і таємно прокрастися повз нічні патрулі гвардії до складів Дамара",
                action: () => goScene("valckorn_02_underground")
            }
        ]
    },

    valckorn_entry_chapel: {
        audioTrack: "assets/audio/ep2_city_music.mp3",
        audioAtmosphere: "assets/audio/ep2_city_ambient.mp3",
        title: "Завтрашна Крипта Каплиці",
        text: `Тихий, майже священний спокій оточує вас з усіх боків. Ви заходите в залізне місто через забуті підземні сховища старої монастирської Каплиці за допомогою ключа, який вам таємно передала сестра Тесса у Сонк-Феррі. Свіже прохолодне повітря, запах бджолиного воску та стародавні ікони Ключників на стінах миттєво повертають вам душевну виваженість, повністю очищаючи розум від жахів трясовини. Світло вашого ліхтаря горить рівно й чисто, відбиваючись від старої кам'яної кладки крипти.`,
        choices: [
            {
                text: "Піднятися таємними гвинтовими сходами безпосередньо у Монастирський Клуатр Ордена до Тесси",
                action: () => goScene("valckorn_chapel_district")
            }
        ]
    },

    valckorn_chapel_district: {
        audioTrack: "assets/audio/ep2_city_music.mp3",
        audioAtmosphere: "assets/audio/ep2_city_ambient.mp3",
        title: "Монастирський Клуатр Семи Кинджалів — Крамниця Тесси",
        text: `Верхні закриті тераси каплиці відкривають панорамний вид на всю залізну столицю фронтиру. Тут повільно ходять мовчазні ченці Ордена Семи Кинджалів, які збирають та ретельно каталогізують стародавні реліквії. Ви заходите в таємну крамницю Тесси. У кімнаті за важкою завісою приємно пахне старим папером: «Ти прийшов із самого серця Хейзмуру, Вартовий. Це не питання, я бачу світіння. Орден каже одне, але я скажу інше. Перша Печатка Руфіна — не просто реліквія, це частина прадавньої системи замків. Якщо її зламати — болото вийде за межі. Ось тобі важкий ключ з болотяного заліза, він відкриє бічний вхід до підземелля архівів Одріна.»`,
        choices: [
            {
                text: "Взяти ключ Тесси, об'єднати знання та спуститися через бібліотечні переходи до дверей архівів",
                action: () => {
                    window.playerState.sanity = (window.playerState.sanity || 100) + 20;
                    addToLog("Ваш Розум відновився на 20 одиниць завдяки духовному спокою Клуатру.", "success");
                    goScene("valckorn_02_tessa");
                }
            }
        ]
    },

    valckorn_02_odrin: {
        audioTrack: "assets/audio/ep2_city_music.mp3",
        audioAtmosphere: "assets/audio/ep2_city_ambient.mp3",
        title: "Палацовий архів — Архівіст Одрін",
        text: `Одрін говорить з вами наляканим пошепки між величезними пильними стелажами: «Підземелля під нашою королівською бібліотекою — це справжній секретний архів Ради. Там ховаються документи, яких немає в жодному офіційному реєстрі Корони. І там є таємнича Третя точка системи Ключників.» Він передає вам детально скопійовану карту підземних ходів. Ви спускаєтеся вниз за його вказівками.`,
        choices: [{ text: "Спуститися безпосередньо в підземелля під архівом", action: () => goScene("valckorn_02_underground") }]
    },

    valckorn_02_tessa: {
        audioTrack: "assets/audio/ep2_city_music.mp3",
        audioAtmosphere: "assets/audio/ep2_city_ambient.mp3",
        title: "Таємний хід крамниці Тесси",
        text: `Використовуючи важкий ключ Тесси, ви відчиняєте потайні залізні двері в підлозі її крамниці. Перед вами відкриваються сирі, покриті пліснявою сходи, що ведуть глибоко під фундамент королівської бібліотеки Валькорна. Карта Одріна чітко показує безпечний шлях повз охорону магістра.`,
        choices: [{ text: "Спуститися таємним ходом у підземелля", action: () => goScene("valckorn_02_underground") }]
    },

    valckorn_02_underground: {
        audioTrack: "assets/audio/ep2_dungeon_music.mp3",
        audioAtmosphere: "assets/audio/ep2_dungeon_ambient.mp3",
        title: "Підземелля Валькорна — Пошук Печатки",
        text: `Секретні, холодні лабіринти під містом дихають стародавнім сирим каменем. На стінах видно дивні застережливі написи Ключників: <em>«Хто торкнеться Печатки без Ліхтаря — назавжди втратить свою тінь.»</em> Ви знаходите Третю точку системи. Постамент повністю порожній, але на ньому лежить свіжий клаптик тканини із золотим символом Ордену Семи Кинджалів. Хтось впливовий прийшов сюди набагато раніше за вас. Сліди контрабанди ведуть до гільдії.`,
        choices: [
            {
                text: "Негайно вистежити контрабандиста Дамара в портових складах",
                action: () => goScene("valckorn_03_damar")
            }
        ]
    },

    valckorn_03_damar: {
        audioTrack: "assets/audio/ep2_city_music.mp3",
        audioAtmosphere: "assets/audio/ep2_city_ambient.mp3",
        title: "Торгова Гільдія — Контрабандист Дамар",
        text: `Дамар — непримітний, але неймовірно хитрий торговець гільдії, який тримає секретний пакунок з викраденим артефактом Руфіна на портовому складі. Він зустрічає вас із нахабною посмішкою, підкидаючи на долоні важкий мішечок: <em>«Я звичайний торговець фронтиру, Вартовий. Я ніколи не питаю, що це за дивна штука і навіщо вона потрібна. Я питаю лише одне — скільки срібла ти особисто готовий заплатити за її повернення?»</em>`,
        choices: [
            {
                text: "Жорстко відібрати артефакт Руфіна самому за правом сили закону Вартових",
                action: () => {
                    window.playerState.inventory = window.playerState.inventory || [];
                    window.playerState.inventory.push("Перша Печатка (Частина)");
                    addToLog("Ви силою вилучили Частину Першої Печатки з контрабандного складу Дамара.", "success");
                    goScene("valckorn_03_result");
                }
            },
            {
                text: "Дозволити Тессі офіційно викупити артефакт через канали її крамниці",
                action: () => {
                    window.playerState.reputation = window.playerState.reputation || {};
                    window.playerState.reputation.order = (window.playerState.reputation.order || 0) - 10;
                    addToLog("Тесса викупила артефакт. Орден незадоволений втратою контролю над гільдією.", "damage");
                    goScene("valckorn_03_result");
                }
            }
        ]
    },

    valckorn_03_result: {
        audioTrack: "assets/audio/ep2_city_music.mp3",
        audioAtmosphere: "assets/audio/ep2_city_ambient.mp3",
        title: "Сліди ведуть до Вищої Ради",
        text: `Аналіз фінансових документів Дамара та міток на скрині показує неспростовну правду: замовником викрадення артефакту є Орден Семи Кинджалів. Усі нитки розслідування тепер тягнуться безпосередньо до кабінетів Сьомої Ради. Слід урядового срібла повністю розкритий.`,
        choices: [
            {
                text: "Вийти на пряму зустріч із впливовим членом Ради — магістром Лоеном",
                action: () => goScene("valckorn_04_loen")
            }
        ]
    },

    valckorn_04_loen: {
        audioTrack: "assets/audio/ep2_city_music.mp3",
        audioAtmosphere: "assets/audio/ep2_city_ambient.mp3",
        title: "Магістр Лоен — Сьома Рада Ордену",
        text: `Ви знаходите Лоена — високопоставленого члена Сьомої Ради Ордену Семи Кинджалів у його розкішній резиденції. Він спокійно наливає вино і погоджується відповісти на ваші три жорсткі питання:<br><br>1. <em>«Нам потрібен був цей артефакт. Руфін ідеально знав болото, тому ми найняли його. Ми шукаємо спосіб повністю стабілізувати Моур, а не знищити його.»</em><br>2. <em>«Ми хочемо підпорядкувати його силу Раді. Хто повністю контролює трясовину Хейзмуру — той контролює весь стратегічний фронтир Корони.»</em><br>3. <em>«Справжній тіньовий лідер нашого Ордену набагато ближче до урядового палацу, ніж ти думаєш, Вартовий. Його офіційні листи завжди пахнуть болотяною м'ятою та вологим торфом, а чорнило унікально блищить золотим пилом Ради.»</em>`,
        choices: [
            {
                text: "🤝 Офіційно погодитись на умови альянсу з Орденом та прийняти їхні ресурси",
                action: () => {
                    window.playerState.flags = window.playerState.flags || {};
                    window.playerState.flags.clue_loen = true;
                    window.playerState.flags.loen_align = 'A';
                    window.playerState.reputation = window.playerState.reputation || {};
                    window.playerState.reputation.order = (window.playerState.reputation.order || 0) + 30;
                    goScene("loen_align_A");
                }
            },
            {
                text: "⚖️ Зберегти суворий Нейтралітет і відмовитися від підписання будь-яких зобов'язань",
                action: () => {
                    window.playerState.flags = window.playerState.flags || {};
                    window.playerState.flags.clue_loen = true;
                    window.playerState.flags.loen_align = 'B';
                    window.playerState.reputation = window.playerState.reputation || {};
                    window.playerState.reputation.order = (window.playerState.reputation.order || 0) + 10;
                    goScene("loen_align_B");
                }
            },
            {
                text: "⚔️ [Доктрина Судді] Офіційно оголосити Орден ворогами закону та відкинути їхні умови",
                visible: () => window.playerState && window.playerState.doctrines && window.playerState.doctrines.judge >= 1,
                action: () => {
                    window.playerState.flags = window.playerState.flags || {};
                    window.playerState.flags.clue_loen = true;
                    window.playerState.flags.loen_align = 'C';
                    window.playerState.reputation = window.playerState.reputation || {};
                    window.playerState.reputation.order = (window.playerState.reputation.order || 0) - 40;
                    window.playerState.reputation.admin = (window.playerState.reputation.admin || 0) + 20;
                    goScene("loen_align_C");
                }
            }
        ]
    },

    loen_align_A: {
        audioTrack: "assets/audio/ep2_city_music.mp3",
        audioAtmosphere: "assets/audio/ep2_city_ambient.mp3",
        title: "Союз із Орденом Семи Кинджалів",
        text: `«Мудрий та далекоглядний вибір, Вартовий» — задоволено каже Лоен. «Орден забезпечить тебе всіма необхідними ресурсами, золотом та військовим захистом у столиці. Натомість — ти стаєш нашим офіційним головним провідником у болотах фронтиру.» Він простіть руку. Ви тисните її. Десь глибоко в душі ви чітко відчуваєте, що щойно обміняли одну клітку на іншу — просто набагато більш розкішну.`,
        choices: [{ text: "Перейти до фінального аналізу доказів розслідування", action: () => goScene("valckorn_04_deduction") }]
    },
    loen_align_B: {
        audioTrack: "assets/audio/ep2_city_music.mp3",
        audioAtmosphere: "assets/audio/ep2_city_ambient.mp3",
        title: "Обережний нейтралітет з Радою",
        text: `«Обережний, суто професійний підхід» — Лоен тонко посміхається. «Ми надамо тобі повну інформацію з архівів Корони. Ти ж натомість надаєш нашим загонам доступ до болотяних локацій, коли нам це знадобиться за квотами. Без жодних підписів під таємними протоколами.» Угода вкрай хитка — але на даний момент цього цілком достатньо для продовження місії.`,
        choices: [{ text: "Перейти до дедуктивного аналізу справи", action: () => goScene("valckorn_04_deduction") }]
    },
    loen_align_C: {
        audioTrack: "assets/audio/ep2_city_music.mp3",
        audioAtmosphere: "assets/audio/ep2_city_ambient.mp3",
        title: "Пряме протистояння з Орденом",
        text: `«Ворог... Що ж, це принаймні набагато чесніше, ніж більшість вельмож у Палаці,» — спокійно і холодно вимовляє Лоен. Він повільно встає із крісла. «Але пам'ятай добре, Вартовий — Рада успішно існує і керує цим містом уже триста років. Твоє залізо зламається першим.» Ви залишаєте резиденцію у стані відкритого конфлікту.`,
        choices: [{ text: "Рухатися далі до розкриття Хранителя", action: () => goScene("valckorn_04_deduction") }]
    },

    valckorn_04_deduction: {
        audioTrack: "assets/audio/ep2_city_music.mp3",
        audioAtmosphere: "assets/audio/ep2_city_ambient.mp3",
        title: "Розкриття Хранителя — Дедуктивний тріумф",
        text: `Три залізобетонні докази нарешті сходяться в одну фінальну точку вашої ментальної карти розслідування. По-перше: срібні бубонці на костюмі Фіппа зроблені з унікального Білого срібла, як і викрадений артефакт Руфіна. По-друге: слова Стетсона про те, що «найкраща шпигунська тінь у місті — це та, яка вдягнена найяскравіше на ринку». По-третє: запах листівок лідера пахне болотяною м'ятою та вологим торфом, а Фіпп використовує саме цей екстракт для свого білого гриму. Висновок вражає: <strong>Таємничий Верховний Хранитель Першої Печатки — це Блазень Фіпп!</strong>`,
        choices: [
            {
                text: "Здійснити негайне проникнення до секретного Чорного Архіву під бібліотекою",
                action: () => goScene("valckorn_05_infiltrate")
            }
        ]
    },

    valckorn_05_infiltrate: {
        audioTrack: "assets/audio/ep2_city_music.mp3",
        audioAtmosphere: "assets/audio/ep2_city_ambient.mp3",
        title: "Проникнення до королівського Палацу",
        text: `Ви успішно знаходите замаскований шлях у Чорний Архів, прихований безпосередньо під фундаментами головної урядової бібліотеки Валькорна. Оберіть свій метод проникнення крізь фінальний заслін охорони:`,
        choices: [
            {
                text: "[Доктрина Судді 2] Задіяти офіційний Шлях Судді та пред'явити Закон Корони гвардії",
                visible: () => window.playerState && window.playerState.doctrines && window.playerState.doctrines.judge >= 2,
                action: () => goScene("valckorn_05_archive")
            },
            {
                text: "Використати Шлях Посередника, задіявши підписаний Тіньовий договір Ради",
                action: () => goScene("valckorn_05_archive")
            },
            {
                text: "[Доктрина Слідопита 3] Прокрастися таємно через затоплені болотяні колектори собору",
                visible: () => window.playerState && window.playerState.doctrines && window.playerState.doctrines.pathfinder >= 3,
                action: () => goScene("valckorn_05_archive")
            }
        ]
    },

    valckorn_05_archive: {
        audioTrack: "assets/audio/ep2_dungeon_music.mp3",
        audioAtmosphere: "assets/audio/ep2_dungeon_ambient.mp3",
        title: "Чорний Архів — Секретне Сховище",
        text: `Чорний Архів зустрічає вас довгим, похмурим коридором із монолітного чорного тесаного каменю. Настінні смолоскипи тут горять специфічним синім полум'ям. На стінах чітко видно прадавні рунічні символи Ключників, які набагато старіші за сам Орден. В самому кінці коридору підносяться масивні двері з чистісінького болотяного заліза. За ними долинає тихий, дивно спокійний і рівний голос. Хтось уже перебуває всередині і чекає на вас.`,
        choices: [
            {
                text: "Відчинити важкі залізні двері та увійти на фінальну зустріч із Хранителем",
                action: () => goScene("valckorn_05_iliya")
            }
        ]
    },

    valckorn_05_iliya: {
        audioTrack: "assets/audio/ep2_dungeon_music.mp3",
        audioAtmosphere: "assets/audio/ep2_dungeon_ambient.mp3",
        title: "Хранитель Першої Печатки — Себастьян Марр",
        text: `Ви проникаєте до зали Чорного Архіву. У кімнаті виразно пахне вологим торфом і свіжою болотяною м'ятою. Блазень Фіпп стоїть перед великим дзеркалом і спокійно змиває свій білий акторський грим. Він повільно виймає з потайної скрині <strong>Першу Печатку</strong> — циліндр із Білого срібла та болотяного заліза, що яскраво пульсує срібним світлом. Ваша супутниця Ілія Марр раптово жахається і впізнає його: <em>«Дядьку... Себастьяне? Ти живий?»</em> Себастьян Марр повільно повертається до вас: <em>«Орден Семи Кинджалів — це не банальні вбивці, племіннице. Ми — залізні ворота, які зобов'язані утримати отруйну воду Моура. Я особисто пішов у туман, щоб врятувати столицю. Вирішуйте негайно, Вартовий, що ми будемо робити з цією силою далі.»</em>`,
        choices: [
            {
                text: "⚖️ [Шлях Судді] «Твій Орден сіє лише смерть і корупцію на фронтирі. Віддай Печатку під арешт!» (Прийняти бій з магістром)",
                action: () => {
                    window.playerState.reputation = window.playerState.reputation || {};
                    window.playerState.reputation.order = (window.playerState.reputation.order || 0) - 100;
                    window.playerState.reputation.admin = (window.playerState.reputation.admin || 0) + 40;
                    window.playerState.reputation.wanderers = (window.playerState.reputation.wanderers || 0) + 30;
                    window.playerState.flags = window.playerState.flags || {};
                    window.playerState.flags.valkorn5_choice = 'judge';
                    window.playerState.flags.sebastian_fate = 'dead';
                    window.playerState.valckorn_path = "A";
                    goScene("valckorn_epilogue");
                }
            },
            {
                text: "🤝 [Шлях Посередника] «Ми надійно збережемо твою таємницю. Але відтепер Орден зобов'язаний захищати Хейзмур.» (Укласти Тіньовий Пакт)",
                action: () => {
                    window.playerState.reputation = window.playerState.reputation || {};
                    window.playerState.reputation.order = (window.playerState.reputation.order || 0) + 40;
                    window.playerState.flags = window.playerState.flags || {};
                    window.playerState.flags.valkorn5_choice = 'mediator';
                    window.playerState.flags.sebastian_fate = 'deal';
                    window.playerState.valckorn_path = "C";
                    goScene("valckorn_epilogue");
                }
            },
            {
                text: "🕯️ [Шлях Ліхтаря] «Я стану тим, хто особисто тримає удар Туману. Передай мені Печатку для Злиття!» (Провести Ритуал Злиття плоті)",
                action: () => {
                    window.playerState.reputation = window.playerState.reputation || {};
                    window.playerState.reputation.wanderers = (window.playerState.reputation.wanderers || 0) + 50;
                    window.playerState.flags = window.playerState.flags || {};
                    window.playerState.flags.valkorn5_choice = 'lantern';
                    window.playerState.flags.sebastian_fate = 'merge';
                    window.playerState.flags.iliya_anchor = true;
                    window.playerState.bolo_weaving = true;
                    window.playerState.valckorn_path = "B";
                    goScene("valckorn_epilogue");
                }
            }
        ]
    },

    valckorn_epilogue: {
        audioTrack: "assets/audio/ep2_city_music.mp3",
        audioAtmosphere: "assets/audio/ep2_city_ambient.mp3",
        title: "Втеча з Валькорна — Сигналізація тривоги",
        text: `Раптово урядова магічна сигналізація Палацу з гуркотом спрацьовує на всю будівлю, піднімаючи гвардію Стетсона по тривозі. Двері за спиною починають блокуватися важкими залізними решітками. Ви поспіхом збираєте зброю, забираєте Печатку і разом з Ілією прориваєтесь через заслони охорони назад до безпечних гнилих кордонів рідного Хейзмуру.`,
        choices: [
            {
                text: "Утекти з міста та знову заглибитися у великий Хейзмур",
                action: () => goScene("ep3_fog")
            }
        ]
    },

    // --- ЕПІЗОД 3: ГЛИБОКЕ БОЛОТО (АКТ III ПРОДОВЖЕННЯ) ---
    ep3_fog: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Голос із туману — Повернення в імлу",
        text: `Ви стрімко заглиблюєтесь у серце глибокого Хейзмуру, залишаючи залізо столиці далеко позаду. Білий щільний туман обволікає ваші обладунки, намагаючись повністю стерти почуття правильного напрямку руху. Раптом з імли постає знайома сувора постать провідниці. Міа чекає на вас біля старого очерету.`,
        choices: [
            {
                text: "Підійти ближче та вислухати її звинувачення",
                action: () => {
                    window.playerState.sanity = 100;
                    goScene("ep3_mia_conflict");
                }
            }
        ]
    },

    ep3_mia_conflict: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Конфлікт інтересів на стежці",
        text: `Міа стоїть нерухомо посеред вузької затопленої стежки, її очі горять гнівом Моура: «Кам'яне залізне місто сильно змінило тебе, Вартовий. Я чітко бачу це по твоїх рухах.» Вона пильно позирає на Першу Печатку у ваших руках. «Ти приніс їхнє кляте людське срібло назад у наше святе болотяне серце. Моур фізично відчуває цей біль і кричить під водою. Ти взагалі розумієш, що коїш за своїм планом? Справді розумієш ціну?»`,
        choices: [{ text: "Заспокоїти її та продовжити рух до вежі Вежі Лілеї", action: () => goScene("ep3_tykhy_tower") }]
    },

    ep3_tykhy_tower: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Вежа Ключниці — Давня Лілея",
        text: `Давня Ключниця болот Лілея зустрічає вас на самому порозі своєї старої кам'яної вежі. Її очі виглядають неймовірно старими та втомленими: «Мій рід поколіннями будував ці великі стіни та замки між людиною та Туману. Не для того, щоб надійно захистити людей від болота, Вартовий — а для того, щоб захистити дике болото від руйнівного заліза людей.» Вона дивиться на Першу Печатку. «Друга Печатка з темної болотяної міді ховається під Затопленою Обителлю Ключників. Іди туди, якщо твій розум готовий платити фінальну ціну замикання.»`,
        choices: [{ text: "Отримати благословення та висунутись до Каена за ключем", action: () => goScene("ep3_kaen_deal") }]
    },

    ep3_kaen_deal: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Мідний амулет старого шамана",
        text: `Старий шаман Каен зупиняє вас на виході з локації біля затопленої стежки: «Я свято знав, що ви обов'язково повернетесь сюди живими за балансом.» Він повільно дістає старий, вкритий зеленню мідний амулет у формі прадавнього ключа: «Ця реліквія відкриє лише зовнішні масивні замки Затопленої Обителі. Внутрішні головні замки зможе відкрити виключно кров Лілеї. Вкладаю цей амулет у твою долоню. Поверніть їй свободу і поверніться живими з крипти.»`,
        choices: [{ text: "Прийняти ключ Каена та вийти до Шаленої Переправи через річку", action: () => goScene("ep3_ferry_crossing") }]
    },

    ep3_ferry_crossing: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Шалена Переправа — Руйнування ланцюга",
        text: `Ви наближаєтесь до Шаленого річкового порому. Чорна річка вирує як киплячий дьоготь, а сліпі хижаки Тварюки Твані люто намагаються перегризти тримаючі ланцюги плоту. Раптом один головний ланцюг із тріском лопається під тиском течії! Пліт починає стрімко зносити на гострі скелі водоспаду. Оберіть метод порятунку:`,
        choices: [
            {
                text: "Затиснути іржавий розірваний ланцюг голими руками, використовуючи Силу Плетіння (Bolo-Weaving)",
                action: () => {
                    window.playerState.sanity = (window.playerState.sanity || 100) - 20;
                    addToLog("Жахливі опіки від іржавого металу та магії Туману. Ваш Розум впав на 20 одиниць, але пором врятовано.", "damage");
                    goScene("ep3_ferry_choice_A");
                }
            },
            {
                text: "Використати магічне поле Першої Печатки як важкий якір для стабілізації плоту",
                action: () => {
                    window.playerState.reputation = window.playerState.reputation || {};
                    window.playerState.reputation.muri = (window.playerState.reputation.muri || 0) - 30;
                    addToLog("Срібне поле заморозило киплячу річку. Пліт стабілізовано, але Мурі проклинають вас за випалювання води.", "damage");
                    goScene("ep3_ferry_choice_B");
                }
            }
        ]
    },

    ep3_ferry_choice_A: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Шлях Плетіння — Вузькі очерети",
        text: `Сила стародавнього Плетіння забрала у вас надто багато життєвої енергії. Ваші руки сильно тремтять, а вени назавжди потемнішали від торф'яного соку. Проте ви успішно подолали Шалену Переправу і опинилися на іншому березі. Лілея мовчки вивчає ваші рани. Попереду з імли велично підноситься похмурий силует Затопленої Обителі Ключників.`,
        choices: [{ text: "Рушити далі — до Затопленої Обителі", action: () => goScene("ep3_vapor_zone") }]
    },
    
    ep3_ferry_choice_B: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Шлях Заліза — Сухий Горб Хейзмуру",
        text: `Колосальна енергія Білого срібла Печатки повністю пересушила і випалила навколишню землю під ногами. Шлях до воріт тепер абсолютно вільний від багнюки, але берег річки назавжди перетворився на мертву потріскану глину. Лілея суворо констатує: «Болото ніколи не забуде цього акту випалювання.»`,
        choices: [{ text: "Рушити далі — до Затопленої Обителі", action: () => goScene("ep3_vapor_zone") }]
    },

    ep3_vapor_zone: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Гнилі Поля — Зона отруйних випарів",
        text: `Між берегом річки та Затопленою Обителлю лежать Гнилі Поля — низина, де болото віками перетравлює все, що в нього потрапило. Над чорною жижею висять жовто-зелені пасма випарів: повітря тут на смак гірке, а очі починають сльозитися вже на краю низини. Лілея прикриває обличчя краєм плаща: «Дихання Моура. Травники Обителі ходили сюди по інгредієнти — і не всі поверталися.»<br><br>Навпростець — швидко, але випари роз'їдають легені. В обхід, краєм драговини — довше, і там, у мулі, щось ворушиться.`,
        choices: [
            {
                text: "Йти навпростець крізь випари, затиснувши обличчя тканиною.",
                action: () => {
                    applyPoison("Гіркі випари обпікають горло і легені — отрута вже в крові!");
                    addToLog("Ви долаєте Гнилі Поля швидко, але кожен вдих дається болем.", "damage");
                    goScene("ep3_obitel_enter");
                }
            },
            {
                text: "Обходити низину краєм драговини, подалі від випарів.",
                action: () => {
                    addToLog("Ви обираєте довгий шлях. Драговина чвакає під ногами, і час від часу позаду чується сторонній сплеск...", "system");
                    ambushOrGo(0.5, "Гнилий потопельник", 45, 10, "ep3_obitel_enter", {
                        intro: "Мул перед вами здіймається горбом — потопельник Гнилих Полів не любить, коли тривожать його трясовину!"
                    });
                }
            },
            {
                text: "«Міа вчила читати дихання болота.» Шукати безпечні вікна між пасмами випарів.",
                visible: () => (window.playerState.mia_trust || 0) >= 3,
                action: () => {
                    addToLog("Сім уроків болота не минули даремно: ви рухаєтесь короткими перебіжками між подихами вітру, як вчила Міа, і проходите Гнилі Поля неушкодженим. Лілея проводжає вас здивованим поглядом.", "success");
                    goScene("ep3_obitel_enter");
                }
            }
        ]
    },

    ep3_murok_guardian: {
        audioTrack: "assets/audio/ep2_dungeon_music.mp3",
        audioAtmosphere: "assets/audio/ep2_dungeon_ambient.mp3",
        title: "Страж глибин — Дорослий мурок",
        text: `Останній коридор перед Жертовником перегороджує вода — чорна, абсолютно нерухома. І раптом вона оживає. З глибини повільно підіймається туша завбільшки з рибальський човен: дорослий мурок-трясовик, оброслий мушлями і кістками тих, хто дійшов до цього місця раніше за вас. Старі шрами на його панцирі світяться тьмяним болотним вогнем.<br><br>Міа колись попереджала: «Дорослого ти вже не переживеш.» Лілея притискається до стіни: «Він — сторож. Обитель не пускає до Моура нікого... живим.»`,
        choices: [
            {
                text: "Прийняти бій. Печатка Вартового не відступає перед сторожами.",
                action: () => {
                    startCombat("Дорослий мурок", 90, 16, () => {
                        addToLog("Гігант осідає на дно з протяжним стогоном, що віддає у стіни Обителі. Шлях до Жертовника відкритий. Лілея шепоче: «Тисячу років ніхто не проходив тут силою...»", "success");
                        goScene("ep3_altar");
                    });
                }
            },
            {
                text: "Прослизнути тінню вздовж стіни, поки мурок підіймається. [Потребує 20 Рішучості]",
                visible: () => (window.playerState.will || 0) >= 20,
                action: () => {
                    window.playerState.will = Math.max(0, window.playerState.will - 20);
                    addToLog("Серце калатає у горлі. Крок за кроком, по карниз у крижаній воді, ви прослизаєте повз сліпу зону гіганта. Витрачено 20 Рішучості — але жодної краплі крові.", "success");
                    updateUi();
                    goScene("ep3_altar");
                }
            }
        ]
    },

    ep3_obitel_enter: {
        audioTrack: "assets/audio/ep2_dungeon_music.mp3",
        audioAtmosphere: "assets/audio/ep2_dungeon_ambient.mp3",
        title: "Затоплена Обитель — Вхід у темряву",
        text: `Затоплена Обитель Ключників більше ніж наполовину пішла під чорну воду Хейзмуру. Лілея повільно витягує стародавній бронзовий циліндр, вкритий рунами: «Ці замки реагують виключно на рідний голос та чисту кров нашого роду.» Вона робить глибокий розріз на долоні і проводить кров'ю по центральній руні. Головний замок відчиняється з жахливим залізним скреготом. Всередині панує абсолютна темрява і запах тисячолітнього моху.`,
        choices: [
            {
                text: "Обшукати затоплені келії братів-Ключників, перш ніж іти далі",
                visible: () => !(window.playerState.completedQuests && window.playerState.completedQuests['obitel_cells_searched']),
                action: () => {
                    window.playerState.completedQuests = window.playerState.completedQuests || {};
                    window.playerState.completedQuests['obitel_cells_searched'] = true;
                    addItem("🧪 Протиотрута");
                    addItem("🍯 Болотяна мазь");
                    addToLog("У зотлілій скрині брата-травника ви знаходите дивом збережені 🧪 Протиотруту та 🍯 Болотяну мазь. Ключники готувалися до болота краще за вас.", "success");
                    goScene("ep3_obitel_enter");
                }
            },
            { text: "Увійти всередину затоплених коридорів монастиря", action: () => goScene("ep3_obitel_locks") }
        ]
    },

    ep3_obitel_locks: {
        audioTrack: "assets/audio/ep2_dungeon_music.mp3",
        audioAtmosphere: "assets/audio/ep2_dungeon_ambient.mp3",
        title: "Коридори Обителі — Рунічні пастки",
        text: `Всередині на вас чекають нескінченні затоплені коридори та ряди складних рунічних замків. Лілея працює методично та спокійно: «Мій рід будував це святе місце для того, щоб Моур міг вічно спати в межах. Не померти під залізом — а просто мирно спати.» Вода піднімається по пояс, вона неймовірно холодна. З глибини залів доносяться дивні звуки сутностей: «Не зупиняйтесь ні на секунду, Вартовий. Воно відчуває твій людський страх набагато краще, ніж кроки.»`,
        choices: [{ text: "Пройти фінальний заслін та вийти безпосередньо до Жертовника", action: () => goScene("ep3_murok_guardian") }]
    },

    ep3_altar: {
        audioTrack: "assets/audio/ep2_dungeon_music.mp3",
        audioAtmosphere: "assets/audio/ep2_dungeon_ambient.mp3",
        title: "Жертовник Другої Печатки — Вирішальний Вердикт",
        text: `Ви стоїте в самому серці крипти перед великим Вівтарем Стагнації, де лежить Друга Печатка з болотяної міді. З туману повільно виступає Міа, її очі тепер абсолютно чорні від магії Моура: «Якщо ти поєднаєш людське срібло з нашою міддю — уся магія Хейзмуру назавжди помре під залізом столиці!» Це фінальний вибір АКТУ. Ваш Вердикт визначить усе майбутнє.`,
        choices: [
            {
                text: "⚙️ [Вердикт Заліза] Насильно вставити срібну Першу Печатку в мідний вівтар (Випалити болото)",
                action: () => {
                    window.playerState.flags = window.playerState.flags || {};
                    window.playerState.flags.verdict = 'iron';
                    window.playerState.valckorn_path = "A";
                    goScene("ep3_verdict_iron");
                }
            },
            {
                text: "🌿 [Вердикт Очерету] Назавжди кинути срібну Печатку в глибоку болотяну жижу (Віддати силу Моуру)",
                action: () => {
                    window.playerState.flags = window.playerState.flags || {};
                    window.playerState.flags.verdict = 'reed';
                    window.playerState.valckorn_path = "B";
                    goScene("ep3_verdict_reed");
                }
            },
            {
                text: "🕯️ [Пакт Ключника] Пропустити силу обох Печаток через власне тіло (Зберегти хиткий Баланс)",
                action: () => {
                    window.playerState.flags = window.playerState.flags || {};
                    window.playerState.flags.verdict = 'pact';
                    window.playerState.valckorn_path = "C";
                    goScene("ep3_verdict_pact");
                }
            }
        ]
    },

    ep3_verdict_iron: {
        audioTrack: "assets/audio/ep4_bridge_music.mp3",
        audioAtmosphere: "assets/audio/ep4_bridge_ambient.mp3",
        title: "Результат Вердикту: Сила Заліза",
        text: `Сліпучий білий спалах — і в крипті настає мертва тиша. Болотяна вода миттєво стає прозорою і холодною. Шепіт Моура назавжди обривається в умах. Міа дико кричить — не від фізичного болю, а від непоправної втрати зв'язку. Лілея опускає голову: «Ми щойно холодно вбили живу душу цього прадавнього місця.» Голос Ілії у вашій голові чіткий: «Ти повернув чистий порядок. Хейзмур вмирає, але залізна столиця Валькорн житиме.» Ви повертаєтесь до міста.`,
        choices: [{ text: "Перейти до Епізоду 4 — Початок розв'язки", action: () => goScene("ep4_start") }]
    },
    ep3_verdict_reed: {
        audioTrack: "assets/audio/ep4_bridge_music.mp3",
        audioAtmosphere: "assets/audio/ep4_bridge_ambient.mp3",
        title: "Результат Вердикту: Сила Очерету",
        text: `Урядове срібло розчиняється в мідному вівтарі з тихим шипінням. Ваша шкіра стрімко темнішає, а вени назавжди стають чорними як торф. Міа ніжно торкається вашого обличчя: «Ти вибрав порятунок нашого народу, Вартовий.» Голос Ілії у вашій голові стрімко слабшає й згасає: «Вартовий... я все ще тут... але ти вже занадто далеко від людського світу...» Болото починає активно розширювати свої кордони на залізне місто.`,
        choices: [{ text: "Рухатися до Епізоду 4 під капотом сюжету", action: () => goScene("ep4_start") }]
    },
    ep3_verdict_pact: {
        audioTrack: "assets/audio/ep4_bridge_music.mp3",
        audioAtmosphere: "assets/audio/ep4_bridge_ambient.mp3",
        title: "Результат Вердикту: Канонічний Пакт Балансу",
        text: `Ви пропускаєте колосальну енергію обох Печаток безпосередньо через власне смертне тіло. Відчуття жахливе — наче пекельний вогонь і космічний лід спалахнули всередині вен одночасно. Срібло й мідь назавжди замикаються у вашій плоті живим замком. Міа схиляє голову: «Ти добровільно вибрав нести цей вічний біль, щоб ми обидва могли жити.» Лілея: «Цей болісний баланс триватиме до останнього подиху вашого життя.» Голос Ілії: «Я залишаюся з тобою назавжди. Крокуємо далі.»`,
        choices: [{ text: "Перейти до Великої тристоронньої розв'язки АКТУ IV", action: () => goScene("ep4_start") }]
    },

    // --- ЕПІЗОД 4: ДВА БЕРЕГИ (АКТ IV АНKЕРНИЙ) ---
    ep4_start: {
        audioTrack: "assets/audio/ep4_bridge_music.mp3",
        audioAtmosphere: "assets/audio/ep4_bridge_ambient.mp3",
        title: "Повернення до великого Валькорна",
        text: `Ви знову повернулися до стін залізної столиці Валькорна. Позаду вирують аномалії глибокого Хейзмуру, а залізні стіни урядових палаців повністю дихають початком громадянської війни та зачистками. Ваш подальший крок повністю залежить від того, яку саме долю ви ухвалили на вівтарі монастиря.`,
        choices: [
            {
                text: "Прийняти всі наслідки свого доленосного вибору",
                action: () => {
                    if (window.playerState.valckorn_path === "A") { goScene("ep4_valckorn_iron_triumph"); }
                    else if (window.playerState.valckorn_path === "B") { goScene("ep4_valckorn_shadow_in_channels"); }
                    else { goScene("ep4_valckorn_fragile_ambassador"); }
                }
            }
        ]
    },

    // Шлях А: Залізний Тріумф (Випалювання болота)
    ep4_valckorn_iron_triumph: {
        audioTrack: "assets/audio/ep4_bridge_music.mp3",
        audioAtmosphere: "assets/audio/ep4_bridge_ambient.mp3",
        title: "Залізний Тріумф — Повернення карателів",
        text: `Ви повертаєтесь у залізний Валькорн як тріумфальний переможець у складі важкої військової делегації магістра Ордену Семи Кинджалів. Висушене болото більше не перешкоджає маршу гвардії. Під важким парадним плащем ви змушені ретельно ховати свої омертвілі руки, що перетворилися на сіру суху деревину Ключників. Лілея крокує поруч із вами, стискаючи креслення давніх систем. <br><br><em>Голос Ілії (чітко й близько у вашій голові):</em> "Я чітко чую горді кроки твого коня на мостовій столиці... Ти повернувся справжнім героєм, Вартовий. Твій розум повністю чистий від болотяного очеретяного шепоту Мії. Я відчуваю твій холод, але це наш чистий людський холод порядку. Ми майже вдома. Себастьян Марр уже чекає на тебе у Чорному Архіві для фінального звіту Раді."`,
        choices: [{ text: "Вирушити до Чорного Архіву на офіційну аудієнцію до Себастьяна Марра", action: () => goScene("ep4_valckorn_marr_audience") }]
    },

    ep4_valckorn_marr_audience: {
        audioTrack: "assets/audio/ep4_bridge_music.mp3",
        audioAtmosphere: "assets/audio/ep4_bridge_ambient.mp3",
        title: "Аудієнція у магістра Себастьяна Марра",
        text: `Ви піднімаєтеся до головної зали Чорного Архіву Палацу. У центрі кімнати Себастьян Марр тріумфує, підписуючи каральні накази: «Ти зробив те, що не вдавалося жодному елітному Вартовому до тебе, мій друже. Хейзмур стрімко вмирає, вода відступає під землю. Наш Орден ніколи не забуде твою велику службу Корони. Але твої задерев'янілі руки... що ж, це справедлива ціна за повний державний порядок.» Він передає вам Арбалет Залізного Завіту. На самому виході з Архіву вас раптово перехоплює сестра Тесса. Вона з глибоким презирством дивиться на ваші дерев'яні сухі пальці: «Вони зробили з тебе звичайний залізний кілок, щоб забити його в серце землі. Міа та тисячі беззбройних Мурів зараз просто вмирають від спраги в очереті. Кого ти захищатимеш тепер під цим прапором тиранії?»`,
        choices: [{ text: "Прийняти пропозицію Тесси та перейти до операції повалення тирана", action: () => goScene("ep4_valckorn_iron_burn") }]
    },

    ep4_valckorn_iron_burn: {
        audioTrack: "assets/audio/ep4_bridge_music.mp3",
        audioAtmosphere: "assets/audio/ep4_bridge_ambient.mp3",
        title: "Залізне випалювання — Початок бунту",
        text: `Себастьян Марр віддає офіційний наказ про початок фінальної зачистки «Чиста земля». Тесса піднімає відкритий бунт урядових сил всередині самого Ордену, категорично відмовляючись винищувати беззбройне корінне населення боліт фронтиру. Вона палко закликає вас зупинити божевілля магістра. Разом із бунтівними лицарями Тесси ви штурмуєте кабінети Чорного Архіву, використовуючи арбалет Залізного Завіту проти каральних загонів Себастьяна. Коридори заповнюються димом та брязканням сталі.`,
        choices: [{ text: "Зіткнутися з Себастьяном Марром у фінальному поєдинку в залі пресу", action: () => goScene("ep4_valckorn_marr_death") }]
    },

    ep4_valckorn_marr_death: {
        audioTrack: "assets/audio/ep4_bridge_music.mp3",
        audioAtmosphere: "assets/audio/ep4_bridge_ambient.mp3",
        title: "Смерть магістра Себастьяна Марра",
        text: `Ви разом із Тессою затискаєте Себастьяна Марра в кут біля механізмів головного архівного пресу Палацу. Він намагається захищатися, активуючи залізні захисні блоки, але пошкоджена система дає критичний збій. Важка залізна плита пресу зі скреготом зривається з опорних ланцюгів і миттєво розчавлює тирана під своєю вагою. <strong>Магістр Себастьян Марр гине на місці.</strong> Тесса бере головну печатку Ордену та офіційно оголошує про початок реформ. Орден більше не виконуватиме роль катів фронтиру. Ви збираєте речі та вирушаєте назад до випаленого Хейзмуру.`,
        choices: [{ text: "Повернутися до висушеного Хейзмуру для закриття справи", action: () => goScene("ep4_hazemoor_ash_paths") }]
    },

    ep4_hazemoor_ash_paths: {
        audioTrack: "assets/audio/ep4_bridge_music.mp3",
        audioAtmosphere: "assets/audio/ep4_bridge_ambient.mp3",
        title: "Попільні стежки Хейзмуру",
        text: `Прадавнє болото стрімко помирає на очах. Уся вода пішла занадто глибоко під землю, залишаючи на поверхні лише потріскану глину та гнилу твань, яка під сонцем швидко перетворюється на сірий попіл. Здичавілі Очеретяні Блукачі стали крихкими і розсипаються в труху від першого дотику вашого чобота. <br><br><em>Голос Ілії у вашому розумі:</em> "Дивись... гниль нарешті повністю відступає від наших кордонів. Я відчуваю твій спокій, Вартовий. Твої руки більше не пульсують очеретом." Ви виходите до старого вівтаря.`,
        choices: [{ text: "Іти безпосередньо до сухого Вівтаря Стагнації", action: () => goScene("ep4_hazemoor_dry_altar") }]
    },

    ep4_hazemoor_dry_altar: {
        audioTrack: "assets/audio/ep4_bridge_music.mp3",
        audioAtmosphere: "assets/audio/ep4_bridge_ambient.mp3",
        title: "Зіткнення біля сухого вівтаря — Фінал Мії",
        text: `Біля повністю висохлого Вівтаря Стагнації стоїть виснажена, знесилена Міа. З її потрісканої шкіри замість крові сочиться сірий пил Хейзмуру. Вона судорожно намагається вичавити з мідної Печатки останні краплі болотяної сили, щоб скерувати отруйний газ на Грейфорд у пориві помсти: «Ти привів сюди залізо гвардії... Ти повністю висушив наші священні ріки, Вартовий! Дивись на цю бідну землю — вона абсолютно мертва під твоїм чоботом. Але я не дам тобі піти просто так. Ми згинемо в цьому попелі разом!»`,
        choices: [
            {
                text: "Жорстко прибити Мію залізними штирями до кам'яного вівтаря, повністю нейтралізувавши її",
                action: () => {
                    window.playerState.reputation = window.playerState.reputation || {};
                    window.playerState.reputation.muri = (window.playerState.reputation.muri || 0) - 50;
                    goScene("ep4_hazemoor_dry_altar_nailed");
                }
            },
            {
                text: "Відмовитися від насильства, забрати мідну Печатку і дозволити їй згаснути самостійно",
                action: () => {
                    window.playerState.reputation = window.playerState.reputation || {};
                    window.playerState.reputation.muri = (window.playerState.reputation.muri || 0) - 30;
                    goScene("ep4_hazemoor_dry_altar_fade");
                }
            }
        ]
    },

    ep4_hazemoor_dry_altar_nailed: {
        audioTrack: "assets/audio/ep5_winter_music.mp3",
        audioAtmosphere: "assets/audio/ep5_winter_ambient.mp3",
        title: "Вівтар Стагнації — Залізний фінал",
        text: `Ви холодно і фізично фіксуєте кінцівки Мії на сухому камені вівтаря за допомогою залізних штирів, назавжди позбавляючи її залишків зв'язку з землею фронтиру. Вона не вмирає, але повністю затихає, перетворюючись на онімілу, нерухому мумію згаслого Хейзмуру. Ваша місія виконана повністю.`,
        choices: [
            {
                text: "Вийти на Суху Дорогу геть від Валькорна (ФІНАЛ А)",
                action: () => {
                    window.isChapterEnding = true;
                    goScene("ep5_final_A");
                }
            }
        ]
    },

    ep4_hazemoor_dry_altar_fade: {
        audioTrack: "assets/audio/ep5_winter_music.mp3",
        audioAtmosphere: "assets/audio/ep5_winter_ambient.mp3",
        title: "Вівтар Стагнації — Мирне згасання",
        text: `Ви категорично відмовляєтесь від подальшого насильства й просто обережно забираєте мідну Печатку з її слабких рук. Міа безсило падає на сухі плити вівтаря, її дихання стає ледь помітним, і тіло повністю дерев'яніє, перетворюючись на звичайну суху вербову гілку під сонцем фронтиру.`,
        choices: [
            {
                text: "Завершити подорож та вийти на Суху Дорогу (ФІНАЛ А)",
                action: () => {
                    window.isChapterEnding = true;
                    goScene("ep5_final_A");
                }
            }
        ]
    },

    // Шлях Б: Тінь у Каналах (Монстр очерету)
    ep4_valckorn_shadow_in_channels: {
        audioTrack: "assets/audio/ep4_bridge_music.mp3",
        audioAtmosphere: "assets/audio/ep4_bridge_ambient.mp3",
        title: "Чудовисько під бруківкою столиці",
        text: `Ваше тіло під дією розчиненого срібла остаточно перетворилося на величезного очеретяного монстра з лякаючими чорними очима Моура. Ви потайки пробираєтеся до Валькорна крізь брудні стічні колектори міста. Гнила болотна вода вже на повну силу сочиться крізь тріщини підземних каналів столиці. Ваші вени пульсують чорним торф'яним соком. <br><br><em>Голос Ілії у вашому розумі (звучить неймовірно далеко і слабо):</em> "Вартовий... де ти? Навколо мого духу лише... холодна чорна вода й суцільна темрява. Я ледь чую рідке биття твого серця... прошу, знайди вихід."`,
        choices: [{ text: "Пробратися далі крізь колектори в пошуках порятунку та Лілеї", action: () => goScene("ep4_valckorn_tessa_encounter_channels") }]
    },

    ep4_valckorn_tessa_encounter_channels: {
        audioTrack: "assets/audio/ep4_bridge_music.mp3",
        audioAtmosphere: "assets/audio/ep4_bridge_ambient.mp3",
        title: "Зіткнення з заслоном сестри Тесси",
        text: `На самому виході з підземних колекторів під головним собором вас блокує елітна варта на чолі з сестрою Тессою. Вона в жаху зупиняє готових до атаки солдатів і раптом впізнає у вашому спотвореному силуеті зниклого Вартового: «Боги... Вартовий? Що це прокляте болото з тобою зробило? Магістр Себастьян Марр звинуватив тебе у зраді й збирає всю гвардію з вогнеметами, щоб випалити Хейзмур дощенту. Якщо в тобі залишилося хоч щось людське... тікай негайно. Давня Лілея ховається в крипті собору, тільки її рід може зняти цю очеретяну кору.»`,
        choices: [
            {
                text: "Задіяти Силу Плетіння, щоб миттєво зникнути в густому тумані підземелля без пролиття крові варти",
                action: () => {
                    window.playerState.reputation = window.playerState.reputation || {};
                    window.playerState.reputation.order = (window.playerState.reputation.order || 0) + 10;
                    goScene("ep4_valckorn_hunt_for_beast");
                }
            },
            {
                text: "Люто атакувати загін варти, прориваючись силою кігтів очеретяного монстра",
                action: () => {
                    window.playerState.reputation = window.playerState.reputation || {};
                    window.playerState.reputation.order = (window.playerState.reputation.order || 0) - 50;
                    goScene("ep4_valckorn_hunt_for_beast");
                }
            }
        ]
    },

    ep4_valckorn_hunt_for_beast: {
        audioTrack: "assets/audio/ep4_bridge_music.mp3",
        audioAtmosphere: "assets/audio/ep4_bridge_ambient.mp3",
        title: "Штурм собору з нічних тіней",
        text: `Валькорн охоплений тотальною панікою — густий болотний туман просочився на центральні вулиці міста. Магістр Себастьян Марр особисто веде каральний загін з вогнеметами до підвалів собору. У тілі величезного очеретяного монстра ви починаєте повноцінне полювання в темних коридорах крипти, поодинці безшумно затягуючи гвардійців у твань.`,
        choices: [{ text: "Наздогнати магістра Себастьяна Марра біля головного вівтаря крипти собору", action: () => goScene("ep4_valckorn_marr_shadow_death") }]
    },

    // Перейменовано для унікальності ключа
    ep4_valckorn_marr_shadow_death: {
        audioTrack: "assets/audio/ep4_bridge_music.mp3",
        audioAtmosphere: "assets/audio/ep4_bridge_ambient.mp3",
        title: "Кривавий розрахунок у темній крипті",
        text: `Ви наздоганяєте Себастьяна Марра біля вівтаря крипти собору. Він намагається відчайдушно захищатися своїм важким срібним мечем Раді, але ви блискавично обплутуєте його кінцівки міцним корінням верби й ламаєте залізну броню. <strong>Магістр Себастьян Марр гине від ядухи.</strong> Сестра Тесса з'являється в залі, жахається вигляду тіла і кидає свій меч на плити: «Досить смертей, Вартовий! Твій опікун мертвий. Військо нікуди не піде. Дай нам спокій.» Вона оголошує реформацію.`,
        choices: [{ text: "Повернутися назад до глибокого Хейзмуру разом із Лілеєю для зняття прокляття", action: () => goScene("ep4_hazemoor_monster_return") }]
    },

    ep4_hazemoor_monster_return: {
        audioTrack: "assets/audio/ep4_bridge_music.mp3",
        audioAtmosphere: "assets/audio/ep4_bridge_ambient.mp3",
        title: "Поverнення монстра додому",
        text: `Ви повертаєтесь до Хейзмуру разом із Лілеєю, яка тримає у своїх руках важкий мідний Ключ Ключників для проведення ритуалу повернення вашої людської подоби. <br><br><em>Голос Ілії у вашій голові (звучить неймовірно кволо від впливу кори):</em> "Я... все ще ховаюся тут... під цією чорною жорсткою корою... прошу тебе, не дай очерету закрити мої очі назавжди..."`,
        choices: [{ text: "Прямувати безпосередньо до Вівтаря Стагнації для ритуалу Ключниці", action: () => goScene("ep4_hazemoor_mia_interferes") }]
    },

    ep4_hazemoor_mia_interferes: {
        audioTrack: "assets/audio/ep4_bridge_music.mp3",
        audioAtmosphere: "assets/audio/ep4_bridge_ambient.mp3",
        title: "Трагічне зіткнення з Мією біля вівтаря",
        text: `Біля вівтаря вас несподівано зустрічає Міа. Вона бачить у вашій очеретяній формі нового великого вождя болота і жахається, помітивши Лілею зі священним мідним ключем restauración: «Ні! Прадавнє болото нарешті повністю обрало тебе своїм захисником! А ця людська стара хоче знову замкнути твою велич у слабке, смертне тіло? Я ніколи не дозволю цього скоїти!» Міа з дикою люттю нападає на Лілею. Ви змушені стримувати Мію, не завдаючи їй смертельних ран.`,
        choices: [{ text: "Стримати лють Мії та дозволити Лілеї завершити ритуал повернення плоті", action: () => goScene("ep4_hazemoor_restoration_ritual") }]
    },

    ep4_hazemoor_restoration_ritual: {
        audioTrack: "assets/audio/ep5_winter_music.mp3",
        audioAtmosphere: "assets/audio/ep5_winter_ambient.mp3",
        title: "Ритуал Ключниці — Повернення людської подоби",
        text: `Коли Міа остаточно знерухомлена корінням, Лілея з зусиллям вставляє важкий мідний Ключ у рунічний паз прямо на ваших дерев'яних грудях. З жахливим скреготом кісток очеретяна чорна кора тріскається й злазить великими шарами. Торф'яний сік у венах замінюється гарячою червоною кров'ю. Ваші очі знову стають людськими, хоча на передпліччях назавжди залишаються темні глибокі рубці кори верби. Міа дивиться на вас із безмежним болем і презирством: «Ти боягузливо вибрав бути слабкою людиною... Біжи геть, людська тварюко.» Вона розвертається й назавжди зникає в імлі. <br><br><em>Голос Ілії (втомлено, але полегшено):</em> "Твоє серце... я знову чітко чую його людське биття. Принаймні тепер ми зможемо йти далі вперед."`,
        choices: [
            {
                text: "Ступити на Стежку Очерету босоніж крізь імлу (ФІНАЛ Б)",
                action: () => {
                    window.isChapterEnding = true;
                    goScene("ep5_final_B");
                }
            }
        ]
    },

    // Шлях В: Крихкий Посол (Баланс сил)
    ep4_valckorn_fragile_ambassador: {
        audioTrack: "assets/audio/ep4_bridge_music.mp3",
        audioAtmosphere: "assets/audio/ep4_bridge_ambient.mp3",
        title: "Живий замок на бруківці Ради",
        text: `Ви входите до залізничного Валькорна абсолютно легально, як офіційний дипломатичний посланець і «живий замок» Хейзмуру. Ваша шкіра землистого кольору, пальці чорні від торфу, але розум залишається повністю людським. Ви відчуваєте постійний пекельний біль у грудях від внутрішнього тертя срібла й міді всередині вашої плоті. <br><br><em>Голос Ілії (тихо й підтримуюче):</em> "Я чую твій важкий подих, Вартовий. Цей постійний біль тримає твій розум у реальності. Ти став єдиним живим мостом між нашим та їхнім берегом."`,
        choices: [{ text: "Перейти до зали Ратуші на вирішальну дипломатичну шахівницю фракцій", action: () => goScene("ep4_valckorn_diplomacy") }]
    },

    ep4_valckorn_diplomacy: {
        audioTrack: "assets/audio/ep4_bridge_music.mp3",
        audioAtmosphere: "assets/audio/ep4_bridge_ambient.mp3",
        title: "Дипломатична шахівниця фракцій фронтиру",
        text: `У великій залі Ратуші Себастьян Марр, маршал Тесса та Лілея ведуть запеклі тристоронні перемовини про кордони. Себастьян Марр жорстко б'є кулаком по столу: «Ти пропонуєш нам нейтралітет Амфібій, Вартовий? Це занадто крихка конструкція! Наш Орден вимагає негайного встановлення застав військових ліхтарів уздовж усієї лінії очерету Хейзмуру. Якщо відмовишся — пакт буде негайно анульовано гвардією.» Лілея тихо шепоче вам, що Міа обіцяє не чіпати патрулі гвардії лише в тому випадку, якщо вони ніколи не перетинатимуть Шалену Річку.`,
        choices: [
            {
                text: "Прийняти ультимативні умови Себастьяна про встановлення ліхтарних застав охорони",
                action: () => {
                    window.playerState.reputation = window.playerState.reputation || {};
                    window.playerState.reputation.order = (window.playerState.reputation.order || 0) + 20;
                    window.playerState.reputation.muri = (window.playerState.reputation.muri || 0) - 20;
                    goScene("ep4_valckorn_conspiracy");
                }
            },
            {
                text: "Категорично заборонити встановлення ліхтарів, погрожуючи Раді повною силою Моура",
                action: () => {
                    window.playerState.reputation = window.playerState.reputation || {};
                    window.playerState.reputation.muri = (window.playerState.reputation.muri || 0) + 20;
                    window.playerState.reputation.order = (window.playerState.reputation.order || 0) - 20;
                    goScene("ep4_valckorn_conspiracy");
                }
            }
        ]
    },

    ep4_valckorn_conspiracy: {
        audioTrack: "assets/audio/ep4_bridge_music.mp3",
        audioAtmosphere: "assets/audio/ep4_bridge_ambient.mp3",
        title: "Змова радикалів та підписання Пакту",
        text: `Радикальні лицарі Ордену Семи Кинджалів раптово оголюють мечі та намагаються влаштувати кривавий замах на ваше життя прямо під час аудієнції, щоб повністю зірвати Пакт і спровокувати повноцінну війну. Разом із маршалом Тессою ви успішно стримуєте натиск змовників, майстерно балансуючи на межі магії Плетіння та використання срібних ліхтарів собору. Коли радикалів повністю подолано, блідий Себастьян Марр змушений підписати офіційний Пакт про розмежування кордонів фронтиру. Його одноосібна влада тепер назавжди обмежена Радою, а Тесса стає верховним маршалом Валькорна.`,
        choices: [{ text: "Повернутися до Хейзмуру для фінальної стабілізації Печаток на вівтарі", action: () => goScene("ep4_hazemoor_three_forces") }]
    },

    ep4_hazemoor_three_forces: {
        audioTrack: "assets/audio/ep4_bridge_music.mp3",
        audioAtmosphere: "assets/audio/ep4_bridge_ambient.mp3",
        title: "Сходження трьох сил у серці багнюки",
        text: `Дипломатичний нейтралітет успішно зафіксовано на папері у Ратуші, але сама земля Хейзмуру здригається від аномалій — закриті Печатки шалено пручаються зсередини вашої плоті. Ви прибуваєте до стародавнього вівтаря Обителі разом із Лілеєю та Мією. Для порятунку світу ви повинні діяти абсолютно спільно, як єдиний механізм. <br><br><em>Голос Ілії у вашій голові:</em> "Вода фронтиру й Залізо столиці. Тільки твій незламний дух може змусити їх триматися разом. Це твій вічний міст, Вартовий."`,
        choices: [{ text: "Розпочати фінальний великий ритуал повного замикання обох Печаток", action: () => goScene("ep4_hazemoor_balance_ritual") }]
    },

    ep4_hazemoor_balance_ritual: {
        audioTrack: "assets/audio/ep5_winter_music.mp3",
        audioAtmosphere: "assets/audio/ep5_winter_ambient.mp3",
        title: "Замикання Печаток — Фінальна стабілізація світу",
        text: `Ви впевнено керуєте рунічними механізмами стародавнього вівтаря Обителі, обертаючи важкі бронзові диски та затискаючи срібні важелі Раді обома руками. Ви замикаєте обидва ключі сили безпосередньо у власній живій плоті. Величезний внутрішній біль нарешті повністю стабілізується назавжди, фіксуючи кордон. Міа обережно відпускає плиту вівтаря: «Ти вибрав свідомо нести цей великий біль у грудях, щоб наш народ міг вічно жити в очереті. Болото триматиметься у своїх межах.» Лілея втомлено спирається на ваше плече: «Це найважчий шлях з усіх можливих. Ти будеш цим живим мостом усе своє життя.» Ваша місія виконана бездоганно.`,
        choices: [
            {
                text: "Зупинитися посередині мосту між двома світами (ФІНАЛ В)",
                action: () => {
                    window.isChapterEnding = true;
                    goScene("ep5_final_C");
                }
            }
        ]
    },

    // --- АБСОЛЮТНІ ФІНАЛИ 5-ГО ЕПІЗОДУ (КІНЕЦЬ ГРИ) ---
    ep5_final_A: {
        audioTrack: "assets/audio/ep5_winter_music.mp3",
        audioAtmosphere: "assets/audio/ep5_winter_ambient.mp3",
        title: "Відхід Вартового: Суха Дорога",
        text: `Сірий, холодний ранок. Небо повністю чисте від болотного туману, але виглядає абсолютно безживним. Земля Хейзмуру повністю випалена, висушена і перетворена на сірий попіл залізом Ради. Ви повільно йдете по пильній сухій дорозі геть від стін Валькорна. Рухи ваших омертвілих пальців неймовірно повільні й жорсткі всередині шкіряних дорожніх рукавиць. <br><br><em>Голос Ілії у вашому розумі (тихо й сумно):</em> "Твій обов'язок повністю згасає, як і останнє тепло в твоїх задерев'янілих руках, Вартовий. Попереду на нас чекають лише сухі, чужі й далекі краї... Йди вперед." <br><br>Ви влітку озираєтесь на високі кам'яні вежі залізничного Валькорна, мовчки поправляєте рукавицю на руці і назавжди зникаєте на сірому горизонті фронтиру. <br><br><strong>ДЯКУЄМО ЗА ГРУ. КІНЕЦЬ ЛІНІЇ ЗАЛІЗА.</strong>`,
        isAbsoluteFinal: true,
        choices: []
    },

    ep5_final_B: {
        audioTrack: "assets/audio/ep5_winter_music.mp3",
        audioAtmosphere: "assets/audio/ep5_winter_ambient.mp3",
        title: "Відхід Вартового: Стежка Очерету",
        text: `Вологі, густі та затишні сутінки оточують мандрівника. Все навколо на кілометри вкрите знайомим сизим болотним туманом Хейзмуру. Ви спокійно йдете босоніж по теплому вологому торфу. Ваша шкіра знову м'яка й тепла, але передпліччя назавжди покриті темними глибокими рубці стародавньої кори верби Ключників. Ви назавжди залишаєте очеретяні хащі поселення за своєю спиною. <br><br><em>Голос Ілії (тихо й полегшено):</em> "Ми назавжди залишаємо Хейзмур нашому рідному очерету. А наша нова дорога лежить далі, туди, де холодно, сніжно й чужо для Палацу. Ніколи не озирайся назад, мій друже. Твоя людська душа нарешті повністю вільна. Іди вперед." <br><br>Ви впевнено ступаєте крізь Туман у невідомі землі, повністю розчиняючись у сизій імлі разом із пам'яттю про Орден. <br><br><strong>ДЯКУЄМО ЗА ГРУ. КІНЕЦЬ ЛІНІЇ ОЧЕРЕТУ.</strong>`,
        isAbsoluteFinal: true,
        choices: []
    },

    ep5_final_C: {
        audioTrack: "assets/audio/ep5_winter_music.mp3",
        audioAtmosphere: "assets/audio/ep5_winter_ambient.mp3",
        title: "Відхід Вартового: Міст Між Берегами",
        text: `Глибокі зимові сутінки фронтиру. Ви повільно й важко йдете по великому кам'яному мосту через Шалену Річку. З одного боку мосту яскраво світяться штучні ліхтарі Палаців Валькорна, з іншого — загадково темніє природний отруйний туман вічного Хейзмуру. Ви зупиняєтесь рівно посередині споруди, міцно стискаючи своїми чорними пальцями два ключі від великих Печаток сил. <br><br><em>Голос Ілії (тихо й близько):</em> "Це твоє єдине істинне місце у світі — вічний живий міст між двома ворогуючими світами. Але міст за своєю природою ніколи не може належати жодному з берегів. Ми забираємо ці ключі із собою в невідомість... Я залишаюся з тобою... назавжди..." <br><br>Ви повільно розвертаєтесь і продовжуєте свій рух по мосту вперед — у зовсім нові, невідомі землі, залишаючи обидва береги далеко за своєю спиною. <br><br><strong>ДЯКУЄМО ЗА ГРУ. КІНЕЦЬ ЛІНІЇ БАЛАНСУ.</strong>`,
        isAbsoluteFinal: true,
        choices: []
    }
};
