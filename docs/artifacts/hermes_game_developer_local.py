#!/usr/bin/env python3
"""
Hermes Local Agent: AI Game Developer for Hazemoor.

Local helper for a Windows/WSL Godot workflow with optional Telegram control.
Tokens are never stored in this file. Pass the Telegram token as CLI arg or set
TELEGRAM_TOKEN in the environment.
"""

from __future__ import annotations

import argparse
import logging
import os
import shutil
import subprocess
import sys
from dataclasses import dataclass, field
from pathlib import Path
from typing import Optional

try:
    from telegram import Update
    from telegram.ext import Application, CommandHandler, ContextTypes
except ImportError:  # Telegram support is optional until the bot is used.
    Update = None  # type: ignore[assignment]
    Application = None  # type: ignore[assignment]
    CommandHandler = None  # type: ignore[assignment]
    ContextTypes = None  # type: ignore[assignment]


LOG_FORMAT = "[%(asctime)s] [%(levelname)s] %(message)s"
logging.basicConfig(
    level=logging.INFO,
    format=LOG_FORMAT,
    handlers=[logging.FileHandler("hermes.log", encoding="utf-8"), logging.StreamHandler()],
)
logger = logging.getLogger(__name__)


@dataclass
class GameState:
    project_initialized: bool = False
    scenes_created: list[str] = field(default_factory=list)
    assets_imported: list[str] = field(default_factory=list)
    current_task: Optional[str] = None
    progress: int = 0


class GameDeveloperAgent:
    """Small local automation layer for the Hazemoor Godot project."""

    def __init__(self, project_path: str | Path, godot_command: str = "godot") -> None:
        self.project_path = Path(project_path).expanduser().resolve()
        self.godot_project = self.project_path / "godot-project"
        self.godot_command = godot_command
        self.game_state = GameState(project_initialized=self.godot_project.exists())
        logger.info("GameDeveloperAgent initialized: %s", self.project_path)

    def log(self, message: str, level: str = "INFO") -> None:
        if level == "SUCCESS":
            logger.info("✓ %s", message)
        elif level == "ERROR":
            logger.error("✗ %s", message)
        elif level == "TASK":
            logger.info("▶ %s", message)
        else:
            logger.info("%s", message)

    def setup_project(self) -> bool:
        """Validate the existing project layout."""
        self.log("Checking project setup...", "TASK")
        self.game_state.current_task = "setup"

        try:
            if not self.project_path.exists():
                raise FileNotFoundError(f"Project folder not found: {self.project_path}")
            if not self.godot_project.exists():
                raise FileNotFoundError(f"Godot project folder not found: {self.godot_project}")
            if not (self.godot_project / "project.godot").exists():
                raise FileNotFoundError("project.godot not found")

            self.game_state.project_initialized = True
            self.game_state.progress = max(self.game_state.progress, 20)
            self.log("Project setup validated", "SUCCESS")
            return True
        except Exception as exc:
            self.log(f"Setup failed: {exc}", "ERROR")
            return False

    def create_scene(self, scene_path: str, node_type: str = "Node3D") -> bool:
        """Create a minimal Godot .tscn scene inside the project."""
        self.log(f"Creating scene: {scene_path}", "TASK")
        try:
            relative = scene_path.replace("res://", "")
            scene_file = self.godot_project / relative
            scene_file.parent.mkdir(parents=True, exist_ok=True)

            node_name = Path(relative).stem or node_type
            tscn_content = (
                "[gd_scene format=3]\n\n"
                f"[node name=\"{node_name}\" type=\"{node_type}\"]\n"
            )
            scene_file.write_text(tscn_content, encoding="utf-8")
            self.game_state.scenes_created.append(scene_path)
            self.log(f"Scene created: {scene_path}", "SUCCESS")
            return True
        except Exception as exc:
            self.log(f"Scene creation failed: {exc}", "ERROR")
            return False

    def create_all_scenes(self) -> int:
        """Create starter scenes that are safe to overwrite only if missing."""
        self.log("Creating starter scenes...", "TASK")
        self.game_state.current_task = "create_scenes"
        scenes = [
            ("res://scenes/ui/HUD.tscn", "CanvasLayer"),
            ("res://scenes/ui/DialoguePanel.tscn", "CanvasLayer"),
            ("res://scenes/ui/InventoryPanel.tscn", "CanvasLayer"),
            ("res://scenes/ui/QuestLog.tscn", "CanvasLayer"),
            ("res://scenes/ui/PauseMenu.tscn", "CanvasLayer"),
            ("res://scenes/levels/Greyford/TavernInterior.tscn", "Node3D"),
            ("res://scenes/levels/Greyford/Player.tscn", "CharacterBody3D"),
        ]

        created = 0
        for index, (scene_path, node_type) in enumerate(scenes, start=1):
            relative = scene_path.replace("res://", "")
            target = self.godot_project / relative
            if target.exists():
                self.log(f"Scene already exists, skipped: {scene_path}")
            elif self.create_scene(scene_path, node_type):
                created += 1
            self.game_state.progress = int(index / len(scenes) * 100)

        self.log(f"Created {created}/{len(scenes)} new scenes", "SUCCESS")
        return created

    def open_editor(self) -> bool:
        """Open Godot Editor for the project."""
        self.log("Opening Godot Editor...", "TASK")
        try:
            subprocess.Popen([self.godot_command, "--editor", "--path", str(self.godot_project)])
            self.log("Godot Editor opened", "SUCCESS")
            return True
        except Exception as exc:
            self.log(f"Failed to open editor: {exc}", "ERROR")
            return False

    def play_game(self) -> bool:
        """Run the Godot game from the main scene configured in project.godot."""
        self.log("Starting game...", "TASK")
        try:
            subprocess.Popen([self.godot_command, "--path", str(self.godot_project)])
            self.log("Game started", "SUCCESS")
            return True
        except Exception as exc:
            self.log(f"Failed to start game: {exc}", "ERROR")
            return False

    def validate_godot_project(self) -> bool:
        """Run a quick headless Godot scan."""
        self.log("Validating Godot project...", "TASK")
        try:
            result = subprocess.run(
                [self.godot_command, "--headless", "--editor", "--quit", "--path", str(self.godot_project)],
                text=True,
                capture_output=True,
                timeout=180,
            )
            output = (result.stdout or "") + (result.stderr or "")
            if result.returncode == 0 and "ERROR:" not in output and "Parse Error" not in output:
                self.log("Godot validation passed", "SUCCESS")
                return True
            self.log("Godot validation reported errors", "ERROR")
            logger.error(output[-4000:])
            return False
        except Exception as exc:
            self.log(f"Validation failed: {exc}", "ERROR")
            return False

    def git_commit(self, message: str) -> bool:
        """Commit changes in the project repository."""
        self.log(f"Committing: {message}", "TASK")
        try:
            subprocess.run(["git", "add", "."], cwd=self.project_path, check=True)
            subprocess.run(["git", "commit", "-m", message], cwd=self.project_path, check=True)
            self.log(f"Committed: {message}", "SUCCESS")
            return True
        except Exception as exc:
            self.log(f"Commit failed: {exc}", "ERROR")
            return False

    def get_status(self) -> str:
        return f"""
HAZEMOOR GAME STATUS
====================
Project: {self.project_path}
Godot project: {self.godot_project}
Progress: {self.game_state.progress}%
Initialized: {self.game_state.project_initialized}
Scenes created in this run: {len(self.game_state.scenes_created)}
Assets imported in this run: {len(self.game_state.assets_imported)}
Current task: {self.game_state.current_task}
""".strip()


agent: Optional[GameDeveloperAgent] = None


async def cmd_setup_game(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:  # type: ignore[name-defined]
    await update.message.reply_text("Starting setup...")
    assert agent is not None
    ok = agent.setup_project() and agent.validate_godot_project()
    await update.message.reply_text("✓ Setup validated" if ok else "✗ Setup failed. Check hermes.log")


async def cmd_open_editor(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:  # type: ignore[name-defined]
    await update.message.reply_text("Opening Godot Editor...")
    assert agent is not None
    await update.message.reply_text("✓ Godot Editor opened" if agent.open_editor() else "✗ Failed to open editor")


async def cmd_play_game(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:  # type: ignore[name-defined]
    await update.message.reply_text("Starting game...")
    assert agent is not None
    await update.message.reply_text("✓ Game started" if agent.play_game() else "✗ Failed to start game")


async def cmd_status(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:  # type: ignore[name-defined]
    assert agent is not None
    await update.message.reply_text(agent.get_status())


async def cmd_git_commit(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:  # type: ignore[name-defined]
    if not context.args:
        await update.message.reply_text("Usage: /git_commit <message>")
        return
    assert agent is not None
    message = " ".join(context.args)
    await update.message.reply_text(f"Committing: {message}")
    await update.message.reply_text(f"✓ Committed: {message}" if agent.git_commit(message) else "✗ Commit failed")


async def cmd_help(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:  # type: ignore[name-defined]
    await update.message.reply_text(
        """
HAZEMOOR GAME DEVELOPER BOT
===========================
/setup_game      - validate Godot project
/open_editor     - open Godot Editor
/play_game       - run the game
/status          - show game status
/git_commit msg  - commit changes to Git
/help            - show this help
""".strip()
    )


def build_arg_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Hazemoor local Godot helper")
    parser.add_argument("project_path", help="Path to game-bible folder, e.g. E:\\Hazemoor\\game-bible")
    parser.add_argument("telegram_token", nargs="?", default=os.getenv("TELEGRAM_TOKEN"), help="Telegram bot token or TELEGRAM_TOKEN env var")
    parser.add_argument("--godot", default=os.getenv("GODOT", "godot"), help="Godot executable, default: godot")
    parser.add_argument("--validate-only", action="store_true", help="Validate the Godot project and exit")
    return parser


def main() -> None:
    global agent
    args = build_arg_parser().parse_args()
    agent = GameDeveloperAgent(args.project_path, godot_command=args.godot)

    if args.validate_only:
        ok = agent.setup_project() and agent.validate_godot_project()
        raise SystemExit(0 if ok else 1)

    if not args.telegram_token:
        print("Error: TELEGRAM_TOKEN not provided. Use --validate-only for local checks without Telegram.")
        raise SystemExit(1)

    if Application is None or CommandHandler is None:
        print("Error: python-telegram-bot is not installed. Run: pip install python-telegram-bot")
        raise SystemExit(1)

    logger.info("Initializing Telegram bot for project: %s", args.project_path)
    application = Application.builder().token(args.telegram_token).build()
    application.add_handler(CommandHandler("setup_game", cmd_setup_game))
    application.add_handler(CommandHandler("open_editor", cmd_open_editor))
    application.add_handler(CommandHandler("play_game", cmd_play_game))
    application.add_handler(CommandHandler("status", cmd_status))
    application.add_handler(CommandHandler("git_commit", cmd_git_commit))
    application.add_handler(CommandHandler("help", cmd_help))
    logger.info("Telegram bot started. Waiting for commands...")
    application.run_polling()


if __name__ == "__main__":
    main()
