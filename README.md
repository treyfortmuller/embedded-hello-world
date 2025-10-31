# Embedded rust `hello-world`

This project works out of the embedded rust book found here: https://doc.rust-lang.org/beta/embedded-book/intro/index.html

The toolchain to hack on this thing is in the provided dev shell:

```
nix develop

cargo --version
```

The only thing not delivered to your system with the dev shell is udev rules you might want to enable in order to use OpenOCD with the discovery board without root privledges:

```
# STM32F3DISCOVERY rev A/B - ST-LINK/V2
ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", TAG+="uaccess"

# STM32F3DISCOVERY rev C+ - ST-LINK/V2-1
ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374b", TAG+="uaccess"
```

