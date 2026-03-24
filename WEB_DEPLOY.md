# HİCRET — Web Dağıtım Kılavuzu

## Hızlı Başlangıç

```bash
# 1. love.js kur
npm install -g love.js

# 2. Derle ve tarayıcıda aç
./build_web.sh --serve --open
```

---

## Proje Dizin Yapısı

```
hicret/                     ← oyun kodu (Lua + JSON)
├── main.lua
├── conf.lua
├── src/
├── data/
├── assets/
├── build_web.sh            ← derleme scripti
└── web/                    ← web-özel dosyalar
    ├── index.html          ← özelleştirilmiş yükleme ekranı
    └── assets/             ← favicon, og-image vb. (opsiyonel)

build_web/                  ← derleme çıktısı (git'e ekleme!)
├── index.html
├── game.data               ← oyun verisi (sıkıştırılmış)
├── game.js                 ← oyun loader
├── love.js                 ← LÖVE 2D WASM runtime
├── love.wasm
└── love.worker.js
```

---

## GitHub Pages Kurulumu

### 1. Repo Oluştur
```bash
git init
git add .
git commit -m "ilk yükleme"
git branch -M main
git remote add origin https://github.com/KULLANICI/hicret.git
git push -u origin main
```

### 2. GitHub Actions İzinleri
**Settings → Actions → General → Workflow permissions:**
- ✅ Read and write permissions

### 3. GitHub Pages Aktif Et
**Settings → Pages:**
- Source: **GitHub Actions**

### 4. Workflow Dosyası
`.github/workflows/deploy.yml` dosyası repo'da bulunuyor.
`main` branch'e her push'ta otomatik derlenir ve deploy edilir.

### 5. Repo Yapısı (GitHub Actions için)
```
repo/
├── game/          ← hicret/ içeriği buraya
│   ├── main.lua
│   ├── conf.lua
│   ├── src/
│   └── data/
├── web/
│   └── index.html ← özelleştirilmiş HTML
└── .github/
    └── workflows/
        └── deploy.yml
```

**Not:** `game/` dizinindeki tüm içerik `.love` dosyasına paketlenir.

---

## Yerel Geliştirme

### Python ile
```bash
cd build_web/
python3 -m http.server 8080
# → http://localhost:8080
```

### Node.js ile
```bash
cd build_web/
npx serve -p 8080 --cors
```

**ÖNEMLİ:** `file://` protokolü ile çalışmaz — mutlaka bir HTTP sunucusu gerekir.

---

## WASM için COOP/COEP Başlıkları

SharedArrayBuffer kullanılıyorsa (love.js bazı sürümlerde gerektirir):

**Nginx:**
```nginx
add_header Cross-Origin-Opener-Policy "same-origin";
add_header Cross-Origin-Embedder-Policy "require-corp";
```

**Apache:**
```apache
Header set Cross-Origin-Opener-Policy "same-origin"
Header set Cross-Origin-Embedder-Policy "require-corp"
```

**GitHub Pages bu başlıkları desteklemez.** Alternatif: `coi-serviceworker` shim.
Derleme scriptindeki Node sunucusu bu başlıkları otomatik ekler.

---

## Performans Notları

| Dosya | Boyut | Açıklama |
|-------|-------|----------|
| `love.wasm` | ~4.6 MB | LÖVE 2D runtime (önbelleğe alınır) |
| `game.data`  | ~90 KB | Tüm oyun içeriği |
| `love.js`    | ~380 KB | JS bootstrap |

**Toplam ilk yükleme:** ~5 MB (runtime), sonraki ziyaretlerde ~90 KB.

### Sıkıştırma (opsiyonel)
```bash
gzip -k build_web/love.wasm
gzip -k build_web/love.js
# Sunucunun gzip'i servis etmesi gerekir
```

---

## Mobil Uyumluluk

Oyun mobil tarayıcılarda tam olarak çalışır:
- Pinch-zoom haritası ✓
- Dokunmatik kontroller (TouchManager) ✓
- Canvas boyutlandırma (16:9 letterbox) ✓
- iOS Safari: tam ekran kısıtlaması — `touch-action: none` uygulandı

**Test edildi:** Chrome Android, Safari iOS, Firefox Mobile

---

## Sorun Giderme

**Ekran boş:**
- Konsolu aç (F12), WebGL hatası var mı kontrol et
- `love.js` CDN'i yüklenememiş olabilir — sayfayı yenile

**Ses çalışmıyor:**
- Tarayıcı ses için kullanıcı etkileşimi bekliyor
- Kanvasa bir kez tıklayın

**Yavaş yükleniyor:**
- `.wasm` dosyası ilk ziyarette indirilir (4.6 MB)
- Sonraki ziyaretler önbellekten hızlı yüklenir

**`file://` protokolü:**
- `./build_web.sh --serve` ile HTTP sunucusu başlatın
