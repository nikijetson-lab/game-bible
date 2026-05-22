window.stopAutoplay = false;

function runAutoplayStep() {
    if (window.stopAutoplay) { console.log("Autoplay stopped by user."); return; }

    if (document.body.innerText.includes("AI GM Settings")) {
        console.log("Autoplay paused: modal open");
        setTimeout(runAutoplayStep, 1000);
        return;
    }

    const currentSceneId = window.currentSceneKey;
    if (window.GAME_SCENES && window.GAME_SCENES[currentSceneId] && window.GAME_SCENES[currentSceneId].isAbsoluteFinal) {
        window.stopAutoplay = true;
        console.log(`[Autoplay] HALTED: Reached terminal game-over/ending scene: ${currentSceneId}`);
        return;
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

        // Try to find a choice we haven't clicked yet
        let targetChoice = choices[0]; // fallback
        for (const choice of choices) {
            if (!window.clickedChoicesHistory) { window.clickedChoicesHistory = new Set(); }
            if (!window.clickedChoicesHistory.has(choice.innerText)) {
                targetChoice = choice;
                break;
            }
        }
        
        if (window.clickedChoicesHistory) {
            window.clickedChoicesHistory.add(targetChoice.innerText);
        }

        console.log("Autoplay clicking:", targetChoice.innerText);
        targetChoice.click();
    }
    setTimeout(runAutoplayStep, 800);
}
setTimeout(runAutoplayStep, 800);
