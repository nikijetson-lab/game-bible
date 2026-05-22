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
        choices: [
            {
                text: "Перейти до Епізоду 2",
                nextSceneId: "ep2_travel"
            }
        ]
    },

    // --- ЕПІЗОД 2: ВАЛЬКОРН ---
    ep2_travel: {
        title: "Подорож крізь Туманний ліс",
        text: `Ви йдете вузькою стежкою між високими болотяними соснами. Туман густішає, повітря наповнене запахом гнилої хвої та торфу. Раптом попереду чується важке дихання та тріск гілок...<br><br>З темряви виповзає велетенська **Болотяна Тварюка** (Swamp Beast) з очима, що світяться гнилим зеленим світлом! Вона блокує вам дорогу!`,
        choices: [
            {
                text: "⚔️ Приготуватись до бою з монстром!",
                action: () => {
                    startCombat("Болотяна Тварюка", 50, 10, () => goScene("ep2_victory"), () => goScene("death"));
                }
            }
        ]
    },
    ep2_victory: {
        title: "Перемога над Тварюкою",
        text: `Ви здолали Болотяну Тварюку! Її тіло з шипінням розчиняється в торф'яному мулі. У слизі ви знаходите містичний інгредієнт — пульсуючу болотну органіку.<br><br>Невдовзі ви виходите до кам'яних околиць **Валькорна**. Тут, біля стародавнього Чорного Архіву, ви зустрічаєте командувача Себастьяна Марра та його помічницю Тессу. Вони тримають скриньку з Печаткою.`,
        choices: [
            {
                text: "Підійти до Себастьяна Марра",
                action: () => {
                    adjustResource("heart", 1);
                    goScene("ep2_meeting");
                }
            }
        ]
    },
    ep2_meeting: {
        title: "Вибір біля Чорного Архіву",
        text: `Себастьян Марр тримає в руках важку срібну скриньку, всередині якої лежить **Перша Печатка**. Він дивиться на вас із підозрою: «Руфін мертвий. Його місія провалилася. Нам потрібен новий Ключник, який підкорить Моур королівській волі. Візьми Печатку і зламай її волю, або поверни її болоту.»<br><br>Тесса шепоче: «Це божевілля! Спроба зламати Печатку знищить рівновагу і випалить болото назавжди!»`,
        choices: [
            {
                text: "⚙️ [Шлях А] «Я підкорю Печатку волі столиці та Ордену.»",
                action: () => chooseValkornPath("A", "Ви підкорюєте Печатку волі столиці. Ваші пальці починають темніти й дерев'яніти.", "ep3_swamp")
            },
            {
                text: "🌿 [Шлях Б] «Я поверну Печатку болоту. Болото має дихати вільно.»",
                action: () => chooseValkornPath("B", "Ви кидаєте Печатку в болото. Себастьян лютує, але Тесса допомагає вам втекти.", "ep3_swamp")
            },
            {
                text: "🕯️ [Шлях В] «Печатка повинна тримати рівновагу. Я збережу її цілісність.»",
                action: () => chooseValkornPath("C", "Ви закриваєте Печатку в скриньці, балансуючи між силами Ордену та болотних Мурі.", "ep3_swamp")
            }
        ]
    },

    // --- ЕПІЗОД 3: ГЛИБОКЕ БОЛОТО ---
    ep3_swamp: {
        title: "Глибоке болото та Отруйний туман",
        text: `Ви заглиблюєтесь у Глибоке Болото. Вода піднімається до колін. Раптом підіймаються отруйні випари блекоти! Ваше дихання перехоплює, а в голові починає паморочитись...<br><br>Вам потрібно швидко захиститися від отрути!`,
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
                    goScene("ep3_meeting_lileya");
                }
            },
            {
                text: "Пробитись крізь хмару напролом (Втрата 30 HP та 15 Рішучості)",
                action: () => takePoisonDamage()
            }
        ]
    },
    ep3_meeting_lileya: {
        title: "Напівзатоплена Обитель",
        text: `Ви виходите на суху галявину, де стоїть напівзатоплена Обитель. Тут вас зустрічає **Лілея** — древня Ключниця боліт. Вона дивиться на вас із глибоким сумом: «Я бачу тінь Моура на твоєму обличчі. Печатка змінила твій шлях. Скоро Сезон Порожнечі закриється. Ти маєш зробити свій остаточний вибір на мосту між двома берегами...»`,
        choices: [
            {
                text: "«Я готовий зустріти свою долю у фіналі.» (Вирушити на Міст)",
                action: () => goScene("ep4_bridge")
            }
        ]
    },

    // --- ЕПІЗОД 4: ДВА БЕРЕГИ ---
    ep4_bridge: {
        title: "Міст між Двома Берегами",
        text: `Ви стоїте посеред величного стародавнього кам'яного мосту, що сполучає два береги: Чорний берег столиці Валькорна з його залізними ліхтарями та Зелений берег проклятого болота Хейзмуру. Вода під мостом шумить темним відлунням.<br><br>Себастьян Марр стоїть на Чорному березі з оголеним срібним мечем. Лілея та Міа стоять на Зеленому березі серед очеретів. Голос Ілії шепоче у вашій голові: *«Це фінал. Обери свій вирок...»*`,
        choices: [
            {
                text: "⚙️ «Оголосити Вердикт Заліза (Шлях А)»",
                action: () => resolveFinalWay("A")
            },
            {
                text: "🌿 «Оголосити Вердикт Очерету (Шлях Б)»",
                action: () => resolveFinalWay("B")
            },
            {
                text: "🕯️ «Підписати Пакт Ключника (Шлях В)»",
                action: () => resolveFinalWay("C")
            }
        ]
    },

    death: {
        title: "Трагічна загибель",
        text: `Ваша подорож обірвалася в болотах Хейзмуру. Холодний туман огортає ваше тіло, а прокляття Порожнього Сезону забирає залишки вашої душі...<br><br>Ніхто не дізнається про вашу місію, а лист Руфіна згниє під шаром торфу.`,
        isGameOver: true,
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
        isGameOver: true,
        choices: []
    }
};
