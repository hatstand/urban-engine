FROM balenalib/raspberry-pi-debian:buster-build AS build

RUN install_packages git device-tree-compiler systemd

RUN git clone https://github.com/pimoroni/hyperpixel2r.git

# Build the device tree overlay for Hyperpixel2r
RUN mkdir /overlays
RUN cd hyperpixel2r && dtc -@ -I dts -O dtb -o /overlays/hyperpixel2r.dtbo ./src/hyperpixel2r-overlay.dts

FROM balenalib/raspberry-pi-debian-python:buster-run

# Chromium & X
RUN install_packages chromium-browser unclutter xinit xorg
COPY .xinitrc /root/.xinitrc

RUN install_packages build-essential
RUN pip install RPi.GPIO

RUN mkdir /overlays
ENV OVERLAYS_DIR /overlays

# Compiled device tree overlay for Hyperpixel2r
COPY --from=build /overlays/hyperpixel2r.dtbo /overlays
COPY apply_overlays.sh /apply-overlays.sh

# Init script for Hyperpixel2r
COPY --from=build /hyperpixel2r/dist/hyperpixel2r-init /

CMD /apply-overlays.sh hyperpixel2r && /hyperpixel2r-init && startx
