## Pexip's LGPL Bundle 

### LGPL Dependencies

We have all of our work in the LGPL libraries we use public and available for everyone on github.

In order to build this bundle, you must have built the dependencies listed below.

Here is a list of those dependencies:

https://github.com/pexip/os-cairo \
https://github.com/pexip/os-expat \
https://github.com/pexip/os-fontconfig \
https://github.com/pexip/os-fribidi \
https://github.com/pexip/glib \
https://github.com/pexip/gobject-introspection \
https://github.com/pexip/os-harfbuzz \
https://github.com/pexip/json-glib \
https://github.com/pexip/libav \
https://github.com/pexip/os-libffi \
https://github.com/pexip/os-libjpeg-turbo \
https://github.com/pexip/libnice \
https://github.com/pexip/os-libpng1.6 \
https://github.com/pexip/librtmp \
https://github.com/pexip/os-openssl \
https://github.com/pexip/os-nghttp2 \
https://github.com/pexip/os-pango1.0 \
https://github.com/pexip/os-pcre2 \
https://github.com/pexip/os-pixman \
https://github.com/pexip/proxy-libintl \
https://github.com/pexip/pexrtmpserver \
https://github.com/pexip/os-zlib \
https://github.com/pexip/os-openvino \
https://github.com/pexip/os-pugixml \
https://github.com/pexip/os-xbyak \
https://github.com/pexip/gstreamer \
https://github.com/pexip/gst-rtsp-server \
https://github.com/pexip/gstreamer-rs

#### Symbol visibility 

Maintaining the right symbol visibility for all these dependencies is hard.
Hence we have relied on definition maps to do so, you can find the map files
under the `data`.

For Windows, we have created a little script under `tools` to generate the map
automatically from already built dynamic DLL files.


#### Dynamic versus Static 

Linking LGPL code as static into a commercial product is problematic and violates the license.

Therefore, for a static build, we follow these steps:
1) we build all of our dependencies as **static**
2) we **merge** those dependencies into a **single dynamic** library
3) we link **dynamically** to the "lgpl bundle"

That way we can comply to the LGPL license and make a stricter separation into
what is LGPL code and what is Pexips code.

For dynamic builds it is pretty simple, we build and link against all of the
dependencies as *dynamic*.

The bundle basically generates a pkg-config file that encapsulates all of
them.
