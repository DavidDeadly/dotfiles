#!/usr/bin/env python3

import gi
import sys
import json
import signal
import os

gi.require_version("Playerctl", "2.0")

from gi.repository import Playerctl, GLib


def signal_handler(sig, _):
    sys.stdout.write("\n")
    sys.stdout.flush()
    sys.exit(0)


class PlayerManager:
    default_player = "none"
    default_data = {
        "name": "No player",
        "status": "None",
        "artist-song": "Nothing playing"
    }
    players_data = {}

    def __init__(self):
        self.players_data[self.default_player] = self.default_data
        self.update_player(self.default_player)

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
        self.loop.run()

    def init_players(self):
        player_names = self.manager.props.player_names

        for player_data in player_names:
            self.init_player(player_data)

        first_playing_player = self.get_first_playing_player()
        if first_playing_player is not None:
            self.update_player(first_playing_player.props.player_name)
        else:
            self.update_player(self.default_player)

        self.write_output()
        self.set_players_list()

    def init_player(self, player_data):
        player = Playerctl.Player.new_from_name(player_data)

        self.register_player(player)

        player.connect("playback-status", self.on_playback_status_changed, None)
        player.connect("metadata", self.on_metadata_changed, None)

        self.manager.manage_player(player)
        self.on_metadata_changed(player, player.props.metadata)

    def register_player(self, player):
        player_status = self.parse_status(player.props.playback_status)

        self.players_data[player.props.player_name] = {
            "name": player.props.player_name,
            "status": player_status
        }

    def get_players(self):
        return self.manager.props.players

    def get_first_playing_player(self):
        players = self.get_players()

        if len(players) == 0:
            return None

        # if any are playing, show the first one that is playing
        # reverse order, so that the most recently added ones are preferred
        for player in players[::-1]:
            if player.props.status == "Playing":
                return player

        return None

    def on_player_appeared(self, _, player_data):
        if player_data is not None:
            self.init_player(player_data)
            self.write_output()

    def on_player_vanished(self, _, player):
        del self.players_data[player.props.player_name]

        if len(self.players_data) == 1:
            self.update_player(self.default_player)

        self.write_output()

    def on_playback_status_changed(self, player, status, _=None):
        player_status = self.parse_status(status)
        player_name = player.props.player_name

        self.players_data[player.props.player_name]["status"] = player_status
        self.write_output()
        self.update_player(player_name)

    def on_metadata_changed(self, player, metadata, _=None):
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

        self.players_data[player_name]["artist-song"] = track_info
        self.players_data[player_name]["status"] = self.parse_status(player.props.playback_status)
        self.write_output()

    def update_player(self, player_name):
        os.system(f"eww update player={player_name}")

    def parse_status(self, status: int) -> str:
        if status == 1:
            return "Paused"

        if status == 0:
            return "Playing"

        self.update_player(self.default_player)

        return "None"

    def write_output(self):
        sys.stdout.write(json.dumps(self.players_data) + "\n")
        sys.stdout.flush()

    def set_players_list(self):
        players = self.get_players()
        players_list = list(
            map(
                lambda player: player.props.player_name,
                players
            )
        )

        os.system(f"eww update players-list='{players_list}'")


def main():
    player = PlayerManager()
    player.run()


if __name__ == "__main__":
    main()
