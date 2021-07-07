# Nox

Nox is a 15" (Early) 2021 Razer Blade laptop with only NixOS installed.

### Known Issues

I can't get sway to work with external monitors. I suspect that this is because
the nouveau driver isn't properly working with the GPU, and the HDMI port
connects directly to the GPU. I can properly use external monitors if I switch
to X11 (Xfce+i3), but frankly I've been spoiled by sway and I can't go back to
X.
