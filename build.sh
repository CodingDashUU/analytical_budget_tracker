#!/bin/bash

# 1. Download Flutter (Stable channel)
git clone https://github.com/flutter/flutter.git -b stable

# 2. Add Flutter to the PATH
export PATH="$PATH:`pwd`/flutter/bin"

# 3. Pre-cache and check version
flutter doctor

# 4. Build the web app
# Use --wasm if you want that extra performance boost you're likely after
flutter build web --release