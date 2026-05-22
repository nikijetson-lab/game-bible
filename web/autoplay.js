window.stopAutoplay = false;

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
        return;
    }

    const choices = Array.from(document.querySelectorAll('.choice-btn')).filter(el => el.offsetWidth > 0);
    if (choices.length > 0) {
        // Find if we are stuck on the same DOM element... let's just click the first one that is visible.
        // But to avoid clicking the same button over and over if it doesn't do anything, let's track the text
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

        console.log("Autoplay clicking:", choices[0].innerText);
        choices[0].click();
    }
    setTimeout(runAutoplayStep, 800);
}
setTimeout(runAutoplayStep, 800);
