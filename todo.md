# TODO and FIXME

## TODO

Waybar:
* abstract battery widget for Waybar

Wireplumber:
* rename devices
  * find out a "common" consistent name a device might get on each computer (alla monitor, sound card, microphone, etc.)

## Borked pipewire
When moving between 24.11 and 25.05 pipewire got borked. Service didn't run, only pipewire-pulse.
Waybar was having panic attach, lagging, etc.

Cause were invalid links to pipewire service and socket config in ~/.config/systemd/user/pipewire.<socket/service>
This was seen with eza since the links were red.

I did the following to get it going again.

Remove the broken links:
rm -rf ~/.config/systemd/user/pipewire.service
rm -rf ~/.config/systemd/user/pipewire.socket

Reload daemon:
systemctl --user daemon-reload
systemctl --user reset-failed

Re-enable systemd units:
systemctl --user enable pipewire.service
systemctl --user enable pipewire.socket
systemctl --user start pipewire.service

Now pipewire was running, waybar was happy.
