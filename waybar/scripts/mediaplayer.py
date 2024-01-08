#!/usr/bin/env python3

import gi
import os
import sys
import json
import signal
import logging
import argparse
from typing import List

gi.require_version("Playerctl", "2.0")

from gi.repository import Playerctl, GLib
from gi.repository.Playerctl import Player

logger = logging.getLogger(__name__)


def signal_handler(sig, _):
    logger.info(f"Received signal to stop: {sig}, exiting")
    sys.stdout.write("\n")
    sys.stdout.flush()
    sys.exit(0)


class PlayerManager:
    init_all_players = False

    def __init__(self):
        self.manager = Playerctl.PlayerManager()
        self.loop = GLib.MainLoop()

        self.manager.connect(
            "name-appeared", lambda *args: self.on_player_appeared(*args)
        )
        self.manager.connect(
            "player-vanished", lambda *args: self.on_player_vanished(*args)
        )

        signal.signal(signal.SIGINT, signal_handler)
        signal.signal(signal.SIGTERM, signal_handler)
        signal.signal(signal.SIGPIPE, signal.SIG_DFL)

        self.init_players()

    def run(self):
        logger.info("Starting main loop")
        self.loop.run()

    def init_players(self):
        if len(self.manager.props.player_names) == 0:
            self.show_not_players()
            return

        for player in self.manager.props.player_names:
            self.init_player(player)

    def get_players(self) -> List[Player]:
        return self.manager.props.players

    def on_player_appeared(self, _, player):
        logger.info(f"Player has appeared: {player.name}")

        if player is not None:
            self.init_player(player)
        else:
            logger.debug(
                "... But it's not the selected player, skipping"
            )

    def on_player_vanished(self, _, player):
        logger.info(f"Player {player.props.player_name} has vanished")
        self.show_most_important_player()

    def show_most_important_player(self):
        logger.debug("Showing most important player")
        # show the currently playing player
        # or else show the first paused player
        # or else show nothing
        current_player = self.get_first_playing_player()
        if current_player is not None:
            self.on_metadata_changed(current_player, current_player.props.metadata)
        else:
            self.show_not_players()

    def show_not_players(self):
        self.write_output(
            "",
            "No players found",
            None
        )

    def init_player(self, player):
        logger.info(f"Initialize new player: {player.name}")
        player = Playerctl.Player.new_from_name(player)

        player.connect("playback-status", self.on_playback_status_changed, None)
        player.connect("metadata", self.on_metadata_changed, None)

        self.manager.manage_player(player)
        self.on_metadata_changed(player, player.props.metadata)

    def on_playback_status_changed(self, player, status, _=None):
        logger.debug(
            f"Playback status changed for player {player.props.player_name}: {status}"
        )
        self.on_metadata_changed(player, player.props.metadata)

    def on_metadata_changed(self, player, metadata, _=None):
        logger.debug(f"Metadata changed for player {player.props.player_name}")

        track = self.get_track_info(player, metadata)
        icon = self.get_icon(track, player)

        # current_playing = self.get_first_playing_player()
        # if current_playing is not None:
        self.write_output(icon, track, player)

    def get_first_playing_player(self):
        players = self.get_players()
        logger.debug(f"Getting first playing player from {len(players)} players")

        if len(players) > 0:
            # if any are playing, show the first one that is playing
            # reverse order, so that the most recently added ones are preferred
            for player in players[::-1]:
                if player.props.status == "Playing":
                    return player
            # if none are playing, show the first one
            return players[0]
        else:
            logger.debug("No players found")
            return None

    def get_icon(self, track, player):
        is_playing = player.props.status == "Playing"

        icon = "" if track and is_playing else ""

        return icon

    def get_track_info(self, player, metadata):
        player_name = player.props.player_name
        artist = player.get_artist()
        title = player.get_title()

        track_info = ""

        if player_name == "spotify" and "mpris:trackid" in metadata.keys() and ":ad:" in player.props.metadata["mpris:trackid"]:
            track_info = "Advertisement"
        elif artist is not None and title is not None:
            track_info = f"{artist} - {title}"
        else:
            track_info = title

        return track_info

    def write_output(self, text, tooltip, player):
        logger.debug(f"Writing output: {text} <-:-> {tooltip}")

        output = {
            "text": text,
            "tooltip": tooltip,
        }

        if player:
            output["class"] = f"custom-{player.props.player_name}"

        sys.stdout.write(json.dumps(output) + "\n")
        sys.stdout.flush()


def parse_arguments():
    parser = argparse.ArgumentParser()

    # Increase verbosity with every occurrence of -v
    parser.add_argument("-v", "--verbose", action="count", default=0)

    parser.add_argument("--enable-logging", action="store_true")

    return parser.parse_args()


def main():
    arguments = parse_arguments()

    if arguments.enable_logging:
        logfile = os.path.join(
            os.path.dirname(os.path.realpath(__file__)), "media-player.log"
        )

        logging.basicConfig(
            filename=logfile,
            level=logging.DEBUG,
            format="%(asctime)s %(name)s %(levelname)s:%(lineno)d %(message)s"
        )

    # Logging is set by default to WARN and higher.
    # With every occurrence of -v it's lowered by one
    logger.setLevel(max((3 - arguments.verbose) * 10, 0))
    logger.info("Creating player manager")

    player = PlayerManager()
    player.run()


if __name__ == "__main__":
    main()
