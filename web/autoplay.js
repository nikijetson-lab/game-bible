window.stopAutoplay = false;
window.visitedScenes = window.visitedScenes || new Set();
window.autoplayEpisodesLog = window.autoplayEpisodesLog || new Set();
window.autoplayItemsLog = window.autoplayItemsLog || new Set();
window.clickedChoicesHistory = window.clickedChoicesHistory || new Set();

function runAutoplayStep() {
    if (window.stopAutoplay) { console.log("[Autoplay] Stopped by user."); return; }

    if (document.body.innerText.includes("AI GM Settings")) {
        console.log("[Autoplay] Paused: modal open");
        setTimeout(runAutoplayStep, 1000);
        return;
    }

    const currentSceneId = window.currentSceneKey;
    if (currentSceneId && window.GAME_SCENES && window.GAME_SCENES[currentSceneId] && window.GAME_SCENES[currentSceneId].isGameOver) {
        window.stopAutoplay = true;
        console.log(`[Autoplay] HALTED: Reached terminal game-over/ending scene: ${currentSceneId}`);
        console.log("[Autoplay] Episodes Explored:", Array.from(window.autoplayEpisodesLog).join(", "));
        console.log("[Autoplay] Items Collected:", Array.from(window.autoplayItemsLog).join(", "));
        return;
    }

    // Logging current episode
    const questTag = document.getElementById("quest-tag");
    if (questTag && questTag.innerText && !window.autoplayEpisodesLog.has(questTag.innerText)) {
        window.autoplayEpisodesLog.add(questTag.innerText);
        console.log(`[Autoplay] Reached Episode: ${questTag.innerText}`);
    }

    // Logging items
    if (window.playerState && window.playerState.inventory) {
        window.playerState.inventory.forEach(item => {
            if (!window.autoplayItemsLog.has(item)) {
                window.autoplayItemsLog.add(item);
                console.log(`[Autoplay] Acquired Item: ${item}`);
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
            console.error("[Autoplay] HALTED ERROR: Stuck in the same scene for 10 consecutive clicks.");
            return;
        }

        let pickedChoice = null;

        // Try to find a completely new choice we haven't clicked yet across ALL runs in this session
        const unclickedAcrossRuns = choices.filter(c => !window.clickedChoicesHistory.has(c.innerText));

        if (unclickedAcrossRuns.length > 0) {
            // Priority 1: Required unclicked choices
            const requiredUnclicked = unclickedAcrossRuns.filter(c => c.hasAttribute("data-has-requirement"));
            if (requiredUnclicked.length > 0) {
                pickedChoice = requiredUnclicked[Math.floor(Math.random() * requiredUnclicked.length)];
            }

            // Priority 2: Random unclicked choice
            if (!pickedChoice) {
                pickedChoice = unclickedAcrossRuns[Math.floor(Math.random() * unclickedAcrossRuns.length)];
            }
        }

        // Priority 3: If all choices have been clicked before, pick one that leads to a scene we haven't visited *in this specific run*
        if (!pickedChoice) {
            const unvisitedDestinations = choices.filter(c => {
                const dest = c.getAttribute("data-next-scene");
                return dest && !window.visitedScenes.has(dest);
            });
            if (unvisitedDestinations.length > 0) {
                pickedChoice = unvisitedDestinations[Math.floor(Math.random() * unvisitedDestinations.length)];
            }
        }

        // Priority 4: Fully Random choice fallback
        if (!pickedChoice) {
            pickedChoice = choices[Math.floor(Math.random() * choices.length)];
        }

        const nextScene = pickedChoice.getAttribute("data-next-scene");
        if (nextScene) window.visitedScenes.add(nextScene);
        window.clickedChoicesHistory.add(pickedChoice.innerText);

        console.log(`[Autoplay] Clicking: ${pickedChoice.innerText.substring(0, 50)}...`);
        pickedChoice.click();
    }
    setTimeout(runAutoplayStep, 800);
}
setTimeout(runAutoplayStep, 800);
