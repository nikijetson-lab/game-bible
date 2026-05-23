window.playerState = window.playerState || {};
window.EPISODE_1_QUESTS = window.EPISODE_1_QUESTS || [];
window.GAME_SCENES = {
    arriving: {
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
                nextSceneId: "ep2_port_and_docks"
            }
        ]
    },


    // --- ЕПІЗОД 2: ВАЛЬКОРН ---

    ep2_port_and_docks: {
        title: "Порт і Доки Валькорна",
        text: `Ви прибули до величезних доків Валькорна. Залізне місто дихає димом та машинами. Звідси ви можете потрапити у Тіньове Гетто або Дипломатичний Квартал.`,
        choices: [
            {
                text: "Пройти до Тіньового Гетто",
                nextSceneId: "ep2_shadow_ghetto"
            },
            {
                text: "Вирушити у Дипломатичний Квартал",
                nextSceneId: "ep2_diplomatic_quarter"
            },
            {
                text: "Шукати скритні шлюзи в Палацові колектори",
                nextSceneId: "ep2_palace_sewers"
            }
        ]
    },
    ep2_shadow_ghetto: {
        title: "Тіньове Гетто",
        text: `Гетто наповнене шумом, бідністю та секретами. Місцеві знають кожен таємний хід Валькорна.`,
        choices: [
            {
                text: "Повернутися в Порт",
                nextSceneId: "ep2_port_and_docks"
            },
            {
                text: "Шукати шлях до Палацових колекторів",
                nextSceneId: "ep2_palace_sewers"
            }
        ]
    },
    ep2_diplomatic_quarter: {
        title: "Дипломатичний Квартал",
        text: `Елегантний та суворий квартал, де плетуться інтриги між Орденом та Адміністрацією.`,
        choices: [
            {
                text: "Повернутися в Порт",
                nextSceneId: "ep2_port_and_docks"
            },
            {
                text: "Прямувати до Королівського Палацу",
                nextSceneId: "ep2_royal_palace"
            }
        ]
    },
    ep2_palace_sewers: {
        title: "Палацові колектори",
        text: `Смердючі тунелі під Валькорном. Шлях далі веде безпосередньо до Палацу, але він закритий важкими гратами. Вам потрібні особливі навички або срібло, щоб пройти.`,
        choices: [
            {
                text: "🏕️ [Слідопит] Знайти обхідний шлях серед труб",
                visible: () => window.playerState.doctrines.pathfinder >= 1,
                action: () => {
                    addToLog("Ваші навички слідопита дозволили оминути грати.", "success");
                    goScene("ep2_royal_palace");
                }
            },
            {
                text: "💰 Підкупити вартового тунелю (1 Срібло)",
                visible: () => window.playerState.resources.silver >= 1,
                action: () => {
                    adjustResource("silver", -1);
                    addToLog("Срібло відкриває багато дверей у Валькорні.", "success");
                    goScene("ep2_royal_palace");
                }
            },
            {
                text: "Повернутися у Гетто",
                nextSceneId: "ep2_shadow_ghetto"
            },
            {
                text: "Повернутися в Порт",
                nextSceneId: "ep2_port_and_docks"
            }
        ]
    },
    ep2_royal_palace: {
        title: "Королівський Палац",
        text: `Величний палац Валькорна. Саме тут ухвалюються рішення, що впливають на Хейзмур. Звідси шлях лежить у Чорний Архів.`,
        choices: [
            {
                text: "Увійти в Чорний Архів",
                nextSceneId: "valkorn_05"
            },
            {
                text: "Повернутися у Дипломатичний Квартал",
                nextSceneId: "ep2_diplomatic_quarter"
            }
        ]
    },
    valkorn_05: {
        title: "Чорний Архів",
        text: `Себастьян Марр тримає в руках важку срібну скриньку, всередині якої лежить **Перша Печатка**. Він дивиться на вас із підозрою: «Руфін мертвий. Його місія провалилася. Нам потрібен новий Ключник, який підкорить Моур королівській волі. Візьми Печатку і зламай її волю, або поверни її болоту.»<br><br>Тесса шепоче: «Це божевілля! Спроба зламати Печатку знищить рівновагу і випалить болото назавжди!»`,
        choices: [
            {
                text: "Повернутися у Палац",
                nextSceneId: "ep2_royal_palace"
            },
            {
                text: "⚙️ [Шлях А] «Я підкорю Печатку волі столиці та Ордену.» (Втеча)",
                action: () => chooseValkornPath("A", "Ви підкорюєте Печатку волі столиці. Ваші пальці починають темніти й дерев'яніти.", "ep3_narrow_reeds")
            },
            {
                text: "🌿 [Шлях Б] «Я поверну Печатку болоту. Болото має дихати вільно.» (Втеча)",
                action: () => chooseValkornPath("B", "Ви кидаєте Печатку в болото. Себастьян лютує, але Тесса допомагає вам втекти.", "ep3_narrow_reeds")
            },
            {
                text: "🕯️ [Шлях В] «Печатка повинна тримати рівновагу. Я збережу її цілісність.» (Втеча)",
                action: () => chooseValkornPath("C", "Ви закриваєте Печатку в скриньці, балансуючи між силами Ордену та болотних Мурі.", "ep3_narrow_reeds")
            }
        ]
    },

    // --- ЕПІЗОД 3: ГЛИБОКЕ БОЛОТО ---

    ep3_narrow_reeds: {
        title: "Вузькі очерети",
        text: `Ви заглиблюєтесь у Глибоке Болото, тікаючи з Валькорна. Вода піднімається до колін, а отруйні випари блекоти заповнюють повітря. Захистіться від отрути!`,
        choices: [
            {
                text: "🧪 Випити Протиотруту зі своєї сумки",
                visible: () => window.playerState.inventory.includes("🧪 Протиотрута"),
                action: () => consumeAntidoteForPoison()
            },
            {
                text: "🏕️ [Слідопит] Знайти чисту стежку за напрямком вітру",
                visible: () => window.playerState.doctrines.pathfinder >= 1,
                action: () => {
                    addToLog("Слідопит успішно знайшов чистий прохід крізь вітер!", "success");
                    goScene("ep3_dry_mound");
                }
            },
            {
                text: "Пробитись крізь хмару напролом до Сухого Горба (Втрата 30 HP та 15 Рішучості)",
                action: () => takePoisonDamage()
            }
        ]
    },
    ep3_dry_mound: {
        title: "Сухий Горб",
        text: `Невеликий острівець сухої землі посеред трясовини. Ви можете перепочити або рушати слідами Амфібій далі.`,
        choices: [
            {
                text: "Вирушити у Заборонене Місце",
                nextSceneId: "ep3_forbidden_place"
            },
            {
                text: "Повернутися у Вузькі очерети",
                nextSceneId: "ep3_narrow_reeds"
            }
        ]
    },
    ep3_forbidden_place: {
        title: "Заборонене Місце",
        text: `Святилище Мурі, приховане від людських очей. Ви знаходите стародавні інгредієнти для крафту.`,
        choices: [
            {
                text: "Зібрати ресурси (Болотяна Мазь) та йти до Жертовника",
                action: () => {
                    adjustResource("slime", 1);
                    adjustResource("henbane", 1);
                    addToLog("Ви зібрали інгредієнти для Болотяної Мазі.", "success");
                    goScene("ep3_altar_second_seal");
                }
            },
            {
                text: "Повернутися на Сухий Горб",
                nextSceneId: "ep3_dry_mound"
            }
        ]
    },
    ep3_altar_second_seal: {
        title: "Жертовник Другої Печатки",
        text: `Тут вас зустрічає **Лілея** — древня Ключниця боліт. Відбувається ментальний вибух від близькості Печатки. "Скоро Сезон Порожнечі закриється. Ти маєш зробити свій остаточний вибір на мосту між двома берегами..."`,
        choices: [
            {
                text: "«Я готовий зустріти свою долю у фіналі.» (Вирушити на Міст)",
                nextSceneId: "ep4_old_bridge_ruins"
            }
        ]
    },

    // --- ЕПІЗОД 4: ДВА БЕРЕГИ ---

    ep4_old_bridge_ruins: {
        title: "Руїни Старого Мосту",
        text: `Ви стоїте на Руїнах Старого Мосту. Тут вирішується доля Хейзмуру. Вам доведеться зробити Вирок Фронтиру.`,
        choices: [
            {
                text: "Перейти до Суду Вартового",
                nextSceneId: "ep4_wardens_judgment"
            }
        ]
    },
    ep4_wardens_judgment: {
        title: "Суд Вартового",
        text: `На мосту вас чекають представники фракцій. Ваша репутація визначить, куди лежить ваш подальший шлях.`,
        choices: [
            {
                text: "Підтримати Міа та Мурі (Потрібна позитивна репутація Мурі)",
                visible: () => window.playerState.reputation.muri > 0,
                nextSceneId: "ep4_resistance_camp"
            },
            {
                text: "Підтримати Марра та Орден (Потрібна позитивна репутація Адміністрації/Ордену)",
                visible: () => (window.playerState.reputation.greyford > 0 || window.playerState.reputation.knives > 0),
                nextSceneId: "ep4_military_outpost"
            },
            {
                text: "Зберегти нейтралітет Веї (Потрібна позитивна репутація Хранителів)",
                visible: () => window.playerState.reputation.keepers > 0,
                nextSceneId: "ep4_isolated_chapel"
            },
            {
                text: "Зробити вибір (Нейтральний)",
                visible: () => window.playerState.reputation.muri <= 0 && window.playerState.reputation.greyford <= 0 && window.playerState.reputation.knives <= 0 && window.playerState.reputation.keepers <= 0,
                nextSceneId: "ep4_isolated_chapel"
            }
        ]
    },
    ep4_resistance_camp: {
        title: "Табір Опору Жаболюдей",
        text: `Ви прибули до Табору Опору. Тут вас зустрічають як героя боліт. Ваша підтримка змінила баланс сил.`,
        choices: [
            {
                text: "Підрахувати фінальні ваги та перейти до Початку Зими",
                action: () => resolveFinalWay("B")
            }
        ]
    },
    ep4_military_outpost: {
        title: "Військовий Аванпост Грейфорда",
        text: `Ви прибули до Військового Аванпосту. Залізний порядок крокує в Хейзмур під вашим захистом.`,
        choices: [
            {
                text: "Підрахувати фінальні ваги та перейти до Початку Зими",
                action: () => resolveFinalWay("A")
            }
        ]
    },
    ep4_isolated_chapel: {
        title: "Ізольована Каплиця Хранителів",
        text: `Ви прибули до Каплиці. Ви обрали шлях рівноваги, не віддаючи перевагу жодній зі сторін.`,
        choices: [
            {
                text: "Підрахувати фінальні ваги та перейти до Початку Зими",
                action: () => resolveFinalWay("C")
            }
        ]
    },

    death: {
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
        title: "Кінець Гри",
        text: "",
        isAbsoluteFinal: true,
        choices: []
    },


    ep5_beginning_of_winter: {
        title: "Початок Зими",
        text: `Холодний вітер сповіщає про прихід зими. Ваша подорож Хейзмуром добігає кінця, але ще лишилося пройти Замерзлі Болота.`,
        choices: [
            {
                text: "Вирушити на Замерзлі Болота",
                nextSceneId: "ep5_frozen_bogs"
            }
        ]
    },
    ep5_frozen_bogs: {
        title: "Замерзлі Болота",
        text: `Вода перетворилася на лід. Ви йдете обережно, кожен крок лунає в тиші Порожнього Сезону. Попереду видніється Брама Забутих.`,
        choices: [
            {
                text: "Прямувати до Брами Забутих",
                nextSceneId: "ep5_gate_forgotten"
            }
        ]
    },
    ep5_gate_forgotten: {
        title: "Брама Забутих",
        text: `Стародавня брама, що відділяє Хейзмур від зовнішнього світу. Ви залишаєте цей край, несучи його наслідки у своїй душі.`,
        choices: [
            {
                text: "Перейти через Браму",
                nextSceneId: "ep5_final_journey"
            }
        ]
    },
    ep5_final_journey: {
        title: "Остаточний Фінал Подорожі Яромира",
        text: `<p style="font-style: italic; color: var(--text-muted); text-align: center; margin-top: 1rem;">Дякуємо, що зіграли у симулятор "Мандруючого Вартового"! Ваші рішення сформували долю Хейзмуру.</p>`,
        isAbsoluteFinal: true,
        choices: []
    }

};
