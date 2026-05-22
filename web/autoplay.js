window.stopAutoplay = false;
window.visitedScenes = new Set();
window.autoplayEpisodesLog = new Set();
window.autoplayItemsLog = new Set();

function runAutoplayStep() {
    if (window.stopAutoplay) { console.log("Autoplay stopped by user."); return; }

    if (document.body.innerText.includes("AI GM Settings")) {
        console.log("Autoplay paused: modal open");
        setTimeout(runAutoplayStep, 1000);
        return;
    }

    const currentSceneId = window.currentSceneKey;
    if (currentSceneId === "ending" || (window.GAME_SCENES && window.GAME_SCENES[currentSceneId] && window.GAME_SCENES[currentSceneId].isGameOver)) {
        window.stopAutoplay = true;
        console.log("Autoplay halted: Reached endgame.");
        console.log("Episodes Explored:", Array.from(window.autoplayEpisodesLog).join(", "));
        console.log("Items Collected:", Array.from(window.autoplayItemsLog).join(", "));
        return;
    }

    // Logging current episode
    const questTag = document.getElementById("quest-tag");
    if (questTag && questTag.innerText && !window.autoplayEpisodesLog.has(questTag.innerText)) {
        window.autoplayEpisodesLog.add(questTag.innerText);
        console.log(`[Autoplay Progress] Reached: ${questTag.innerText}`);
    }

    // Logging items
    if (window.playerState && window.playerState.inventory) {
        window.playerState.inventory.forEach(item => {
            if (!window.autoplayItemsLog.has(item)) {
                window.autoplayItemsLog.add(item);
                console.log(`[Autoplay Progress] Acquired Item: ${item}`);
            }
        });
    }

    const choices = Array.from(document.querySelectorAll('.choice-btn')).filter(el => el.offsetWidth > 0);
    if (choices.length > 0) {

        const currentText = choices.map(c => c.innerText).join("|");
        if (window.lastChoicesText === currentText) {
            window.stuckCount = (window.stuckCount || 0) + 1;
        } else {
            window.stuckCount = 0;
            window.lastChoicesText = currentText;
        }

        if (window.stuckCount >= 10) {
            window.stopAutoplay = true;
            console.error("Autoplay halted: stuck in the same scene for 10 clicks.");
            return;
        }

        // Try to pick a choice that leads to an unvisited scene, or requires attributes, else random
        let pickedChoice = null;

        // Priority 1: Required choices (shows we meet conditions for hidden paths)
        const requiredChoices = choices.filter(c => c.hasAttribute("data-has-requirement"));
        if (requiredChoices.length > 0) {
            pickedChoice = requiredChoices[Math.floor(Math.random() * requiredChoices.length)];
        }

        // Priority 2: Unvisited destinations
        if (!pickedChoice) {
            const unvisited = choices.filter(c => {
                const dest = c.getAttribute("data-next-scene");
                return dest && !window.visitedScenes.has(dest);
            });
            if (unvisited.length > 0) {
                pickedChoice = unvisited[Math.floor(Math.random() * unvisited.length)];
            }
        }

        // Priority 3: Random choice
        if (!pickedChoice) {
            pickedChoice = choices[Math.floor(Math.random() * choices.length)];
        }

        const nextScene = pickedChoice.getAttribute("data-next-scene");
        if (nextScene) window.visitedScenes.add(nextScene);

        console.log("Autoplay clicking:", pickedChoice.innerText);
        pickedChoice.click();
    }
    setTimeout(runAutoplayStep, 800);
}
setTimeout(runAutoplayStep, 800);
