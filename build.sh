
if [ ! -d "flutter" ]; then
    echo "[INFO] Cloning Flutter stable..."
    git clone https://github.com/flutter/flutter.git -b stable --depth 1 --single-branch
else
    echo "[INFO] Flutter already exists in cache."
fi

export PATH="$PATH:$(pwd)/flutter/bin"

echo "[INFO] Pre-caching Web artifacts..."
flutter precache --web

echo "[INFO] Building Flutter Web (WASM)..."
flutter build web --release --wasm
