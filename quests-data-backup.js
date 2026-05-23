window.playerState = window.playerState || {};
window.playerState.doctrines = window.playerState.doctrines || { judge: 0, pathfinder: 0, lantern: 0, mediator: 0 };
window.playerState.madness = window.playerState.madness || 0;
window.playerState.resilience = window.playerState.resilience || 100;

window.GAME_SCENES = {
    // === Епізод 1: Грейфорд ===
    arriving: {
        title: "Постоялий двір Грейфорда (Епізод 1)",
        text: `Ви входите у напівтемну таверну. За шинком стоїть Ерван. Ви запитуєте про Руфіна. Ерван мовчки бере ваш лист, дивиться на дивну печатку...`,
        choices: [
            {
                text: "«Я просто доставляю листа. Що далі — моя проблема.» (Прагматик)",
                action: () => chooseMotivation("Прагматик", "Ерван хмикає: «Просто наймит. Це безпечніше. Ключ твій, роби свое діло.»", "investigation")
            },
            {
                text: "⚖️ [Суддя] «Я представляю закон Грейфорда. Ти зобов'язаний співпрацювати зі слідством.»",
                visible: () => window.playerState.doctrines.judge >= 1,
                action: () => chooseMotivation("Суддя", "Ерван стримано киває. Ось ключ від кімнати Руфіна.", "investigation")
            }
        ]
    },
    investigation: {
        title: "Розслідування у Грейфорді",
        text: `Кімната Руфіна порожня. Треба знайти зачіпки.`,
        choices: [
            {
                text: "🚪 Оглянути кімнату Руфіна",
                action: () => {
                    adjustResource("slate", 1);
                    addItem("🎒 Сумка Руфіна");
                    goThread("room_clues");
                }
            }
        ]
    },
    room_clues: {
        title: "Кімната Руфіна",
        text: `Тут безлад.`,
        choices: [
            {
                text: "🏕️ [Слідопит] Дослідити сліди бруду на підлозі",
                visible: () => window.playerState.doctrines.pathfinder >= 1,
                action: () => {
                    adjustReputation("muri", 10);
                    adjustResource("loosestrife", 2);
                    goScene("ep1_ending");
                }
            },
            {
                text: "💡 [Ліхтар] Оглянути стіни та одвірки на наявність прихованої магії",
                visible: () => window.playerState.doctrines.lantern >= 1,
                action: () => {
                    adjustReputation("keepers", 10);
                    adjustResource("silver", 1);
                    goScene("ep1_ending");
                }
            },
            {
                text: "🤝 [Посередник] Знайти боргові розписки",
                visible: () => window.playerState.doctrines.mediator >= 1,
                action: () => {
                    adjustReputation("greyford", 10);
                    goScene("ep1_ending");
                }
            }
        ]
    },
    ep1_ending: {
        title: "Епізод 1 Завершено",
        text: `Ви зібрали достатньо інформації. Шлях лежить до Валькорна.`,
        isChapterEnding: true,
        choices: [
            {
                text: "Вирушити до Валькорна (Епізод 2)",
                nextSceneId: "ep2_valkorn_arrival"
            }
        ]
    },

    // === Епізод 2: Валькорн ===
    ep2_valkorn_arrival: {
        title: "Валькорн (Епізод 2)",
        text: `Ви прибули до величного залізного міста Ордену Семи Кинджалів. Вас зустрічає Тесса.`,
        choices: [
            {
                text: "Розпитати Тессу про Орден",
                action: () => {
                    adjustReputation("knives", 5);
                    goScene("ep2_climax");
                }
            }
        ]
    },
    ep2_climax: {
        title: "Чорний Архів Валькорна",
        text: `Ви проникаєте в Архів і стикаєтесь з Хранителем Першої Печатки — Себастьяном Марром. Відбувається розкол. (Шлях А, Б або В)`,
        choices: [
            {
                text: "Шлях А: Допомогти Ордену",
                action: () => {
                    adjustReputation("knives", 50);
                    goScene("ep2_ending");
                }
            },
            {
                text: "Шлях Б: Підтримати Тессу",
                action: () => {
                    adjustReputation("greyford", 30);
                    goScene("ep2_ending");
                }
            },
            {
                text: "Шлях В: Забрати Печатку собі",
                action: () => {
                    window.playerState.resilience -= 10;
                    addItem("Перша Печатка");
                    goScene("ep2_ending");
                }
            }
        ]
    },
    ep2_ending: {
        title: "Епізод 2 Завершено",
        text: `Валькорн залишається позаду. Ви прямуєте в Глибоке Болото. Ілія Марр тепер звучить лише у вашій голові.`,
        isChapterEnding: true,
        choices: [
            {
                text: "Спуститися в Глибоке Болото (Епізод 3)",
                nextSceneId: "ep3_deep_bog"
            }
        ]
    },

    // === Епізод 3: Глибоке Болото ===
    ep3_deep_bog: {
        title: "Глибоке Болото (Епізод 3)",
        text: `Болото вирує. Голос Ілії лунає у голові, захищаючи ваш розум від шепоту Моура.`,
        choices: [
            {
                text: "Прислухатися до Ілії (Зберегти стійкість)",
                action: () => {
                    window.playerState.resilience += 5;
                    window.playerState.madness -= 5;
                    goScene("ep3_combat");
                }
            },
            {
                text: "Ігнорувати Ілію (Придушення голосу)",
                action: () => {
                    window.playerState.madness += 20;
                    window.playerState.resilience -= 20;
                    goScene("ep3_combat");
                }
            }
        ]
    },
    ep3_combat: {
        title: "Зіткнення у тумані",
        text: `З туману виринають істоти Порожнього Сезону.`,
        choices: [
            {
                text: "Битися зброєю Ордену",
                action: () => {
                    adjustResource("bogiron", -1);
                    goScene("ep3_climax");
                }
            },
            {
                text: "💡 [Ліхтар] Використати Плетіння Моура (Bolo-Weaving)",
                visible: () => window.playerState.doctrines.lantern >= 2,
                action: () => {
                    window.playerState.madness += 5;
                    addToLog("Ви вплітаєте енергію болота у смертоносний удар.", "success");
                    goScene("ep3_climax");
                }
            }
        ]
    },
    ep3_climax: {
        title: "Затоплена Обитель",
        text: `Ви досягли Жертовника разом з Міа. Тут вирішується доля Другої Печатки.`,
        choices: [
            {
                text: "Завершити Епізод 3",
                action: () => goScene("ep3_ending")
            }
        ]
    },
    ep3_ending: {
        title: "Епізод 3 Завершено",
        text: `Ви зробили свій вибір у Затопленій Обителі.`,
        isChapterEnding: true,
        choices: [
            {
                text: "Перейти до Епізоду 4",
                nextSceneId: "ep4_climax"
            }
        ]
    },

    // === Епізод 4: Два Береги ===
    ep4_climax: {
        title: "Кульмінація (Епізод 4)",
        text: `Фінальне зіткнення сил Валькорна та Хейзмуру. Великий вибір.`,
        choices: [
            {
                text: "Пожертвувати Печатками для відновлення балансу",
                action: () => {
                    window.playerState.resilience += 50;
                    goScene("ep4_ending");
                }
            },
            {
                text: "Знищити Жертовник і Орден",
                action: () => {
                    window.playerState.madness += 50;
                    goScene("ep4_ending");
                }
            }
        ]
    },
    ep4_ending: {
        title: "Епізод 4 Завершено",
        text: `Все скінчено. Пилюка осідає.`,
        isChapterEnding: true,
        choices: [
            {
                text: "Перейти до Епілогу",
                nextSceneId: "ep5_epilogue"
            }
        ]
    },

    // === Епізод 5: Епілог / Фінал ===
    ep5_epilogue: {
        title: "Епізод 5: Відхід Героя",
        text: `Ви залишаєте болота і місто позаду. Порожній сезон завершено. Це остаточний фінал вашої подорожі.`,
        isAbsoluteFinal: true,
        choices: []
    },
    death: {
        title: "Трагічна загибель",
        text: `Ваш розум не витримав Божевілля. Холодний туман огортає ваше тіло.`,
        isAbsoluteFinal: true,
        choices: []
    }
};
