window.playerState = window.playerState || {};
window.EPISODE_1_QUESTS = window.EPISODE_1_QUESTS || [];
window.GAME_SCENES = {
    arriving: {

        audioTrack: "assets/audio/ep1_tavern_music.mp3",

        audioAtmosphere: "assets/audio/ep1_tavern_crowd_loop.mp3",

        title: "Постоялий двір Грейфорда",
        text: `Ви входите у напівтемну таверну. За шинком стоїть Ерван — хазяїн закладу. Ви підходите і запитуєте про Руфіна. Ерван мовчки бере ваш лист, дивиться на дивну печатку (два перехрещені кинджали, коло і крапля), тримає його на мить довше, ніж варто звичайному паперу...<br><br>Потім піднімає на вас очі і запитує:<br><em>«І що он тобі був — друг, боржник, чи ти просто наймит-кур'єр?»</em>`,
        choices: [
            {
                text: "«Ми домовились. Я приїхав виконати свою частину обов'язку.» (Шлях Ідеаліста)",
                action: () => chooseMotivation("Ідеаліст", "Ерван киває з повагою: «Людина обов'язку в наші часи — рідкість. Ось ключ від його кімнати нагорі.»", "investigation")
            },
            {
                text: "«Він мав дещо, що мне потрібно. Це особиста справа.» (Особистий Інтерес)",
                action: () => chooseMotivation("Особистий інтерес", "Ерван примружується: «У всіх тут свої інтереси. Тримай ключ, кімната на другому поверсі.»", "investigation")
            },
            {
                text: "«Я просто доставляю листа. Що далі — моя проблема.» (Прагматик)",
                action: () => chooseMotivation("Прагматик", "Ерван хмикає: «Просто наймит. Це безпечніше. Ключ твій, роби свое діло.»", "investigation")
            },
            {
                text: "⚖️ [Суддя] «Я представляю закон Грейфорда. Ти зобов'язаний співпрацювати зі слідством.»",
                visible: () => window.playerState.doctrines.judge >= 1,
                action: () => chooseMotivation("Суддя", "Ерван стримано киває: «Закон... Що ж, ми поважаємо закон міста, хоча болото його не чує. Ось ключ від кімнати Руфіна.»", "investigation")
            }
        ]
    },
    investigation: {

        audioTrack: "assets/audio/ep1_tavern_music.mp3",

        audioAtmosphere: "assets/audio/ep1_tavern_crowd_loop.mp3",

        title: "Розслідування у Грейфорді",
        text: `Ерван повідомив, що картограф Руфін зник три дні тому. Його кімната досі оплачена, речі лежать недоторканими на другому поверсі таверни.<br><br>У вас є три головні нитки розслідування у Грейфорді. Дослідіть принаймні дві, щоб зібрати достатньо доказів і рушити за його слідами:`,
        choices: [
            {
                text: "🚪 Оглянути кімнату Руфіна на другому поверсі таверни",
                visible: () => window.playerState && !window.playerState.clues.room,
                action: () => goThread("room")
            },
            {
                text: "🛠️ Відвідати квартал ремісників та поговорити з різьбярем",
                visible: () => window.playerState && !window.playerState.clues.carver,
                action: () => goThread("carver")
            },
            {
                text: "🍻 Завітати у портову таверну та розпитати куртизанку Касандру",
                visible: () => window.playerState && !window.playerState.clues.tavern,
                action: () => goThread("tavern")
            },
            {
                text: "🧙‍♀️ Оглянути будинок Чаклунки на околиці (Доступно після виявлення знаків)",
                visible: () => window.playerState.clues.witch_hint === true,
                action: () => goThread("witch")
            },
            {
                text: "🚪 Іти до воріт міста та вирушати в Хейзмуру (Потрібно знайти докази)",
                visible: () => (Object.values(window.playerState.clues).filter(v => v === true && v !== "witch_hint").length >= 2),
                action: () => goScene("gates")
            }
        ]
    },
    thread_room: {

        audioTrack: "assets/audio/ep1_tavern_music.mp3",

        audioAtmosphere: "assets/audio/ep1_tavern_crowd_loop.mp3",

        title: "Кімната Руфіна",
        text: `Ви заходите в порожню, пильну кімнату. Тут лежить зношений плащ картографа, дорожній посох та шкіряна сумка з незвичайним тавром у вигляді змії.<br><br>Що ви будете робити?`,
        choices: [
            {
                text: "🔍 Детально обшукати особисті речі (Звичайний пошук)",
                nextSceneId: "investigation",
                action: () => {
                    window.playerState.clues.room = true;
                    addToLog("Знайдено шкіряну сумку з тавром ремісничого кварталу.", "success");
                    addItem("🎒 Сумка Руфіна");
                    adjustResource("bogiron", 1);
                    adjustResource("water", 1);

                }
            },
            {
                text: "🏕️ [Слідопит] Дослідити сліди бруду на підлозі",
                visible: () => window.playerState.doctrines.pathfinder >= 1,
                nextSceneId: "gates",
                action: () => {
                    window.playerState.clues.room = true;
                    addToLog("Слідопит виявив: болотяна глина на підлозі — чорний торф з глибин Хейзмуру.", "success");
                    addItem("🎒 Сумка Руфіна");
                    adjustResource("loosestrife", 2);
                    adjustResource("slate", 1);
                    adjustReputation("muri", 10);

                }
            },
            {
                text: "💡 [Ліхтар] Оглянути стіни та одвірки на наявність прихованої магії",
                visible: () => window.playerState.doctrines.lantern >= 1,
                nextSceneId: "gates",
                action: () => {
                    window.playerState.clues.room = true;
                    window.playerState.clues.witch_hint = true;
                    addToLog("Ліхтар виявив: ледь помітні захисні руни над дверима. Вони ведуть до Чаклунки.", "success");
                    addItem("🎒 Сумка Руфіна");
                    adjustResource("ash", 1);
                    adjustResource("slate", 1);
                    adjustReputation("keepers", 10);

                }
            }
        ]
    },
    thread_carver: {

        audioTrack: "assets/audio/ep1_city_music.mp3",

        audioAtmosphere: "assets/audio/ep1_city_ambient.mp3",

        title: "Квартал ремісників — Різьбяр",
        text: `Ви знаходите майстерню різьбяра по дереву. Старий майстер працює над викривленою гілкою і неохоче реагує на ваші запитання про Руфіна. «Багато хто приходить і йде. Чому я маю допомагати кожному Вартовому?»`,
        choices: [
            {
                text: "📜 Показати запечатаний лист Руфіна з дивною восковою печаткою",
                nextSceneId: "investigation",
                action: () => {
                    window.playerState.clues.carver = true;
                    addToLog("Різьбяр побачив печатку, здригнувся і сказав: «Руфін питав про дорогу до Тихого Шелесту.»", "success");
                    adjustResource("bogiron", 2);
                    adjustReputation("order", 15);

                }
            },
            {
                text: "🏕️ [Слідопит] Заговорити про болотяне дерево, з яким він працює",
                visible: () => window.playerState.doctrines.pathfinder >= 1,
                nextSceneId: "gates",
                action: () => {
                    window.playerState.clues.carver = true;
                    addToLog("Ви впізнали корінь-вербу з болота. Майстер сказав: «Руфін ніс щось дуже важке перед виходом.»", "success");
                    adjustResource("tendons", 2);
                    adjustResource("bogiron", 1);
                    adjustReputation("muri", 15);

                }
            },
            {
                text: "🤝 [Посередник] Запропонувати взаємовигідну угоду",
                visible: () => window.playerState.doctrines.mediator >= 1,
                nextSceneId: "gates",
                action: () => {
                    window.playerState.clues.carver = true;
                    addToLog("Ви домовилися розізнати долю його боргів. Різьбяр зізнався: «Хтось оплатив йому подорож сріблом!»", "success");
                    adjustResource("silver", 2);
                    adjustReputation("admin", 15);

                }
            },
            {
                text: "💡 [Ліхтар] Вказати на болотяні захисні знаки над його дверима",
                visible: () => window.playerState.doctrines.lantern >= 1,
                nextSceneId: "gates",
                action: () => {
                    window.playerState.clues.carver = true;
                    window.playerState.clues.witch_hint = true;
                    addToLog("Майстер бачить, що ви розумієте руни: «Руфін ставив ці знаки перед виходом вночі.»", "success");
                    adjustResource("slate", 2);
                    adjustReputation("keepers", 15);

                }
            }
        ]
    },
    thread_tavern: {

        audioTrack: "assets/audio/ep1_tavern_music.mp3",

        audioAtmosphere: "assets/audio/ep1_tavern_crowd_loop.mp3",

        title: "Портова таверна",
        text: `У брудному шинку бармен протирає склянку: «Руфін спілкувався з куртизанкою на ім'я Касандра. Вона зараз сидить за кутовим столиком.»<br><br>Касандра дивиться на вас із підозрою.`,
        choices: [
            {
                text: "🗣️ Спробувати розговорити її",
                nextSceneId: "investigation",
                action: () => {
                    window.playerState.clues.tavern = true;
                    addToLog("Касандра розповіла: «Руфін казав, що щось у Хейзмурі не чекає на людей.»", "success");
                    adjustResource("loosestrife", 2);
                    adjustReputation("admin", 10);

                }
            },
            {
                text: "🤝 [Посередник] Заговорити про гроші та срібло Руфіна",
                visible: () => window.playerState.doctrines.mediator >= 1,
                nextSceneId: "gates",
                action: () => {
                    window.playerState.clues.tavern = true;
                    addToLog("Касандра зізнається: «Він платив чистим сріблом. Хтось багатий найняв його.»", "success");
                    adjustResource("silver", 1);
                    adjustResource("peganum", 1);
                    adjustReputation("order", 10);

                }
            },
            {
                text: "⚖️ [Суддя] «Перешкоджання офіційному слідству Ордену карається суворо. Говори правду.»",
                visible: () => window.playerState.doctrines.judge >= 1,
                nextSceneId: "gates",
                action: () => {
                    window.playerState.clues.tavern = true;
                    addToLog("Вона шепоче: «Він шукав старого провідника мурі. Заберіть цей слиз мурі, що він забув на столі!»", "success");
                    adjustResource("slime", 2);
                    adjustReputation("admin", 20);
                    adjustReputation("order", -10);

                }
            }
        ]
    },
    thread_witch: {

        audioTrack: "assets/audio/ep1_city_music.mp3",

        audioAtmosphere: "assets/audio/ep1_city_ambient.mp3",

        title: "Помешкання Чаклунки",
        text: `Ви знайшли прихований будинок на околиці міста, прикрашений оберегами від болотяних духів. Чаклунка зустрічає вас із посмішкою. Вона знає, чому ви прийшли. «Руфін? Я бачила, як він ішов у болота вночі...»`,
        choices: [
            {
                text: "🗣️ Просто запитати, що вона бачила тієї ночі",
                nextSceneId: "investigation",
                action: () => {
                    window.playerState.clues.witch = true;
                    addToLog("Вона каже: «Він ніс важку річ, яка горіла холодним світлом у темряві. Це було моторошно.»", "success");
                    adjustResource("henbane", 1);
                    adjustReputation("muri", 10);

                }
            },
            {
                text: "💡 [Ліхтар] Розпитати про магічне світіння його речей",
                visible: () => window.playerState.doctrines.lantern >= 1,
                nextSceneId: "gates",
                action: () => {
                    window.playerState.clues.witch = true;
                    addToLog("Чаклунка шепоче: «Він ніс стародавній артефакт боліт, який світився зеленим вогнем!»", "success");
                    addItem("🧿 Болотяний амулет");
                    adjustResource("ash", 1);
                    adjustResource("heart", 1);
                    adjustResource("henbane", 2);
                    adjustReputation("keepers", 20);

                }
            },
            {
                text: "🤝 [Посередник] Спробувати купити її знання",
                visible: () => window.playerState.doctrines.mediator >= 1,
                nextSceneId: "gates",
                action: () => {
                    window.playerState.clues.witch = true;
                    addToLog("За жменю мідяків вона зізналася: «Він купив це світіння у когось впливового в Грейфорді.»", "success");
                    adjustResource("henbane", 2);
                    adjustReputation("admin", -10);

                }
            }
        ]
    },
    gates: {

        audioTrack: "assets/audio/ep1_city_music.mp3",

        audioAtmosphere: "assets/audio/ep1_city_ambient.mp3",

        title: "Міські Ворота — Вихід у Хейзмур",
        text: `Ви зібрали достатньо доказів і підходите до важких дерев'яних воріт. Сержант воріт перевіряє свої записи: «Так, Руфін вийшов три дні тому в напрямку Тихого Шелесту.»<br><br>Він уважно дивиться на вас: <em>«З якого приводу Вартовий іде в болота?»</em>`,
        choices: [
            {
                text: "«Я шукаю людину. Руфін пішов і не повернувся, я маю його знайти.» (Правда)",
                action: () => {
                    adjustReputation("admin", 20);
                    adjustReputation("order", 10);
                    finishQuest("Правда", "Сержант киває: «Нехай закон світить тобі в тумані.»");
                }
            },
            {
                text: "«Я маю перевірити маршрут. Є скарги на безпеку поселення.» (Напівправда)",
                action: () => {
                    adjustReputation("admin", 5);
                    adjustReputation("order", -5);
                    finishQuest("Напівправда", "Сержант скептично хмикає: «У Хейзмурі немає безпеки. Ну йди.»");
                }
            },
            {
                text: "⚖️ [Суддя] «Я виконую офіційне доручення суду Грейфорда щодо картографа. Зареєструйте вихід.»",
                visible: () => window.playerState.doctrines.judge >= 1,
                action: () => {
                    adjustReputation("admin", 30);
                    adjustReputation("order", 15);
                    finishQuest("Судове доручення", "Сержант витягується струнко: «Зрозуміло, пане Суддя. Ваша подорож внесена до реєстру.»");
                }
            }
        ]
    },
    ending_episode1: {

        audioTrack: "assets/audio/ep1_city_music.mp3",

        audioAtmosphere: "assets/audio/ep1_city_ambient.mp3",

        title: "Епізод 1 Завершено: Адресат відсутній",
        text: "",
        isChapterEnding: true,
        choices: [
            {
                text: "Вирушити до Сонк-Феррі",
                nextSceneId: "hazemoor-01"
            }
        ]
    },

    "hazemoor-01": {

        audioTrack: "assets/audio/swamp_music.mp3",

        audioAtmosphere: "assets/audio/swamp_wind_rain.mp3",

        title: "Сонк-Феррі",
        text: `Ви прибули до Сонк-Феррі — невеликого поселення поромників на краю болота. Пахне стоячою водою та гнилим деревом.`,
        choices: [
            {
                text: "Відправитись до Мірефолду",
                nextSceneId: "hazemoor-01"
            },
            {
                text: "Піти до Ліхтарного Дому Святої Вей",
                nextSceneId: "hazemoor-01"
            },
            {
                text: "Вирушити до Тихого Шелесту (Шлях болота)",
                nextSceneId: "hazemoor-01"
            },
            {
                text: "Повернутися до воріт Грейфорда",
                nextSceneId: "gates"
            }
        ]
    },
    ep1_mirefold: {

        audioTrack: "assets/audio/swamp_music.mp3",

        audioAtmosphere: "assets/audio/swamp_wind_rain.mp3",

        title: "Мірефолд",
        text: `Ви увійшли до Мірефолду, поселення, що потопає в болотяному тумані. Тутешні жителі з підозрою дивляться на Вартового.`,
        choices: [
            {
                text: "Вирушити до Тихого Шелесту",
                nextSceneId: "hazemoor-01"
            },
            {
                text: "Повернутися до Сонк-Феррі",
                nextSceneId: "hazemoor-01"
            }
        ]
    },
    ep1_lantern_house: {

        audioTrack: "assets/audio/swamp_music.mp3",

        audioAtmosphere: "assets/audio/swamp_wind_rain.mp3",

        title: "Ліхтарний Дім Святої Вей",
        text: `Перед вами височіє Ліхтарний Дім. Хранителі Святої Вей мовчки запалюють вогні, намагаючись розігнати темряву Порожнього сезону.`,
        choices: [
            {
                text: "Вирушити до Тихого Шелесту",
                nextSceneId: "hazemoor-01"
            },
            {
                text: "Повернутися до Сонк-Феррі",
                nextSceneId: "hazemoor-01"
            }
        ]
    },
    ep1_silent_rustle: {

        audioTrack: "assets/audio/swamp_music.mp3",

        audioAtmosphere: "assets/audio/swamp_wind_rain.mp3",

        title: "Тихий Шелест",
        text: `Поселення Тихий Шелест стоїть посеред глибокого болота. Саме сюди прямував Руфін. Попереду видніється шлях до Галявини Моура.`,
        choices: [
            {
                text: "Провести Ритуал занурення та увійти на Галявину Моура",
                nextSceneId: "ep1_mours_glade"
            }
            // Cannot easily return here based on the graph F -> ... but graph shows C & D & B -> E, E -> F. No backwards arrows for E and F
        ]
    },
    ep1_mours_glade: {

        audioTrack: "assets/audio/swamp_music.mp3",

        audioAtmosphere: "assets/audio/swamp_wind_rain.mp3",

        title: "Галявина Моура",
        text: `Галявина Моура. Тут енергія болота пульсує під ногами. Ви знайшли таємничий артефакт, захований у торфі - **Камінь Моура**.`,
        choices: [
            {
                text: "Дослідити Галявину та забрати Камінь Моура",
                visible: () => !window.playerState.inventory.includes("Камінь Моура"),
                action: () => {
                    addItem("Камінь Моура");
                    addToLog("Ви відчуваєте зв'язок з болотом.", "success");
                    goScene("ep1_mours_glade");
                }
            },
            {
                text: "Використати зв'язок та вирушити до Порту Валькорна",
                visible: () => window.playerState.inventory.includes("Камінь Моура"),
                nextSceneId: "ep2_valkorn_arrival"
            }
        ]
    },


    // --- ЕПІЗОД 2: ВАЛЬКОРН ---

    ep2_valkorn_arrival: {
        audioTrack: "assets/audio/ep2_city_music.mp3",
        audioAtmosphere: "assets/audio/ep2_city_ambient.mp3",
        title: "Прибуття у Валькорн",
        text: `Ви прибуваєте у Валькорн, залізне місто-столицю. На ринковій площі ви стикаєтеся з Блазнем Фіппом. Він завмирає і дивиться на вас крізь білий грим. Камінь Моура стає гарячим.
<br><br><em>«Дивись-но, мала Марр веде нове цуценя на повідку! Тільки нашийник у нього з холодного болотяного заліза, а в зубах — розбита печатка!»</em>
<br><br>Ілія шепоче: <em>«Звідки він знає моє ім'я? Він знає набагато більше ніж повинен.»</em>`,
        choices: [
            {
                text: "Відвідати Брес у Тіньовому Гетто",
                nextSceneId: "ep2_valkorn_bres"
            },
            {
                text: "Відвідати слідчого Стетсона у Дипломатичному Кварталі",
                nextSceneId: "ep2_valkorn_stetson"
            },
            {
                text: "Відвідати крамницю Тесси",
                nextSceneId: "ep2_valkorn_tessa"
            }
        ]
    },

    ep2_valkorn_bres: {
        audioTrack: "assets/audio/ep2_city_music.mp3",
        audioAtmosphere: "assets/audio/ep2_city_ambient.mp3",
        title: "Тіньове Гетто: Брес",
        text: `Ви зустрічаєте Брес, втікачку із Сонк-Феррі.
<br><br><em>«Болото не відмивається за один день.»</em> Вона згадує жінку, що платить за інформацію про болото, і про пакунок на складі в портовому кварталі, який контролює торгова гільдія.`,
        choices: [
            {
                text: "Піти до Торгової Гільдії (Правильна Ціна)",
                nextSceneId: "ep2_valkorn_damar"
            },
            {
                text: "Відвідати крамницю Тесси",
                nextSceneId: "ep2_valkorn_tessa"
            },
            {
                text: "Відвідати слідчого Стетсона",
                nextSceneId: "ep2_valkorn_stetson"
            }
        ]
    },

    ep2_valkorn_tessa: {
        audioTrack: "assets/audio/ep2_city_music.mp3",
        audioAtmosphere: "assets/audio/ep2_city_ambient.mp3",
        title: "Крамниця Тесси",
        text: `Ви заходите в крамницю Тесси. У кімнаті за завісою пахне старим папером.
<br><br><em>«Ти з Хейзмуру.»</em> Це не питання.
<br><br>Ви дізнаєтесь від неї іншу версію правди про Печатку та Орден Семи Кинджалів.`,
        choices: [
            {
                text: "Об'єднати знання з архівом Одріна і піти в підземелля",
                nextSceneId: "ep2_valkorn_dungeon"
            },
            {
                text: "Повернутися на вулицю",
                nextSceneId: "ep2_valkorn_arrival"
            }
        ]
    },

    ep2_valkorn_stetson: {
        audioTrack: "assets/audio/ep2_city_music.mp3",
        audioAtmosphere: "assets/audio/ep2_city_ambient.mp3",
        title: "Слідчий Стетсон",
        text: `Стетсон зустрічає вас: <em>«Ти дійшов. Я думав — можливо.»</em> Він шукає доказів проти Ордену для чистки й пропонує вам стати союзником.`,
        choices: [
            {
                text: "Шукати шлях до Лоена (Сьома Рада Ордену)",
                nextSceneId: "ep2_valkorn_loen"
            },
            {
                text: "Повернутися на вулицю",
                nextSceneId: "ep2_valkorn_arrival"
            }
        ]
    },

    ep2_valkorn_damar: {
        audioTrack: "assets/audio/ep2_city_music.mp3",
        audioAtmosphere: "assets/audio/ep2_city_ambient.mp3",
        title: "Торгова Гільдія: Дамар",
        text: `Дамар — непримітний торговець, який тримає пакунок з артефактом.
<br><br><em>«Я торговець. Я не питаю що це і навіщо. Я питаю скільки ти готовий заплатити.»</em>`,
        choices: [
            {
                text: "Забрати артефакт самому",
                action: () => {
                    addItem("Перша Печатка (Частина)");
                    goScene("ep2_valkorn_loen");
                }
            },
            {
                text: "Дозволити Тессі забрати артефакт",
                action: () => {
                    adjustReputation("order", -10);
                    goScene("ep2_valkorn_loen");
                }
            }
        ]
    },

    ep2_valkorn_dungeon: {
        audioTrack: "assets/audio/ep2_dungeon_music.mp3",
        audioAtmosphere: "assets/audio/ep2_dungeon_ambient.mp3",
        title: "Третя точка: Підземелля",
        text: `Об'єднавши версії правди Одріна та Тесси, ви знаходите вхід у підземелля Валькорна. На стінах написи: <em>«Хто торкнеться Печатки без Ліхтаря — втратить тінь.»</em>
<br><br>Ви знаходите Третю точку. Постамент порожній. Лежить свіжий клаптик тканини із символом Ордену. Хтось прийшов раніше.`,
        choices: [
            {
                text: "Йти до Лоена",
                nextSceneId: "ep2_valkorn_loen"
            }
        ]
    },

    ep2_valkorn_loen: {
        audioTrack: "assets/audio/ep2_city_music.mp3",
        audioAtmosphere: "assets/audio/ep2_city_ambient.mp3",
        title: "Людина що послала Руфіна",
        text: `Ви знаходите Лоена — члена Сьомої Ради Ордену. Він відповідає на три питання.
<br><br>1. <em>«Нам потрібен був артефакт. Руфін знав болото. Ми шукаємо спосіб стабілізувати Моур, а не знищити його.»</em>
<br><br>2. <em>«Ми хочемо підпорядкувати його силу. Хто контролює трясовину — контролює весь фронтир.»</em>
<br><br>3. <em>«Справжній лідер ближче до палацу. Його листи пахнуть болотяною м'ятою та вологим торфом, чорнило блищить золотим пилом.»</em>
<br><br>Ви поєднуєте факти (запах, бубонці, слова Стетсона) і розумієте: <strong>Хранитель Першої Печатки — це Блазень Фіпп!</strong>`,
        choices: [
            {
                text: "🤝 Співпрацювати з Орденом",
                action: () => {
                    adjustReputation("order", 30);
                    goScene("ep2_valkorn_black_archive");
                }
            },
            {
                text: "Нейтралітет",
                action: () => {
                    adjustReputation("order", 10);
                    goScene("ep2_valkorn_black_archive");
                }
            },
            {
                text: "⚔️ Протистояння",
                action: () => {
                    adjustReputation("order", -40);
                    adjustReputation("admin", 20);
                    goScene("ep2_valkorn_black_archive");
                }
            }
        ]
    },

    ep2_valkorn_black_archive: {
        audioTrack: "assets/audio/ep2_dungeon_music.mp3",
        audioAtmosphere: "assets/audio/ep2_dungeon_ambient.mp3",
        title: "Чорний Архів: Хранитель",
        text: `Ви проникаєте до Чорного Архіву під бібліотекою. Запах торфу і свіжої м'яти. Блазень Фіпп змиває грим.
<br><br>Він виймає <strong>Першу Печатку</strong> — циліндр із Білого срібла та болотяного заліза, що пульсує срібним світлом.
<br><br>Ілія впізнає його: <em>«Дядьку... Себастьяне?»</em>
<br><br>Себастьян Марр: <em>«Орден Семи Кинджалів — не вбивці. Це залізні ворота, які мають стримати воду. Я пішов у туман. Вирішуйте, що ми будемо робити далі.»</em>`,
        choices: [
            {
                text: "⚖️ [Шлях Судді] «Твій Орден сіє смерть. Віддай Печатку.» (Бій)",
                action: () => chooseValkornPath("A", "Ти обрав чесну смерть замість складного життя.", "ep3_deep_bog_start")
            },
            {
                text: "🤝 [Шлях Посередника] «Ми збережемо таємницю. Але Орден захищатиме Хейзмур.» (Угода)",
                action: () => chooseValkornPath("C", "Прагматизм — рідкісна риса. Ми домовились.", "ep3_deep_bog_start")
            },
            {
                text: "🕯️ [Шлях Ліхтаря] «Я стану тим, хто тримає удар. Дай мені Печатку.» (Ритуал Злиття)",
                action: () => chooseValkornPath("B", "Срібне і болотяне зелене змішуються. Ілія стає вашим Трагічним Моральним Якорем.", "ep3_deep_bog_start")
            }
        ]
    },


    // --- ЕПІЗОД 3: ГЛИБОКЕ БОЛОТО ---

    ep3_deep_bog_start: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Повернення в імлу",
        text: `Ви перетинаєте зруйнований річковий міст і ступаєте на хитку стежку Глибокого болота. Молочно-білий туман обволікає вас, намагаючись стерти відчуття напрямку.
<br><br>Очерет шепоче: <em>«Тут тепло... Срібло холодне, а вода пам'ятає твою колиску... Лягай...»</em>
<br><br>Ваша стійкість повільно спливає. Крізь зелену імлу проривається голос Ілії у вашій голові: <em>«Вартовий! Згадай своє ім'я. Дихай глибше. Болото бреше тобі.»</em>`,
        choices: [
            {
                text: "Вчепитися за голос Ілії",
                action: () => {
                    addToLog("Стійкість відновлюється. Туман розступається.", "success");
                    goScene("ep3_ruined_path");
                }
            }
        ]
    },

    ep3_ruined_path: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Понівечений шлях",
        text: `Стежка до Тихого Шелесту знищена аномальною активністю Моура. Гігантські сплетіння чорного коріння блокують прохід. З провалів піднімається отруйний газ.
<br><br>Ілія тремтить: <em>«Твоє серце б'ється так швидко, наче зараз розірветься. Зупинись, прошу тебе.»</em>`,
        choices: [
            {
                text: "Використати Плетіння (Bolo-Weaving)",
                action: () => {
                    addToLog("Вени темнішають, стійкість падає. Коріння розступається.", "system");
                    goScene("ep3_mia_encounter");
                }
            },
            {
                text: "Використати Першу Печатку",
                action: () => {
                    addToLog("Срібний купол захищає від газів, але залізо завдає болю болоту.", "system");
                    goScene("ep3_mia_encounter");
                }
            }
        ]
    },

    ep3_mia_encounter: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Зустріч із Міа",
        text: `З туману повільно виступає Міа. В її очах горить дике світло Моура.
<br><br><em>«Що вони зробили з тобою у своєму кам'яному місті? Ти хотів приборкати болото, але дозволив йому зжерти себе зсередини. І цей холод... Ти приніс їхнє срібло сюди. Навіщо?»</em>`,
        choices: [
            {
                text: "«Ця печатка — єдине, що захищає мій розум.»",
                nextSceneId: "ep3_silent_rustle_lileya"
            },
            {
                text: "«Я приніс її, щоб знайти Другу Печатку й збалансувати силу.»",
                nextSceneId: "ep3_silent_rustle_lileya"
            },
            {
                text: "«Я сам вирішую, яку силу використовувати. З дороги.»",
                nextSceneId: "ep3_silent_rustle_lileya"
            }
        ]
    },

    ep3_silent_rustle_lileya: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Тихий Шелест: Лілея",
        text: `У Тихому Шелесті єдина кам'яна споруда — вежа, де ховається Лілея, давня Ключниця боліт.
<br><br><em>«Мій рід будував стіни між людиною та болотом. Ти став ключем, який ламається у власному замку. Під Затопленою Обителлю лежить Друга Печатка з темної болотяної міді. Вона утримує Моур.»</em>
<br><br>Вам потрібно перетнути Шалену Річку.`,
        choices: [
            {
                text: "Йти до Шаленого Порому",
                nextSceneId: "ep3_mad_ferry"
            }
        ]
    },

    ep3_mad_ferry: {
        audioTrack: "assets/audio/ep3_swamp_music.mp3",
        audioAtmosphere: "assets/audio/ep3_swamp_ambient.mp3",
        title: "Шалена Переправа",
        text: `Важкий дерев'яний пліт на ланцюгах. Річка перетворилася на киплячий чорний дьоготь. Сліпі хижаки — Тварюки Твані — намагаються перегризти ланцюги.
<br><br>Один ланцюг лопається! Пором знесе на водоспад.`,
        choices: [
            {
                text: "Затиснути ланцюг голими руками (Bolo-Weaving)",
                action: () => {
                    addToLog("Страшні опіки від іржавого металу. Пором врятовано.", "system");
                    goScene("ep3_flooded_abode");
                }
            },
            {
                text: "Використати Першу Печатку як якір",
                action: () => {
                    adjustReputation("muri", -20);
                    addToLog("Вода замерзає. Пліт стабілізується, але річка випалена сріблом.", "system");
                    goScene("ep3_flooded_abode");
                }
            }
        ]
    },

    ep3_flooded_abode: {
        audioTrack: "assets/audio/ep3_dungeon_music.mp3",
        audioAtmosphere: "assets/audio/ep3_dungeon_ambient.mp3",
        title: "Затоплена Обитель",
        text: `Лілея розшифровує бронзові рунічні замки Ключників. Ви пробираєтесь по пояс у чорній твані всередині затопленого монастиря.
<br><br>У центрі крипти — Вівтар Стагнації, на якому лежить Друга Печатка з болотяної міді. З туману виходить Міа, її очі повністю чорні.
<br><br><em>«Якщо ти поєднаєш срібло з міддю — Хейзмур помре!»</em>`,
        choices: [
            {
                text: "⚙️ [Вердикт Заліза] Вставити срібну Печатку в мідний вівтар",
                action: () => {
                    window.playerState.valkorn_path = "A";
                    window.playerState.history.push({ step: "verdict", choice: "iron" });
                    addToLog("Болотяна магія випалена. Хейзмур вмирає.", "system");
                    goScene("ep4_start");
                }
            },
            {
                text: "🌿 [Вердикт Очерету] Кинути Першу Печатку в болотяну жижу",
                action: () => {
                    window.playerState.valkorn_path = "B";
                    window.playerState.history.push({ step: "verdict", choice: "reed" });
                    addToLog("Срібло розчиняється. Ви остаточно стаєте очеретяним монстром.", "system");
                    goScene("ep4_start");
                }
            },
            {
                text: "🕯️ [Пакт Ключника] Стати «живим замком» (Використати своє тіло)",
                action: () => {
                    window.playerState.valkorn_path = "C";
                    window.playerState.history.push({ step: "verdict", choice: "pact" });
                    addToLog("Ви пропускаєте срібло й мідь через себе. Болісний баланс збережено.", "success");
                    goScene("ep4_start");
                }
            }
        ]
    },


    // --- ЕПІЗОД 4: ДВА БЕРЕГИ ---

    // Початок 4-го епізоду: Повернення до Валькорна
    ep4_start: {
        audioTrack: "assets/audio/ep4_bridge_music.mp3",
        audioAtmosphere: "assets/audio/ep4_bridge_ambient.mp3",
        title: "Повернення до Валькорна",
        text: `Ви повернулися до Валькорна. Ваш шлях залежить від того, яку долю ви обрали раніше.`,
        choices: [
            {
                text: "Продовжити",
                action: () => {
                    if (window.playerState.valkorn_path === "A") {
                        goScene("ep4_valkorn_iron_triumph");
                    } else if (window.playerState.valkorn_path === "B") {
                        goScene("ep4_valkorn_shadow_in_channels");
                    } else {
                        goScene("ep4_valkorn_fragile_ambassador");
                    }
                }
            }
        ]
    },

    // Шлях А: Залізний Тріумф
    ep4_valkorn_iron_triumph: {
        audioTrack: "assets/audio/ep4_bridge_music.mp3",
        audioAtmosphere: "assets/audio/ep4_bridge_ambient.mp3",
        title: "Залізний Тріумф",
        text: `Ви повертаєтесь у Валькорн як переможець у складі делегації Ордену Семи Кинджалів. Висушене болото більше не перешкоджає вашому шляху. Під важким парадним плащем ви ховаєте свої омертвілі руки, що перетворилися на сіру деревину. Лілея йде поруч із кресленнями древніх замків Ключників.

<br><br><em>Голос Ілії (чітко й близько):</em> "Я чую кроки твого коня на мостовій... Ти повернувся, Вартовий. Твій розум чистий від болотяного шепоту. Я відчуваю твій холод, але це людський холод. Ми майже вдома. Себастьян чекає на тебе у Чорному Архіві."`,
        choices: [
            {
                text: "Вирушити до Чорного Архіву на аудієнцію до Себастьяна Марра",
                nextSceneId: "ep4_valkorn_marr_audience"
            }
        ]
    },

    ep4_valkorn_marr_audience: {
        audioTrack: "assets/audio/ep4_bridge_music.mp3",
        audioAtmosphere: "assets/audio/ep4_bridge_ambient.mp3",
        title: "Аудієнція у Себастьяна Марра",
        text: `Ви піднімаєтеся до Чорного Архіву. У центрі зали Себастьян Марр тріумфує:
<br><br>"Ти зробив те, що не вдалося жодному Вартовому до тебе. Хейзмур вмирає. Орден не забуде твою службу. Але твої руки... це ціна порядку."
<br><br>Він передає вам Арбалет Залізного Завіту та набір важких срібних пасток.
<br><br>На виході з Архіву вас перехоплює Тесса. Вона з презирством дивиться на ваші дерев'яні пальці:
<br><br>"Вони зробили з тебе залізний кілок, щоб забити його в землю болота. Міа та її люди зараз вмирають від спраги. Кого ти захищатимеш тепер?"`,
        choices: [
            {
                text: "Перейти до операції «Чиста земля»",
                nextSceneId: "ep4_valkorn_iron_burn"
            }
        ]
    },

    ep4_valkorn_iron_burn: {
        audioTrack: "assets/audio/ep4_bridge_music.mp3",
        audioAtmosphere: "assets/audio/ep4_bridge_ambient.mp3",
        title: "Залізне випалювання",
        text: `Себастьян Марр віддає наказ про початок фінальної операції «Чиста земля». Тесса піднімає бунт всередині Ордену, відмовляючись винищувати беззбройних. Вона закликає вас зупинити безумство Себастьяна.
<br><br>Разом із бунтівними лицарями Тесси ви штурмуєте Архів, використовуючи арбалет Залізного Завіту проти каральних загонів.`,
        choices: [
            {
                text: "Зіткнутися з Себастьяном Марром",
                nextSceneId: "ep4_valkorn_marr_death"
            }
        ]
    },

    ep4_valkorn_marr_death: {
        audioTrack: "assets/audio/ep4_bridge_music.mp3",
        audioAtmosphere: "assets/audio/ep4_bridge_ambient.mp3",
        title: "Смерть Себастьяна",
        text: `Ви й Тесса заганяєте Себастьяна в кут. Він намагається активувати залізний захисний прес, але той ламається, і важка залізна плита зривається з ланцюгів, розчавивши тирана.
<br><br><strong>Себастьян Марр гине.</strong> Тесса бере печатку Ордену та оголошує про реформи. Орден більше не буде катами. Руфін залишається живою, але порожньою тінню назавжди.`,
        choices: [
            {
                text: "Повернутися до висушеного Хейзмуру",
                nextSceneId: "ep4_hazemoor_ash_paths"
            }
        ]
    },

    ep4_hazemoor_ash_paths: {
        audioTrack: "assets/audio/ep4_bridge_music.mp3",
        audioAtmosphere: "assets/audio/ep4_bridge_ambient.mp3",
        title: "Попільні стежки Хейзмуру",
        text: `Болото стрімко помирає. Вода пішла глибоко під землю, залишаючи за собою потріскану глину та гнилу твань, яка швидко перетворюється на попіл. Здичавілі Очеретяні Блукачі крихкі й розсипаються в труху.
<br><br><em>Голос Ілії:</em> "Дивись... гниль відступає. Я відчуваю твій спокій, Вартовий. Твої руки більше не пульсують очеретом."`,
        choices: [
            {
                text: "Іти до сухого Вівтаря Стагнації",
                nextSceneId: "ep4_hazemoor_dry_altar"
            }
        ]
    },

    ep4_hazemoor_dry_altar: {
        audioTrack: "assets/audio/ep4_bridge_music.mp3",
        audioAtmosphere: "assets/audio/ep4_bridge_ambient.mp3",
        title: "Зіткнення біля сухого вівтаря",
        text: `Біля сухого Вівтаря Стагнації стоїть виснажена Міа. З її потрісканої шкіри сочиться сірий пил. Вона намагається вичавити з мідної Печатки останні краплі болотяної сили, щоб скерувати отруйний газ на Грейфорд.
<br><br>"Ти привів сюди залізо... Ти висушив наші ріки, Вартовий! Дивись на цю землю — вона мертва. Але я не дам тобі піти просто так. Ми згинемо разом!"`,
        choices: [
            {
                text: "Прибити Мію залізними штирями до вівтаря",
                action: () => {
                    adjustReputation("muri", -50);
                    goScene("ep4_hazemoor_dry_altar_nailed");
                }
            },
            {
                text: "Дозволити їй згаснути самостійно (Забрати Печатку)",
                action: () => {
                    adjustReputation("muri", -30);
                    goScene("ep4_hazemoor_dry_altar_fade");
                }
            }
        ]
    },

    ep4_hazemoor_dry_altar_nailed: {
        audioTrack: "assets/audio/ep4_bridge_music.mp3",
        audioAtmosphere: "assets/audio/ep4_bridge_ambient.mp3",
        title: "Вівтар Стагнації",
        text: `Ви фізично фіксуєте кінцівки Мії на сухому камені залізними штирями, назавжди позбавляючи її зв'язку з землею. Вона не вмирає, але затихає як безпорадна, оніміла мумія Хейзмуру.`,
        choices: [
            {
                text: "Повернутися у Валькорн для Великої Розв'язки",
                action: () => resolveFinalWay("A")
            }
        ]
    },

    ep4_hazemoor_dry_altar_fade: {
        audioTrack: "assets/audio/ep4_bridge_music.mp3",
        audioAtmosphere: "assets/audio/ep4_bridge_ambient.mp3",
        title: "Вівтар Стагнації",
        text: `Ви відмовляєтесь від насильства й просто забираєте мідну Печатку з її рук. Міа падає на сухі плити, її дихання стає ледь помітним, і тіло повністю дерев'яніє, перетворюючись на суху вербову гілку.`,
        choices: [
            {
                text: "Повернутися у Валькорн для Великої Розв'язки",
                action: () => resolveFinalWay("A")
            }
        ]
    },

    // Шлях Б: Тінь у Каналах
    ep4_valkorn_shadow_in_channels: {
        audioTrack: "assets/audio/ep4_bridge_music.mp3",
        audioAtmosphere: "assets/audio/ep4_bridge_ambient.mp3",
        title: "Чудовисько під бруківкою",
        text: `Ваше тіло остаточно перетворилося на очеретяного монстра з чорними очима. Ви потайки пробираєтеся до Валькорна крізь стічні колектори. Гнила болотна вода вже сочиться крізь тріщини підземних каналів столиці. Ваші вени пульсують чорним торф'яним соком.
<br><br><em>Голос Ілії (дуже далеко):</em> "Вартовий... де ти? Навколо лише... холодна вода й темрява. Я ледь чую биття твого серця..."`,
        choices: [
            {
                text: "Пробратися крізь колектори в пошуках Лілеї",
                nextSceneId: "ep4_valkorn_tessa_encounter_channels"
            }
        ]
    },

    ep4_valkorn_tessa_encounter_channels: {
        audioTrack: "assets/audio/ep4_bridge_music.mp3",
        audioAtmosphere: "assets/audio/ep4_bridge_ambient.mp3",
        title: "Зіткнення з Тессою",
        text: `На виході з колекторів під собором вас блокує варта на чолі з Тессою. Вона зупиняє солдатів і впізнає у вас Вартового.
<br><br>"Боги... Вартовий? Що це болото з тобою зробило? Себастьян Марр збирає королівську гвардію, щоб випалити Хейзмур дощенту. Якщо в тобі залишилося хоч щось людське... тікай. Лілея ховається в крипті старого собору, тільки її рід може зняти це прокляття."`,
        choices: [
            {
                text: "Використати Плетіння, щоб зникнути в тумані без бою",
                action: () => {
                    adjustReputation("order", 10);
                    goScene("ep4_valkorn_hunt_for_beast");
                }
            },
            {
                text: "Атакувати варту",
                action: () => {
                    adjustReputation("order", -50);
                    goScene("ep4_valkorn_hunt_for_beast");
                }
            }
        ]
    },

    ep4_valkorn_hunt_for_beast: {
        audioTrack: "assets/audio/ep4_bridge_music.mp3",
        audioAtmosphere: "assets/audio/ep4_bridge_ambient.mp3",
        title: "Штурм палацу з тіней",
        text: `Валькорн охоплений панікою — болотний туман просочився на вулиці. Себастьян Марр веде каральний загін з вогнеметами до підвалів.
<br><br>У тілі очеретяного монстра ви ведете полювання в темних коридорах собору, затягуючи гвардійців у твань.`,
        choices: [
            {
                text: "Наздогнати Себастьяна Марра в крипті",
                nextSceneId: "ep4_valkorn_marr_strangle"
            }
        ]
    },

    ep4_valkorn_marr_strangle: {
        audioTrack: "assets/audio/ep4_bridge_music.mp3",
        audioAtmosphere: "assets/audio/ep4_bridge_ambient.mp3",
        title: "Розрахунок у крипті",
        text: `Ви наздоганяєте Себастьяна в крипті. Він намагається захищатися срібним мечем, але ви обплутуєте його корінням верби й ламаєте броню.
<br><br><strong>Себастьян Марр гине від ядухи.</strong>
<br><br>Тесса з'являється й кидає меч на плити: "Досить, Вартовий! Ти вбив магістра. Військо не піде в болота. Дай нам піти." Вона оголошує реформацію Ордену.`,
        choices: [
            {
                text: "Повернутися до Хейзмуру з Лілеєю",
                nextSceneId: "ep4_hazemoor_monster_return"
            }
        ]
    },

    ep4_hazemoor_monster_return: {
        audioTrack: "assets/audio/ep4_bridge_music.mp3",
        audioAtmosphere: "assets/audio/ep4_bridge_ambient.mp3",
        title: "Повернення монстра",
        text: `Ви повертаєтесь до Хейзмуру разом із Лілеєю, яка тримає важкий мідний ключ Ключників для ритуалу повернення вашої людської подоби.
<br><br><em>Голос Ілії (дуже слабкий):</em> "Я... все ще тут... під цією чорною корою... Не дай очерету закрити мої очі..."`,
        choices: [
            {
                text: "Прямувати до Вівтаря Стагнації",
                nextSceneId: "ep4_hazemoor_mia_interferes"
            }
        ]
    },

    ep4_hazemoor_mia_interferes: {
        audioTrack: "assets/audio/ep4_bridge_music.mp3",
        audioAtmosphere: "assets/audio/ep4_bridge_ambient.mp3",
        title: "Трагічний антагоніст",
        text: `Біля вівтаря вас зустрічає Міа. Вона бачить у вас нового вождя болота й жахається, побачивши Лілею з ключем:
<br><br>"Ні! Болото обрало тебе! А вона хоче знову замкнути тебе в смертне тіло? Я не дозволю!"
<br><br>Міа нападає на Лілею з шаленою люттю. Ви повинні захистити Лілею, не вбиваючи Мію, що завдає вам неймовірного болю.`,
        choices: [
            {
                text: "Стримати Мію та дозволити Лілеї провести ритуал",
                nextSceneId: "ep4_hazemoor_restoration_ritual"
            }
        ]
    },

    ep4_hazemoor_restoration_ritual: {
        audioTrack: "assets/audio/ep4_bridge_music.mp3",
        audioAtmosphere: "assets/audio/ep4_bridge_ambient.mp3",
        title: "Ритуал Ключниці",
        text: `Коли Міа знерухомлена, Лілея силою вставляє мідний Ключ у рунічний паз на ваших дерев'яних грудях. Зі скреготом кісток дерев'яна кора тріскається й злазить шарами. Торф'яний сік замінюється червоною кров'ю. Очі знову стають людськими, хоча на передпліччях залишаються темні рубці.
<br><br>Міа дивиться на вас із болем і презирством: "Ти вибрав бути слабким... Біжи, людська тварюко." Вона розвертається й зникає в тумані.
<br><br><em>Голос Ілії (втомлено):</em> "Твоє серце... я знову чую його биття. Принаймні тепер ми зможемо йти далі..."`,
        choices: [
            {
                text: "Перейти до Великої Розв'язки",
                action: () => resolveFinalWay("B")
            }
        ]
    },

    // Шлях В: Крихкий Посол
    ep4_valkorn_fragile_ambassador: {
        audioTrack: "assets/audio/ep4_bridge_music.mp3",
        audioAtmosphere: "assets/audio/ep4_bridge_ambient.mp3",
        title: "Живий замок на бруківці",
        text: `Ви входите до Валькорна легально, як посланець і «живий замок» Хейзмуру. Ваша шкіра землиста, пальці чорні, але розум людський. Ви відчуваєте постійний біль у грудях від внутрішнього тертя срібла й міді.
<br><br><em>Голос Ілії (тихо):</em> "Я чую твій важкий подих. Біль тримає тебе в реальності. Ти став мостом між нами та ними."`,
        choices: [
            {
                text: "Перейти до Ратуші на дипломатичну шахівницю",
                nextSceneId: "ep4_valkorn_diplomacy"
            }
        ]
    },

    ep4_valkorn_diplomacy: {
        audioTrack: "assets/audio/ep4_bridge_music.mp3",
        audioAtmosphere: "assets/audio/ep4_bridge_ambient.mp3",
        title: "Дипломатична шахівниця",
        text: `У великій залі Ратуші Себастьян Марр, Тесса та Лілея ведуть перемовини.
<br><br>Себастьян каже: "Ти пропонуєш нейтралітет? Це крихка конструкція. Орден вимагає встановлення застав ліхтарів уздовж усієї лінії очерету. Якщо відмовишся — пакт буде анульовано."
<br><br>Лілея тихо шепоче, що Міа обіцяє не чіпати патрулі, якщо вони не перетинатимуть річку.`,
        choices: [
            {
                text: "Прийняти умови Себастьяна про ліхтарні застави",
                action: () => {
                    adjustReputation("order", 20);
                    adjustReputation("muri", -20);
                    goScene("ep4_valkorn_conspiracy");
                }
            },
            {
                text: "Заборонити ліхтарі, погрожуючи силою Моура",
                action: () => {
                    adjustReputation("muri", 20);
                    adjustReputation("order", -20);
                    goScene("ep4_valkorn_conspiracy");
                }
            }
        ]
    },

    ep4_valkorn_conspiracy: {
        audioTrack: "assets/audio/ep4_bridge_music.mp3",
        audioAtmosphere: "assets/audio/ep4_bridge_ambient.mp3",
        title: "Змова радикалів",
        text: `Радикальні лицарі Ордену намагаються влаштувати замах на вас просто під час аудієнції, щоб спровокувати війну.
<br><br>Разом із Тессою ви стримуєте змовників, балансуючи на межі Плетіння та використання срібних ліхтарів.
<br><br>Коли змовників подолано, блідий Себастьян Марр підписує Пакт про розмежування кордонів. Він виживає, але його влада обмежена. Тесса стає верховним маршалом.`,
        choices: [
            {
                text: "Повернутися до Хейзмуру для стабілізації Печаток",
                nextSceneId: "ep4_hazemoor_three_forces"
            }
        ]
    },

    ep4_hazemoor_three_forces: {
        audioTrack: "assets/audio/ep4_bridge_music.mp3",
        audioAtmosphere: "assets/audio/ep4_bridge_ambient.mp3",
        title: "Сходження трьох сил",
        text: `Дипломатичний нейтралітет зафіксовано, але земля Хейзмуру здригається — Печатки пручаються.
<br><br>Ви прибуваєте до вівтаря разом із Лілеєю та Мією. Ви повинні діяти спільно.
<br><br><em>Голос Ілії:</em> "Вода й Залізо. Тільки ти можеш змусити їх триматися разом. Це твій міст."`,
        choices: [
            {
                text: "Розпочати ритуал замикання Печаток",
                nextSceneId: "ep4_hazemoor_balance_ritual"
            }
        ]
    },

    ep4_hazemoor_balance_ritual: {
        audioTrack: "assets/audio/ep4_bridge_music.mp3",
        audioAtmosphere: "assets/audio/ep4_bridge_ambient.mp3",
        title: "Замикання Печаток",
        text: `Ви керуєте рунічними механізмами вівтаря, обертаючи важкі бронзові диски та затискаючи срібні важелі. Ви замикаєте обидва ключі обома руками. Срібло й мідь замикаються безпосередньо у вашій плоті. Ваш стан стабілізується назавжди.
<br><br>Міа відпускає вівтар: "Ти вибрав нести цей біль, щоб ми могли жити. Болото триматиметься у своїх межах."
<br><br>Лілея втомлено спирається на ваше плече: "Це найважчий шлях. Ти будеш цим мостом усе життя."`,
        choices: [
            {
                text: "Перейти до Великої Розв'язки",
                action: () => resolveFinalWay("C")
            }
        ]
    },

    death: {
        audioTrack: "assets/audio/death_music.mp3",
        audioAtmosphere: "assets/audio/death_ambient.mp3",
        title: "Трагічна загибель",
        text: `Ваша подорож обірвалася в болотах Хейзмуру. Холодний туман огортає ваше тіло, а прокляття Порожнього Сезону забирає залишки вашої душі...<br><br>Ніхто не дізнається про вашу місію, а лист Руфіна згниє під шаром торфу.`,
        isAbsoluteFinal: true,
        choices: [
            {
                text: "🎮 Почати подорож заново",
                action: () => resetGame()
            }
        ]
    },

    ending: {
        audioTrack: "assets/audio/ep5_winter_music.mp3",
        audioAtmosphere: "assets/audio/ep5_winter_ambient.mp3",
        title: "Кінець Гри",
        text: "",
        isAbsoluteFinal: true,
        choices: []
    },

    // --- ЕПІЗОД 5: ФІНАЛЬНІ СЦЕНИ ВІДХОДУ ---

    ep5_final_A: {
        audioTrack: "assets/audio/ep5_winter_music.mp3",
        audioAtmosphere: "assets/audio/ep5_winter_ambient.mp3",
        title: "Відхід: Суха Дорога",
        text: `Сірий, холодний ранок. Небо чисте від туману, але абсолютно безживне. Хейзмур випалене й висушене. Ви йдете по пильній сухій дорозі геть від Валькорна. Рухи ваших омертвілих пальців повільні й жорсткі в шкіряних рукавицях.
<br><br><em>Голос Ілії:</em> "Твій обов'язок згасає, як і тепло в твоїх руках. Попереду лише сухі й далекі краї... Йди."
<br><br>Ви озираєтесь на кам'яні вежі Валькорна, поправляєте рукавицю і зникаєте на горизонті.`,
        isAbsoluteFinal: true,
        choices: []
    },

    ep5_final_B: {
        audioTrack: "assets/audio/ep5_winter_music.mp3",
        audioAtmosphere: "assets/audio/ep5_winter_ambient.mp3",
        title: "Відхід: Стежка Очерету",
        text: `Вологі, густі сутінки. Все навколо вкрите сизим туманом. Ви йдете босоніж по вологому торфу. Ваша шкіра м'яка й тепла, але передпліччя назавжди вкриті темними рубцями кори верби. Ви залишаєте очеретяні хащі за спиною.
<br><br><em>Голос Ілії:</em> "Ми залишаємо Хейзмур очерету. А наша дорога лежить далі, туди, де холодно й чужо. Не озирайся назад. Твоя душа вільна. Іди вперед."
<br><br>Ви ступаєте крізь туман у невідомість, розчиняючись у сизій імлі.`,
        isAbsoluteFinal: true,
        choices: []
    },

    ep5_final_C: {
        audioTrack: "assets/audio/ep5_winter_music.mp3",
        audioAtmosphere: "assets/audio/ep5_winter_ambient.mp3",
        title: "Відхід: Міст Між Берегами",
        text: `Глибокі сутінки. Ви повільно йдете по кам'яному мосту через Шалену Річку. З одного боку світяться ліхтарі Валькорна, з іншого — темніє туман Хейзмуру. Ви зупиняєтесь посередині, стискаючи чорними пальцями два ключі від Печаток.
<br><br><em>Голос Ілії:</em> "Це твоє місце — міст між двома світами. Але міст не може належати жодному з берегів. Ми забираємо ключі із собою... Я з тобою... завжди."
<br><br>Ви розвертаєтесь і продовжуєте свій рух по мосту вперед — у невідомі землі, залишаючи обидва світи за своєю спиною.`,
        isAbsoluteFinal: true,
        choices: []
    }

,

    hazemoor_ep1: {
        title: "Шум на воді",
        text: `Перед світанком, перший день.<br>Герой і Міа йдуть по коліно у воді через вузьку протоку в очереті. Міа рухається безшумно. Герой — ні. Болото звучить навколо: хтось реагує на кроки, завмираючи, віддаляючись від протоки. Міа зупиняється і дивиться на героя. Без слів. Вона чекає, поки він зрозуміє, що треба змінити спосіб руху.`,
        choices: [
            {
                text: "Сповільнитись, намагатись ступати м'якше.",
                action: () => {
                    window.playerState.mia_trust = (window.playerState.mia_trust || 0) + 1;
                    addToLog("Міа помічає.", "success");
                    goScene("hazemoor_ep2");
                }
            },
            {
                text: "Зупинитись і подивитись, як вона ставить ноги.",
                action: () => {
                    window.playerState.mia_trust = (window.playerState.mia_trust || 0) + 1;
                    addToLog("Вчиться спостерігаючи.", "success");
                    goScene("hazemoor_ep2");
                }
            },
            {
                text: "Продовжити як ішов.",
                action: () => {
                    addToLog("Виживання — цього достатньо.", "success");
                    goScene("hazemoor_ep2");
                }
            },
            {
                text: "Тривожно озиратись, створюючи ще більше шуму.",
                action: () => {
                    window.playerState.mia_trust = (window.playerState.mia_trust || 0) - 1;
                    addToLog("Тривога — це шум.", "success");
                    goScene("hazemoor_ep2");
                }
            }
        ]
    },

    hazemoor_ep2: {
        title: "Нічліг і світло в темряві",
        text: `Вечір першого дня.<br>Міа зупиняється на нічліг — невеликий острівець, суха земля, старе дерево, місце, яке вона явно знає. Розкладає багаття так, щоб його не було видно здалеку: вологе коріння, дим утворює низький шар над водою.<br>Вночі — звуки болота. Щось велике рухається поряд у воді. Герой помічає в темряві десятки рухомих жовтих цяток.`,
        choices: [
            {
                text: "Допомогти мовчки. А потім запитати Міа, що це за світло.",
                action: () => {
                    window.playerState.mia_trust = (window.playerState.mia_trust || 0) + 1;
                    addToLog("Вона відповідає: «Спостерігачі. Вони дивляться — чи варто боятись.»", "success");
                    goScene("hazemoor_ep3");
                }
            },
            {
                text: "Почати говорити, а потім спостерігати, не рухаючись.",
                action: () => {
                    addToLog("Міа відповідає коротко або не відповідає.", "success");
                    goScene("hazemoor_ep3");
                }
            },
            {
                text: "Підняти зброю на світло.",
                action: () => {
                    window.playerState.mia_trust = (window.playerState.mia_trust || 0) - 1;
                    addToLog("Міа кладе руку на його зап'ясток: «Воно не цікавиться нами. Не змушуй його зацікавитись.»", "success");
                    goScene("hazemoor_ep3");
                }
            }
        ]
    },

    hazemoor_ep3: {
        title: "Глибока вода і слід Руфіна",
        text: `Ранок — середина другого дня.<br>Вранці вони виходять до широкої чорної води — стариця без видимого дна. Міа пірнає і зникає. Довго не з'являється.<br>Після переправи Міа знаходить слід. На болотяному березі — відбиток чобота і знак на корі дерева. Скорочення загальною мови, яке знає тільки той, хто знав Руфіна. Міа питає: «Ти знаєш, що це означає?»`,
        choices: [
            {
                text: "Чекати. Потім чесно відповісти про знак.",
                action: () => {
                    window.playerState.mia_trust = (window.playerState.mia_trust || 0) + 1;
                    addToLog("Міа виринає за кілька хвилин з іншого боку. Питає: «Він живий чи мертвий — тобі важливо?»", "success");
                    goScene("hazemoor_ep4");
                }
            },
            {
                text: "Почати пірнати, шукати її. Намагатись вгадати знак.",
                action: () => {
                    addToLog("Міа знає, коли людина бреше.", "success");
                    goScene("hazemoor_ep4");
                }
            },
            {
                text: "Кричати, гукати. Потім збрехати про знак.",
                action: () => {
                    window.playerState.mia_trust = (window.playerState.mia_trust || 0) - 1;
                    addToLog("Звук по воді йде далеко.", "success");
                    goScene("hazemoor_ep4");
                }
            }
        ]
    },

    hazemoor_ep4: {
        title: "Чужий слід і болотяна істота",
        text: `Середина — післяполудень другого дня.<br>Вони виходять на відкриту воду. Міа входить без вагань. Посередині Міа раптом зупиняється над нерухомою водою. Нахиляється. Торкає поверхню. «Тихо. Не рухайся.» Під водою — щось велике. Слідом за нею — щось торкається ноги героя знизу.`,
        choices: [
            {
                text: "Завмерти, не рухатись.",
                action: () => {
                    window.playerState.mia_trust = (window.playerState.mia_trust || 0) + 1;
                    addToLog("Істота обнюхує, торкається, іде далі. Міа: «Воно вирішило, що ти не їжа.»", "success");
                    goScene("hazemoor_ep5");
                }
            },
            {
                text: "Повільно рухатись далі.",
                action: () => {
                    addToLog("Ви повільно відступаєте.", "success");
                    goScene("hazemoor_ep5");
                }
            },
            {
                text: "Різко смикнутись або хапати зброю.",
                action: () => {
                    window.playerState.mia_trust = (window.playerState.mia_trust || 0) - 1;
                    addToLog("Бій у воді, важкий. Міа закривається.", "success");
                    goScene("hazemoor_ep5");
                }
            }
        ]
    },

    hazemoor_ep5: {
        title: "Нічна варта ім'я вночі",
        text: `Ніч другого дня.<br>Другий нічліг. Міа сідає і дивиться на воду — довго, без руху. Вона втомилась.`,
        choices: [
            {
                text: "Взяти варту без слів. Запитати чесно про ім'я Моур.",
                action: () => {
                    window.playerState.mia_trust = (window.playerState.mia_trust || 0) + 1;
                    addToLog("Міа зупиняється, дивиться, відповідає коротко: «Не питай про це. Ще не час.»", "success");
                    goScene("hazemoor_ep6");
                }
            },
            {
                text: "Запитати, чи все гаразд. Мовчати.",
                action: () => {
                    addToLog("Міа: «Все.»", "success");
                    goScene("hazemoor_ep6");
                }
            },
            {
                text: "Лягти спати самому. Наполягати на відповіді вранці.",
                action: () => {
                    window.playerState.mia_trust = (window.playerState.mia_trust || 0) - 1;
                    addToLog("Неправильний час.", "success");
                    goScene("hazemoor_ep6");
                }
            }
        ]
    },

    hazemoor_ep6: {
        title: "Заборонене місце",
        text: `Третій день.<br>Міа зупиняється перед широкою галявиною — відкрита вода, туман, у центрі щось темніє під поверхнею. Вона не йде туди. Обходить по краю, далеко.`,
        choices: [
            {
                text: "Обійти без запитань.",
                action: () => {
                    window.playerState.mia_trust = (window.playerState.mia_trust || 0) + 1;
                    addToLog("Міа сповільнює темп — вона більше не на крок попереду, тепер поряд.", "success");
                    goScene("hazemoor_ep7");
                }
            },
            {
                text: "Запитати, чому обхід.",
                action: () => {
                    addToLog("Вона: «Там не ходять.»", "success");
                    goScene("hazemoor_ep7");
                }
            },
            {
                text: "Піти напряму.",
                action: () => {
                    window.playerState.mia_trust = (window.playerState.mia_trust || 0) - 1;
                    addToLog("Міа не зупиняє, але довго не говорить після.", "success");
                    goScene("hazemoor_ep7");
                }
            }
        ]
    },

    hazemoor_ep7: {
        title: "Останній перехід і фінальне питання",
        text: `Вечір третього дня.<br>До Тихого Шелесту — кілька годин. На вузькій стежці над трясовиною — гнилий настил. Міа провалюється. Герой витягує її.<br>Тихий Шелест видно. Міа зупиняється: «Я маю тебе запитати. Навіщо ти тут? Навіщо тобі Хейзмур?»`,
        choices: [
            {
                text: "Дати їй час. Чесно відповісти про свою мотивацію.",
                action: () => {
                    window.playerState.mia_trust = (window.playerState.mia_trust || 0) + 1;
                    addToLog("Міа дивиться кілька секунд: «Добре.»", "success");
                    if (window.playerState.mia_trust >= 5) {
                        goScene("hazemoor_result_good");
                    } else {
                        goScene("hazemoor_result_bad");
                    }
                }
            },
            {
                text: "Пожартувати або знецінити. Відповісти нещиро.",
                action: () => {
                    window.playerState.mia_trust = (window.playerState.mia_trust || 0) - 1;
                    addToLog("Міа: «Ти кажеш те, що хочеш, щоб я почула. Спробуй ще раз.»", "success");
                    if (window.playerState.mia_trust >= 5) {
                        goScene("hazemoor_result_good");
                    } else {
                        goScene("hazemoor_result_bad");
                    }
                }
            }
        ]
    },

    hazemoor_result_good: {
        title: "Шлях відкрито",
        text: `Міа веде героя в Тихий Шелест під її захистом. Мурі зустрічають без ворожості.`,
        choices: [
            {
                text: "Продовжити шлях",
                action: () => {
                    window.playerState.flags = window.playerState.flags || {};
                    window.playerState.flags.mia_with_hero = true;
                    goScene("tykhy-arrive");
                }
            }
        ]
    },

    hazemoor_result_bad: {
        title: "Запасний маршрут",
        text: `Міа зникає. Герой іде сам. Тінь зверху: літаючий монстр. Падіння у воду. Сітки Мурі — герой у Тихому Шелесті, але не як гість, а як знахідка.`,
        choices: [
            {
                text: "Вибратися з сіток",
                action: () => {
                    window.playerState.flags = window.playerState.flags || {};
                    window.playerState.flags.mia_with_hero = false;
                    goScene("tykhy-arrive");
                }
            }
        ]
    },

    tykhy_arrive: {
        title: "Тихий Шелест",
        text: `Тихий Шелест. Кілька ниток розслідування тягнуться звідси.`,
        choices: [
            {
                text: "Розпитати Варріка про Руфіна",
                action: () => goScene("tykhy_rufin")
            },
            {
                text: "Знайти Каена, матір Міа і дізнатись таємницю",
                action: () => goScene("tykhy_kaen")
            },
            {
                text: "Поговорити з Міа про її рішення",
                visible: () => window.playerState.flags.mia_with_hero === true,
                action: () => goScene("tykhy_mia")
            },
            {
                text: "Заробити довіру як чужинець",
                visible: () => window.playerState.flags.mia_with_hero === false,
                action: () => goScene("tykhy_status")
            },
            {
                text: "Вирушити до Галявини Моура",
                action: () => goScene("tykhy_exit")
            }
        ]
    },

    tykhy_rufin: {
        title: "Той, хто знав дорогу",
        text: `Варрік питає: «Навіщо тобі ця людина?»`,
        choices: [
            {
                text: "Правда.",
                action: () => goScene("tykhy_rufin_found")
            }
        ]
    },

    tykhy_rufin_found: {
        title: "Сліди Руфіна",
        text: `Руфін пішов до забороненої галявини. Варрік: «Він ніс щось що світилось. Не ліхтар.»`,
        choices: [
            {
                text: "Повернутися",
                action: () => goScene("tykhy_exit")
            }
        ]
    },

    tykhy_kaen: {
        title: "Що батьки не кажуть",
        text: `Каен знайшов Міа в болоті. Немовля, живе, без слідів як вона там опинилась.`,
        choices: [
            {
                text: "Повернутися",
                action: () => goScene("tykhy_exit")
            }
        ]
    },

    tykhy_mia: {
        title: "Друге рішення",
        text: `Міа приймає рішення йти з вами. «Там є щось що стосується мене більше ніж тебе.»`,
        choices: [
            {
                text: "Повернутися",
                action: () => goScene("tykhy_exit")
            }
        ]
    },

    tykhy_status: {
        title: "Чужинець у сітці",
        text: `Ви заробляєте довіру, допомагаючи поселенню. Міа повертається і бачить це.`,
        choices: [
            {
                text: "Повернутися",
                action: () => goScene("tykhy_exit")
            }
        ]
    },

    tykhy_exit: {
        title: "Кінець локації",
        text: `Всі нитки зібрані або відкинуті. Герой іде далі в Хейзмур. Туди де галявина і дух.`,
        choices: [
            {
                text: "Вийти до Галявини",
                action: () => goScene("hazemoor-02-galyna")
            }
        ]
    },

    glade_explore: {
        title: "Розвідка Галявини",
        text: `Галявина виглядає як звичайна болотяна заводь. Тиша. Дивне світло. Пам'ять Руфіна.`,
        choices: [
            {
                text: "Активно шукати зустріч. Підійти до води.",
                action: () => goScene("glade_enter")
            }
        ]
    },

    glade_enter: {
        title: "Вхід до Галявини",
        text: `Міа відкриває туман своєю присутністю. Вхід — знизу. Треба пірнути.`,
        choices: [
            {
                text: "Пірнути (якщо готові)",
                visible: () => (window.playerState.mia_trust || 0) >= 3,
                action: () => goScene("glade_mour")
            },
            {
                text: "Паніка. Виринаємо.",
                visible: () => (window.playerState.mia_trust || 0) < 3,
                action: () => goScene("hazemoor-02-galyna")
            }
        ]
    },

    glade_mour: {
        title: "Зустріч з Моуром",
        text: `Під водою — основа старого артефакту. З поверхні злітають мільйони комах, утворюючи голову Моура. Він зупиняється на Міа.`,
        choices: [
            {
                text: "Продовжити",
                action: () => goScene("glade_mia_truth")
            }
        ]
    },

    glade_mia_truth: {
        title: "Правда Міа",
        text: `Міа каже: «Я думала, що чую болото... але я чула його тому, що воно — я.» Моур показує видіння — фрагмент Прадавньої війни і символ Ордену Семи Кинджалів.`,
        choices: [
            {
                text: "Запитати про Орден",
                action: () => goScene("glade_mount")
            }
        ]
    },

    glade_mount: {
        title: "Болотяний Маунт",
        text: `З глибини піднімається щось велике і повільне. Болотяний маунт приймає героя.`,
        choices: [
            {
                text: "Покинути галявину",
                action: () => goScene("glade_result")
            }
        ]
    },

    glade_result: {
        title: "Повернення з Галявини",
        text: `Ви маєте знання про Моура і порожній камінь. Сліди Руфіна розкриті.`,
        choices: [
            {
                text: "Вирушити до Сонк-Феррі",
                action: () => goScene("holod-znuzu")
            }
        ]
    },

    sunkferry_arrive: {
        title: "Прибуття до Сонк-Феррі",
        text: `Сонк-Феррі. Затонуле річкове поселення. Черги за раціоном стають агресивними. Зник зерновий конвой.`,
        choices: [
            {
                text: "Розслідувати 'Голод знизу'",
                action: () => goScene("holod-znuzu")
            }
        ]
    },

    holod_investigate: {
        title: "Голод знизу",
        text: `Конвой зник біля Затонулої Сторожової Дороги. Частину зерна відвели чиновники, а контрабандисти допомогли.`,
        choices: [
            {
                text: "Публічно викрити корупцію (Public exposure)",
                action: () => goScene("holod_result_A")
            },
            {
                text: "Контрольоване придушення (Controlled suppression)",
                action: () => goScene("holod_result_B")
            },
            {
                text: "Місцева угода (Local deal)",
                action: () => {
                    adjustReputation("muri", 30);
                    adjustReputation("admin", -20);
                    goScene("holod_result_C");
                }
            },
            {
                text: "[Ліхтар] Ритуальне милосердя (Ritual mercy)",
                visible: () => (window.playerState.doctrines || {}).lantern >= 1,
                action: () => goScene("holod_result_D")
            }
        ]
    },

    holod_result_A: { title: "Результат: Викриття", text: "Викриття", choices: [{ text: "Далі", action: () => goScene("sil_u_knyzi") }] },
    holod_result_B: { title: "Результат: Придушення", text: "Придушення", choices: [{ text: "Далі", action: () => goScene("sil_u_knyzi") }] },
    holod_result_C: { title: "Результат: Місцева угода", text: "Місцева угода укладена.", choices: [{ text: "Далі", action: () => goScene("sil_u_knyzi") }] },
    holod_result_D: { title: "Результат: Милосердя", text: "Ритуальне милосердя", choices: [{ text: "Далі", action: () => goScene("sil_u_knyzi") }] },

    sil_u_knyzi: {
        title: "Сіль у книзі",
        text: `Таємна партія ліків розведена болотяною водою. Це наслідок місцевої угоди.`,
        choices: [
            {
                text: "Розібратися з поромниками",
                action: () => goScene("poromna_prysyaga")
            }
        ]
    },

    poromna_prysyaga: {
        title: "Поромна присяга",
        text: `Конфлікт між Тованом Рідом і Нерою Вейл за контроль над водними шляхами.`,
        choices: [
            {
                text: "Підтримати Тована Ріда",
                action: () => {
                    window.playerState.flags = window.playerState.flags || {};
                    window.playerState.flags.ferry = 'tovan';
                    adjustReputation("admin", 10);
                    goScene("poromna_result_tovan");
                }
            },
            {
                text: "Підтримати Неру Вейл",
                action: () => {
                    window.playerState.flags = window.playerState.flags || {};
                    window.playerState.flags.ferry = 'nera';
                    adjustReputation("muri", 15);
                    goScene("poromna_result_nera");
                }
            },
            {
                text: "[Посередник] Знайти третій шлях",
                visible: () => (window.playerState.doctrines || {}).mediator >= 1,
                action: () => goScene("poromna_result_third")
            }
        ]
    },

    poromna_result_tovan: { title: "Тован контролює пороми", text: "Рішення прийнято.", choices: [{ text: "Далі", action: () => goScene("popil_pid_kaplytseyu") }] },
    poromna_result_nera: { title: "Нера контролює пороми", text: "Рішення прийнято.", choices: [{ text: "Далі", action: () => goScene("popil_pid_kaplytseyu") }] },
    poromna_result_third: { title: "Перемир'я поромників", text: "Рішення прийнято.", choices: [{ text: "Далі", action: () => goScene("popil_pid_kaplytseyu") }] },

    popil_pid_kaplytseyu: {
        title: "Попіл під каплицею",
        text: `Брат Карос виявляє імітацію ритуалів на поховальному місці.`,
        choices: [
            {
                text: "Сховати правду",
                action: () => {
                    adjustReputation("keepers", -10);
                    goScene("popil_secret");
                }
            },
            {
                text: "Викрити імітацію",
                action: () => {
                    adjustReputation("keepers", 10);
                    adjustReputation("admin", -5);
                    goScene("popil_expose");
                }
            },
            {
                text: "[Ліхтар 2] Формалізувати ритуал",
                visible: () => (window.playerState.doctrines || {}).lantern >= 2,
                action: () => {
                    adjustReputation("keepers", 20);
                    goScene("popil_ritual");
                }
            }
        ]
    },

    popil_secret: { title: "Правда прихована", text: "Секрет", choices: [{ text: "Далі", action: () => goScene("nizh_kvoty") }] },
    popil_expose: { title: "Правда відкрита", text: "Викриття", choices: [{ text: "Далі", action: () => goScene("nizh_kvoty") }] },
    popil_ritual: { title: "Ритуал проведено", text: "Ритуал", choices: [{ text: "Далі", action: () => goScene("nizh_kvoty") }] },

    nizh_kvoty: {
        title: "Ніж квоти",
        text: `Маршал-Реєстратор Серіт Келм вимагає відновити дисципліну.`,
        choices: [
            {
                text: "Підписати звіт (Sign report)",
                action: () => goScene("nizh_result_A")
            },
            {
                text: "Частковий супротив (Partial resist)",
                action: () => goScene("nizh_result_B")
            },
            {
                text: "[Суддя 2] Повний розрахунок (Full reckoning)",
                visible: () => (window.playerState.doctrines || {}).judge >= 2,
                action: () => {
                    adjustReputation("wanderers", 20);
                    adjustReputation("admin", -30);
                    goScene("nizh_result_C");
                }
            },
            {
                text: "[Посередник 2] Спільний контроль (Co-control)",
                visible: () => (window.playerState.doctrines || {}).mediator >= 2,
                action: () => goScene("nizh_result_D")
            }
        ]
    },

    nizh_result_A: { title: "Звіт", text: "Звіт підписано.", choices: [{ text: "Вирушити до Валькорна", action: () => goScene("valkorn-01") }] },
    nizh_result_B: { title: "Супротив", text: "Супротив.", choices: [{ text: "Вирушити до Валькорна", action: () => goScene("valkorn-01") }] },
    nizh_result_C: { title: "Повний розрахунок", text: "Розрахунок.", choices: [{ text: "Вирушити до Валькорна", action: () => goScene("valkorn-01") }] },
    nizh_result_D: { title: "Спільний контроль", text: "Контроль.", choices: [{ text: "Вирушити до Валькорна", action: () => goScene("valkorn-01") }] },

    valkorn_arrive: {
        title: "Людина з болота",
        text: `Ви прибуваєте до Валькорна з Ілією Марр. Місто велике і байдуже.`,
        choices: [
            {
                text: "Зустрітися зі Стетсоном",
                action: () => goScene("valkorn_01_stetsion")
            },
            {
                text: "Шукати шлях через Гетто",
                action: () => goScene("valkorn_01_ghetto")
            },
            {
                text: "Піти до крамниці Тесси",
                action: () => goScene("valkorn_01_tessa")
            }
        ]
    },

    valkorn_01_stetsion: { title: "Слідчий Стетсон", text: "Зустріч зі слідчим.", choices: [{ text: "До Архіву", action: () => goScene("valkorn_02_odrin") }] },
    valkorn_01_ghetto: { title: "Тіньове Гетто Валькорна", text: "Пошуки в Гетто.", choices: [{ text: "До Тесси", action: () => goScene("valkorn_01_tessa") }] },
    valkorn_01_tessa: { title: "Зустріч з Тессою", text: "Тесса слухає вас.", choices: [{ text: "Дві версії правди", action: () => goScene("valkorn_02_tessa") }] },

    valkorn_02_odrin: { title: "Палацовий архів і Одрін", text: "Одрін та карта підземель.", choices: [{ text: "У підземелля", action: () => goScene("valkorn_02_underground") }] },
    valkorn_02_tessa: { title: "Крамниця Тесси", text: "Тесса дає ключ.", choices: [{ text: "У підземелля", action: () => goScene("valkorn_02_underground") }] },

    valkorn_02_underground: {
        title: "Підземелля Валькорна",
        text: `Секретні шляхи під містом. Ви знаходите докази, що хтось уже був тут.`,
        choices: [
            {
                text: "Вистежити Дамара",
                action: () => goScene("valkorn_03_damar")
            }
        ]
    },

    valkorn_03_damar: {
        title: "Правильна ціна",
        text: `Зустріч з Дамаром. Торгова гільдія і контрабанда артефакту.`,
        choices: [
            {
                text: "Отримати інформацію",
                action: () => goScene("valkorn_03_result")
            }
        ]
    },

    valkorn_03_result: {
        title: "Сліди ведуть вище",
        text: `Тепер ви знаєте: це Орден Семи Кинджалів.`,
        choices: [
            {
                text: "Зустріч з Лоеном",
                action: () => goScene("valkorn_04_loen")
            }
        ]
    },

    valkorn_04_loen: {
        title: "Людина, що послала Руфіна",
        text: `Лоен, член Сьомої Ради Ордену. Він чекає на ваші відповіді.`,
        choices: [
            {
                text: "Погодитись на умови Ордену (Шлях А)",
                action: () => {
                    window.playerState.flags = window.playerState.flags || {};
                    window.playerState.flags.clue_loen = true;
                    window.playerState.flags.loen_align = 'A';
                    adjustReputation("order", 30);
                    goScene("loen_align_A");
                }
            },
            {
                text: "Часткова співпраця (Шлях Б)",
                action: () => {
                    window.playerState.flags = window.playerState.flags || {};
                    window.playerState.flags.clue_loen = true;
                    window.playerState.flags.loen_align = 'B';
                    adjustReputation("order", 10);
                    goScene("loen_align_B");
                }
            },
            {
                text: "[Суддя] Відкинути Орден (Шлях В)",
                visible: () => (window.playerState.doctrines || {}).judge >= 1,
                action: () => {
                    window.playerState.flags = window.playerState.flags || {};
                    window.playerState.flags.clue_loen = true;
                    window.playerState.flags.loen_align = 'C';
                    adjustReputation("order", -40);
                    goScene("loen_align_C");
                }
            }
        ]
    },

    loen_align_A: { title: "Союз з Орденом", text: "Ви обрали Орден.", choices: [{ text: "Розслідування завершено", action: () => goScene("valkorn_04_deduction") }] },
    loen_align_B: { title: "Нейтралітет з Орденом", text: "Обережний підхід.", choices: [{ text: "Розслідування завершено", action: () => goScene("valkorn_04_deduction") }] },
    loen_align_C: { title: "Ворог Ордену", text: "Відкритий конфлікт.", choices: [{ text: "Розслідування завершено", action: () => goScene("valkorn_04_deduction") }] },

    valkorn_04_deduction: {
        title: "Розкриття Хранителя",
        text: `Всі докази зібрані. Хранитель Першої Печатки — це Блазень Фіпп.`,
        choices: [
            {
                text: "Проникнення в Чорний Архів",
                action: () => goScene("valkorn_05_infiltrate")
            }
        ]
    },

    valkorn_05_infiltrate: {
        title: "Проникнення до Палацу",
        text: `Шлях у Чорний Архів під королівською бібліотекою.`,
        choices: [
            {
                text: "[Суддя 2] Шлях Судді / Закон Корони",
                visible: () => (window.playerState.doctrines || {}).judge >= 2,
                action: () => goScene("valkorn_05_archive")
            },
            {
                text: "Шлях Посередника / Тіньовий договір",
                action: () => goScene("valkorn_05_archive")
            },
            {
                text: "[Слідопит 3] Болотяні колектори",
                visible: () => (window.playerState.doctrines || {}).pathfinder >= 3,
                action: () => goScene("valkorn_05_archive")
            }
        ]
    },

    valkorn_05_archive: {
        title: "Чорний Архів",
        text: `Ви увійшли до Чорного Архіву.`,
        choices: [
            {
                text: "Зустріч з Фіппом (Себастьяном Марром)",
                action: () => goScene("valkorn_05_iliya")
            }
        ]
    },

    valkorn_05_iliya: {
        title: "Хранитель Першої Печатки",
        text: `Себастьян Марр і Ілія. Час вирішити його долю.`,
        choices: [
            {
                text: "⚖️ [Шлях Судді] Арешт або страта",
                action: () => {
                    adjustReputation("order", -100);
                    adjustReputation("admin", 40);
                    adjustReputation("wanderers", 30);
                    window.playerState.flags = window.playerState.flags || {};
                    window.playerState.flags.valkorn5_choice = 'judge';
                    window.playerState.flags.sebastian_fate = 'dead';
                    goScene("valkorn_epilogue");
                }
            },
            {
                text: "🤝 [Шлях Посередника] Тіньовий Пакт",
                action: () => {
                    adjustReputation("order", 40);
                    window.playerState.flags = window.playerState.flags || {};
                    window.playerState.flags.valkorn5_choice = 'mediator';
                    window.playerState.flags.sebastian_fate = 'deal';
                    goScene("valkorn_epilogue");
                }
            },
            {
                text: "🕯️ [Шлях Ліхтаря] Ритуал переходу",
                action: () => {
                    adjustReputation("wanderers", 50);
                    window.playerState.flags = window.playerState.flags || {};
                    window.playerState.flags.valkorn5_choice = 'lantern';
                    window.playerState.flags.sebastian_fate = 'merge';
                    window.playerState.flags.iliya_anchor = true;
                    window.playerState.bolo_weaving = true;
                    goScene("valkorn_epilogue");
                }
            }
        ]
    },

    valkorn_epilogue: {
        title: "Втеча з Валькорна",
        text: `Сигналізація спрацювала. Ви тікаєте до боліт.`,
        choices: [
            {
                text: "Повернутися у Хейзмур",
                action: () => goScene("deep-bog-01")
            }
        ]
    },


    ep3_fog: {
        title: "Голос із туману",
        text: `Ви заглиблюєтесь у Хейзмур. Туман густішає, і ви помічаєте знайому постать. Міа чекає на вас.`,
        choices: [
            {
                text: "Далі",
                action: () => {
                    window.playerState.sanity = 100;
                    goScene("ep3_mia_conflict");
                }
            }
        ]
    },
    ep3_mia_conflict: { title: "Епізод 3", text: "Туман", choices: [{ text: "Далі", action: () => goScene("ep3_tykhy_tower") }] },
    ep3_tykhy_tower: { title: "Епізод 3", text: "Туман", choices: [{ text: "Далі", action: () => goScene("ep3_kaen_deal") }] },
    ep3_kaen_deal: { title: "Епізод 3", text: "Туман", choices: [{ text: "Далі", action: () => goScene("ep3_ferry_crossing") }] },
    ep3_ferry_crossing: {
        title: "Шалений Переправа",
        text: `Ви наближаєтесь до Шаленого порому. Річка вирує. Вам потрібно обрати шлях переправи.`,
        choices: [
            {
                text: "Сила Плетіння (Bolo-Weaving)",
                action: () => {
                    window.playerState.sanity = (window.playerState.sanity || 100) - 20;
                    goScene("ep3_ferry_choice_A");
                }
            },
            {
                text: "Перша Печатка",
                action: () => {
                    adjustReputation("muri", -30);
                    goScene("ep3_ferry_choice_B");
                }
            }
        ]
    },
    ep3_ferry_choice_A: { title: "Епізод 3", text: "Вузькі очерети", choices: [{ text: "Далі", action: () => goScene("ep3_narrow_reeds") }] },
    ep3_ferry_choice_B: { title: "Епізод 3", text: "Сухий Горб", choices: [{ text: "Далі", action: () => goScene("ep3_dry_mound") }] },

    ep3_narrow_reeds: {
        title: "Вузькі очерети",
        text: `Шлях Плетіння забрав сили, але ви подолали річку.`,
        choices: [
            { text: "Далі", action: () => goScene("ep3_obitel_enter") }
        ]
    },

    ep3_dry_mound: {
        title: "Сухий Горб",
        text: `Сили Печатки пересушили землю, шлях вільний. Мурі незадоволені.`,
        choices: [
            { text: "Далі", action: () => goScene("ep3_obitel_enter") }
        ]
    },

    ep3_obitel_enter: { title: "Обитель", text: "Затоплена Обитель", choices: [{ text: "Далі", action: () => goScene("ep3_obitel_locks") }] },
    ep3_obitel_locks: { title: "Обитель", text: "Обитель", choices: [{ text: "Далі", action: () => goScene("ep3_altar") }] },
    ep3_altar: {
        title: "Жертовник Другої Печатки",
        text: `Ви стоїте перед Вівтарем Стагнації. Це фінальний вибір Епізоду 3. Ваш Вердикт визначить долю Хейзмуру та Валькорна.`,
        choices: [
            {
                text: "Вердикт Заліза",
                action: () => {
                    window.playerState.flags = window.playerState.flags || {};
                    window.playerState.flags.verdict = 'iron';
                    goScene("ep3_verdict_iron");
                }
            },
            {
                text: "Вердикт Очерету",
                action: () => {
                    window.playerState.flags = window.playerState.flags || {};
                    window.playerState.flags.verdict = 'reed';
                    goScene("ep3_verdict_reed");
                }
            },
            {
                text: "Вердикт Пакту",
                action: () => {
                    window.playerState.flags = window.playerState.flags || {};
                    window.playerState.flags.verdict = 'pact';
                    goScene("ep3_verdict_pact");
                }
            }
        ]
    },
    ep3_verdict_iron: { title: "Залізо", text: "Ви обрали Шлях Заліза.", choices: [{ text: "Епізод 4", action: () => goScene("ep4_valkorn_iron") }] },
    ep3_verdict_reed: { title: "Очерет", text: "Ви обрали Шлях Очерету.", choices: [{ text: "Епізод 4", action: () => goScene("ep4_valkorn_reed") }] },
    ep3_verdict_pact: { title: "Пакт", text: "Ви обрали Шлях Пакту.", choices: [{ text: "Епізод 4", action: () => goScene("ep4_valkorn_pact") }] },

    ep4_valkorn_iron: { title: "Валькорн (Шлях Заліза)", text: "«Тріумф Адміністрації!» — вигукують глашатаї. Ви приносите порядок у Валькорн.", choices: [{ text: "Далі", action: () => goScene("ep4_climax_iron") }] },
    ep4_valkorn_reed: { title: "Валькорн (Шлях Очерету)", text: "Ви проникаєте у Валькорн тінями, немов привид із боліт.", choices: [{ text: "Далі", action: () => goScene("ep4_climax_reed") }] },
    ep4_valkorn_pact: { title: "Валькорн (Шлях Пакту)", text: "«Дипломатичний візит...» — шепочуться вельможі. Ви входите як посередник.", choices: [{ text: "Далі", action: () => goScene("ep4_climax_pact") }] },

    ep4_climax_iron: { title: "Кульмінація Заліза", text: "Себастьян гине під пресом. Тесса починає свої жорсткі реформи. Залізо встановлює нові правила.", choices: [{ text: "Далі", action: () => goScene("ep4_mire_iron") }] },
    ep4_climax_reed: { title: "Кульмінація Очерету", text: "Тихе усунення Себастьяна. Лілея повертає свою людську форму. Болото відвойовує своє.", choices: [{ text: "Далі", action: () => goScene("ep4_mire_reed") }] },
    ep4_climax_pact: { title: "Кульмінація Пакту", text: "Себастьян живий. Підписання тристоронньої угоди. Хитка рівновага встановлена.", choices: [{ text: "Далі", action: () => goScene("ep4_mire_pact") }] },

    ep4_mire_iron: { title: "Хейзмур (Шлях Заліза)", text: "«Вони випалюють Серце Моура...» — Міа німіє, втрачаючи свій зв'язок з болотом.", choices: [{ text: "Далі", action: () => goScene("ep4_resolution_iron") }] },
    ep4_mire_reed: { title: "Хейзмур (Шлях Очерету)", text: "«Болото дихає вільно,» — шепоче Лілея. Хейзмур відновлює свої сили.", choices: [{ text: "Далі", action: () => goScene("ep4_resolution_reed") }] },
    ep4_mire_pact: { title: "Хейзмур (Шлях Пакту)", text: "«Ритуал рівноваги завершено.» — констатує Тесса. Дві сили пов'язані.", choices: [{ text: "Далі", action: () => goScene("ep4_resolution_pact") }] },

    ep4_resolution_iron: { title: "Розв'язка Заліза", text: "Ваша місія виконана. Шлях відходу: суха дорога в рукавицях.", choices: [{ text: "Завершити", action: () => goScene("ep5_final_A") }] },
    ep4_resolution_reed: { title: "Розв'язка Очерету", text: "Ви стали частиною легенди. Шлях відходу: босоніж по болоту.", choices: [{ text: "Завершити", action: () => goScene("ep5_final_B") }] },
    ep4_resolution_pact: { title: "Розв'язка Пакту", text: "Ви — живий міст між світами. Шлях відходу: зупинка на мосту.", choices: [{ text: "Завершити", action: () => goScene("ep5_final_C") }] }

,
    "hazemoor-01": {
        title: "Урок 1: Шум на воді",
        text: "Вузька протока. Вартовий і Міа йдуть по коліно у воді. Міа — безшумно. Він — ні. Болото реагує.",
        choices: [
            { text: "Сповільнитись, дивитись як вона ставить ноги", action: () => { window.playerState.mia_trust = (window.playerState.mia_trust || 0) + 1; goScene("hazemoor-02"); } },
            { text: "Продовжити як ішов", action: () => { goScene("hazemoor-02"); } },
            { text: "Тривожно озиратись", action: () => { window.playerState.mia_trust = (window.playerState.mia_trust || 0) - 1; goScene("hazemoor-02"); } }
        ]
    },
    "hazemoor-02": {
        title: "Урок 2: Нічна іскра",
        text: "Вночі — десятки жовтих цяток у темряві. Міа спокійна.",
        choices: [
            { text: "Запитати Міа що це", action: () => { window.playerState.mia_trust = (window.playerState.mia_trust || 0) + 1; addToLog('Міа: «Спостерігачі. Вони дивляться — чи варто боятись.»'); goScene("hazemoor-03"); } },
            { text: "Спостерігати нерухомо", action: () => { goScene("hazemoor-03"); } },
            { text: "Підняти зброю", action: () => { window.playerState.mia_trust = (window.playerState.mia_trust || 0) - 1; addToLog('Міа: «Не змушуй його зацікавитись.»'); goScene("hazemoor-03"); } }
        ]
    },
    "hazemoor-03": {
        title: "Урок 3: Глибока вода",
        text: "Міа пірнає, довго не з'являється. Знаходять слід Руфіна. Міа: «Твій картограф знав дорогу. Або знав, або біг.»",
        choices: [
            { text: "Чекати", action: () => { window.playerState.mia_trust = (window.playerState.mia_trust || 0) + 1; goScene("hazemoor-04"); } },
            { text: "Пірнати шукати", action: () => { goScene("hazemoor-04"); } },
            { text: "Кричати, гукати", action: () => { window.playerState.mia_trust = (window.playerState.mia_trust || 0) - 1; goScene("hazemoor-04"); } }
        ]
    },
    "hazemoor-04": {
        title: "Урок 4: Чужий слід",
        text: "Широкий розлив. Міа зупиняється: «Тихо. Не рухайся.» Під водою — щось велике. Щось торкається ноги.",
        choices: [
            { text: "Стояти нерухомо", action: () => { window.playerState.mia_trust = (window.playerState.mia_trust || 0) + 1; addToLog('Міа: «Воно вирішило, що ти не їжа.»'); goScene("hazemoor-05"); } },
            { text: "Повільно відступати", action: () => { goScene("hazemoor-05"); } },
            { text: "Різко смикнутись", action: () => { window.playerState.mia_trust = (window.playerState.mia_trust || 0) - 1; goScene("hazemoor-05"); } }
        ]
    },
    "hazemoor-05": {
        title: "Урок 5: Варта і ім'я",
        text: "Міа сидить і дивиться на воду. Вночі говорить уві сні. Повторюється слово: Моур.",
        choices: [
            { text: "Взяти варту без слів", action: () => { window.playerState.mia_trust = (window.playerState.mia_trust || 0) + 1; goScene("hazemoor-06"); } },
            { text: "Запитати чесно вранці про Моур", action: () => { window.playerState.mia_trust = (window.playerState.mia_trust || 0) + 1; addToLog('Міа: «Не питай про це. Ще не час.»'); goScene("hazemoor-06"); } },
            { text: "Наполягати", action: () => { window.playerState.mia_trust = (window.playerState.mia_trust || 0) - 1; goScene("hazemoor-06"); } }
        ]
    },
    "hazemoor-06": {
        title: "Урок 6: Заборонене місце",
        text: "Широка галявина — Міа обходить по краю. Пояснює пізніше: «Там лежить Моур. Це домовленість старіша за мого батька.»",
        choices: [
            { text: "Обійти без запитань", action: () => { window.playerState.mia_trust = (window.playerState.mia_trust || 0) + 1; goScene("hazemoor-07"); } },
            { text: "Запитати чому", action: () => { goScene("hazemoor-07"); } },
            { text: "Піти напряму", action: () => { window.playerState.mia_trust = (window.playerState.mia_trust || 0) - 1; goScene("hazemoor-07"); } }
        ]
    },
    "hazemoor-07": {
        title: "Урок 7: Останній перехід",
        text: "Гнилий настил. Міа провалюється. Вартовий витягує. Перед Тихим Шелестом — створіння що не можна перемогти.",
        choices: [
            { text: "Дати їй час, мовчати", action: () => { window.playerState.mia_trust = (window.playerState.mia_trust || 0) + 1; if ((window.playerState.mia_trust || 0) >= 5) { window.playerState.flags = window.playerState.flags || {}; window.playerState.flags.mia_joined = true; goScene("hazemoor-result-good"); } else { goScene("hazemoor-result-bad"); } } },
            { text: "Перевірити", action: () => { if ((window.playerState.mia_trust || 0) >= 5) { window.playerState.flags = window.playerState.flags || {}; window.playerState.flags.mia_joined = true; goScene("hazemoor-result-good"); } else { goScene("hazemoor-result-bad"); } } },
            { text: "Пожартувати", action: () => { window.playerState.mia_trust = (window.playerState.mia_trust || 0) - 1; if ((window.playerState.mia_trust || 0) >= 5) { window.playerState.flags = window.playerState.flags || {}; window.playerState.flags.mia_joined = true; goScene("hazemoor-result-good"); } else { goScene("hazemoor-result-bad"); } } }
        ]
    },
    "hazemoor-result-good": {
        title: "Довіра здобута",
        text: "Міа запитує: «Навіщо ти тут? Не Руфін. Не лист. Ти.» Вартовий відповідає чесно. Міа: «Добре.» Іде вперед.",
        choices: [
            { text: "Відповісти чесно", action: () => { window.playerState.flags = window.playerState.flags || {}; window.playerState.flags.mia_joined = true; goScene("tykhy-arrive"); } }
        ]
    },
    "hazemoor-result-bad": {
        title: "Запасний маршрут",
        text: "Довіри недостатньо. Міа веде небезпечнішим маршрутом.",
        choices: [
            { text: "Іти далі", action: () => { goScene("tykhy-arrive"); } }
        ]
    },
    "tykhy-arrive": {
        title: "Тихий Шелест",
        text: "Ви прибуваєте до Тихого Шелесту. Поселення Мурі. Мінімум для виходу: нитка Руфіна і нитка Міа.",
        choices: [
            { text: "Знайти Руфіна", action: () => { goScene("tykhy-rufin"); } },
            { text: "Поговорити з Каеном", action: () => { goScene("tykhy-kaen"); } },
            { text: "Поговорити з Міа", visible: () => (window.playerState.flags || {}).mia_joined, action: () => { goScene("tykhy-mia"); } },
            { text: "Дізнатись про статус поселення", visible: () => !(window.playerState.flags || {}).mia_joined, action: () => { goScene("tykhy-status"); } }
        ]
    },
    "tykhy-rufin": {
        title: "Пошук Руфіна",
        text: "Варрік (старший мисливець) спочатку не говорить. «Він ніс щось що світилось. Не ліхтар.»",
        choices: [
            { text: "Сказати правду — він зник, хтось чекає", action: () => { adjustReputation('admin', 10); goScene("tykhy-rufin-found"); } },
            { text: "Говорити через Міа", action: () => { goScene("tykhy-rufin-found"); } }
        ]
    },
    "tykhy-rufin-found": {
        title: "Руфін знайдений",
        text: "Руфін живий, але змінений. «Я чув голос. Не вухами — звідси. Він сказав: Ти ніс це досить довго. Я віддав. Воно пішло в воду. Тепер я чую тільки тишу — і це найгучніший звук у моєму житті.» Докази: випалена трава колом, щоденник з останнім записом «Воно…», темний холодний камінь.",
        choices: [
            { text: "Взяти артефакт", action: () => { window.playerState.flags = window.playerState.flags || {}; window.playerState.flags.has_artifact = true; goScene("tykhy-exit"); } },
            { text: "Залишити артефакт", action: () => { goScene("tykhy-exit"); } }
        ]
    },
    "tykhy-kaen": {
        title: "Розмова з Каеном",
        text: "Каен ніколи не називає ім'я Моур вголос. Якщо між ними є довіра: «Я знайшов Міа в болоті. Немовля, живе. Я знав звідки — і все одно взяв. З любові.»",
        choices: [
            { text: "Сказати Міа", action: () => { window.playerState.flags = window.playerState.flags || {}; window.playerState.flags.told_mia_truth = true; goScene("tykhy-exit"); } },
            { text: "Не говорити", action: () => { goScene("tykhy-exit"); } },
            { text: "Запитати Каена що робити", action: () => { addToLog('Каен: «Скажи їй. Я не зможу.»'); goScene("tykhy-exit"); } }
        ]
    },
    "tykhy-mia": {
        title: "Міа приймає рішення",
        text: "Розмова Міа і Каена. Вартовий бачить з відстані. Після — Міа: «Я іду з тобою. Не тому що мушу. Тому що там є щось що стосується мене більше ніж тебе.»",
        choices: [
            { text: "Прийняти", action: () => { window.playerState.flags = window.playerState.flags || {}; window.playerState.flags.mia_companion = true; goScene("tykhy-exit"); } }
        ]
    },
    "tykhy-status": {
        title: "Статус поселення",
        text: "Поселення напружене. Прихід чужинця без провідника викликає підозру.",
        choices: [
            { text: "Іти далі", action: () => { goScene("tykhy-exit"); } }
        ]
    },
    "tykhy-exit": {
        title: "Вихід із Тихого Шелесту",
        text: "Ви залишаєте Тихий Шелест. Попереду — галявина духа.",
        choices: [
            { text: "Іти до галявини", action: () => { goScene("hazemoor-02-galyna"); } }
        ]
    },
    "hazemoor-02-galyna": {
        title: "Галявина",
        text: "Тиша. Не співають птахи. Вода стоїть без руху — тому що слухає. Вночі — світло рухається, збирається в коло.",
        choices: [
            { text: "Наблизитись", visible: () => (window.playerState.mia_trust || 0) >= 3, action: () => { goScene("hazemoor-02-enter"); } },
            { text: "Чекати", action: () => { goScene("hazemoor-02-enter"); } }
        ]
    },
    "hazemoor-02-enter": {
        title: "Вхід у галявину",
        text: "Міа стає перед водою. Туман розходиться сам — реагує на її присутність. Вхід — знизу, через воду.",
        choices: [
            { text: "Зануритись", action: () => { goScene("hazemoor-02-mour"); } }
        ]
    },
    "hazemoor-02-mour": {
        title: "Моур",
        text: "З поверхні, трави, гілок злітають комахи — мільйони, одночасно. Збираються у хмару. Величезна голова. Очі з порожнечі. Зупиняється на Міа. Дивиться як впізнавання.",
        choices: [
            { text: "Про артефакт", action: () => { addToLog('Моур: «Його зробили з мене. Я пішов. Вони забрали шматок. Тепер він знову мій.»'); goScene("hazemoor-02-mia-truth"); } },
            { text: "Про Руфіна", action: () => { addToLog('Моур: «Він ніс моє. Я забрав. Він залишився живим — більше ніж я обіцяв.»'); goScene("hazemoor-02-mia-truth"); } },
            { text: "Про Міа", action: () => { addToLog('Моур: «Вона моя. Інакше, ніж ти думаєш. Але моя.»'); goScene("hazemoor-02-mia-truth"); } }
        ]
    },
    "hazemoor-02-mia-truth": {
        title: "Міа дізнається",
        text: "«Я думала, що чую болото краще за інших, тому що вчилась. Але я чула його тому, що воно — я.» Пауза. «Він не знав, що я існую. Або знав — і чекав. Я не знаю, що гірше.»",
        choices: [
            { text: "Іти далі", action: () => { goScene("hazemoor-02-mount"); } }
        ]
    },
    "hazemoor-02-mount": {
        title: "Маунт",
        text: "З глибини піднімається щось велике. Крила складені. Не монстр. Частина Моура що отримала форму. Просто є.",
        choices: [
            { text: "Підійти", action: () => { window.playerState.flags = window.playerState.flags || {}; window.playerState.flags.has_mount = true; goScene("hazemoor-02-result"); } },
            { text: "Не підходити", action: () => { goScene("hazemoor-02-result"); } }
        ]
    },
    "hazemoor-02-result": {
        title: "Результат галявини",
        text: "Символ на обладунку у видінні: два перехрещені кинджали, коло і крапля — Орден Семи Кинджалів. Та сама печатка що була на листі з Грейфорда.",
        choices: [
            { text: "Іти до Сонк-Феррі", action: () => { goScene("holod-znuzu"); } }
        ]
    },
    "holod-znuzu": {
        title: "Голод знизу",
        text: "Сонк-Феррі. Кризова ситуація вимагає рішення.",
        choices: [
            { text: "Публічне викриття", action: () => { adjustReputation('muri', 20); adjustReputation('admin', -15); goScene("holod-result-A"); } },
            { text: "Контрольоване стримування", action: () => { adjustReputation('admin', 15); goScene("holod-result-B"); } },
            { text: "Місцева угода", action: () => { adjustReputation('muri', 30); adjustReputation('admin', -20); goScene("holod-result-C"); } },
            { text: "Ритуальне милосердя", visible: () => (window.playerState.doctrines || {}).lantern >= 1, action: () => { adjustReputation('keepers', 25); goScene("holod-result-D"); } }
        ]
    },
    "holod-result-A": { title: "Результат: Викриття", text: "Ви обрали публічне викриття.", choices: [{ text: "Далі", action: () => { goScene("sil-u-knyzi"); } }] },
    "holod-result-B": { title: "Результат: Стримування", text: "Ви обрали контрольоване стримування.", choices: [{ text: "Далі", action: () => { goScene("sil-u-knyzi"); } }] },
    "holod-result-C": { title: "Результат: Місцева угода", text: "Ви уклали місцеву угоду.", choices: [{ text: "Далі", action: () => { goScene("sil-u-knyzi"); } }] },
    "holod-result-D": { title: "Результат: Милосердя", text: "Ви обрали ритуальне милосердя.", choices: [{ text: "Далі", action: () => { goScene("sil-u-knyzi"); } }] },
    "sil-u-knyzi": {
        title: "Сіль у книзі",
        text: "Партія ліків досягла через неофіційні канали, але хтось замінив частину розведеним товаром.",
        choices: [
            { text: "Іти далі", action: () => { goScene("poromna-prysyaga"); } }
        ]
    },
    "poromna-prysyaga": {
        title: "Поромна присяга",
        text: "Тован Рід і Нера Вейл сперечаються про контроль водних маршрутів.",
        choices: [
            { text: "Підтримати Тована", action: () => { adjustReputation('wanderers', 10); goScene("poromna-result-tovan"); } },
            { text: "Підтримати Неру", action: () => { adjustReputation('admin', 10); goScene("poromna-result-nera"); } },
            { text: "Третій шлях", visible: () => (window.playerState.doctrines || {}).mediator >= 1, action: () => { goScene("poromna-result-third"); } }
        ]
    },
    "poromna-result-tovan": { title: "Тован контролює", text: "Тован отримав контроль.", choices: [{ text: "Далі", action: () => { goScene("popil-pid-kaplytseyu"); } }] },
    "poromna-result-nera": { title: "Нера контролює", text: "Нера отримала контроль.", choices: [{ text: "Далі", action: () => { goScene("popil-pid-kaplytseyu"); } }] },
    "poromna-result-third": { title: "Третій шлях", text: "Ви обрали третій шлях.", choices: [{ text: "Далі", action: () => { goScene("popil-pid-kaplytseyu"); } }] },
    "popil-pid-kaplytseyu": {
        title: "Попіл під каплицею",
        text: "Хтось імітує логіку компромісу не розуміючи ритуалів.",
        choices: [
            { text: "Зберегти таємницю", action: () => { goScene("popil-secret"); } },
            { text: "Викрити", action: () => { goScene("popil-expose"); } },
            { text: "Ритуал", visible: () => (window.playerState.doctrines || {}).lantern >= 2, action: () => { goScene("popil-ritual"); } }
        ]
    },
    "popil-secret": { title: "Таємниця", text: "Ви зберегли таємницю.", choices: [{ text: "Далі", action: () => { goScene("nizh-kvoty"); } }] },
    "popil-expose": { title: "Викриття", text: "Викриття успішне.", choices: [{ text: "Далі", action: () => { goScene("nizh-kvoty"); } }] },
    "popil-ritual": { title: "Ритуал", text: "Ритуал проведено.", choices: [{ text: "Далі", action: () => { goScene("nizh-kvoty"); } }] },
    "nizh-kvoty": {
        title: "Ніж квоти",
        text: "Серіт Келм прибуває. «Твій підпис як свідка дасть мені підстави для поміркованого висновку. Відмова — для іншого. Це не погроза. Це арифметика.»",
        choices: [
            { text: "Підписати", action: () => { adjustReputation('admin', 20); goScene("nizh-result-A"); } },
            { text: "Частково оскаржити", action: () => { goScene("nizh-result-B"); } },
            { text: "Відмовитись", action: () => { adjustReputation('wanderers', 20); adjustReputation('admin', -30); goScene("nizh-result-C"); } },
            { text: "Домовитись", visible: () => (window.playerState.doctrines || {}).mediator >= 2, action: () => { goScene("nizh-result-D"); } }
        ]
    },
    "nizh-result-A": { title: "Підписано", text: "Ви підписали.", choices: [{ text: "Далі", action: () => { goScene("valkorn-01"); } }] },
    "nizh-result-B": { title: "Оскаржено", text: "Ви частково оскаржили.", choices: [{ text: "Далі", action: () => { goScene("valkorn-01"); } }] },
    "nizh-result-C": { title: "Відмова", text: "Ви відмовились.", choices: [{ text: "Далі", action: () => { goScene("valkorn-01"); } }] },
    "nizh-result-D": { title: "Домовленість", text: "Ви домовились.", choices: [{ text: "Далі", action: () => { goScene("valkorn-01"); } }] },
    "valkorn-01": {
        title: "Валькорн — Прибуття",
        text: "Вартовий і Ілія прибувають до Валькорна.",
        choices: [
            { text: "Іти в місто", action: () => { goScene("valkorn-02"); } }
        ]
    },
    "valkorn-02": {
        title: "Три нитки орієнтації",
        text: "Три імені від Ілії: Брес (нове гетто), Стетсон (палацовий квартал), Одрін (архів).",
        choices: [
            { text: "Іти до підземелля", action: () => { goScene("valkorn-02-underground"); } }
        ]
    },
    "valkorn-02-underground": {
        title: "Підземелля",
        text: "Написи: «Хто торкнеться Печатки без Ліхтаря — втратить тінь.» Закрита камера — тіла трьох шпигунів Ордену. Третя точка: постамент порожній. Хтось прийшов раніше.",
        choices: [
            { text: "Іти далі", action: () => { goScene("valkorn-03"); } }
        ]
    },
    "valkorn-03": {
        title: "Правильна ціна",
        text: "Дамар — непримітний торговець. «Я торговець. Я не питаю що це і навіщо. Я питаю скільки ти готовий заплатити.»",
        choices: [
            { text: "Взяти артефакт", action: () => { window.playerState.flags = window.playerState.flags || {}; window.playerState.flags.artifact_secured = true; goScene("valkorn-04"); } }
        ]
    },
    "valkorn-04": {
        title: "Людина що послала Руфіна",
        text: "Лоен — член Сьомої Ради Ордену. «Нам потрібен був артефакт. Руфін знав болото. Справжній лідер — я ніколи не бачив обличчя. Листи пахнуть болотяною м'ятою та вологим торфом, чорнило блищить золотим пилом.»",
        choices: [
            { text: "Дедукція", action: () => { goScene("valkorn-04-deduction"); } }
        ]
    },
    "valkorn-04-deduction": {
        title: "Три докази",
        text: "1. Бубонці Фіппа з Білого срібла. 2. Запах гриму — болотяна м'ята і золоте чорнило. 3. Стетсон: «Найкраща тінь у палаці — та, яка яскраво вдягнена й змушує всіх сміятися.» Висновок: Хранитель Першої Печатки — це Блазень Фіпп.",
        choices: [
            { text: "Іти до Фіппа", action: () => { window.playerState.flags = window.playerState.flags || {}; window.playerState.flags.knows_keeper = true; goScene("valkorn-05"); } }
        ]
    },
    "valkorn-05": {
        title: "Проникнення",
        text: "Три шляхи в палац.",
        choices: [
            { text: "[Суддя] Офіційні перепустки", visible: () => (window.playerState.doctrines || {}).judge >= 1, action: () => { goScene("valkorn-05-iliya"); } },
            { text: "[Посередник] Через господарський двір", visible: () => (window.playerState.doctrines || {}).mediator >= 1, action: () => { goScene("valkorn-05-iliya"); } },
            { text: "[Слідопит] Через зливову систему", visible: () => (window.playerState.doctrines || {}).pathfinder >= 1, action: () => { goScene("valkorn-05-iliya"); } }
        ]
    },
    "valkorn-05-iliya": {
        title: "Себастьян Марр",
        text: "Чоловік змиває грим. Виймає Першу Печатку. «Тихіше, чи не так? Болото вміє кричати навіть крізь милі каменю.» Ілія: «Дядьку... Себастьяне?» Себастьян: «Іліє. Маленька іскорка. Ти виросла.»",
        choices: [
            { text: "⚖️ Шлях Судді", action: () => { goScene("valkorn-05-judge"); } },
            { text: "🤝 Шлях Посередника", action: () => { goScene("valkorn-05-mediator"); } },
            { text: "🕯️ Шлях Ліхтаря", action: () => { goScene("valkorn-05-lantern"); } }
        ]
    },
    "valkorn-05-judge": {
        title: "Шлях Судді",
        text: "«Твій Орден сіє смерть. Руфін загинув через твої ігри. Віддай Печатку.» Важка сутичка. Себастьян смертельно поранений. Ілія: «Закон має бути один для всіх. Навіть для моєї крові.»",
        choices: [
            { text: "Іти далі", action: () => { window.playerState.flags = window.playerState.flags || {}; window.playerState.flags.valkorn5_choice = 'judge'; adjustReputation('order', -100); adjustReputation('admin', 30); goScene("valkorn-epilogue"); } }
        ]
    },
    "valkorn-05-mediator": {
        title: "Шлях Посередника",
        text: "«Ми збережемо твою таємницю. Але Орден захищає поселення. І ти віддаси карти Чорного Архіву.» Себастьян: «Прагматизм — рідкісна риса. Ми домовились.» Ілія холодно: «Ми уклали угоду з чудовиськом.»",
        choices: [
            { text: "Іти далі", action: () => { window.playerState.flags = window.playerState.flags || {}; window.playerState.flags.valkorn5_choice = 'mediator'; adjustReputation('order', 40); goScene("valkorn-epilogue"); } }
        ]
    },
    "valkorn-05-lantern": {
        title: "Шлях Ліхтаря",
        text: "«Я провожу болотяний шепіт крізь свій ліхтар. Я стану тим, хто тримає удар. Дай мені Печатку.» Ритуал Злиття. Ілія кидається: «Ні! Я триматиму твій розум! Я буду твоїм світловим якорем!» Відкривається Bolo-Weaving.",
        choices: [
            { text: "Іти далі", action: () => { window.playerState.flags = window.playerState.flags || {}; window.playerState.flags.valkorn5_choice = 'lantern'; window.playerState.flags.bolo_weaving = true; goScene("valkorn-epilogue"); } }
        ]
    },
    "valkorn-epilogue": {
        title: "Фінал на балконі",
        text: "Епізод 2 завершено. Туман піднімається. Попереду — Глибоке болото.",
        choices: [
            { text: "Вирушати в Хейзмур", action: () => { goScene("deep-bog-01"); } }
        ]
    },
    "deep-bog-01": {
        title: "Повернення в імлу",
        text: "Герой перетинає зруйнований річковий міст за Грейфордом. Молочно-білий туман обволікає. Очерет шепоче: «Тут тепло... Срібло холодне, а вода пам'ятає твою колиску... Лягай...» Голос Ілії в голові: «Вартовий! Згадай своє ім'я. Болото бреше тобі.»",
        choices: [
            { text: "Вчепитися за голос Ілії", action: () => { goScene("deep-bog-02"); } }
        ]
    },
    "deep-bog-02": {
        title: "Понівечений шлях і Міа",
        text: "Стежка знищена. Міа виступає з туману: «Що вони зробили з тобою у своєму кам'яному місті? Ти хотів приборкати болото, але дозволив йому зжерти себе зсередини. І цей холод... Ти приніс їхнє срібло сюди.»",
        choices: [
            { text: "«Ця печатка — єдине що захищає мій розум»", action: () => { goScene("deep-bog-03"); } },
            { text: "«Я приніс її щоб знайти Другу Печатку»", action: () => { goScene("deep-bog-03"); } },
            { text: "«Я сам вирішую яку силу використовувати»", action: () => { goScene("deep-bog-03"); } }
        ]
    },
    "deep-bog-03": {
        title: "Затоплена Обитель",
        text: "Лілея розгортає карту: «Глибоко в Чорній Твані, під напівзатопленими арками Обителі, лежить Друга Печатка. Вона викувана з темної болотяної міді. Вона тримає Моур у стані вічного ув'язнення. Якщо не дістанемось — болото поглине Грейфорд.» Міа з чорними очима: «Якщо поєднаєш срібло з міддю — Хейзмур помре!»",
        choices: [
            { text: "⚙️ Вердикт Заліза — вставити срібну Печатку в мідний вівтар", action: () => { goScene("ep3-verdict-iron"); } },
            { text: "🌿 Вердикт Очерету — кинути Печатку в болотяну жижу", action: () => { goScene("ep3-verdict-reed"); } },
            { text: "🕯️ Пакт Ключника — стати живим замком", action: () => { goScene("ep3-verdict-pact"); } }
        ]
    },
    "ep3-verdict-iron": {
        title: "Вердикт Заліза",
        text: "Білий спалах. Вода в крипті стає чистою. Землистий розпад зупиняється. Шепіт Моура зникає повністю. Міа кричить від болю і тікає. Лілея: «Ми вбили душу цього місця.» Ілія: «Ти вижив. Ти повернув порядок.»",
        choices: [
            { text: "Іти далі", action: () => { window.playerState.flags = window.playerState.flags || {}; window.playerState.flags.ep3_path = 'iron'; goScene("episode-4-01-iron"); } }
        ]
    },
    "ep3-verdict-reed": {
        title: "Вердикт Очерету",
        text: "Тіло остаточно втрачає людську подобу. Шкіра — суха вербова кора. Очі — повністю чорні. Отримує повну силу Bolo-Weaving. Болото розширює межі. Міа торкається обличчя: «Ти вибрав нас. Тепер болото захистить тебе.» Ілія згасає: «Прощавай, Вартовий...»",
        choices: [
            { text: "Іти далі", action: () => { window.playerState.flags = window.playerState.flags || {}; window.playerState.flags.ep3_path = 'reed'; goScene("episode-4-01-reed"); } }
        ]
    },
    "ep3-verdict-pact": {
        title: "Пакт Ключника",
        text: "Лілея висікає руни. Трансформація стабілізується в проміжному стані. Постійний приглушений біль у грудях. Розум залишається людським. Міа: «Ти не знищив нас, але й не став одним із нас. Болото дозволить тобі ходити своїми стежками.» Лілея: «Це найважчий шлях.» Ілія: «Я залишаюся з тобою.»",
        choices: [
            { text: "Іти далі", action: () => { window.playerState.flags = window.playerState.flags || {}; window.playerState.flags.ep3_path = 'pact'; goScene("episode-4-01-pact"); } }
        ]
    },
"episode-4-01-iron": {
        title: "Залізний Тріумф: Повернення",
        text: `Ви повертаєтесь у Валькорн у складі офіційної делегації Ордену. Під важким парадним плащем — передпліччя, що повністю здерев'яніли: сірі, безживні, холодні. Лілея йде поруч з опущеною головою.\n\nГолос Ілії: «Я чую кроки твого коня на мостовій... Ти повернувся. Твій розум чистий від болотяного шепоту. Ми майже вдома.»\n\nУ Чорному Архіві — Себастьян Марр. Очі горять тріумфом: «Ти зробив те, що не вдалося жодному Вартовому до тебе. Хейзмур вмирає. Але твої руки... це ціна порядку.» Він передає Арбалет Залізного Завіту та набір важких срібних пасток.`,
        choices: [
            {
                text: "Прийняти зброю і йти далі",
                action: () => { goScene("episode-4-02-iron"); }
            }
        ]
    },
"episode-4-02-iron": {
        title: "Залізне Випалювання",
        text: `Себастьян Марр віддає наказ операції «Чиста земля» — випалювальні печі для знищення сховищ Мурі.\n\nТесса перехоплює вас на виході: «Ти думаєш, ти герой? Ти просто інструмент Себастьяна. Міа та її люди зараз вмирають від спраги на висушених болотах.»\n\nВона піднімає бунт усередині Ордену, відмовляючись винищувати беззбройних. Закликає вас зупинити Себастьяна.`,
        choices: [
            {
                text: "Приєднатись до бунту Тесси",
                action: () => { adjustReputation("wanderers", 20); goScene("episode-4-03-iron"); }
            },
            {
                text: "Відмовитись від бунту",
                action: () => { adjustReputation("admin", 10); goScene("episode-4-03-iron"); }
            }
        ]
    },
"episode-4-03-iron": {
        title: "Смерть Себастьяна",
        text: `Разом із бунтівними лицарями Тесси ви штурмуєте верхні рівні Архіву. У кабінеті магістра — Себастьян намагається активувати залізний захисний прес. Пошкодження парових клапанів. Важка залізна плита Архіву зривається з ланцюгів.\n\nСебастьян Марр гине. Розчавлений залізом, яке він так обожнював.\n\nТесса бере до рук печатку Ордену: «Ми більше не будемо катами столиці. Наше завдання — тримати закритими кордони, а не випалювати живих людей.»\n\nРуфін стоїть у кутку. Очі скляні. Не реагує на смерть господаря. Залишається живою, але порожньою тінню — назавжди.`,
        choices: [
            {
                text: "Повернутись у Хейзмур",
                action: () => {
                    window.playerState.flags = window.playerState.flags || {};
                    window.playerState.flags.sebastian_fate = 'dead';
                    goScene("episode-4-04-iron");
                }
            }
        ]
    },
"episode-4-04-iron": {
        title: "Попільні Стежки",
        text: `Болото стрімко помирає. Очерет ламається від вітру. Здичавілі Очеретяні Блукачі — крихкі, розсипаються від ударів.\n\nГолос Ілії: «Дивись... гниль відступає. Земля нарешті стає німою. Я відчуваю твій спокій. Твої руки більше не пульсують очеретом.»\n\nБіля сухого вівтаря — Міа. Виснажена, зневоднена. Тріщини на деревній шкірі. Тримає Другу Печатку, намагаючись вичавити отруйний газ для помсти Грейфорду.\n\n«Ти висушив наші ріки, Вартовий! Дивись на цю землю — вона мертва! Але я не дам тобі піти просто так. Ми згинемо разом!»`,
        choices: [
            {
                text: "Прибити Міа залізними штирями до вівтаря",
                action: () => {
                    adjustReputation("muri", -50);
                    addToLog("Міа залишається там — безпорадна, оніміла мумія Хейзмуру.", "system");
                    goScene("episode-4-05-iron");
                }
            },
            {
                text: "Дозволити їй згаснути самостійно — забрати Печатку",
                action: () => {
                    adjustReputation("muri", -30);
                    addToLog("Міа падає. Тіло повністю дерев'яніє — суха вербова гілка.", "system");
                    goScene("episode-4-05-iron");
                }
            }
        ]
    },
"episode-4-05-iron": {
        title: "Залізна Спадщина",
        text: `Чорний Архів очищено. Тесса офіційно очолює Орден Срібних Кинджалів. Лицарі скидають чорну броню, одягають легкі прикордонні плащі.\n\nТесса: «Ти віддав свої руки за цей порядок. Орден не забуде. Твоє ім'я буде вписане в наші хроніки.»\n\nРуфін стоїть у кутку зали біля вікна. Очі скляні. Тесса: «Він ніколи не повернеться. Нехай стоїть тут, в Архіві. Він — наш вічний німий пам'ятник гріхів минулого Ордену.»\n\nЛілея — головний архіваріус Грейфорда: «Я систематизую все що залишилось від мого роду. Люди захочуть будувати тут міста. Я маю переконатися, що вони знатимуть про Ключників.»\n\nГерой надягає важкі шкіряні рукавиці — ховає здерев'янілі передпліччя від сторонніх очей.`,
        choices: [
            {
                text: "Вирушити в дорогу",
                action: () => { goScene("ep5-final-A"); }
            }
        ]
    },
"episode-4-01-reed": {
        title: "Тінь у Каналах",
        text: `Ваше тіло — очеретяний монстр з чорними нафтовими очима. Ви потайки пробираєтесь до Валькорна крізь стічні колектори. Гнила болотна вода вже сочиться крізь тріщини підземних каналів столиці.\n\nГолос Ілії (дуже далеко): «Вартовий... де ти? Я ледь чую биття твого серця. Будь ласка, згадай моє ім'я...»\n\nНа виході — загін міської варти з Тессою. Вона впізнає монстра. Зупиняє солдатів.\n\n«Боги... Вартовий? Що це болото з тобою зробило? Себастьян Марр збирає всю королівську гвардію — збирається випалити весь Хейзмур. Якщо в тобі залишилося хоч щось людське — тікай. Лілея ховається в крипті старого собору.»`,
        choices: [
            {
                text: "Використати Плетіння — зникнути в тумані",
                action: () => { adjustReputation("order", 10); goScene("episode-4-02-reed"); }
            },
            {
                text: "Атакувати варту",
                action: () => { adjustReputation("order", -50); goScene("episode-4-02-reed"); }
            }
        ]
    },
"episode-4-02-reed": {
        title: "Полювання в Темряві",
        text: `Валькорн охоплений панікою — болотний туман на вулицях, очеретяні блукачі з підземель.\n\nСебастьян Марр особисто веде каральний загін із вогнеметами до підвалів.\n\nУ тілі очеретяного монстра ви ведете полювання в темних коридорах — затягуєте гвардійців у твань, залишаєтесь невидимими у тумані.\n\nГолос Ілії (ледь чутно): «Себастьян... він там... у крипті...»`,
        choices: [
            {
                text: "Наздогнати Себастьяна",
                action: () => { goScene("episode-4-03-reed"); }
            }
        ]
    },
"episode-4-03-reed": {
        title: "Розрахунок у Крипті",
        text: `Ви наздоганяєте Себастьяна в крипті собору. Срібний меч проти сили очерету. Ви обплутуєте його корінням верби та ламаєте залізну броню.\n\nСебастьян Марр гине від ядухи.\n\nТесса кидає меч на плити: «Досить, Вартовий! Ти вбив магістра. Військо не піде в болота. Якщо в тобі є хоч крапля людяності — зупини очерет.»\n\nВона оголошує реформацію Ордену.\n\nГолос Ілії (ледь чутно): «Себастьян... його більше немає... Знайди Лілею...»`,
        choices: [
            {
                text: "Повернутися до Хейзмуру з Лілеєю",
                action: () => {
                    window.playerState.flags = window.playerState.flags || {};
                    window.playerState.flags.sebastian_fate = 'dead';
                    goScene("episode-4-04-reed");
                }
            }
        ]
    },
"episode-4-04-reed": {
        title: "Ритуал Повернення",
        text: `Ви повертаєтесь до Хейзмуру разом із Лілеєю, яка тримає мідний ключ Ключників.\n\nГолос Ілії (дуже слабкий): «Я... все ще тут... під цією чорною корою... Не дай очерету закрити мої очі...»\n\nБіля вівтаря — Міа. Велична і страшна. Бачить задум і кидається на Лілею.\n\nВи стримуєте Міа Bolo-Weaving — лише блокуючи, не вбиваючи. Кожна дія відбирає здоров'я.\n\nКоли Міа знерухомлена — Лілея підбігає і силою вставляє мідний ключ у рунічний паз на грудях героя. Дерев'яна кора тріскається й злазить шарами. Чорний торф'яний сік витікає з вен, замінюючись гарячою червоною кров'ю. Очі знову стають людськими.\n\nМіа дивиться з болем: «Ти вибрав бути слабким. Біжи, людська тварюко.» Розвертається й зникає в тумані.\n\nГолос Ілії: «Твоє серце... я знову чую його биття. Принаймні тепер ми зможемо йти далі...»`,
        choices: [
            {
                text: "Іти до Великої Розв'язки",
                action: () => { goScene("episode-4-05-reed"); }
            }
        ]
    },
"episode-4-05-reed": {
        title: "Зелена Варта",
        text: `Болото поглинуло околиці Грейфорда, перетворивши їх на дрімучі очеретяні ліси. Валькорн зачинив брами.\n\nТесса реформує Орден у Залізні Кинджали — прикордонна глуха оборона. Офіційно визнає суверенітет Хейзмуру: «Ти повернув собі людське обличчя. Але Хейзмур тепер належить очерету. Ми триматимемо оборону тут.»\n\nРуфін перенесений до каплиці прикордонної застави на самій межі з болотом. Стоїть біля вівтаря, безмовно дивлячись у вікно, за яким шумить очерет.\n\nЛілея оселяється в невеликому будинку на околиці Грейфорда: «Я не змогла зберегти болото в його старих межах, але я зберегла твою душу.»\n\nГерой повністю повернув людську подобу. Рубці на руках — вічна пам'ять.`,
        choices: [
            {
                text: "Вирушити в дорогу",
                action: () => { goScene("ep5-final-B"); }
            }
        ]
    },
"episode-4-01-pact": {
        title: "Живий Замок на Бруківці",
        text: `Ви входите до Валькорна офіційно, під конвоєм. Землисте обличчя спокійне, але зосереджене. Чорні дерев'яні пальці. Постійний приглушений біль у грудях від внутрішнього тертя двох Печаток.\n\nГолос Ілії: «Біль... він тримає тебе в реальності. Ти став мостом між нами та ними.»\n\nУ Ратуші — Себастьян Марр, Тесса, Лілея.\n\nСебастьян: «Ти пропонуєш нейтралітет? Один твій невірний крок — і Моур прорветься. Орден вимагає встановлення застав ліхтарів уздовж усієї лінії очерету. Відмовишся — пакт буде анульовано.»\n\nЛілея шепоче: «Він блефує. Нам потрібно погодитися на ліхтарі, щоб зберегти мир. Міа надіслала листа — вона обіцяє не чіпати патрулі, якщо вони не перетинатимуть Шалену Річку.»`,
        choices: [
            {
                text: "Прийняти умови — ліхтарні застави",
                action: () => { adjustReputation("order", 20); adjustReputation("muri", -20); goScene("episode-4-02-pact"); }
            },
            {
                text: "Заборонити ліхтарі, погрожуючи Моуром",
                action: () => { adjustReputation("muri", 20); adjustReputation("order", -20); goScene("episode-4-02-pact"); }
            }
        ]
    },
"episode-4-02-pact": {
        title: "Змова Радикалів",
        text: `Радикальні лицарі намагаються влаштувати замах просто під час аудієнції, щоб спровокувати болото на прорив.\n\nРазом із Тессою ви стримуєте змовників — балансуючи на межі Плетіння та срібних ліхтарів.\n\nКоли змовників подолано, блідий Себастьян Марр підписує Пакт про розмежування кордонів. Розуміє, що Вартовий — єдиний «живий замок» між ним і Моуром.\n\nСебастьян Марр виживає. Залишається при владі, але обмежений.\n\nТесса — новий верховний маршал реформованого Ордену. Її лицарі стають прикордонною вартою ліхтарів.\n\nРуфін стоїть біля крісла Себастьяна, дивлячись у нікуди. Безмовне нагадування про ціну таємниць.`,
        choices: [
            {
                text: "Повернутись до Хейзмуру для стабілізації",
                action: () => {
                    window.playerState.flags = window.playerState.flags || {};
                    window.playerState.flags.sebastian_fate = 'alive';
                    goScene("episode-4-03-pact");
                }
            }
        ]
    },
"episode-4-03-pact": {
        title: "Сходження Трьох Сил",
        text: `Дипломатичний нейтралітет зафіксовано, але земля Хейзмуру здригається — Печатки пручаються.\n\nВи прибуваєте до вівтаря разом із Лілеєю та Міа. Вони мають діяти спільно.\n\nГолос Ілії: «Вода й Залізо. Тільки ти можеш змусити їх триматися разом. Це твій міст.»\n\nЛілея — срібні інструменти зліва. Міа — руки на мідному вівтарі справа. Герой — посередині.\n\nВи замикаєте обидва ключі обома руками. Потужна хвиля болю — срібло й мідь замикаються у вашій плоті. Стан стабілізується назавжди: землиста шкіра, чорні пальці, але людський розум.\n\nМіа (зі стриманою повагою): «Ти вибрав нести цей біль, щоб ми могли жити. Болото триматиметься у своїх межах.»\n\nЛілея: «Це найважчий шлях. Але ми зберегли і людські життя, і душу цієї землі.»`,
        choices: [
            {
                text: "Іти до Великої Розв'язки",
                action: () => { goScene("episode-4-04-pact"); }
            }
        ]
    },
"episode-4-04-pact": {
        title: "Орден Рівноваги",
        text: `Дипломатичний Пакт офіційно діє. Тесса очолює Орден Рівноваги. Лицарі — вартові срібних ліхтарів уздовж лінії очерету.\n\nТесса тисне руку: «Твій пакт працює. Люди незадоволені ліхтарями, а болото незадоволене сріблом, але вони більше не вбивають одне одного. Ти став мостом, який витримав цю вагу.»\n\nРуфін посаджений на кам'яну лаву в саду Ратуші, під старою розлогою вербою на межі з болотяною зоною. Сидить нерухомо, скляні очі спрямовані на срібну лінію ліхтарів.\n\nЛілея — офіційний дипломат Грейфорда і Ключник Пакту: «Я стежитиму за кожним гвинтом цього Пакту. Твій біль не повинен бути марним.»\n\nСебастьян Марр — живий, відійшов від влади. Спостерігає з тіней палацу.`,
        choices: [
            {
                text: "Іти до фінальної сцени",
                action: () => { goScene("episode-4-05-pact"); }
            }
        ]
    },
"episode-4-05-pact": {
        title: "Ваша Місія Виконана",
        text: `Хейзмур — дикий і небезпечний, але в рівновазі. Не розширюється.\n\nМіа — поважає Пакт, залишається в болоті. Стримана повага.\n\nГерой несе два ключі та постійний біль у грудях — і йде будувати мости в інших землях, де ніхто ще не знає, що він такий є.\n\nГолос Ілії: «Ти зробив неможливе. Ти побудував міст над прірвою. Я залишаюся з тобою... завжди.»`,
        choices: [
            {
                text: "Вирушити в дорогу",
                action: () => { goScene("ep5-final-C"); }
            }
        ]
    },
    "ep5-final-A": {
        title: "Суха дорога",
        text: "Сірий холодний ранок. Болото висушене — потріскана сіра глина. Герой пішки по пильній дорозі. Передпліччя загорнуті в шкіряні рукавиці. Голос Ілії: «Ми залишаємо це залізо, Вартовий. Попереду лише сухі й далекі краї. Йди.» Герой зупиняється на пагорбі, озирається на вежі Валькорна, розвертається й іде вперед.",
        choices: [
            { text: "Завершити", action: () => { addToLog('Порожній Сезон завершено. Мандруючий Вартовий іде далі.', 'success'); } }
        ]
    },
    "ep5-final-B": {
        title: "Стежка очерету",
        text: "Вологі густі сутінки. Важкий туман пахне вологою землею. Герой босоніж по мокрому торфі. Рубці на передпліччях — назавжди. Голос Ілії: «Ти відчуваєш цей мокрий бруд під ногами? Він холодний... але він справжній. Не озирайся назад. Твоя душа вільна від гнилі.» Герой крокує крізь очерет у туман.",
        choices: [
            { text: "Завершити", action: () => { addToLog('Порожній Сезон завершено. Мандруючий Вартовий іде далі.', 'success'); } }
        ]
    },
    "ep5-final-C": {
        title: "Міст між берегами",
        text: "Глибокі сутінки над водою. Старий кам'яний міст через Шалену Річку. Зліва — срібні вогні ліхтарів Ордену. Справа — темні тумани Хейзмуру. Герой зупиняється посередині. Стискає два ключі — срібний та мідний. Голос Ілії: «Це твоє місце — міст між двома світами. Ми забираємо ключі з собою. Я з тобою... завжди.» Герой ховає ключі під плащ і йде вперед.",
        choices: [
            { text: "Завершити", action: () => { addToLog('Порожній Сезон завершено. Мандруючий Вартовий іде далі.', 'success'); } }
        ]
    }
};
