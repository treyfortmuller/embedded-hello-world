# Embedded rust `hello-world`

This project works out of the embedded rust "discovery" book here: https://docs.rust-embedded.org/discovery-mb2/

> Note: this is different from the ["Embedded Rust Book"](https://doc.rust-lang.org/beta/embedded-book/intro/index.html) which uses the STMF3 Discovery board, very confusing.

The toolchain to hack on this thing is in the provided dev shell:

```
nix develop

cargo --version
```

## udev rules setup

The only thing not delivered to your system with the dev shell is udev rules you might want to enable in order to the micro:bit board without root privledges. The book will recommend something like this:

```
# CMSIS-DAP for microbit
ACTION!="add|change", GOTO="microbit_rules_end"
SUBSYSTEM=="usb", ATTR{idVendor}=="0d28", ATTR{idProduct}=="0204", TAG+="uaccess"
LABEL="microbit_rules_end"
```

This is what I went with in my NixOS config:

```nix
    # Use OpenOCD with the micro:bit v2 discovery board, see:
    # https://doc.rust-lang.org/beta/embedded-book/intro/install/linux.html
    #
    # TODO (tff): clean this up, this is just for micro:bit v2 boards, I seemed to be suffering from this
    # problem with udev.extraRules: https://github.com/NixOS/nixpkgs/issues/210856
    services.udev.packages = [
      (pkgs.writeTextFile {
        name = "i2c-udev-rules";
        text = ''ATTRS{idVendor}=="0d28", ATTRS{idProduct}=="0204", TAG+="uaccess"'';
        destination = "/etc/udev/rules.d/70-microbit.rules";
      })
    ];
```

Read all about why you can't just plop the rule in `services.udev.extraRules` [here](https://github.com/NixOS/nixpkgs/issues/210856). We love life on hard mode in NixOS, and this is Poettering's fault anyway.

This gives us this goodness:

```
23:40:58 (embedded-hello-world) $ lsusb | grep NXP
Bus 001 Device 054: ID 0d28:0204 NXP ARM mbed

23:41:04 (embedded-hello-world) $ getfacl /dev/bus/usb/001/054 | grep user
getfacl: Removing leading '/' from absolute path names
user::rw-
user:trey:rw- # <---- nice.
```
