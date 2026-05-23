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
                    adjustReputation("knives", 15);

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
                    adjustReputation("greyford", 15);

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
                    adjustReputation("greyford", 10);

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
                    adjustReputation("knives", 10);

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
                    adjustReputation("greyford", 20);
                    adjustReputation("knives", -10);

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
                    adjustReputation("greyford", -10);

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
                    adjustReputation("greyford", 20);
                    adjustReputation("knives", 10);
                    finishQuest("Правда", "Сержант киває: «Нехай закон світить тобі в тумані.»");
                }
            },
            {
                text: "«Я маю перевірити маршрут. Є скарги на безпеку поселення.» (Напівправда)",
                action: () => {
                    adjustReputation("greyford", 5);
                    adjustReputation("knives", -5);
                    finishQuest("Напівправда", "Сержант скептично хмикає: «У Хейзмурі немає безпеки. Ну йди.»");
                }
            },
            {
                text: "⚖️ [Суддя] «Я виконую офіційне доручення суду Грейфорда щодо картографа. Зареєструйте вихід.»",
                visible: () => window.playerState.doctrines.judge >= 1,
                action: () => {
                    adjustReputation("greyford", 30);
                    adjustReputation("knives", 15);
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
                nextSceneId: "ep1_sunk_ferry"
            }
        ]
    },

    ep1_sunk_ferry: {

        audioTrack: "assets/audio/swamp_music.mp3",

        audioAtmosphere: "assets/audio/swamp_wind_rain.mp3",

        title: "Сонк-Феррі",
        text: `Ви прибули до Сонк-Феррі — невеликого поселення поромників на краю болота. Пахне стоячою водою та гнилим деревом.`,
        choices: [
            {
                text: "Відправитись до Мірефолду",
                nextSceneId: "ep1_mirefold"
            },
            {
                text: "Піти до Ліхтарного Дому Святої Вей",
                nextSceneId: "ep1_lantern_house"
            },
            {
                text: "Вирушити до Тихого Шелесту (Шлях болота)",
                nextSceneId: "ep1_silent_rustle"
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
                nextSceneId: "ep1_silent_rustle"
            },
            {
                text: "Повернутися до Сонк-Феррі",
                nextSceneId: "ep1_sunk_ferry"
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
                nextSceneId: "ep1_silent_rustle"
            },
            {
                text: "Повернутися до Сонк-Феррі",
                nextSceneId: "ep1_sunk_ferry"
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
                    adjustReputation("knives", -10);
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
                    adjustReputation("knives", 30);
                    goScene("ep2_valkorn_black_archive");
                }
            },
            {
                text: "Нейтралітет",
                action: () => {
                    adjustReputation("knives", 10);
                    goScene("ep2_valkorn_black_archive");
                }
            },
            {
                text: "⚔️ Протистояння",
                action: () => {
                    adjustReputation("knives", -40);
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
                    adjustReputation("knives", 10);
                    goScene("ep4_valkorn_hunt_for_beast");
                }
            },
            {
                text: "Атакувати варту",
                action: () => {
                    adjustReputation("knives", -50);
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
                    adjustReputation("knives", 20);
                    adjustReputation("muri", -20);
                    goScene("ep4_valkorn_conspiracy");
                }
            },
            {
                text: "Заборонити ліхтарі, погрожуючи силою Моура",
                action: () => {
                    adjustReputation("muri", 20);
                    adjustReputation("knives", -20);
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

};
